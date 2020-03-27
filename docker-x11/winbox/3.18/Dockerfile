FROM debian:latest

MAINTAINER Federico Pereira <fpereira@cnsoluciones.com>
#based on https://github.com/philmd/winbox-docker

ENV USER lordbasex
ENV HOME /home/$USER

RUN useradd --home-dir $HOME --create-home $USER

# wine
RUN dpkg --add-architecture i386 && \
    apt-get -q update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -y wine32 && \
    apt-get install -y mc procps wget && \
    apt-get clean

ENV WINE=wine32 WINEARCH=win32 QT_X11_NO_MITSHM=1 WINEDEBUG=fixme-all

RUN ln -s /usr/lib/wine/wineserver32 /usr/local/sbin/wineserver

# winbox
ADD https://download2.mikrotik.com/routeros/winbox/3.18/winbox.exe /opt/winbox.exe

ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod 755 /opt/winbox.exe /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

USER ${USER}

RUN mkdir -p ${HOME}/.wine/drive_c/users/user/Application\ Data/Mikrotik
