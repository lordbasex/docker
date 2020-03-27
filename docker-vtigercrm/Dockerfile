FROM centos:7
MAINTAINER Federico Pereira <fpereira@cnsoluciones.com>

RUN mkdir -p /usr/src/vtigercrm
#COPY vtigercrm7.1.0.tar.gz /usr/src/vtigercrm 
ADD https://sourceforge.net/projects/vtigercrm/files/vtiger%20CRM%207.1.0/Core%20Product/vtigercrm7.1.0.tar.gz/download /usr/src/vtigercrm/vtigercrm7.1.0.tar.gz

RUN yum -y update \
&& yum -y install vim tar wget unzip htop net-tools iproute telnet mc mlocate cron\
&& yum -y install epel-release \
&& yum clean all \
&& yum -y install supervisor \
&& yum -y install httpd mod_ssl\
&& rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm \
&& yum -y install php56w php56w-mysql php56w-imap php56w-curl php56w-xml php56w-zlib php56w-gd php56w-mbstring \
&& cd /usr/src/vtigercrm && tar xfv vtigercrm7.1.0.tar.gz 	

RUN sed -i 's/^/#&/g' /etc/httpd/conf.d/welcome.conf \
&& sed -i 's/Options Indexes FollowSymLinks/Options FollowSymLinks/' /etc/httpd/conf/httpd.conf \
&& sed  -i 's|DocumentRoot "/var/www/html"|DocumentRoot "/var/www/html/vtigercrm"|' /etc/httpd/conf/httpd.conf

RUN { \
        echo 'display_errors=On'; \
        echo 'max_execution_time=600'; \
        echo 'error_reporting=E_WARNING & ~E_NOTICE & ~E_DEPRECATED'; \
        echo 'log_errors=Off'; \
        echo 'short_open_tag=Off'; \
    } > /etc/php.d/vtiger.ini

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php --install-dir=/usr/local/bin --filename=composer --quiet && rm composer-setup.php \
&& cd /usr/src/vtigercrm && composer require guzzlehttp/guzzle
COPY install-vtiger.php /usr/src/vtigercrm
COPY config.inc.php /usr/src/vtigercrm
COPY ssl.conf /etc/httpd/conf.d/ssl.conf
COPY vtigercron /etc/cron.d/vtigercron
RUN chmod 0644 /etc/cron.d/vtigercron 

EXPOSE 80 443

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /var/www/html

COPY supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord"]
