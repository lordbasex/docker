FROM debian:10
LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV FOP2_INTERFACE_REGISTER=''

ADD https://www.fop2.com/download/debian64 /usr/src/fop2.tarz

RUN apt -y update \
    && apt -y install build-essential net-tools vim default-mysql-client \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
#COPY supervisord.conf /etc/supervisord.conf


WORKDIR /usr/src

RUN tar -xzf /usr/src/fop2.tarz \
    && rm -fr /usr/src/fop2.tarz \
    && cd /usr/src/fop2 && make install \
    && cp -fra /usr/local/fop2/ /usr/local/fop2.org \
    && chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && rm -fr /usr/src/fop2

EXPOSE 4445

WORKDIR /usr/local/fop2

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["/usr/local/fop2/fop2_server", "$FOP2_INTERFACE_REGISTER"]
