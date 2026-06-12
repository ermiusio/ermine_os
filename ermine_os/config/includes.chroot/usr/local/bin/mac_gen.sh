#!/bin/bash

# ================================================
# Автоматическая смена MAC-адресов на всех Wi-Fi интерфейсах
# ================================================

MAC_FILE="/usr/local/share/mac_list.csv"

echo "=== Автоматическая смена MAC-адресов ==="

# Проверка существования файла с OUI
if [ ! -f "$MAC_FILE" ]; then
    echo "Ошибка: файл $MAC_FILE не найден!"
    exit 1
fi

# Получаем список реальных OUI (первые 3 байта MAC)
OUI_LIST=$(awk -F',' 'NR>1 {gsub(/"/,"",$1); print $1}' "$MAC_FILE" | tr -d ' ')

# Находим все беспроводные интерфейсы (кроме lo)
INTERFACES=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^(wlan|wlp|wlx|en)' | grep -v '^lo$')

if [ -z "$INTERFACES" ]; then
    echo "Не найдено беспроводных интерфейсов!"
    exit 1
fi

echo "Найдены интерфейсы: $INTERFACES"

for iface in $INTERFACES; do
    echo "Обрабатываем интерфейс: $iface"

    # Проверяем, существует ли интерфейс
    if ! ip link show "$iface" > /dev/null 2>&1; then
        echo "Интерфейс $iface не найден — пропускаем"
        continue
    fi

    # Выбираем случайный реальный OUI
    OUI=$(echo "$OUI_LIST" | shuf -n 1 | tr -d ':')

    # Генерируем случайные 3 байта (последняя половина MAC)
    RANDOM_PART=$(openssl rand -hex 3 | tr '[:lower:]' '[:upper:]' | sed 's/\(..\)/\1:/g' | sed 's/:$//')

    # Формируем полный MAC-адрес
    MAC="${OUI:0:2}:${OUI:2:2}:${OUI:4:2}:${RANDOM_PART}"

    echo "[$iface] → Новый MAC: $MAC"

    # Применяем новый MAC
    sudo ip link set dev "$iface" down
    sudo ip link set dev "$iface" address "$MAC"
    sudo ip link set dev "$iface" up

    echo "[$iface] MAC успешно изменён"
done

echo "=== Смена MAC-адресов завершена ==="
