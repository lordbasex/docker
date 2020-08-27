FROM alpine
LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

RUN apk add --update \
    docker-cli \
    && rm -rf /var/cache/apk/*

VOLUME [ "/var/run/docker.sock" ]
