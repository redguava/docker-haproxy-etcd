#!/bin/bash
ETCD_PEER="172.17.42.1:4001"
HAPROXY_BACKEND_SERVICE=$(etcdctl --peers ${ETCD_PEER} get /config/HAPROXY_BACKEND_SERVICE | grep -v "Error: 100: Key not found" || echo "web")
exec /usr/local/bin/etcdctl --peers ${ETCD_PEER}  exec-watch --recursive /services/$HAPROXY_BACKEND_SERVICE -- /update-haproxy.sh

