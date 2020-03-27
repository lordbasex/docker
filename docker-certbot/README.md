# Certbot
Dockerized [certbot][certbot].

### Note: 
Added symbolic link to automate installations, in the /etc/letsencrypt/live/ directory to not depend on the name of the domain or subdomain.

You can point to the certificates using the certificate directory

Example path
```
/etc/letsencrypt/live/certificate/cert.pem
/etc/letsencrypt/live/certificate/chain.pem
/etc/letsencrypt/live/certificate/fullchain.pem
/etc/letsencrypt/live/certificate/privkey.pem
```


## Obtaining certificates

The container will run certbot against all the domains provided with the environment variable `domains`.

If `-e distinct=true` is passed, certbot will be run separately for every listed domain.

```
docker run \
  -v /home/certbot/user-data/etc/letsencrypt:/etc/letsencrypt \
  -e domains="example.com,example.org" \
  -e email="me@example.com" \
  -p 80:80 \
  -p 443:443 \
  --volume=`pwd`/user-data/etc/letsencrypt:/etc/letsencrypt \
  --rm cnsoluciones/certbot:latest
```

### Renewing certificates

```
docker run \
  -v /home/certbot/user-data/etc/letsencrypt:/etc/letsencrypt \
  -e renew=true \
  -p 80:80 \
  -p 443:443 \
  --volume=`pwd`/user-data/etc/letsencrypt:/etc/letsencrypt \
  --rm cnsoluciones/certbot:latest
```

### Docker Compose - docker-compose.yml - Certificates 

```
version: '3.3'
services:

  certbot:
    container_name: certbot
    image: cnsoluciones/certbot:latest
    network_mode: host
    restart: always
    volumes:
      - ./user-data/etc/letsencrypt:/etc/letsencrypt
    environment:
      - "domains=${DOMAINS}"
      - "email=${EMAIL}"
```
```
docker-compose up && docker-compose rm -fsv
```

### Docker Compose - docker-compose.yml - Renewing 

```
version: '3.3'
services:

  certbot:
    container_name: certbot
    image: cnsoluciones/certbot:latest
    network_mode: host
    restart: always
    volumes:
      - ./user-data/etc/letsencrypt:/etc/letsencrypt
    environment:
      - "domains=${DOMAINS}"
      - "email=${EMAIL}"
    entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"
    network_mode: host
```


## Configuration Services

### Asterisk
#### Asterisk WebSocket /etc/asterisk/http.conf

```
[general]
enabled=yes
enablestatic=no
bindaddr=0.0.0.0
bindport=8088
prefix=
sessionlimit=100
session_inactivity=30000
session_keep_alive=15000
tlsenable=yes
tlsbindaddr=0.0.0.0:8089
tlscertfile=/etc/letsencrypt/live/certificate/fullchain.pem
tlsprivatekey=/etc/letsencrypt/live/certificate/privkey.pem
```

#### Asterisk PJSIP Transport TLS

```
[0.0.0.0-tls]
type=transport
protocol=tls
bind=0.0.0.0:5161
external_media_address=52.41.75.100
external_signaling_address=52.41.75.100
cert_file=/etc/letsencrypt/live/certificate/fullchain.pem
priv_key_file=/etc/letsencrypt/live/certificate/privkey.pem
method=default
verify_client=no
allow_reload=yes
tos=cs3
cos=3
local_net=172.44.16.0/20
```

#### Asterisk PJSIP Endpoint

```
[3838]
type=endpoint
aors=3838
auth=3838-auth
tos_audio=ef
tos_video=af41
cos_audio=5
cos_video=4
disallow=all
allow=opus
context=algusal-context
callerid=3838 <3838>

dtmf_mode=rfc4733
mailboxes=3838@default

mwi_subscribe_replaces_unsolicited=yes
transport=0.0.0.0-wss
aggregate_mwi=yes
use_avpf=yes
rtcp_mux=yes
bundle=yes
ice_support=yes
media_use_received_transport=yes
trust_id_inbound=yes
media_encryption=sdes
timers=yes
media_encryption_optimistic=yes
send_pai=yes
rtp_symmetric=yes
rewrite_contact=yes
force_rport=yes
language=en
one_touch_recording=on
record_on_feature=apprecord
record_off_feature=apprecord
media_encryption=dtls
dtls_verify=fingerprint
dtls_cert_file=/etc/letsencrypt/live/certificate/fullchain.pem
dtls_private_key=/etc/letsencrypt/live/certificate/privkey.pem
dtls_setup=actpass
dtls_rekey=0
```

### Apache /etc/httpd/conf.d/ssl.conf

```
Listen 443 https
SSLPassPhraseDialog exec:/usr/libexec/httpd-ssl-pass-dialog
SSLSessionCache         shmcb:/run/httpd/sslcache(512000)
SSLSessionCacheTimeout  300
SSLRandomSeed startup file:/dev/urandom  256
SSLRandomSeed connect builtin
SSLCryptoDevice builtin

<VirtualHost _default_:443>

DocumentRoot "/var/www/html"
ErrorLog logs/ssl_error_log
TransferLog logs/ssl_access_log
LogLevel warn

SSLEngine on
SSLProtocol all -SSLv2 -SSLv3
SSLCipherSuite HIGH:3DES:!aNULL:!MD5:!SEED:!IDEA

SSLCertificateFile "/etc/letsencrypt/live/certificate/cert.pem"
SSLCertificateKeyFile "/etc/letsencrypt/live/certificate/privkey.pem"
SSLCertificateChainFile "/etc/letsencrypt/live/certificate/fullchain.pem"

<Files ~ "\.(cgi|shtml|phtml|php3?)$">
    SSLOptions +StdEnvVars
</Files>
<Directory "/var/www/cgi-bin">
    SSLOptions +StdEnvVars
</Directory>

BrowserMatch "MSIE [2-5]" \
         nokeepalive ssl-unclean-shutdown \
         downgrade-1.0 force-response-1.0

CustomLog logs/ssl_request_log \
          "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"

</VirtualHost>
```

### Nginx 

```
server {
  listen      443 http2;
  listen      [::]:443 http2;
  server_name example.com;

  ssl on;
  ssl_certificate     /etc/nginx/certs/live/certificate/fullchain.pem;
  ssl_certificate_key /etc/nginx/certs/live/certificate/privkey.pem;

  [...]
```

### Mosquitto MQTT mosquitto.conf

```
port 1883
listener 8883

protocol websockets
log_dest file /mosquitto/log/mosquitto.log

cafile /etc/letsencrypt/live/certificate/chain.pem
certfile /etc/letsencrypt/live/certificate/fullchain.pem
keyfile /etc/letsencrypt/live/certificate/privkey.pem
```

[certbot]: https://certbot.eff.org/ "letsencrypt client website"