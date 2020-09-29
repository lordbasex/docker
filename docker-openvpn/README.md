# OpenVPN for Docker

OpenVPN server in a Docker container complete with an EasyRSA PKI CA.


## Quick Start


```
yum install -y vim screen mc net-tools git 
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

systemctl enable docker
systemctl start docker
systemctl start firewalld

firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --zone=public --add-port=3000/udp --permanent
firewall-cmd --reload
firewall-cmd --list-all
```

```
rm -fr /root/openvpn && mkdir -p /root/openvpn
docker run -v /root/openvpn/user-data:/etc/openvpn --rm cnsoluciones/openvpn-alpine ovpn_genconfig -u udp://IP_SERVER:3000
docker run -v /root/openvpn/user-data:/etc/openvpn --rm -it cnsoluciones/openvpn-alpine ovpn_initpki
```

# docker-compose.yml
vim /root/openvpn/docker-compose.yml
```
version: '2'
services:
  openvpn:
    cap_add:
     - NET_ADMIN
    image: cnsoluciones/openvpn-alpine
    container_name: openvpn
    ports:
     - "3000:1194/udp"
    restart: always
    volumes:
     - ./user-data:/etc/openvpn
     - /etc/localtime:/etc/localtime:ro
```
```
docker-compose up -d
```

## CLIENT

```
export CLIENTNAME="fpereira"
docker run -v /root/openvpn/user-data:/etc/openvpn --rm -it cnsoluciones/openvpn-alpine easyrsa build-client-full $CLIENTNAME nopass
docker run -v /root/openvpn/user-data:/etc/openvpn --rm -it cnsoluciones/openvpn-alpine ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn
```
## REVOKE CLIENT


```
docker run -v /root/openvpn/user-data:/etc/openvpn --rm -it cnsoluciones/openvpn-alpine ovpn_revokeclient $CLIENTNAME
```
Or

```
docker run -v /root/openvpn/user-data:/etc/openvpn --rm -it cnsoluciones/openvpn-alpine ovpn_revokeclient $CLIENTNAME remove
```

#based on https://github.com/rlesouef/alpine-openvpn
