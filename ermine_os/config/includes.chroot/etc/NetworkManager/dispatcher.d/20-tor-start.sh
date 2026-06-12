BASENAME=$(basename "$0")
TOR_USER="debian-tor"        

if [ "$2" = "up" ]; then

    iptables -F OUTPUT
    iptables -t nat -F OUTPUT 2>/dev/null || true
    iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
    iptables -A OUTPUT -m owner --uid-owner "$TOR_USER" -j ACCEPT
    iptables -P OUTPUT DROP
    
    systemctl restart tor@default.service

elif [ "$2" = "down" ]; then
    iptables -P OUTPUT ACCEPT
    iptables -F OUTPUT
    exit 0
fi
