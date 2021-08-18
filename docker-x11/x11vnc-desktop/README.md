# Docker Image for Ubuntu with X11 and VNC

This is a Docker image for Ubuntu with X11 and VNC. It is similar to
[fcwu/docker-ubuntu-vnc-desktop](https://github.com/fcwu/docker-ubuntu-vnc-desktop), but with enhancements on security and features.


## CUSTOM imagen

Pakages 
 * wine-stable
 * winbox64.exe

```
docker run --rm --name ubuntu -it -p6080:6080  cnsoluciones/x11vnc-desktop:18.04
```

```bash
curl -fsSL https://raw.githubusercontent.com/lordbasex/Docker/master/X11Docker/x11vnc-desktop/x11vnc_desktop.py -o x11vnc_desktop.py && python x11vnc_desktop.py -i cnsoluciones/x11vnc-desktop -t 18.04 -v ubuntu -v /Users/basex/x11vnc-desktop
```
