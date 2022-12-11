FROM debian:bullseye-slim

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

RUN apt-get update
RUN apt-get install -y gnupg2 net-tools default-mysql-client procps

ADD ./kamailio.list /etc/apt/sources.list.d/kamailio.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FB40D3E6508EA4C8

RUN apt-get update && apt-get install -y kamailio kamailio-autheph-modules \
  kamailio-mysql-modules kamailio-presence-modules kamailio-tls-modules \
  kamailio-utils-modules kamailio-websocket-modules kamailio-xml-modules \
  kamailio-xmpp-modules

ENV MYSQL_HOST=127.0.0.1
ENV MYSQL_USER=kamailio
ENV MYSQL_PASSWORD=kamailiorw

EXPOSE 5060
EXPOSE 5060/udp

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
