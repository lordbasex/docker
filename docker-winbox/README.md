# noVNC Winbox

Lord BaseX (c) 2014-2020
 Federico Pereira <fpereira@cnsoluciones.com>

<img src="https://raw.githubusercontent.com/lordbasex/docker/master/docker-winbox/screenshot/novnc-winbox-01.png" width="400" /><img src="https://raw.githubusercontent.com/lordbasex/docker/master/docker-winbox/screenshot/novnc-winbox-02.png" width="400" />

This docker image is made for laboratory use and testing only. We are not responsible if you use it for commercial purposes or if you use it in production.

## How to use


### Use image from docker hub

```bash
docker pull cnsoluciones/novnc-winbox
```

```bash
docker run --rm --name=winbox -tid -p -p 5901:5900 -p 18081:8080 cnsoluciones/novnc-winbox:latest
```


### Use in docker-compose.yml

Example is [here](docker-compose.yml).

```yml
version: "3.3"

services:

  winbox:
    image: cnsoluciones/novnc-winbox:latest
    container_name: winbox
    restart: always
    #volumes:
    # - ./user-data/.wine:/home/alpine/.wine
    ports:
      - "5901:5900"
      - "18081:8080"
    network_mode: bridge
```

## List of exposed ports

For access via VNC: 5901 Or [noVNC http://localhost:18081/](http://localhost:18081/)


## Github
Visit my github where I have several projects with Docker [CNSoluciones](https://github.com/lordbasex/Docker)
