FROM alpine

MAINTAINER Federico Pereira <cnsolucions.com>

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

# Testing: pamtester
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator pamtester && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars
ENV EASYRSA_VARS_FILE /usr/share/easy-rsa/vars.example
ENV EASYRSA_CRL_DAYS 3650

VOLUME ["/etc/openvpn"]

EXPOSE 1194/udp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

ADD ./otp/openvpn /etc/pam.d/
