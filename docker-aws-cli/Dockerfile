FROM alpine:latest
LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"
ARG VERSION
ENV AWSCLI_VERSION=$VERSION \
    TZ='America/Argentina/Buenos_Aires' 

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    tzdata \
    && pip install awscli==$AWSCLI_VERSION \
    && apk --purge -v del py-pip \
    && rm -rf /var/cache/apk/*

VOLUME [ "/root/.aws", "/download", "/upload" ]
