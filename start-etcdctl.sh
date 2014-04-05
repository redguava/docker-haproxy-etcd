#!/bin/bash
ETCD_PEER="172.17.42.1:4001"
HAPROXY_BACKEND_SERVICE=$(etcdctl --peers ${ETCD_PEER} get /config/HAPROXY_BACKEND_SERVICE | egrep -v "Error: 100: Key not found|Cannot sync with the cluster" || echo "web")
for i in $(etcdctl --peers ${ETCD_PEER} ls --recursive /services/web | egrep -v "Error: 100: Key not found|Cannot sync with the cluster"); do
        ETCD_WATCH_ACTION="set" ETCD_WATCH_KEY=$i ETCD_WATCH_VALUE=$(etcdctl --peers ${ETCD_PEER} get ${ETCD_WATCH_KEY} | egrep -v "Error: 100: Key not found|Cannot sync with the cluster") /update-haproxy.sh
exec /usr/local/bin/etcdctl --peers ${ETCD_PEER}  exec-watch --recursive /services/$HAPROXY_BACKEND_SERVICE -- /update-haproxy.sh

