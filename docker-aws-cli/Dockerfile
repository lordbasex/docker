FROM amazonlinux:latest
LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV TZ='America/Argentina/Buenos_Aires' \
    MAIL_NOTIFICATION='lord.basex@gmail.com'

RUN amazon-linux-extras install epel -y \
    && yum -y install https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm

RUN yum install -y msmtp \
    p7zip \
    mariadb \
    crontabs \
    net-tools \
    procps \
    which \
    jq \
    mailx \
    unzip \
    && yum clean all \
    && rm -rf /var/cache/yum

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && rm -fr /aws /awscliv2.zip

VOLUME [ "/root/.aws", "/Download", "/Upload" ]

COPY scripts /usr/src/scripts
COPY crontabs /usr/src/crontabs
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

CMD ["/docker-entrypoint.sh"]
