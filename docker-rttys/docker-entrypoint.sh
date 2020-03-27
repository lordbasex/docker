#!/bin/bash
sed -i "s/\(^username: *\)\(.*\)/\1${RTTYS_USERNAME}/" /rttys/rttys.conf
sed -i "s/\(^password: *\)\(.*\)/\1${RTTYS_PASSWORD}/" /rttys/rttys.conf
sed -i "s/\(^token: *\)\(.*\)/\1${RTTYS_TOKEN}/" /rttys/rttys.conf

if [ -n "$RTTYS_CERT_CRT" -a -e "$RTTYS_CERT_CRT" ]; then
    rm -fr /rttys/rttys.crt
    rm -fr /rttys/rttys.key 
    ln -s ${RTTYS_CERT_CRT} /rttys/rttys.crt
    ln -s ${RTTYS_CERT_KEY} /rttys/rttys.key
fi

/rttys/rttys
