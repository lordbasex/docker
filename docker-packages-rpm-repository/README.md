# Docker Packages RPM Repository

## Docker build

```bash
docker build -t cnsoluciones/httpd:latest -f Dockerfile .
```

## Example Usage with Data Inside Docker

```bash
docker run --name packages -itd -p 0.0.0.0:80:80/tcp cnsoluciones/httpd:latest
```

## Docker Compose - nginx-proxy

```bash
version: '2'
services:
  packages:
   container_name: packages
   image: cnsoluciones/httpd:latest
   expose:
     - 80
   volumes:
     - ./user-data/html:/var/www/html
     - ./user-data/root/.gnupg:/root/.gnupg
     - /etc/localtime:/etc/localtime:ro
   environment:
     - "VIRTUAL_HOST=packages.cnsoluciones.com"
     - "VIRTUAL_PORT=80"
   restart: always
networks:
 default:
   external:
     name: nginx-net
```

## Docker Auto Start boot

dcsg: A systemd service generator for docker-compose

```bash
curl -L https://github.com/andreaskoch/dcsg/releases/download/v0.3.0/dcsg_linux_amd64 > /usr/local/bin/dcsg
chmod +x /usr/local/bin/dcsg
```

```bash
dcsg install docker-compose.yml
```
