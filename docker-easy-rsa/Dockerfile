FROM alpine:latest

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV TZ='America/Argentina/Buenos_Aires' \
	DOMAIN_OVPN='172.16.0.203' \
	EASYRSA_REQ_COUNTRY='AR' \
	EASYRSA_REQ_PROVINCE='Buenos Aires' \
	EASYRSA_REQ_CITY='La Plata' \
	EASYRSA_REQ_ORG='CNSoluciones' \
	EASYRSA_REQ_EMAIL='fpereira@cnsoluciones' \
	EASYRSA_REQ_OU='server'

RUN apk add --update --no-cache bash openssl tzdata expect easy-rsa \
	&& mkdir -p /keystore/ca && mkdir -p /keystore/client && mkdir -p /keystore/server \
	&& rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

COPY ./run.sh /usr/sbin/create
COPY ./build-ca /usr/share/easy-rsa/build-ca
COPY ./gen-req /usr/share/easy-rsa/gen-req
COPY ./sign-req /usr/share/easy-rsa/sign-req

RUN chmod 777 /usr/sbin/create /usr/share/easy-rsa/build-ca /usr/share/easy-rsa/gen-req /usr/share/easy-rsa/sign-req
WORKDIR /usr/share/easy-rsa/
