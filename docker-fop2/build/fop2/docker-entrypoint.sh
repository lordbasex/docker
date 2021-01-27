#!/bin/bash
set -e

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
  cp -fra /usr/src/fop2/html/* /var/www/html/
  touch /var/www/html/admin/functions-custom.php
  cp -fra /usr/src/phone /var/www/html/admin/plugins/
fi

echo "Configuration file config.php"
sed -i "s/^\s*\$DBHOST\s*=\s*'.*'\s*;\s*/\$DBHOST='${MYSQL_HOST}';/g" /var/www/html/config.php
sed -i "s/^\s*\$DBNAME\s*=\s*'.*'\s*;\s*/\$DBNAME='${MYSQL_DATABASE_FOP2}';/g" /var/www/html/config.php
sed -i "s/^\s*\$DBUSER\s*=\s*'.*'\s*;\s*/\$DBUSER='${MYSQL_USER}';/g" /var/www/html/config.php
sed -i "s/^\s*\$DBPASS\s*=\s*'.*'\s*;\s*/\$DBPASS='${MYSQL_PASSWORD}';/g" /var/www/html/config.php

echo "Configuration file admin/config.php"
sed -i "s/\(ADMINUSER = *\)\(.*\)/\1'${FOP2_ADMIN_USER}';/" /var/www/html/admin/config.php
sed -i "s/\(ADMINPWD  = *\)\(.*\)/\1'${FOP2_ADMIN_PWD}';/" /var/www/html/admin/config.php

sed -i "s/\(DBHOST= *\)\(.*\)/\1'${MYSQL_HOST}';/" /var/www/html/admin/config.php
sed -i "s/\(DBUSER= *\)\(.*\)/\1'${MYSQL_USER}';/" /var/www/html/admin/config.php
sed -i "s/\(DBPASS= *\)\(.*\)/\1'${MYSQL_PASSWORD}';/" /var/www/html/admin/config.php
sed -i "s/\(DBNAME= *\)\(.*\)/\1'${MYSQL_DATABASE_FOP2}';/" /var/www/html/admin/config.php

if [ ! -f /var/www/html/.htaccess ]; then
cat > /var/www/html/.htaccess <<ENDLINE
AuthType Basic
AuthName "Restricted Content"
AuthUserFile /htpasswd/.htpasswd
Require valid-user
ENDLINE

/usr/bin/htpasswd -bc /htpasswd/.htpasswd ${HTPASSWD_USER} ${HTPASSWD_PASS}
chown apache:apache /htpasswd/.htpasswd
chmod 0660 /htpasswd/.htpasswd
fi

chown apache:apache -R /var/www/html

exec "$@"
