#!/bin/bash

HAPROXY_CONFIG="/etc/haproxy/haproxy.cfg"

function update {

  HOST_NAME=$(echo $ETCD_WATCH_KEY | cut -d/ -f4)
  HOST_IP=$(echo $ETCD_WATCH_VALUE | tr -d '"{} ' | cut -d, -f1 | cut -d: -f2)
  HOST_PORT=$(echo $ETCD_WATCH_VALUE | tr -d '"{} ' | cut -d, -f2 | cut -d: -f2)

  HAPROXY_BACKEND_SERVER_MAX_CONNECTIONS=$(etcdctl get /config/HAPROXY_BACKEND_SERVER_MAX_CONNECTIONS || 32)

  if grep -q "server ${HOST_NAME}" $HAPROXY_CONFIG; then
    sed -i -e "s/  server ${HOST_NAME}.*$/  server ${HOST_NAME} ${HOST_IP}:${HOST_PORT} maxconn ${HAPROXY_BACKEND_SERVER_MAX_CONNECTIONS} check/g" $HAPROXY_CONFIG
  else
    echo "  server ${HOST_NAME} ${HOST_IP}:${HOST_PORT} maxconn ${HAPROXY_BACKEND_SERVER_MAX_CONNECTIONS} check" >> $HAPROXY_CONFIG
  fi

}

function remove {

  HOST_NAME=$(echo $ETCD_WATCH_KEY | cut -d/ -f4)

  sed -i'' "/server ${HOST_NAME} /d" $HAPROXY_CONFIG

}

case $ETCD_WATCH_ACTION in
  compareAndSwap | update | set)
    update
    ;;
  delete | expire)
    remove
    ;;
  *)
    echo "Something went wrong..."
    exit 1
esac

/usr/local/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)

