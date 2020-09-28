```
yum install -y vim screen mc net-tools git 

systemctl stop firewalld
systemctl start firewalld

firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --zone=public --add-port=3000/udp --permanent
firewall-cmd --reload
firewall-cmd --list-all
```

```
mkdir -p /root/openvpn && cd /root/openvpn
docker run -v /root/openvpn/user-data:/etc/openvpn --rm cnsoluciones/openvpn-alpine initopenvpn -u udp://IP_DEL_SERVIDOR:3000
docker run -v /root/openvpn/user-data:/etc/openvpn --rm -it cnsoluciones/openvpn-alpine initpki #define una clave para el CA #importante guardarla con 7 llaves.
```

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


## CLIENT

```
export CLIENTNAME="fpereira"
docker run -v /root/openvpn/user-data:/etc/openvpn --rm -it rlesouef/alpine-openvpn easyrsa build-client-full $CLIENTNAME nopass
docker run -v /root/openvpn/user-data:/etc/openvpn --rm rlesouef/alpine-openvpn getclient $CLIENTNAME > $CLIENTNAME.ovpn
```
## REVOKE CLIENT
```

Revoca el certificado de un cliente
# Dejando los archivos crt, key y req.
```
docker run -v /root/openvpn/user-data:/etc/openvpn --rm cnsoluciones/openvpn-alpine ovpn_revokeclient $CLIENTNAME
```

# Borrando los correspondientes archivos crt, key y req.
```
docker run -v /root/openvpn/user-data:/etc/openvpn --rm cnsoluciones/openvpn-alpine ovpn_revokeclient $CLIENTNAME remove
```
#based on https://github.com/rlesouef/alpine-openvpn
