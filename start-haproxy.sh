#!/bin/bash
/usr/local/sbin/haproxy -c -q -f /etc/haproxy/haproxy.cfg
if [ $? -ne 0 ]; then
        echo "Errors in configuration file, check with $prog check."
        exit 1
fi
/usr/local/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)
while [ $(pidof haproxy 1>/dev/null; echo $?) -eq 0 ]; do
        sleep 3
        echo -n "."
done
