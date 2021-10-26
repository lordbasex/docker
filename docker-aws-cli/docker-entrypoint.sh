#!/bin/bash

if [ -z "$(ls -A /scripts )" ]; then
  cp -fra /usr/src/scripts/* /scripts
fi

if [ -z "$(ls -A /var/spool/cron/crontabs )" ]; then
  cp -fra /usr/src/crontabs/* /var/spool/cron/crontabs
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

chmod -R 777 /scripts/*
chmod -R 0600 /var/spool/cron/crontabs/*

/usr/sbin/crond -n
