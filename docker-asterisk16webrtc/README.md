# Docker Asterisk 16 WebRTC

Lord BaseX (c) 2014-2020
 Federico Pereira <fpereira@cnsoluciones.com>

# Install

* [Deploy Amazon AWS - EC2 - Install Docker - Amazon Linux 2 AMI](https://github.com/lordbasex/docker/blob/master/deploy_amazon_aws.md)


### Deploy APP 
```
mkdir -p /home/ec2-user/asterisk16webrtc/db
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/docker-compose.yml -O /home/ec2-user/asterisk16webrtc/docker-compose.yml
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/certbot.yml -O /home/ec2-user/asterisk16webrtc/certbot.yml
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/.env -O /home/ec2-user/asterisk16webrtc/.env
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/db/asteriskcdr.sql -O /home/ec2-user/asterisk16webrtc/db/asteriskcdr.sql
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/db/asteriskdb.sql -O /home/ec2-user/asterisk16webrtc/db/asteriskdb.sql
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/db/docker-entrypoint.sh -O /home/ec2-user/asterisk16webrtc/db/docker-entrypoint.sh
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/createextension -O /home/ec2-user/asterisk16webrtc/createextension
chmod 777 /home/ec2-user/asterisk16webrtc/db/docker-entrypoint.sh /home/ec2-user/asterisk16webrtc/createextension
cd /home/ec2-user/asterisk16webrtc
```

### Docker create cert letsencrypt
NOTE: Please modify **.env** file before doing the **docker-compose -f certbot.yml up**
```
systemctl stop firewalld
docker-compose -f certbot.yml up
docker-compose -f certbot.yml down
systemctl start firewalld
```

### Docker run
```
cd /home/ec2-user/asterisk16webrtc
docker-compose up -d
```

### Firewall
```bash
#SSH
firewall-cmd --zone=public --add-port=22/tcp --permanent

##ASTERISK WEBRTC
firewall-cmd --zone=public --add-port=8089/tcp --permanent

#ASTERISK SIP
firewall-cmd --zone=public --add-port=5060/udp --permanent
firewall-cmd --zone=public --add-port=10000-20000/udp --permanent

firewall-cmd --reload
firewall-cmd --list-all
```

### Create Extension Manual

**pjsip_template_aor.conf**

```bash
vim /home/ec2-user/asterisk16webrtc/user-data/etc/asterisk/pjsip_template_aor.conf
[2324](template-aor)
````
**pjsip_template_auth.conf**

```bash
vim /home/ec2-user/asterisk16webrtc/user-data/etc/asterisk/pjsip_template_auth.conf 
[2324-auth](template-auth)
username=2324
password=mi_clave
```

**pjsip_template_endpoint.conf**

```bash
vim /home/ec2-user/asterisk16webrtc/user-data/etc/asterisk/pjsip_template_endpoint.conf
[2324](template-endpoint)
aors=2324
auth=2324-auth
callerid=2324 <2324>
```

### Create Extension Script

```bash
cd /home/ec2-user/asterisk16webrtc/
./createextension
```

