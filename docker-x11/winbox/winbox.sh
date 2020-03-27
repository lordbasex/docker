#!/usr/bin/env sh

WINEPREFIX=${HOME}/Dropbox/docker-root/.wine
IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')

docker run -itd \
    --rm \
    --name winbox \
    --privileged \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix" \
    --volume="${WINEPREFIX}:/root/.wine" \
    --env="DISPLAY=${IP}:0" \
    cnsoluciones/winbox64:3.22
