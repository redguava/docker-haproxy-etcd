FROM redguava/haproxy

ADD haproxy.cfg /etc/haproxy/haproxy.cfg
ADD supervisord-haproxy.conf /etc/supervisor.d/haproxy.conf
ADD supervisord-etcd.conf /etc/supervisor.d/etcd.conf
ADD server.crt /etc/ssl/certs/server.crt

RUN /usr/local/sbin/haproxy -f /etc/haproxy/haproxy.cfg
