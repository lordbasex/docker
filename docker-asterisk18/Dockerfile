#####################################
# STEP 1 build executable binary    #
#####################################
FROM debian:bullseye-slim

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV MSMTP='false' \
        DEBIAN_FRONTEND=noninteractive \
        ASTERISK_VERSION=18

RUN apt update

RUN apt install -y --no-install-recommends --no-install-suggests \
        asterisk-dev \
        autoconf \
        automake \
	bash \
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
	liburiparser1 \
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
        && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
        # ASTERISK #
        && cd /usr/src \
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
        && rm -rf /var/lib/apt/lists/*

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

### Add users
RUN addgroup --gid 500 asterisk \
        && adduser --uid 500 --gid 500 --gecos "Asterisk User" --disabled-password asterisk

COPY ./config/etc /etc

RUN chown -R asterisk:asterisk /usr/lib/libasterisk*
RUN chown -R asterisk:asterisk /usr/lib/asterisk/
RUN chown -R asterisk:asterisk /var/spool/asterisk/
RUN chown -R asterisk:asterisk /var/log/asterisk/
RUN chown -R asterisk:asterisk /usr/sbin/asterisk
RUN chown -R asterisk:asterisk /etc/asterisk/
RUN chown -R asterisk:asterisk /var/lib/asterisk/ 

EXPOSE 5038 5060 5061 5160 5161 4569 8080 8089 10000-20000/udp 10000-20000/tcp

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

ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh"]

CMD ["/usr/sbin/asterisk", "-f", "-U", "asterisk", "-G", "asterisk"]
