FROM alpine:latest

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

# Environments which may be change
ENV KEYBOARD=en-us
ENV VNCPASSWORD="false"
ENV ROUTEROS_VERSION="6.49.7"
ENV ROUTEROS_IMAGE="chr-${ROUTEROS_VERSION}.vdi"
ENV ROUTEROS_URL="https://download.mikrotik.com/routeros/${ROUTEROS_VERSION}/$ROUTEROS_IMAGE.zip"

RUN set -xe \
    && apk add --no-cache --update \
        wget \
        netcat-openbsd \
        qemu-x86_64 \
        qemu-system-x86_64 \
        busybox-extras \
        iproute2 \
        iputils \
        bridge-utils \
        iptables \
        jq \
        bash \
        python3 \
        curl

WORKDIR /routeros

RUN mkdir /routeros/bin
COPY ./bin/* /routeros/bin/
RUN ls -l /routeros/bin
RUN ip link show

RUN wget ${ROUTEROS_URL} -O /routeros/${ROUTEROS_IMAGE}.zip && unzip ${ROUTEROS_IMAGE}.zip && rm -fr ${ROUTEROS_IMAGE}.zip && ls -la

# Default ports of RouterOS
EXPOSE 21 22 23 80 443 8291 8728 8729

# OpenVPN
EXPOSE 1194

# L2TP
EXPOSE 1701

# PPTP
EXPOSE 1723

ENTRYPOINT [ "/routeros/bin/entrypoint.sh" ]