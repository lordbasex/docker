# docker-rttys

- Version：2.10.3
- [Docker Hub](https://hub.docker.com/r/ztj1993/rttys)

## Description

This image is built [zhaojh329/rttys](https://github.com/zhaojh329/rttys) service.

The release version number will follow the service version number.

## Quick start

Run rttys mirror：
```
docker run -d --name rttys cnsoluciones/rttys:2.10.3
```

Map port：
```
docker run  -d --name rttys -p 5912:5912 cnsoluciones/rttys:2.10.3
```

docker compose：
```
version: '2'
services:
  rttys:
    container_name: rttys
    image: cnsoluciones/rttys:2.10.3
    #build: .
    ports:
      - 5912:5912
    environment:
      RTTYS_USERNAME: admin
      RTTYS_PASSWORD: admin
      RTTYS_TOKEN: a98150a573fb88837b7ea3147c1b9fd0
    volumes:
      - ./user-data/ca.crt:/rttys/rttys.crt
      - ./user-data/ca.key:/rttys/rttys.key
      - /etc/localtime:/etc/localtime:ro
```

The above correct output is similar：
```
Go Version: go1.12.4
Go OS/Arch: linux/amd64
Rttys Version: 2.10.3
Git Commit: 27abde3
Build Time: 2019-08-13T11:26:31+0800 
Listen on: :5912 SSL on
```

## Environmental variable

The environment variable is mainly the configuration of rttys.

- RTTYS_USERNAME: User name, default admin
- RTTYS_PASSWORD: User password, default admin
- RTTYS_TOKEN: User token, default automatic random generation.

## Docker CLI

### Docker build
```
docker-compose up --build
```

### Docker down
``` 
docker-compose down
```

### Docker log
```
docker-compose exec rttys tail -f /var/log/rttys.log 
```

### Docker cli
```
docker-compose exec rttys bash
```

### Client - For Linux distribution: Ubuntu, Debian, ArchLinux, Centos.
```
wget -qO- https://raw.githubusercontent.com/zhaojh329/rtty/master/tools/install.sh | sudo bash
rtty -i enp2s0 -h 172.16.0.11 -p 5912 -a -v -s -d 'demo 1' -t a98150a573fb88837b7ea3147c1b9fd0
```

### Service System
```
cat > /etc/systemd/system/rtty.service <<ENDLINE
[Unit]
Description=RTTY Client
After=network.target

[Service]
Environment="IFNAME=enp2s0"
Environment="HOST=172.16.0.11"
Environment="PORT=5912"
Environment="DESCRIPTION=demo 1"
Environment="TOKEN=a98150a573fb88837b7ea3147c1b9fd0"
WorkingDirectory=/usr/local/bin
ExecStart=/usr/local/bin/rtty -i \$IFNAME -h \$HOST -p \$PORT -a -s -d \$DESCRIPTION -t \$TOKEN -D
KillMode=process

[Install]
WantedBy=multi-user.target
ENDLINE
```

## Systemctl

```
systemctl enable rtty
systemctl start rtty
```
