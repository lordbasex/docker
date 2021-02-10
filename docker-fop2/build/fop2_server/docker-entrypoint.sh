#!/bin/bash
set -e

if [ -z "$(ls -A /usr/local/fop2 )" ]; then
  mkdir -p /usr/local/fop2
  cp -fra  /usr/local/fop2.org/* /usr/local/fop2/
fi

echo "FOP2 - Configuration file fop2.cfg"
sed -i "s/\(manager_host*\)\(.*\)/\1=$FOP2_AMI_HOST/" /usr/local/fop2/fop2.cfg
sed -i "s/\(manager_port*\)\(.*\)/\1=$FOP2_AMI_PORT/" /usr/local/fop2/fop2.cfg
sed -i "s/\(manager_user*\)\(.*\)/\1=$FOP2_AMI_USER/" /usr/local/fop2/fop2.cfg 
sed -i "s/\(manager_secret*\)\(.*\)/\1=$FOP2_AMI_SECRET/" /usr/local/fop2/fop2.cfg
sed -i "s/\(web_dir*\)\(.*\)/\1=\/var\/www\/html/" /usr/local/fop2/fop2.cfg
sed 's|ssl_certificate_file=/etc/pki/tls/certs/localhost.crt|ssl_certificate_file=/etc/letsencrypt/live/certificate/fullchain.pem|'  "/usr/local/fop2/fop2.cfg" > /tmp/fop2.cfg
cat /tmp/fop2.cfg > /usr/local/fop2/fop2.cfg
sed 's|ssl_certificate_key_file=/etc/pki/tls/private/localhost.key|ssl_certificate_key_file=/etc/letsencrypt/live/certificate/privkey.pem|'  "/usr/local/fop2/fop2.cfg" > /tmp/fop2.cfg
cat /tmp/fop2.cfg > /usr/local/fop2/fop2.cfg
touch /usr/local/fop2/buttons_custom.cfg
echo "plugin=phone:/var/www/html/admin/plugins/phone" >> /usr/local/fop2/fop2.cfg
echo "buttonfile=buttons_custom.cfg" >> /usr/local/fop2/fop2.cfg
echo "buttonfile=buttons_custom_trunk.cfg" >> /usr/local/fop2/fop2.cfg

cat > /usr/local/fop2/buttons_custom_trunk.cfg  <<ENDLINE
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

echo "FOP2 - RUN"

exec "$@"
