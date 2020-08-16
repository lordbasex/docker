FROM centos:7

LABEL \
	name="httpd-ssl" \
	image="cnsoluciones/httpd-ssl" \
	vendor="cnsoluciones" \
	license="GNU GPL V3" \
	build-date="2020-08-16"

ENV TIMEZONE='America/Argentina/Buenos_Aires'


RUN yum -y update \
    && yum -y install -y epel-release \
    && yum-config-manager --enable epel &> /dev/null \
    && yum -y install supervisor \
    && yum -y install vim tar htop net-tools iproute git \
    && yum -y groupinstall "Web Server" \
    && yum -y install php php-gd php-mysql php-process httpd mod_ssl php-cli php-soap php-xml php-mcrypt \
    && yum clean all


EXPOSE 80/tcp 443/tcp


CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
