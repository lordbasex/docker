FROM alpine:edge

MAINTAINER lordbasex <lord.basex@gmail.com>
# Based on version of syuchan1005 <syuchan.dev@gmail.com>

ENV QEMU_AUDIO_DRV=none \
    CORE=2 \
    MEMORY=3G \
    KEYBOARD=es \
    CLOVER=1 \
    INSTALLER=1

EXPOSE 8080 2222
VOLUME /data

COPY OSX /OSX

RUN chmod 775 /OSX/start.sh \
&& apk add --no-cache git ca-certificates vim git bash python supervisor qemu-system-x86_64 qemu-img openssh-client

COPY cli /usr/local/sbin/cli
RUN chmod 775 /usr/local/sbin/cli

#noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC \
&& git clone https://github.com/kanaka/websockify /opt/noVNC/utils/websockify \
&& ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html && \
rm -rf /opt/noVNC/.git && \
rm -rf /opt/noVNC/utils/websockify/.git \
rm -fr /opt/noVNC/vnc_lite.html

WORKDIR /OSX

COPY docker-osx-kvm.conf /etc/supervisor/conf.d/docker-osx-kvm.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/docker-osx-kvm.conf"]
