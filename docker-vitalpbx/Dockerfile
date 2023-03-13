FROM arm64v8/debian:11

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ="America/Argentina/Buenos_Aires" \
    veryfy_info=yes

#set mirror
RUN rm /etc/apt/sources.list && \
echo "deb http://deb.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list && \
echo "deb-src http://deb.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list && \
echo "deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
echo "deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
echo "deb http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
echo "deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
echo "deb http://deb.debian.org/debian bullseye-backports main contrib non-free" >> /etc/apt/sources.list && \
echo "deb-src http://deb.debian.org/debian bullseye-backports main contrib non-free" >> /etc/apt/sources.list

#install base pkg
RUN apt-get update && \
    apt-get -y --no-install-recommends install wget systemctl nano vim curl bash gnupg bridge-utils iputils-ping net-tools ca-certificates rsyslog dialog kmod

RUN wget https://repo.vitalpbx.com/vitalpbx/v4/apt/install_vpbx4.sh -O /tmp/install_vpbx4.sh && sed -i "s/reboot/#reboot/g" "/tmp/install_vpbx4.sh" && chmod 777 /tmp/install_vpbx4.sh && ./tmp/install_vpbx4.sh

EXPOSE 5038 5060 5061 5160 5161 4569 8080 8089 10000-20000/udp 10000-20000/tcp

VOLUME [ "/backup" ]
VOLUME [ "/etc/asterisk" ]
VOLUME [ "/var/lib/asterisk/sounds" ]
VOLUME [ "/var/spool/asterisk/voicemail" ]
VOLUME [ "/var/spool/asterisk/monitor" ]
VOLUME [ "/var/log/asterisk" ]
VOLUME [ "/var/lib/mysql" ]

RUN cp -fra /etc/asterisk /etc/asterisk.org \
        && cp -fra /var/lib/asterisk/sounds /var/lib/asterisk/sounds.org \
        && cp -fra /var/spool/asterisk/voicemail /var/spool/asterisk/voicemail.org \
	&& cp -fra /var/lib/mysql /var/lib/mysql.org

WORKDIR /etc/asterisk

COPY docker-entrypoint.sh /
RUN chmod 777 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "/lib/systemd/systemd", "log-level=info", "unit=sysinit.target"]
