FROM redguava/haproxy

ADD haproxy.cfg /etc/haproxy/haproxy.cfg
ADD run.sh /run.sh
ADD start-etcdctl.sh /start-etcdctl.sh
ADD setup-haproxy.sh /setup-haproxy.sh
ADD start-haproxy.sh /start-haproxy.sh
ADD update-haproxy.sh /update-haproxy.sh
ADD supervisord-haproxy.conf /etc/supervisor.d/haproxy.conf
ADD supervisord-etcd.conf /etc/supervisor.d/etcd.conf
ADD server.crt /etc/ssl/certs/server.crt

RUN /run.sh
