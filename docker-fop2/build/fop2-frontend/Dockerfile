FROM centos:7
LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV FOP2_INTERFACE_REGISTER=''

ADD http://download2.fop2.com/fop2-2.31.27-centos-x86_64.tgz /usr/src/fop2.tarz
    
RUN yum -y update \
    && yum -y install -y epel-release \
    && yum-config-manager --enable epel  &> /dev/null \
    && yum -y install supervisor net-tools \
    && yum clean all

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY supervisord.conf /etc/supervisord.conf

WORKDIR /usr/src

RUN tar -xzf /usr/src/fop2.tarz \ 
    && rm -fr /usr/src/fop2.tarz

EXPOSE 4445

CMD ["/usr/bin/supervisord"]
