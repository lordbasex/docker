FROM alpine

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>" 
LABEL fork="Ztj <ztj1993@gmail.com>"

ENV RTTYS_USERNAME="admin"
ENV RTTYS_PASSWORD="admin"
ENV RTTYS_TOKEN=""

ARG RTTYS_VERSION="2.10.3"
ARG RTTYS_RELEASE="3495203"
ARG RTTYS_CHECKSUM="43e0dd166d82d8d8b0bcc80f957b7d048e8202643dbc83a9397c96db2492686e"

EXPOSE 5912

RUN apk add --no-cache bash vim

ADD https://github.com/zhaojh329/rttys/files/${RTTYS_RELEASE}/rttys-linux-amd64.tar.gz /tmp/rttys.tar.gz

RUN if [ "${RTTYS_TOKEN}" == "" ]; then RTTYS_TOKEN=$(date +%s%N | md5sum | head -c 32); fi \
  && echo "Username: ${RTTYS_USERNAME}" \
  && echo "Password: ${RTTYS_USERNAME}" \
  && echo "Token: ${RTTYS_TOKEN}" \
  && echo "Version: ${RTTYS_VERSION}" \
  && echo "Release: ${RTTYS_RELEASE}" \
  && echo "CheckSum: ${RTTYS_CHECKSUM}" \
  && if [ "${RTTYS_CHECKSUM}" != "$(sha256sum /tmp/rttys.tar.gz | awk '{print $1}')" ]; then exit 1; fi \
  && rm -rf /rttys \
  && mkdir /rttys \
  && tar -zxf /tmp/rttys.tar.gz -C /rttys --strip-components 1 \
  && rm -rf /tmp/rttys.tar.gz \
  && cat /rttys/rttys.conf \
  && sed -i "s@^#addr.*@addr: :5912@" /rttys/rttys.conf \
  && sed -i "s@^#username.*@username: ${RTTYS_USERNAME}@" /rttys/rttys.conf \
  && sed -i "s@^#password.*@password: ${RTTYS_PASSWORD}@" /rttys/rttys.conf \
  && sed -i "s@^#ssl-cert.*@ssl-cert: rttys.crt@" /rttys/rttys.conf \
  && sed -i "s@^#ssl-key.*@ssl-key: rttys.key@" /rttys/rttys.conf \
  && sed -i "s@^#token.*@token: ${RTTYS_TOKEN}@" /rttys/rttys.conf

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh 

WORKDIR /rttys

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
