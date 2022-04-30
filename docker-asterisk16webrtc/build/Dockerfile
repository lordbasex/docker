#####################################
# STEP 1 build executable binary    #
#####################################
FROM debian:bullseye-slim AS builder

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV MSMTP='false' \
        DEBIAN_FRONTEND=noninteractive \
        ASTERISK_VERSION=18

RUN apt update

RUN apt install -y --no-install-recommends --no-install-suggests \
        asterisk-dev \
        autoconf \
        automake \
        binutils-dev \
        build-essential \
        ca-certificates \
        curl \
        file \
        git \
        libcurl4-openssl-dev \
        libedit-dev \
        libgsm1-dev \
        libjansson-dev \
        libncurses5-dev \
        libogg-dev \
        libpopt-dev \
        libresample1-dev \
        libspandsp-dev \
        libspeex-dev \
        libspeexdsp-dev \
        libsqlite3-dev \
        libsrtp2-dev \
        libtool \
        libnewt-dev \
        libssl-dev \
        libvorbis-dev \
        libxml2-dev \
        libxslt1-dev \
        m4 \
        make \
        msmtp \
        net-tools \
        procps \
        portaudio19-dev \
        unixodbc \
        unixodbc-dev \
        odbcinst \
        sngrep \
        subversion \
        tzdata \
        uuid \
        uuid-dev \
        unzip \
        xmlstarlet \
        wget \
        && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN cd /usr/src \
        && wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${ASTERISK_VERSION}-current.tar.gz \
        && tar xfz asterisk-* \
        && rm -f asterisk-*.tar.gz \
        && mv asterisk-* asterisk \
        && cd asterisk \
        && contrib/scripts/get_mp3_source.sh \
        && contrib/scripts/install_prereq install \
        && ./configure --libdir=/usr/lib --prefix=/usr --with-pjproject-bundled --with-jansson-bundled --with-ssl=ssl --with-srtp CFLAGS='-O2 -DNDEBUG' \
        && make menuselect/menuselect menuselect-tree menuselect.makeopts \
        && menuselect/menuselect --disable BUILD_NATIVE --enable app_confbridge --disable app_fax --enable app_macro --enable codec_silk --enable format_mp3 --enable BETTER_BACKTRACES \
        && make \
        && make install \
        && make samples \
        && make config \
        && cp -fra contrib/scripts/ast_tls_cert /usr/local/sbin/ast_tls_cert && mkdir -p /etc/asterisk/keys \
        && echo "asterisk -rvvvvvvvvvv" > /usr/local/sbin/a \
        && chmod 777 -R /usr/local/sbin/ \
        && ldconfig \
        && rm -fr /etc/asterisk/res_odbc.conf \
        && rm -fr /etc/asterisk/manager.conf

#### Add G729 Codecs
RUN cd /usr/src \
        && wget https://github.com/BelledonneCommunications/bcg729/archive/refs/tags/1.0.4.tar.gz -O bcg729.tar.gz \
        && tar xfz bcg729.tar.gz \
        && cd /usr/src/bcg729-* \
        && ./autogen.sh \
        && ./configure --libdir=/usr/lib \
        && make \
        && make install \
        && rm -fr /usr/src/bcg729*

#### Add G72X Codecs
RUN cd /usr/src \
        && git clone https://bitbucket.org/arkadi/asterisk-g72x.git \
        && cd /usr/src/asterisk-g72x \
        && ./autogen.sh \
        && ./configure --libdir=/usr/lib --with-bcg729 --enable-penryn \
        && make \
        && make install \
        && rm -fr /usr/src/asterisk-g72x

### Add Opus codecs
RUN cd /usr/src \
        && wget -O codec_opus.tar.gz http://downloads.digium.com/pub/telephony/codec_opus/asterisk-${ASTERISK_VERSION}.0/x86-64/codec_opus-${ASTERISK_VERSION}.0_current-x86_64.tar.gz \
        && tar -xvzf codec_opus.tar.gz \
        && rm -f codec_opus.tar.gz \
        && cd codec_opus-${ASTERISK_VERSION}* \
        && cp codec_opus.so /usr/lib/asterisk/modules \
        && cp format_ogg_opus.so /usr/lib/asterisk/modules \
        && cp codec_opus_config-en_US.xml /var/lib/asterisk/documentation/thirdparty \
        && rm -fr /usr/src/codec_opus*

