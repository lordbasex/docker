FROM centos:7
LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV MSMTP='false'
ENV HTACCESS='false'


ADD http://download2.fop2.com/fop2-2.31.29-centos-x86_64.tgz /usr/src/fop2.tarz
ADD http://download.fop2.com/plugins/phone-1.0.1.tgz /usr/src/phone.tgz

RUN yum -y update \
    && yum -y install -y epel-release \
    && rpm -i https://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum-config-manager --enable epel  &> /dev/null \
    && yum-config-manager --enable remi-php73 &> /dev/null \
    && yum -y install vim wget curl supervisor crontabs openssh-clients unzip msmtp \
    && yum -y groupinstall "Web Server" \
    && yum clean all

RUN yum -y install php php-cli php-common php-devel php-gd php-imap php-mcrypt php-mbstring php-mysql php-pdo php-pear php-pear-DB php-process php-soap php-xml php-pecl-zip\
    && yum -y install php-curl php-sqlite3 php-fpm php-devel \
    && echo "[mail function]" > /etc/php.d/msmtprc.ini \
    && echo "sendmail_path = \"/usr/bin/msmtp -t\"" >> /etc/php.d/msmtprc.ini \
    && yum clean all

COPY additionals/etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/
COPY additionals/etc/httpd/conf.d/fop2.conf /etc/httpd/conf.d/
COPY additionals/etc/httpd/conf.d/fop2-htaccess.conf /etc/httpd/conf.d/
COPY additionals/etc/php.d/fop2.ini /etc/httpd/conf.d/
COPY additionals/etc/php.d/fop2.ini /etc/php.d/
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY supervisord.conf /etc/supervisord.conf

WORKDIR /usr/src

RUN tar -xzf /usr/src/fop2.tarz \
    && tar -xzf /usr/src/phone.tgz

WORKDIR /var/www/html/fop2

EXPOSE 80 443

VOLUME /var/www/html
VOLUME /usr/local/fop

CMD ["/usr/bin/supervisord"]
