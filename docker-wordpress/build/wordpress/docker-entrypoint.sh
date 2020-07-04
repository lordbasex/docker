#!/bin/bash
set -e

echo $TZ > /etc/timezone

if [ ! -f /etc/php.d/timezone.ini ]; then
  echo "date.timezone = $TIMEZONE" > /etc/php.d/timezone.ini
fi

if [ $MSMTP = "true" ]; then

cat > /etc/msmtprc <<ENDLINE
defaults
auth           ${MSMTP_AUTH}
tls            ${MSMTP_TTS}
tls_trust_file ${MSMTP_TTS_TRUST_FILE}
syslog         ${MSMTP_SYSLOG}

account        $MSMTP_ACCOUNT
host           ${MSMTP_HOST}
auth           ${MSMTP_ACCOUNT_AUTH}
port           ${MSMTP_PORT}
from           ${MSMTP_FROM}
user           ${MSMTP_USER}
password       ${MSMTP_PASSWORD}

# Set a default account
account default : $MSMTP_ACCOUNT
aliases        /etc/aliases
ENDLINE

fi

if [ -z "$(ls -A /var/www/html )" ]; then
  cp -fra /var/www/wordpress/* /var/www/html
fi


if [ $WPPROTECTADMIN = "true" ]; then
CHECK_PROTECT_ADMIN=`cat /var/www/html/.htaccess | grep '# Password Protect Your WordPress Admin' |cut -d '(' -f2 | head -1 | cut -d ')' -f1 | head -1`

if [ "$CHECK_PROTECT_ADMIN" != 'wp-admin' ];then
cat >> /var/www/html/.htaccess <<ENDLINE

# Password Protect Your WordPress Admin (wp-admin)
ErrorDocument 401 "Unauthorized Access"
ErrorDocument 403 "Forbidden"
<FilesMatch "wp-login.php">
    AuthName "Authorized Only"
    AuthType Basic
    AuthUserFile /htpasswd/.htpasswd
    Require valid-user
</FilesMatch>

<Files admin-ajax.php>
    Order allow,deny
    Allow from all
    Satisfy any
</Files>

<files wp-config.php>
    order allow,deny
    deny from all
</files>
ENDLINE


/usr/bin/htpasswd -bc /htpasswd/.htpasswd ${HTPASSWD_USER} ${HTPASSWD_PASS}
chown apache:apache /htpasswd/.htpasswd
chmod 0660 /htpasswd/.htpasswd
fi

fi

#FILES DELETE
rm -fr /var/www/html/readme.html /var/www/html/license.txt /var/www/html/licencia.txt  /var/www/html/wp-admin/install.php /var/www/html/wp-admin/install-helper.php

chown apache:apache -R /var/www/html
chown apache:apache -R /var/www/images

exec "$@"
