#!/bin/bash

MAX_WAIT=150
for i in $(seq 1 $MAX_WAIT); do
    if journalctl -u tor@default -n 50 --no-pager 2>/dev/null | grep -q "Bootstrapped 100% (done)"; then
        break
    fi

    if [ $((i % 30)) -eq 0 ]; then
        echo "   Ожидание... ($i/$MAX_WAIT секунд)"
    fi

    if [ $i -eq 80 ]; then
        sudo systemctl restart tor@default
        sleep 8
    fi

    sleep 3
done

ss -tlnp | grep -E '9050|9040|5355'

iptables -F
iptables -t nat -F
ip6tables -F
ip6tables -t nat -F

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT DROP

iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -p tcp --sport 9040 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 9040 -j ACCEPT
iptables -A OUTPUT -p udp --sport 5355 -j ACCEPT
iptables -A OUTPUT -p udp --dport 5355 -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m owner --uid-owner debian-tor -j ACCEPT
iptables -A OUTPUT -m owner --gid-owner debian-tor -j ACCEPT
iptables -A OUTPUT -m owner --uid-owner i2pd -j ACCEPT
iptables -A OUTPUT -m owner --gid-owner i2pd -j ACCEPT

iptables -A OUTPUT -d 10.0.0.0/8 -j ACCEPT
iptables -A OUTPUT -d 172.16.0.0/12 -j ACCEPT
iptables -A OUTPUT -d 192.168.0.0/16 -j ACCEPT

iptables -A OUTPUT -p icmp -j DROP

iptables -t nat -A OUTPUT -p tcp ! -d 127.0.0.0/8 -j REDIRECT --to-ports 9040
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 5355
iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports 5355

ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT DROP

ip6tables -A INPUT  -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT

ip6tables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT

