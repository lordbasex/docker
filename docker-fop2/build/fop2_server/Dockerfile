FROM centos:7
LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV FOP2_INTERFACE_REGISTER=''

ADD http://download2.fop2.com/fop2-2.31.29-centos-x86_64.tgz /usr/src/fop2.tarz

RUN yum -y update \
    && yum -y install -y epel-release \
    && yum-config-manager --enable epel  &> /dev/null \
    && yum -y install supervisor net-tools vim mysql\
    && yum clean all

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY supervisord.conf /etc/supervisord.conf


WORKDIR /usr/src

RUN tar -xzf /usr/src/fop2.tarz \
    && rm -fr /usr/src/fop2.tarz \
    && chmod 777 /usr/local/bin/docker-entrypoint.sh

EXPOSE 4445

WORKDIR /usr/local/fop2

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
