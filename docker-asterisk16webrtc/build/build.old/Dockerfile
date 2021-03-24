FROM centos:7

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV MSMTP='false'

ADD https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm /usr/src
ADD https://mirror.webtatic.com/yum/el7/webtatic-release.rpm /usr/src
COPY irontec.repo /etc/yum.repos.d/

RUN yum -y update

RUN cd /usr/src \
        && rpm -Uvh /usr/src/epel-release-latest-7.noarch.rpm \
        && rpm -Uvh /usr/src/webtatic-release.rpm

RUN yum -y groupinstall core base "Development Tools" \
	&& yum -y install unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel mysql-connector-odbc \
        && yum clean all

RUN yum -y install ncurses-devel sendmail ssmtp sox lame newt-devel libxml2-devel libtiff-devel audiofile-devel gtk2-devel subversion kernel-devel git crontabs cronie cronie-anacron wget vim uuid-devel sqlite-devel net-tools gnutls-devel python-devel texinfo libuuid-devel mc wget htop screen sudo nfs-utils sngrep && yum clean all

RUN cd /usr/src \
        && wget -O jansson.tar.gz https://github.com/akheron/jansson/archive/v2.13.1.tar.gz \
        && tar xfz jansson.tar.gz \
        && rm -f jansson.tar.gz \
        && cd jansson-* \
        && autoreconf -i \
        && ./configure \
        && make \
        && make install \
        && rm -r /usr/src/jansson*

RUN cd /usr/src \
        && wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-16-current.tar.gz \
        && tar xfz asterisk-* \
        && rm -f asterisk-*.tar.gz \
	&& mv asterisk-* asterisk \
        && cd asterisk \
        && contrib/scripts/get_mp3_source.sh \
        && contrib/scripts/install_prereq install \
        && ./configure --libdir=/usr/lib64 --prefix=/usr --with-pjproject-bundled --with-jansson-bundled --with-ssl=ssl --with-srtp CFLAGS='-O2 -DNDEBUG' \
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
RUN     git clone https://github.com/BelledonneCommunications/bcg729 /usr/src/bcg729 ; \
        cd /usr/src/bcg729 ; \
        git checkout tags/$BCG729_VERSION ; \
        ./autogen.sh ; \
        ./configure --libdir=/usr/lib64 ; \
        make ; \
        make install ; \
        rm -fr /usr/src/bcg729 ; \
        \
        mkdir -p /usr/src/asterisk-g72x ; \
        curl https://bitbucket.org/arkadi/asterisk-g72x/get/default.tar.gz | tar xvfz - --strip 1 -C /usr/src/asterisk-g72x ; \
        cd /usr/src/asterisk-g72x ; \
        ./autogen.sh ; \
        ./configure --libdir=/usr/lib64 --with-bcg729 --with-asterisk${ASTERISK_VERSION}0 --enable-penryn; \
        make ; \
        make install ; \
        rm -fr /usr/src/asterisk-g72x

### Add Opus codecs
RUN cd /usr/src \
        && wget -O codec_opus.tar.gz http://downloads.digium.com/pub/telephony/codec_opus/asterisk-16.0/x86-64/codec_opus-16.0_current-x86_64.tar.gz \
        && tar -xvzf codec_opus.tar.gz \
        && rm -f codec_opus.tar.gz \
        && cd codec_opus-16* \
        && cp codec_opus.so /usr/lib64/asterisk/modules \
        && cp format_ogg_opus.so /usr/lib64/asterisk/modules \
        && cp codec_opus_config-en_US.xml /var/lib/asterisk/documentation/thirdparty \
        && rm -fr /usr/src/codec_opus*

### CLIENT VOSK SERVER ASR
RUN cd /usr/src \
        && wget -O vosk-asterisk.tar.gz https://github.com/iperfex-team/vosk-asterisk/archive/vosk-asterisk.tar.gz \
        && tar -xvzf vosk-asterisk.tar.gz \
        && rm -f vosk-asterisk.tar.gz \
        && cd vosk-asterisk-vosk-asterisk \
        && ./bootstrap \
        && ./configure --with-asterisk=/usr/src/asterisk --prefix=/usr/lib64 \
        && make \
	&& make install \
        && cp conf/res-speech-vosk.conf /etc/asterisk/res-speech-vosk.conf \
	&& cp /usr/lib64/lib/asterisk/modules/res_speech_vosk.so /usr/lib64/asterisk/modules \ 
	&& rm -fr /usr/lib64/etc/asterisk/res-speech-vosk.conf 	\
        && rm -fr /usr/src/vosk-asterisk-vosk-asterisk \
	&& rm -fr /usr/lib64/lib/asterisk/modules \
        && rm -r /usr/src/asterisk


EXPOSE 5038 4445 3306 5060 5061 5160 5161 4569 8088 8089 10000-20000/udp 10000-20000/tcp

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

#RUN DOCKER SCRIPT
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

COPY ./config/etc /etc

#mount
RUN cp -fra /etc/asterisk /etc/asterisk.org \
        && cp -fra /var/lib/asterisk/sounds /var/lib/asterisk/sounds.org \
        && cp -fra /var/spool/asterisk/voicemail /var/spool/asterisk/voicemail.org

WORKDIR /etc/asterisk
ENTRYPOINT ["/docker-entrypoint.sh"]
