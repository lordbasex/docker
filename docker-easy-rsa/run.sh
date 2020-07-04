#!/bin/bash

mkdir -p /keystore/{ovpn,client,server}
cd /usr/share/easy-rsa/
rm -fr /usr/share/easy-rsa/vars

if [ ! -z "$( ls -A /keystore/pki )" ]; then
  cp -fra /keystore/pki /usr/share/easy-rsa
fi

cp -fra /usr/share/easy-rsa/vars.example /usr/share/easy-rsa/vars
echo 'set_var EASYRSA_REQ_COUNTRY "${EASYRSA_REQ_COUNTRY}"' >> /usr/share/easy-rsa/vars
echo 'set_var EASYRSA_REQ_PROVINCE "${EASYRSA_REQ_PROVINCE}"' >> /usr/share/easy-rsa/vars
echo 'set_var EASYRSA_REQ_CITY "${EASYRSA_REQ_CITY}"' >> /usr/share/easy-rsa/vars
echo 'set_var EASYRSA_REQ_ORG "${EASYRSA_REQ_ORG}"' >> /usr/share/easy-rsa/vars
echo 'set_var EASYRSA_REQ_EMAIL "${EASYRSA_REQ_EMAIL}"' >> /usr/share/easy-rsa/vars
echo 'set_var EASYRSA_REQ_OU "${EASYRSA_REQ_OU}"' >> /usr/share/easy-rsa/vars

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -a|--all)
            clear
            rm -fr /usr/share/easy-rsa/pki
            rm -fr /keystore/pki

	    /usr/share/easy-rsa/easyrsa init-pki

	    echo "Create Certificate Server, Create Certificate Client, Create File OVPN\n"
            echo ">>> Create Server <<<"

	    #expect server
	    /usr/share/easy-rsa/build-ca
	    /usr/share/easy-rsa/gen-req server
	    /usr/share/easy-rsa/sign-req server server
	    /usr/share/easy-rsa/easyrsa gen-dh

	    #copy certificate server
            cp -fra /usr/share/easy-rsa/pki/ca.crt /keystore/server
	    cp -fra /usr/share/easy-rsa/pki/private/server.key /keystore/server
	    cp -fra /usr/share/easy-rsa/pki/issued/server.crt /keystore/server


            echo ">>> Create Client <<<"

	    #expect client
	    /usr/share/easy-rsa/gen-req client
	    /usr/share/easy-rsa/sign-req client client

	    #copy certificate client
            cp -fra /usr/share/easy-rsa/pki/ca.crt /keystore/client
            cp -fra /usr/share/easy-rsa/pki/issued/client.crt /keystore/client
	    cp -fra /usr/share/easy-rsa/pki/private/client.key /keystore/client

	    echo ">>> Create configuration Client <<<"
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

CA=`cat /usr/share/easy-rsa/pki/ca.crt`
CERT=`cat /usr/share/easy-rsa/pki/issued/client.crt | tail -n 20`
KEY=`cat /usr/share/easy-rsa/pki/private/client.key`

cat > /keystore/ovpn/client_one_file.ovpn <<ENDLINE
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

<ca>
$CA
</ca>

<cert>
$CERT
</cert>

<key>
$KEY
</key>

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

            echo ">>> Backup Certificate Original <<<"

	    #copy certificate all
	    cp -fra /usr/share/easy-rsa/pki /keystore

            exit
        ;;
        -s|--keygen:server)
            clear
            rm -fr /usr/share/easy-rsa/pki
            rm -fr /keystore/pki

            /usr/share/easy-rsa/easyrsa init-pki

            echo ">>> Create Certificate Server Only <<<"

	    #expect server
	    /usr/share/easy-rsa/build-ca
	    /usr/share/easy-rsa/gen-req server
	    /usr/share/easy-rsa/sign-req server server
	    /usr/share/easy-rsa/easyrsa gen-dh

	    #copy certificate server
            cp -fra /usr/share/easy-rsa/pki/ca.crt /keystore/server
	    cp -fra /usr/share/easy-rsa/pki/private/server.key /keystore/server
	    cp -fra /usr/share/easy-rsa/pki/issued/server.crt /keystore/server

            #copy certificate all
            cp -fra /usr/share/easy-rsa/pki /keystore

            exit
        ;;
        -c|--keygen:client)
            clear
            echo ">>> Create Certificate Client Only <<<"

	    if [ ! -f /usr/share/easy-rsa/pki/ca.crt  ! -f /usr/share/easy-rsa/pki/private/server.key  ! -f /usr/share/easy-rsa/pki/issued/server.crt ]; then
	    	echo "--> Server certificates are required first to create client certificate. <-- \n"
		echo "Ejecute: ./create -s"
	    fi

            exit
        ;;
        -C|--clear:all)
            clear
            echo ">>> Clear All Certificate <<<"
	    rm -fr /usr/share/easy-rsa/pki
	    rm -fr /keystore/pki
            exit
        ;;
        -o|--ovpn:only)
            clear
            echo ">>> Create File OVPN Only <<<"
	    echo ">>> Create configuration Client <<<"
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

CA=`cat /usr/share/easy-rsa/pki/ca.crt`
CERT=`cat /usr/share/easy-rsa/pki/issued/client.crt | tail -n 20`
KEY=`cat /usr/share/easy-rsa/pki/private/client.key`

cat > /keystore/ovpn/client_one_file.ovpn <<ENDLINE
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

<ca>
$CA
</ca>

<cert>
$CERT
</cert>

<key>
$KEY
</key>

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
            exit
        ;;

        -h|--help)
            clear
            echo "Docker Easy-RSA V.3 For OpenVPN"
            echo "  -a | --all            Create Certificate Server, Create Certificate Client, Create File OVPN"
            echo "  -s | --keygen:server  Create Certificate Server Only"
            echo "  -c | --keygen:client  Create Certificate Client Only"
            echo "  -C | --clear:all      Clear All Certificate"
            echo "  -o | --ovpn:only      Create File OVPN Only"
            echo "  -h | --help           Help"
            exit
        ;;
    esac
done
