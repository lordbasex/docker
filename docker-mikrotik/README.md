# Mikrotik RouterOS in Docker

This docker image is made for laboratory use and testing only. We are not responsible if you use it for commercial purposes or if you use it in production.

Image based on [docker-routeros](https://github.com/EvilFreelancer/docker-routeros)

## How to use


### Use image from docker hub

```bash
docker pull cnsoluciones/mikrotik
```

```bash
docker run  --name=mkt01 -tid -p 121:21 -p 122:22 -p 123:23 -p 150:50 -p 151:51 -p 180:80 -p 1443:443 -p 1500:500 -p 11194:1194 -p 11701:1701 -p 11723:1723 -p 14500:4500 -p 15900:5900 -p "18080:8080" -p 18291:8291 -p 18728:8728 -p 18729:8729 cnsoluciones/mikrotik
```


### Use in docker-compose.yml

Example is [here](docker-compose.yml).

```yml
version: "3.3"

services:

  mkt01:
    image: cnsoluciones/mikrotik:6.46.4
    container_name: mkt01
    restart: always
    ports:
      - "121:21"
      - "122:22"
      - "123:23"
      - "150:50"
      - "151:51"
      - "180:80"
      - "1443:443"
      - "1500:500"
      - "11194:1194"
      - "11701:1701"
      - "11723:1723"
      - "14500:4500"
      - "15900:5900"
      - "18080:8080"
      - "18291:8291"
      - "18728:8728"
      - "18729:8729"
    environment:
      - "VNCPASSWORD=false"
    network_mode: bridge
    privileged: true
```

## List of exposed ports

For access via VNC: 5900 Or [noVNC http://localhost:18080/](http://localhost:18080/)

Default ports of RouterOS: 21, 22, 23, 80, 443, 8291, 8728, 8729

IPSec: 50, 51, 500, 4500

OpenVPN: 1194

L2TP: 1701

PPTP: 1723

# noVNC Password

* Change variable VNCPASSWORD=true*
* docker exec mkt01 cli changepassword mypassword

## Github
Visit my github where I have several projects with Docker [CNSoluciones](https://github.com/lordbasex/Docker)
