# docker-easy-rsa

Lord BaseX (c) 2014-2020
 Federico Pereira <fpereira@cnsoluciones.com>

This project docker-easy-rsa allows you to generate private keys and certificates for Server, Client and file .ovpn.

https://cnsoluciones.com/blog/crear-certificado-cliente-y-servidor-para-openvpn/

[![VIDEO](https://raw.githubusercontent.com/lordbasex/Docker/master/docker-easy-rsa/docker-easy-rsa.png)](https://youtu.be/0dSfInC6m7M)

## Run option 1

```
docker run --rm --name=easy-rsa -ti  --volume=`pwd`/keystore:/keystore cnsoluciones/easy-rsa:3.0.6-r0 create -a

```
## Run option 2
```
docker run --rm \
--name=easy-rsa \
-ti \
--volume=`pwd`/keystore:/keystore \
--env TZ='America/Argentina/Buenos_Aires' \
--env DOMAIN_OVPN='172.16.0.203' \
--env EASYRSA_REQ_COUNTRY='AR' \
--env EASYRSA_REQ_PROVINCE='Buenos Aires' \
--env EASYRSA_REQ_CITY='La Plata' \
--env EASYRSA_REQ_ORG='CNSoluciones' \
--env EASYRSA_REQ_EMAIL='fpereira@cnsoluciones.com' \
--env EASYRSA_REQ_OU='server' \
cnsoluciones/easy-rsa:3.0.6-r0 create -a
```


## OPTIONS
```
Docker Easy-RSA V.3 For OpenVPN
  -a | --all            Create Certificate Server, Create Certificate Client, Create File OVPN
  -s | --keygen:server  Create Certificate Server Only
  -c | --keygen:client  Create Certificate Client Only
  -C | --clear:all      Clear All Certificate
  -o | --ovpn:only      Create File OVPN Only
  -h | --help           Help
```

### MANUAL
```
docker run --rm --name=easy-rsa -ti  --volume=`pwd`/keystore:/keystore cnsoluciones/easy-rsa:3.0.6-r0
```

```
#var export
TZ='America/Argentina/Buenos_Aires'; export TZ
DOMAIN_OVPN='172.16.0.203'; export DOMAIN_OVPN
EASYRSA_REQ_COUNTRY='AR'; export EASYRSA_REQ_COUNTRY
EASYRSA_REQ_PROVINCE='Buenos Aires'; export EASYRSA_REQ_PROVINCE
EASYRSA_REQ_CITY='La Plata'; export EASYRSA_REQ_CITY
EASYRSA_REQ_ORG='CNSoluciones'; export EASYRSA_REQ_ORG
EASYRSA_REQ_EMAIL='fpereira@cnsoluciones.com'; export EASYRSA_REQ_EMAIL
EASYRSA_REQ_OU='server'; export EASYRSA_REQ_OU


mkdir -p /keystore/{ovpn,client,server}
cd /usr/share/easy-rsa/
rm -fr /usr/share/easy-rsa/vars
rm -fr /usr/share/easy-rsa/pki
cp -fra /usr/share/easy-rsa/vars.example /usr/share/easy-rsa/vars
echo 'set_var EASYRSA_REQ_COUNTRY "${EASYRSA_REQ_COUNTRY}"' >> /usr/share/easy-rsa/vars 
echo 'set_var EASYRSA_REQ_PROVINCE "${EASYRSA_REQ_PROVINCE}"' >> /usr/share/easy-rsa/vars
echo 'set_var EASYRSA_REQ_CITY "${EASYRSA_REQ_CITY}"' >> /usr/share/easy-rsa/vars
echo 'set_var EASYRSA_REQ_ORG "${EASYRSA_REQ_ORG}"' >> /usr/share/easy-rsa/vars
echo 'set_var EASYRSA_REQ_EMAIL "${EASYRSA_REQ_EMAIL}"' >> /usr/share/easy-rsa/vars
echo 'set_var EASYRSA_REQ_OU "${EASYRSA_REQ_OU}"' >> /usr/share/easy-rsa/vars

/usr/share/easy-rsa/easyrsa init-pki

#expect server
/usr/share/easy-rsa/build-ca
/usr/share/easy-rsa/gen-req server
/usr/share/easy-rsa/sign-req server server
/usr/share/easy-rsa/easyrsa gen-dh

#copy certificate server
cp -fra /usr/share/easy-rsa/pki/ca.crt /keystore/server
cp -fra /usr/share/easy-rsa/pki/private/server.key /keystore/server
cp -fra /usr/share/easy-rsa/pki/issued/server.crt /keystore/server


#expect client
/usr/share/easy-rsa/gen-req client
/usr/share/easy-rsa/sign-req client client

#copy certificate client
cp -fra /usr/share/easy-rsa/pki/ca.crt /keystore/client
cp -fra /usr/share/easy-rsa/pki/issued/client.crt /keystore/client
cp -fra /usr/share/easy-rsa/pki/private/client.key /keystore/client


# create ovpn secret
cat > /keystore/ovpn/client.ovpn <<ENDLINE
client
dev tun
proto tcp-client
remote ${DOMAIN_OVPN}
port 1443
nobind
persist-key
persist-tun
tls-client
remote-cert-tls server
ca ca.crt
cert client.crt
key client.key
verb 3
mute 10
cipher AES-256-CBC
auth SHA1
auth-user-pass secret
auth-nocache

#vpn
route 10.10.10.0 255.255.255.0

#example1
route 192.168.0.0 255.255.255.0

#example2
route 172.17.0.0 255.255.255.0
ENDLINE

cat > /keystore/ovpn/secret <<ENDLINE
client
plokij
ENDLINE

#copy certificate server
cp -fra /usr/share/easy-rsa/pki/ca.crt /keystore/ovpn
cp -fra /usr/share/easy-rsa/pki/issued/client.crt /keystore/ovpn
cp -fra /usr/share/easy-rsa/pki/private/client.key /keystore/ovpn


#copy certificate all
cp -fra /usr/share/easy-rsa/pki /keystore
```
