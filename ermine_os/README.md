# Сборка
Сборка Ermine OS

Процесс сборка и струтура дистрибутива вмете стеситровнием и скриншотмаи подробно разобраны в статье в моём репозитории по ссылке [overview_private_os](overview_private_os), но кратко расскажу, как её установить.

**Клонируйте репозиторий и перейдите в папку проекта:**
```bash
   git clone [https://github.com/ermiusio/ermine_os.git](https://github.com/ermiusio/ermine_os.git)
   cd ermine_os

```

 **Важно:** Перед сборкой рекомендуется обновить мосты Tor в файле `/ermine_os/config/includes.chroot/etc/tor/torrc`. Они заданы статически и могли устареть, а без рабочих мостов kill-switch не позволит системе выйти в сеть.
 

**Примечание по работе с Kill-Switch**

Если вам по какой-то причине понадобится отключить kill-switch (что крайне **не рекомендуется** в целях безопасности), уже внутри запущенной системы выполните скрипт:
```bash
/local/bin/clean_all.sh
```


**Установите необходимые зависимости и утилиты:**
```bash
sudo apt install live-build squashfs-tools xorriso isolinux syslinux-common syslinux-efi grub-efi-amd64-bin mtools dosfstools live-boot live-config live-boot-initramfs-tools debootstrap apt-utils rsync gnupg dpkg-dev

```


**Очистите предыдущие сборки и сгенерируйте недостающие конфигурационные файлы:**
```bash
sudo lb clean
sudo lb config

```

**Запустите процесс сборки ISO-образа:**
```bash
sudo lb build
```

## Важное примечание
Если вы не хотите собирать дистрибутив с нуля готовый ISO-образ Ermine OS уже загружен в раздел Releases. Его можно скачать и сразу записать на флешку.
Это тестовый проект, в котором ещё есть что доработать, но он хорошо подходит как демонстрация собственной сборки live-системы.
