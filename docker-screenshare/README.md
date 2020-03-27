# Docker Screen Share WebRTC

Lord BaseX (c) 2014-2020
 Federico Pereira <fpereira@cnsoluciones.com>

## Install Docker - Amazon Linux 2 AMI
```

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
```

```bash
sudo su
yum -y update
yum -y install docker
yum -y install git wget mc screen htop
```

## Install Firewall
```bash
yum -y install firewalld
systemctl start firewalld
systemctl enable firewalld
systemctl status firewalld
```

## Custom Docker
```bash
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<ENDLINE
{
  "graph": "/home/docker",
  "bip": "172.17.0.1/24"
}
ENDLINE

systemctl enable docker
systemctl start docker
```

## Docker Compose
```bash
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o  /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
```

## Docker Login
```bash
docker login
```

### Docker create cert letsencrypt

```bash
systemctl stop firewalld
docker-compose -f certbot.yml up
docker-compose -f certbot.yml down
systemctl start firewalld
```

### Deploy APP


### docker-compose.yml
```bash
version: '3.3'
services:

    certbot:
    container_name: certbot
    image: cnsoluciones/certbot:latest
    restart: always
    volumes:
        - ./user-data/etc/letsencrypt:/etc/letsencrypt
    entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"
    network_mode: host

    screenshare:
        container_name: screenshare
        image: cnsoluciones/screenshare:latest
        volumes:
            - /etc/localtime:/etc/localtime:ro
            - ./user-data/etc/letsencrypt:/etc/letsencrypt
        environment:
            - "LINK=http://www.cnsoluciones.com"
            - "PORT=9559"
        depends_on:
            - certbot
        restart: always
        network_mode: host
```

## Firewall
```bash
#SSH
firewall-cmd --zone=public --add-port=22/tcp --permanent

#WEBRTC
firewall-cmd --zone=public --add-port=9559/tcp --permanen

#CERTBOT
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent

firewall-cmd --reload
firewall-cmd --list-all
```

## DOCKER HUB
```bash
docker push cnsoluciones/screenshare
```

