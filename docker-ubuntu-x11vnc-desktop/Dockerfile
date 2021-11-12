FROM dorowu/ubuntu-desktop-lxde-vnc

LABEL maintainer="Federico Pereira <fpereira@cnsoluciones.com>"

ENV DEBIAN_FRONTEND=noninteractive

ADD Zoiper5_5.5.8_x86_64.deb /usr/src

RUN apt update \
    && apt-get install -y --no-install-recommends sngrep nmap wireshark libnotify4 libv4lconvert0 libv4l-0 notification-daemon htop traceroute mc screen iputils-ping \
    && apt-get install -y pulseaudio socat alsa-utils ffmpeg \
    && dpkg -i /usr/src/Zoiper5_5.5.8_x86_64.deb \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*  /usr/src/Zoiper5_5.5.8_x86_64.deb
