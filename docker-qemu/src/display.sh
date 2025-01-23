#!/usr/bin/env bash
set -Eeuo pipefail

# Docker environment variables

: "${VGA:="std"}"           # VGA adaptor (std for text mode)
: "${DISPLAY:="web"}"       # Display type

[[ "$DISPLAY" == ":0" ]] && DISPLAY="web"

case "${DISPLAY,,}" in
  "vnc" )
    if [[ "${ARCH,,}" == "amd64" ]]; then
        DISPLAY_OPTS="-vga std -display vnc=:0,websocket=5700"
    else
        DISPLAY_OPTS="-display vnc=:0,websocket=5700 -device $VGA"
    fi
    ;;
  "web" )
    if [[ "${ARCH,,}" == "amd64" ]]; then
        DISPLAY_OPTS="-vga std -display vnc=:0,websocket=5700"
    else
        DISPLAY_OPTS="-display vnc=:0,websocket=5700 -device $VGA"
    fi
    ;;
  "ramfb" )
    if [[ "${ARCH,,}" == "amd64" ]]; then
        DISPLAY_OPTS="-vga std -display vnc=:0,websocket=5700"
    else
        DISPLAY_OPTS="-display vnc=:0,websocket=5700 -device ramfb"
    fi
    ;;
  "disabled" )
    DISPLAY_OPTS="-display none -device $VGA"
    ;;
  "none" )
    DISPLAY_OPTS="-display none"
    ;;
  *)
    if [[ "${ARCH,,}" == "amd64" ]]; then
        DISPLAY_OPTS="-vga std -display $DISPLAY,websocket=5700"
    else
        DISPLAY_OPTS="-display $DISPLAY,websocket=5700 -device $VGA"
    fi
    ;;
esac

return 0
