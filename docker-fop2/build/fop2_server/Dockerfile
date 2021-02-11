FROM debian:10
LABEL maintainer="Nicolas Gudiño <ngudino@asternic.net> AND Federico Pereira <fpereira@iperfex.com>"

ENV FOP2_STARTUP_OPTIONS='--licdir=/usr/share/fop2  --dbdir=/var/lib/fop2' \
    FOP2_AMI_HOST=localhost \
    FOP2_AMI_PORT=5038 \
    FOP2_AMI_USER=admin \
    FOP2_AMI_SECRET=amp111 \
    FOP2_WEB_DIR=/var/www/html/ \
    FOP2_LISTEN_IP=\
    FOP2_LISTEN_PORT=4445 \
    FOP2_POLL_INTERVAL=86400 \
    FOP2_POLL_VOICEMAIL=1 \
    FOP2_MONITOR_IPADDRESS=0 \
    FOP2_BLIND_TRANSFER=0 \
    FOP2_SUPERVISED_TRANSFER=1 \
    FOP2_SPY_OPTIONS=bq \
    FOP2_WHISPER_OPTIONS=w \
    FOP2_PERSISTENT_SPY=0 \
    FOP2_CONCEAL_SPIED_EXTENSION=1 \
    FOP2_IGNORE_CLID_ON_BRIDGE=0 \
    FOP2_MONITOR_FILENAME='/var/spool/asterisk/monitor/${ORIG_EXTENSION}${DEST_EXTENSION}%h%i%s_${UNIQUEID}_${FOP2CONTEXT}' \
    FOP2_MONITOR_FORMAT=wav \
    FOP2_MONITOR_MIX=true \
    FOP2_MONITOR_EXEC=/usr/local/fop2/recording_fop2.pl \
    FOP2_NOTIFY_ON_RINGING=1 \
    FOP2_NOTIFY_ON_CONNECT=0 \
    FOP2_NOTIFY_ON_HANGUP=0 \
    FOP2_NOTIFY_ON_CONNECT_QUEUEONLY=1 \
    FOP2_VOICEMAIL_PATH=/var/spool/asterisk/voicemail \
    FOP2_SAVE_CHAT_LOG=1 \
    FOP2_KHOMP_GSM= \
    FOP2_DONGLE_GSM= \
    FOP2_SMS_API_URL= \
    FOP2_SMS_API_METHOD= \
    FOP2_SMS_API_USER= \
    FOP2_SMS_API_PASSWORD= \
    FOP2_SMS_ENABLE_MESSAGESEND=0 \
    FOP2_BROADCAST_PAUSE_COMMANDS=0 \
    FOP2_SSL_CERTIFICATE_FILE=/etc/letsencrypt/live/certificate/fullchain.pem \
    FOP2_SSL_CERTIFICATE_KEY_FILE=/etc/letsencrypt/live/certificate/privkey.pem \
    FOP2_SSLPROXY=0 \
    FOP2_OVERRIDE_REDIRECT_CONTEXT=custom-fop2-autoanswer-redirect \
    FOP2_CLIENT_TIMEOUT=0 \
    FOP2_POLL_STATUS_MODE=0 \
    FOP2_USE_CONTACT_CLID_ON_DIAL=0 \
    FOP2_KICK_UNAUTH_CLIENTS=60 \
    FOP2_ATXFER_APPEND_DIGIT=1

ADD http://download.fop2.com/fop2-2.31.30-debian-x86_64.tgz  /usr/src/fop2.tarz
#ADD https://www.fop2.com/download/debian64 /usr/src/fop2.tarz

RUN apt -y update \
    && apt -y install make net-tools vim default-mysql-client procps libdbd-sqlite3-perl gettext-base \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /usr/src

RUN tar -xzf /usr/src/fop2.tarz \
    && rm -fr /usr/src/fop2.tarz \
    && cd /usr/src/fop2 && make install \
    && cp -fra /usr/src/fop2/server/fop2.cfg.docker /usr/local/fop2/fop2.cfg \
    && cp -fra /usr/src/fop2/server/fop2.docker.template.cfg /usr/local/fop2 \
    && mkdir -p /usr/share/fop2 /var/lib/fop2 \
    && rm -fr /usr/src/fop2

EXPOSE 4445

WORKDIR /usr/local/fop2

ENTRYPOINT /usr/local/fop2/fop2_server ${FOP2_STARTUP_OPTIONS}
