#!/bin/bash
HAPROXY_BACKEND_SERVICE=$(etcdctl get /config/HAPROXY_BACKEND_SERVICE || "web")
exec /usr/local/bin/etcdctl --peers '172.17.42.1:4001'  exec-watch --recursive /services/$HAPROXY_BACKEND_SERVICE -- update-haproxy.sh
