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

## Example 1
```
docker run --rm --name ubuntu -it -p8080:80 -e HTTP_PASSWORD=plokij cnsoluciones/x11vnc-desktop:20.04
```

## Example 1
```
docker run --rm --name ubuntu -it --net=MKT02 --ip=172.17.1.103 -e HTTP_PASSWORD=plokij cnsoluciones/x11vnc-desktop:20.04
```
### More info https://github.com/fcwu/docker-ubuntu-vnc-deskto
