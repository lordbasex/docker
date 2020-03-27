#!/bin/bash
set -e

if [ -z "$(ls -A /usr/local/fop2 )" ]; then
  mkdir -p /usr/local/fop2
  cp -fra /usr/src/fop2/server/* /usr/local/fop2/

echo "Configuration file fop2.cfg"
sed -i "s/\(manager_host*\)\(.*\)/\1=$FOP2_AMI_HOST/" /usr/local/fop2/fop2.cfg
sed -i "s/\(manager_port*\)\(.*\)/\1=$FOP2_AMI_PORT/" /usr/local/fop2/fop2.cfg
sed -i "s/\(manager_user*\)\(.*\)/\1=$FOP2_AMI_USER/" /usr/local/fop2/fop2.cfg 
sed -i "s/\(manager_secret*\)\(.*\)/\1=$FOP2_AMI_SECRET/" /usr/local/fop2/fop2.cfg
sed -i "s/\(web_dir*\)\(.*\)/\1=\/var\/www\/html/" /usr/local/fop2/fop2.cfg
sed 's|ssl_certificate_file=/etc/pki/tls/certs/localhost.crt|ssl_certificate_file=/etc/letsencrypt/live/certificate/fullchain.pem|'  "/usr/local/fop2/fop2.cfg" > /tmp/fop2.cfg
cat /tmp/fop2.cfg > /usr/local/fop2/fop2.cfg
sed 's|ssl_certificate_key_file=/etc/pki/tls/private/localhost.key|ssl_certificate_key_file=/etc/letsencrypt/live/certificate/privkey.pem|'  "/usr/local/fop2/fop2.cfg" > /tmp/fop2.cfg
cat /tmp/fop2.cfg > /usr/local/fop2/fop2.cfg
echo "plugin=phone:/var/www/html/admin/plugins/phone" >> /usr/local/fop2/fop2.cfg


if [ ! -f /var/www/html/.htaccess ]; then
cat >> /var/www/html/.htaccess <<ENDLINE
AuthType Basic
AuthName "Restricted Content"
AuthUserFile /htpasswd/.htpasswd
Require valid-user
ENDLINE
fi

echo "buttonfile=buttons_custom.cfg" >> /usr/local/fop2/fop2.cfg

cat > /usr/local/fop2/buttons_custom.cfg  <<ENDLINE
[SIP/PBX-OUT]
type=trunk
label=PBX-OUT
autoanswerheader=__SIPADDHEADER51=Call-Info: answer-after=0.001

[SIP/6001]
type=trunk
label=WEBPHONE
autoanswerheader=__SIPADDHEADER51=Call-Info: answer-after=0.001

ENDLINE

rm -fr /tmp/fop2.cfg

fi
exec "$@"
