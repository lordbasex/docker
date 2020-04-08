FROM alpine:latest

MAINTAINER Federico Pereira <fpereira@cnsoluciones.com>

ENV DISPLAY=":1"

RUN apk add --no-cache --update netcat-openbsd busybox-extras sudo python git bash supervisor xvfb x11vnc openbox socat xterm msttcorefonts-installer fontconfig wine feh\
  && update-ms-fonts \
  && git clone https://github.com/novnc/noVNC.git /opt/noVNC \
  && git clone https://github.com/kanaka/websockify /opt/noVNC/utils/websockify \
  && ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html \
  && rm -rf /opt/noVNC/.git \
  && rm -rf /opt/noVNC/utils/websockify/.git \
  && rm -fr /opt/noVNC/vnc_lite.html \
  && rm -rf /apk /tmp/* /var/cache/apk/*

RUN addgroup alpine \
  && adduser  -G alpine -s /bin/sh -D alpine \
  && echo "alpine    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers 

# For access via VNC
EXPOSE 5900

# For access via noVNC
EXPOSE 8080

COPY etc /etc
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY winbox64.exe /home/alpine
COPY user-data /home/alpine
COPY docker-mikrotik-1024x576.png /etc/xdg/openbox
COPY winbox.png /opt/noVNC 
COPY vnc.html /opt/noVNC
RUN chown alpine:alpine -R /home/alpine

WORKDIR /home/alpine

# User alpine
USER alpine

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
