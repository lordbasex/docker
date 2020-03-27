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
  cp -fra /var/www/wordpress/* /var/www/html
fi


chown apache:apache -R /var/www/html

exec "$@"
