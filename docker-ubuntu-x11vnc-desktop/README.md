# docker-ubuntu-x11vnc-desktop


based on https://github.com/fcwu/docker-ubuntu-vnc-desktop optimized for debug VoIP


* zoiper 5
* sngrep
* nmap
* wireshark
* htop
* traceroute
* mc
* screen
* iputils-ping

EJ1
```
docker run --rm --name ubuntu -it -p8080:80 -e HTTP_PASSWORD=plokij cnsoluciones/x11vnc-desktop:20.04
```

EJ2
```
docker run --rm --name ubuntu -it --net=MKT02 --ip=172.17.1.103 -e HTTP_PASSWORD=plokij cnsoluciones/x11vnc-desktop:20.04
```
