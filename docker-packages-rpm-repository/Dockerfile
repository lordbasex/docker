FROM centos:7
MAINTAINER Federico Pereira <fpereira@cnsoluciones.com>

RUN yum -y update \
&& yum -y install vim tar htop net-tools iproute mlocate wget \
&& yum -y install httpd mod_ssl createrepo rng-tools

RUN sed -i 's/^/#&/g' /etc/httpd/conf.d/welcome.conf

EXPOSE 80 443
VOLUME /var/www/html

CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
