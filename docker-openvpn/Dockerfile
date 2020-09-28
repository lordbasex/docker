FROM alpine

MAINTAINER Federico Pereira <cnsolucions.com>

COPY ./bin /usr/local/bin

RUN apk add --no-cache bash openvpn git openssl && \
# Get easy-rsa
    git clone https://github.com/OpenVPN/easy-rsa.git /tmp/easy-rsa && \
    cd && \
# Cleanup
    apk del git && \
    rm -rf /tmp/easy-rsa/.git && cp -a /tmp/easy-rsa /usr/local/share/ && \
    rm -rf /tmp/easy-rsa/ && \
    ln -s /usr/local/share/easy-rsa/easyrsa3/easyrsa /usr/local/bin && \
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
