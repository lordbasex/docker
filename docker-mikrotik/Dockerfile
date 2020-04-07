FROM alpine:latest

MAINTAINER Federico Pereira <fpereira@cnsoluciones.com>

ARG VERSON
ENV ROUTEROS_VERSON=$VERSON \
  ROUTEROS_IMAGE="chr-$ROUTEROS_VERSON.vdi" \
  KEYBOARD=es

RUN apk add --no-cache --update netcat-openbsd busybox-extras python git bash qemu-system-x86_64 supervisor 

RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC \
  && git clone https://github.com/kanaka/websockify /opt/noVNC/utils/websockify \
  && ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html \
  && rm -rf /opt/noVNC/.git \
  && rm -rf /opt/noVNC/utils/websockify/.git \
  && rm -fr /opt/noVNC/vnc_lite.html \
  && apk del git

# For access via VNC
EXPOSE 5900

# For access via noVNC
EXPOSE 8080

# Default ports of RouterOS
EXPOSE 21
EXPOSE 22
EXPOSE 23
EXPOSE 80
EXPOSE 443
EXPOSE 8291
EXPOSE 8728
EXPOSE 8729

# IPSec
EXPOSE 50
EXPOSE 51
EXPOSE 500/udp
EXPOSE 4500/udp

# OpenVPN
EXPOSE 1194

# L2TP
EXPOSE 1701

# PPTP
EXPOSE 1723

# Run
RUN mkdir /routeros

COPY $ROUTEROS_IMAGE /routeros

COPY cli /usr/local/sbin/cli
RUN chmod 775 /usr/local/sbin/cli

COPY entrypoint.sh /usr/local/sbin/entrypoint.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod 777 /usr/local/sbin/entrypoint.sh /usr/local/sbin/cli

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
