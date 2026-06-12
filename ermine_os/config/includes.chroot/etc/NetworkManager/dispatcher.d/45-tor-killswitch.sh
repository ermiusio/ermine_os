#!/bin/sh

if [ -z "$1" ] || [ "$1" = "lo" ]; then
   exit 0
fi

if [ "$2" = "up" ]; then

    MAX_WAIT=300
    for i in $(seq 1 $MAX_WAIT); do
        if journalctl -u tor@default -n 100 --no-pager 2>/dev/null | grep -q "Bootstrapped 100% (done)"; then
            systemctl restart i2pd.service 2>/dev/null || true
             sleep 5
             
            /usr/local/bin/tor-killswitch.sh
            exit 0
        fi

        if [ $((i % 30)) -eq 0 ]; then
            echo "[20-killswitch] Ждём Tor... ($i/$MAX_WAIT секунд)"
        fi

        sleep 3
    done
fi
