FROM alpine:latest

ARG VERSON
ENV ROUTEROS_VERSON=$VERSON
ENV ROUTEROS_IMAGE="chr-$ROUTEROS_VERSON.vdi"

RUN apk add --no-cache --update netcat-openbsd busybox-extras openssh-client python git bash qemu-x86_64 qemu-system-x86_64 

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
WORKDIR /routeros

COPY $ROUTEROS_IMAGE .
COPY entrypoint.sh .

RUN chmod 777 -R /routeros

ENTRYPOINT ["/routeros/entrypoint.sh"]
