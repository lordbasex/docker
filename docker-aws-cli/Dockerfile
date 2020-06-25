FROM alpine:3.11
LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"
ARG VERSION
ENV AWSCLI_VERSION=$VERSION \
    TZ='America/Argentina/Buenos_Aires' 

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    tzdata \
    mysql-client \
    dcron \
    supervisor \
    p7zip \
    msmtp \
    mailx \
    bash \
    && pip install awscli==$AWSCLI_VERSION \
    && apk --purge -v del py-pip \
    && rm -rf /var/cache/apk/* \
    && rm -rf /var/spool/cron/crontabs \
    && rm -fr /etc/crontabs/root


VOLUME [ "/root/.aws", "/Download", "/Upload" ]

COPY supervisord.conf /etc/
COPY scripts /usr/src/scripts
COPY crontabs /usr/src/crontabs
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
