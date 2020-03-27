# Docker vtigerCRM 7.1.0


## Docker build

```bash
docker build -t cnsoluciones/vtiger:7.1.0 -f Dockerfile .
```

## Example Usage with Data Inside Docker

```bash
docker run --name vtiger -itd -p 0.0.0.0:80:80/tcp -p 0.0.0.0:443:443/tcp cnsoluciones/vtiger:7.1.0
```

## Docker Compose - nginx-proxy

```bash
version: '2'
services:
  vtiger:
   container_name: vtiger
   image: cnsoluciones/vtiger:7.1.0
   expose:
     - 80
     - 443
   volumes:
     - ./user-data/vtigercrm:/var/www/html/vtigercrm
     - /etc/localtime:/etc/localtime:ro
   environment:
    - "VIRTUAL_HOST=crm.cnsoluciones.com"
    - "VIRTUAL_PORT=443"
    - "VIRTUAL_PROTO=https"
    - "LETSENCRYPT_HOST=crm.cnsoluciones.com"
    - "LETSENCRYPT_EMAIL=info@cnsoluciones.com"
    - "DB_HOSTNAME=mariadbv"
    - "DB_NAME=vtiger710"
    - "DB_USERNAME=vtiger_us"
    - "DB_PASSWORD=${MYSQL_VTIGER_US_PW}"
    - "ADMIN_NAME=Federico"
    - "ADMIN_LASTNAME=Pereira"
    - "ADMIN_PASSWORD=mypassword"
    - "ADMIN_EMAIL=info@cnsoluciones.com"
    - "LANGUAGE=es_es"
    - "CURRENCIES=Argentina, Pesos"
    - "DATEFORMAT=dd-mm-yyyy"
    - "TIMEZONE=America/Argentina/Buenos_Aires"
    - "PACKAGES_SALE=on"
    - "PACKAGES_MARKETING=on"
    - "PACKAGES_SUPPORT=on"
    - "PACKAGES_INVENTORY=on"
    - "PACKAGES_PROJECT=on"
   depends_on:
     - mariadbv
   restart: always
  mariadbv:
   container_name: mariadbv
   image: mariadb:latest
   ports:
     - 3306
   volumes:
     - ./user-data/database:/var/lib/mysql
     - /etc/localtime:/etc/localtime:ro
   environment:
    - "MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PW}"
    - "MYSQL_DATABASE=vtiger710"
    - "MYSQL_USER=vtiger_us"
    - "MYSQL_PASSWORD=${MYSQL_VTIGER_US_PW}"
   command: mysqld --sql_mode="" --character-set-server=utf8 --collation-server=utf8_unicode_ci
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
