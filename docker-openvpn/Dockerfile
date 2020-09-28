FROM alpine

MAINTAINER Federico Pereira <cnsolucions.com>

COPY ./bin /usr/local/bin

RUN apk add --no-cache bash openvpn openssl easy-rsa && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    cp /usr/share/easy-rsa/vars.example /etc/openvpn/vars && \
    chmod 774 /usr/local/bin/*

# Needed by scripts
ENV OPENVPN=/etc/openvpn \
    EASYRSA=/usr/local/share/easy-rsa/easyrsa3 \
    EASYRSA_PKI=/etc/openvpn/pki \
    EASYRSA_VARS_FILE=/etc/openvpn/vars

VOLUME ["/etc/openvpn"]

EXPOSE 1194/udp

WORKDIR /etc/openvpn
CMD ["startopenvpn"]
