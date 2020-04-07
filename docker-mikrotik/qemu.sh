#!/bin/sh

if [ $VNCPASSWORD = "true" ]; then
    PASSWORD=',password'
    echo 1 > /opt/vncpassword
fi

qemu-system-x86_64 \
    -vnc 0.0.0.0:0$PASSWORD \
    -monitor telnet:127.0.0.1:4444,server,nowait \
    -serial telnet:0.0.0.0:5000,server,nowait \
    -m 256 \
    -hda $ROUTEROS_IMAGE \
    -device e1000,netdev=net0 \
    -k $KEYBOARD \
    -netdev user,id=net0,hostfwd=tcp::21-:21,hostfwd=tcp::22-:22,hostfwd=tcp::23-:23,hostfwd=tcp::80-:80,hostfwd=tcp::443-:443,hostfwd=tcp::500-:500,hostfwd=tcp::1194-:1194,hostfwd=tcp::1701-:1701,hostfwd=tcp::1723-:1723,hostfwd=tcp::4500-:4500,hostfwd=tcp::8291-:8291,hostfwd=tcp::8728-:8728,hostfwd=tcp::8729-:8729