### CLIENT BROWSER PHONE
RUN cd /usr/src \
        && git clone https://github.com/InnovateAsterisk/Browser-Phone.git \
        && cp -fra Browser-Phone/Phone/* /var/lib/asterisk/static-http/ \
        && chmod 744 /var/lib/asterisk/static-http/*

### CLIENT VOSK SERVER ASR
RUN cd /usr/src \
        && wget -O vosk-asterisk.tar.gz https://github.com/iperfex-team/vosk-asterisk/archive/vosk-asterisk.tar.gz \
        && tar -xvzf vosk-asterisk.tar.gz \
        && rm -f vosk-asterisk.tar.gz \
        && cd vosk-asterisk-vosk-asterisk \
        && ./bootstrap \
        && ./configure --with-asterisk=/usr/src/asterisk --prefix=/usr/lib \
        && make \
        && make install \
        && cp conf/res-speech-vosk.conf /etc/asterisk/res-speech-vosk.conf \
        && cp /usr/lib/lib/asterisk/modules/res_speech_vosk.so /usr/lib/asterisk/modules \
        && rm -fr /usr/lib/etc/asterisk/res-speech-vosk.conf    \
        && rm -fr /usr/src/vosk-asterisk-vosk-asterisk \
        && rm -fr /usr/lib/lib/asterisk/modules \
        && rm -r /usr/src/asterisk

#####################################
# STEP 2 build a buster slim image  #
#####################################
FROM debian:bullseye-slim as asteriskwebrtc

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV MSMTP='false' \
        DEBIAN_FRONTEND=noninteractive

RUN apt update

RUN apt install -y --no-install-recommends --no-install-suggests \
        freetds-dev \
        libbinutils \
        libcap2 \
        libcodec2-dev \
        libcurl4 \
        libedit-dev \
        libgmime-3.0-dev \
        libgsm1-dev \
        libical-dev \
        libiksemel-dev \
        libjansson-dev \
        libldap2-dev \
        libncurses5-dev \
        libneon27-dev \
        libosptk4 \
        libportaudio-ocaml-dev \
        libresample1-dev \
        libsnmp40 \
        libspandsp-dev \
        libspeexdsp-dev \
        libsqlite3-dev \
        libsrtp2-dev \
        libssl-dev \
        libunbound-dev \
        liburiparser-dev \
        libuuid1 \
        libvorbis-dev \
        libxml2-dev \
        libxslt-dev \
        net-tools \
        odbc-postgresql \
        openssl \
        postgresql-client \
        procps \
        supervisor \
        tzdata \
        unixodbc \
        unixodbc-dev \
        uuid-dev \
        && rm -rf /var/lib/{apt,dpkg,cache,log}/

### Add users
RUN addgroup --gid 500 asterisk \
        && adduser --uid 500 --gid 500 --gecos "Asterisk User" --disabled-password asterisk \
        && rm -fr /etc/odbcinst.ini /etc/odbc.ini

COPY ./config/etc /etc

COPY --from=builder --chown=asterisk:asterisk /usr/lib/libasterisk* /usr/lib/
COPY --from=builder --chown=asterisk:asterisk /usr/lib/asterisk/ /usr/lib/asterisk/
COPY --from=builder --chown=asterisk:asterisk /usr/lib/libbcg729* /usr/lib/
COPY --from=builder --chown=asterisk:asterisk /var/spool/asterisk/ /var/spool/asterisk/
COPY --from=builder --chown=asterisk:asterisk /var/log/asterisk/ /var/log/asterisk/
COPY --from=builder --chown=asterisk:asterisk /usr/sbin/asterisk /usr/sbin/asterisk
COPY --from=builder --chown=asterisk:asterisk /etc/asterisk/ /etc/asterisk/
COPY --from=builder --chown=asterisk:asterisk /etc/init.d/asterisk /etc/init.d/
COPY --from=builder --chown=asterisk:asterisk /var/lib/asterisk/ /var/lib/asterisk/
COPY --from=builder /usr/local/sbin/a /usr/local/sbin/a

EXPOSE 5038 5060 5061 5160 5161 4569 8080 8089 10000-20000/udp 10000-20000/tcp

#automatic backup
VOLUME [ "/backup" ]

#asterisk etc
VOLUME [ "/etc/asterisk" ]
#asterisk sounds
VOLUME [ "/var/lib/asterisk/sounds" ]
#asterisk voicemail
VOLUME [ "/var/spool/asterisk/voicemail" ]
#asterisk monitor
VOLUME [ "/var/spool/asterisk/monitor" ]
#asterisk logs
VOLUME [ "/var/log/asterisk" ]

#mount
RUN cp -fra /etc/asterisk /etc/asterisk.org \
        && cp -fra /var/lib/asterisk/sounds /var/lib/asterisk/sounds.org \
        && cp -fra /var/spool/asterisk/voicemail /var/spool/asterisk/voicemail.org

WORKDIR /etc/asterisk

#RUN DOCKER SCRIPT
COPY docker-entrypoint.sh /

ENTRYPOINT ["/usr/bin/sh", "/docker-entrypoint.sh"]

CMD ["/usr/sbin/asterisk", "-f", "-U", "asterisk", "-G", "asterisk"]
