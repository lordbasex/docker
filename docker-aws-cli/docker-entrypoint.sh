#!/bin/bash

if [ -z "$(ls -A /scripts )" ]; then
  cp -fra /usr/src/scripts/* /scripts
fi

if [ -z "$(ls -A /var/spool/cron/crontabs )" ]; then
  cp -fra /usr/src/crontabs/* /var/spool/cron/crontabs
fi

chmod -R 777 /scripts/*
chmod -R 0600 /var/spool/cron/crontabs/*
