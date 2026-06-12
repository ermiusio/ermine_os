# Ermine OS

Этот репозиторий содержит статью с подробным разбором популярных приватных live-дистрибутивов Linux, а также мой собственный проект Ermine OS.

Ermine OS минималистичная live-система для безопасных крипто-транзакций и анонимного серфинга сети. Работает полностью в оперативной памяти, не оставляет следов на диске и содержит только необходимый минимум софта.

## Возможности
Сеть: Tor-only с kill-switch, автоматическая смена MAC-адреса и hostname.

Браузеры: Tor Browser с собственным плагином Fingerprint Spoofer, отдельный браузер для I2P на базе Tor Browser.

I2P: i2pd (C++ реализация) с удобным GUI на zenity.

Кошелёк: Cake Wallet (Monero) под AppArmor-профилем.

Безопасность: AppArmor с кастомными политиками, hardening ядра (sysctl), защита RAM от cold-boot атак (`sdmem`), отключён swap и любое сохранение данных на диск.

RAM-mode: опциональный режим, при котором система продолжает работать после извлечения флешки.

---

## Статья

В статье разбирается концепция live-систем и чем приватные дистрибутивы отличаются от обычных. Затем следует подробный анализ популярных решений.

### Разобранные дистрибутивы

**[Tails OS](https://tails.net/)** — самый детальный разбор: амнезия, freed memory poisoning, проблемы с видеопамятью, Persistent Storage, AppArmor, network namespaces, kill-switch, Unsafe Browser и прошлые уязвимости.

**[Whonix Live](https://www.whonix.org/wiki/Live_Mode)** — архитектура Gateway + Workstation, почему live-режим в Whonix является костылём и когда лучше использовать обычный Whonix.

**[Cyrethium Linux](https://distrowatch.com/table.php?distribution=cyrethium)** — пример того, как не надо делать приватный live-дистрибутив: перегруженный софт, слабая амнезия, отсутствие нормальной защиты RAM, нерабочий kill-switch по умолчанию.

**[Heads](https://heads.dyne.org/)** — пример минимализма и параноидального hardening. Устарел (последние обновления ~2018), но интересен как образец максимальной защиты.

**[Kicksecure](https://www.kicksecure.com/)** — live-режим от разработчиков Whonix: реализация, архитектура и почему она получилась неудачной, включая проблемы с kill-switch.

### Сборка Ermine OS

Вторая часть статьи — пошаговое руководство по сборке собственной live-системы на базе Debian Live (live-build):

- подготовка конфигурации live-build
- настройка GRUB: обычный режим, RAM-mode, Safe Mode
- AppArmor с кастомными политиками
- Cake Wallet + AppArmor-профиль
- i2pd с GUI на zenity
- Tor Browser и отдельный i2p-браузер
- плагин Fingerprint Spoofer (injector.js)
- kill-switch на iptables с нуля: скрипты `20-tor-start.sh`, `45-tor-killswitch.sh`, `clean_all.sh`
- смена MAC-адреса и hostname
- hardening ядра (sysctl)
- защита RAM: sdmem, swapoff, wipe-сервисы
- кастомизация: обои, экран входа LightDM

---

## Структура репозитория

`/overview_private_os/` — полный текст статьи со скриншотами и примерами кода

`/ermine_os/` — конфигурационные файлы и скрипты для сборки
