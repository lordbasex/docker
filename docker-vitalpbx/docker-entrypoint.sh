#!/bin/bash

if [ -z "$(ls -A /var/lib/mysql)" ]; then
  cp -fra /var/lib/mysql.org/* /var/lib/mysql
    chown mysql:mysql -R /var/lib/mysql
fi

if [ -z "$(ls -A /etc/asterisk)" ]; then
  cp -fra /etc/asterisk.org/* /etc/asterisk
    chown asterisk:asterisk -R /etc/asterisk
fi

if [ -z "$(ls -A /var/lib/asterisk/sounds)" ]; then
  cp -fra /var/lib/asterisk/sounds.org/* /var/lib/asterisk/sounds
  chown asterisk:asterisk -R /var/lib/asterisk/sounds
fi

if [ -z "$(ls -A /var/spool/asterisk/voicemail)" ]; then
  cp -fra /var/spool/asterisk/voicemail.org /var/spool/asterisk/voicemail
  chown asterisk:asterisk -R /var/spool/asterisk/voicemail
fi

exec "$@"
