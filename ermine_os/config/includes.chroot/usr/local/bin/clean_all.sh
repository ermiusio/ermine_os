#!/bin/bash

sudo systemctl stop tor@default i2pd 2>/dev/null || true
sudo pkill -9 tor obfs4proxy 2>/dev/null || true

sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo ip6tables -P INPUT ACCEPT
sudo ip6tables -P FORWARD ACCEPT
sudo ip6tables -P OUTPUT ACCEPT
sudo iptables -F && sudo iptables -X && sudo iptables -Z
sudo iptables -t nat -F && sudo iptables -t nat -X && sudo iptables -t nat -Z
sudo iptables -t mangle -F && sudo iptables -t mangle -X
sudo ip6tables -F && sudo ip6tables -X && sudo ip6tables -Z

sudo iptables-save > ~/iptables-backup-$(date +%F-%H%M).rules 2>/dev/null || true

sudo rm -f /var/log/tor/*
sudo truncate -s 0 /var/log/syslog 2>/dev/null || true

ss -tlnp | grep -E '9050|9040|5355' || echo "Порты не найдены (нормально)"

