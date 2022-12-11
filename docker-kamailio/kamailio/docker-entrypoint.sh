#!/bin/bash

#Test
kamailio -c

while true; do
  echo 'show databases;' | mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -h"$MYSQL_HOST"
  if [ $? -eq 0 ] ; then
    break
  else
    sleep 1
  fi
done

#Run
kamailio -M 24 -m 64 -DD -E -e -f /etc/kamailio/kamailio.cfg \
  || ( echo "DEU ERROR $?"; sleep infinity)
