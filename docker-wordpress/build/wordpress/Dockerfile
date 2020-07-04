FROM centos:7
LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV MSMTP='false' \
    WPPROTECTADMIN='false' \
    TIMEZONE='America/Argentina/Buenos_Aires' \
    TZ='America/Argentina/Buenos_Aires'

ADD https://wordpress.org/latest.tar.gz /usr/src

RUN yum -y update \
    && yum -y install -y epel-release \
    && rpm -i https://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum-config-manager --enable epel  &> /dev/null \
    && yum-config-manager --enable remi-php73 &> /dev/null \
    && yum -y install vim wget curl supervisor crontabs openssh-clients unzip msmtp \
    && yum -y groupinstall "Web Server" \
    && yum -y install mod_security mod_evasive \
    && yum clean all

RUN yum -y install php php-cli php-common php-devel php-gd php-imap php-mcrypt php-mbstring php-mysql php-pdo php-pear php-pear-DB php-process php-soap php-xml php-pecl-zip\
    && yum -y install php-curl php-sqlite3 php-fpm php-devel \
    && yum -y install php-pecl-imagick php-pecl-imagick-devel \
    && echo "[mail function]" > /etc/php.d/msmtprc.ini \
    && echo "sendmail_path = \"/usr/bin/msmtp -t\"" >> /etc/php.d/msmtprc.ini \
    && yum clean all

COPY additionals/etc/httpd/conf.d/hardening.conf /etc/httpd/conf.d/
COPY additionals/etc/httpd/conf.d/letsencrypt_ssl.conf.bkp /etc/httpd/conf.d/
COPY additionals/etc/httpd/conf.d/wordpress.conf /etc/httpd/conf.d/
COPY additionals/etc/httpd/conf.d/wordpress-htaccess.conf /etc/httpd/conf.d/
COPY additionals/etc/php.d/wordpress.ini /etc/php.d/
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY supervisord.conf /etc/supervisord.conf

WORKDIR /var/www

RUN tar -xzf /usr/src/latest.tar.gz \
    && rm -fr /usr/src/latest.tar.gz

EXPOSE 80 443

VOLUME /var/www/html

CMD ["/usr/bin/supervisord"]
