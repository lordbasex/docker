FROM amazonlinux:latest
LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV TZ='America/Argentina/Buenos_Aires' \
    MAIL_NOTIFICATION='lord.basex@gmail.com'

RUN amazon-linux-extras install epel -y \
    && yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm

RUN yum install -y msmtp \
    p7zip \
    mariadb \
    crontabs \
    net-tools \
    supervisor \
    procps \    
    mailx \
    && yum clean all \
    && rm -rf /var/cache/yum

VOLUME [ "/root/.aws", "/Download", "/Upload" ]

COPY supervisord.conf /etc/
COPY scripts /usr/src/scripts
COPY crontabs /usr/src/crontabs
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
