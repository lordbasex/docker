FROM alpine:latest

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"
LABEL github="https://github.com/lordbasex/docker/docker-asterisk-fastagi-go"

RUN apk add --no-cache \
        bash \
        asterisk \
        asterisk-curl \
        asterisk-fax \
        asterisk-odbc \
        asterisk-sample-config \
        asterisk-sounds-en \
        asterisk-sounds-moh \
        unzip \
	util-linux \
        && echo "asterisk -rvvvvvvvvvvvvvvvvv" > /usr/sbin/a && chmod +x /usr/sbin/a \
	&& echo "! installation is finished !"

COPY ./extensions.conf /etc/asterisk/extensions.conf
COPY ./iax.conf /etc/asterisk/iax.conf

RUN rm -fr /var/lib/asterisk/sounds/es && mkdir /var/lib/asterisk/sounds/es
ADD https://www.asterisksounds.org/sites/asterisksounds.org/files/sounds/es-MX/download/asterisk-sounds-core-es-MX-1.11.11.zip  /var/lib/asterisk/sounds/es/core.zip
ADD https://www.asterisksounds.org/sites/asterisksounds.org/files/sounds/es-MX/download/asterisk-sounds-extra-es-MX-1.12.11.zip /var/lib/asterisk/sounds/es/extra.zip
RUN unzip /var/lib/asterisk/sounds/es/core.zip -d /var/lib/asterisk/sounds/es && rm -fr /var/lib/asterisk/sounds/es/LICENSE.txt
RUN rm -fr /var/lib/asterisk/sounds/es/extra.zip /var/lib/asterisk/sounds/es/extra.zip
RUN chown asterisk:asterisk -R /var/lib/asterisk/sounds/es/ /etc/asterisk

EXPOSE 4569

VOLUME [ "/etc/asterisk" ]
VOLUME [ "/var/lib/asterisk/sounds" ]

WORKDIR /etc/asterisk

CMD ["/usr/sbin/asterisk", "-c", "-ddd", "-f", "-vvv"]
