FROM gliderlabs/alpine:3.4

MAINTAINER Seth Lakowske <lakowske@gmail.com>

ENV MASTER_HOST=192.168.11.100
ENV K8S_SERVICE_IP=192.168.11.100

RUN apk-install openssl
ADD ./openssl.cnf /
CMD echo $MASTER_HOST && /usr/bin/openssl genrsa -out /certs/ca-key.pem 2048 && \
/usr/bin/openssl req -x509 -new -nodes -key /certs/ca-key.pem -days 10000 -out /certs/ca.pem -subj "/CN=kube-ca" && \
/usr/bin/openssl genrsa -out /certs/apiserver-key.pem 2048 && \
/usr/bin/openssl req -new -key /certs/apiserver-key.pem -out /certs/apiserver.csr -subj "/CN=kube-apiserver" -config /openssl.cnf && \
/usr/bin/openssl x509 -req -in /certs/apiserver.csr -CA /certs/ca.pem -CAkey /certs/ca-key.pem -CAcreateserial -out /certs/apiserver.pem -days 365 -extensions v3_req -extfile /openssl.cnf


