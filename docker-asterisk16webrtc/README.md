# Docker Asterisk 16 WebRTC

Lord BaseX (c) 2014-2021
 Federico Pereira <fpereira@cnsoluciones.com>


### Instalación Paquetes para Debian 10

Nos conectamos al servidor utilizando algún cliente SSH e instalamos los siguientes paquetes.

Lista de paquetes a instalar:

* vim
* curl
* screen
* mc
* git
* unzip
* net-tools
* links2
* sudo
* nmap
* make
* mycli
* ufw
* docker
* docker-compose

Ejecutamos los siguientes comandos.

```bash
apt update
apt -y install vim curl screen mc git unzip net-tools links2 sudo nmap make mycli ufw
```


## Instalando Docker
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
docker info
```

## Customización docker

```bash
cat > /etc/docker/daemon.json <<ENDLINE
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m"
  }
}
ENDLINE
```

## Instalado docker-compose

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Personalizando el Prompt

```bash 
> /root/.bashrc && vim /root/.bashrc
````

Pegamos lo siguiente:

```bash
# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

export HISTTIMEFORMAT="%d/%m/%y %T "

export LC_CTYPE=C
export LC_MESSAGES=C
export LC_ALL=C
export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin
```
### Recargamos el /root/.bashrc

```bash
source /root/.bashrc
```


### Deploy APP 
```
mkdir -p /root/asterisk16webrtc/db
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/docker-compose.yml -O /root/asterisk16webrtc/docker-compose.yml
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/certbot.yml -O /root/asterisk16webrtc/certbot.yml
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/.env -O /root/asterisk16webrtc/.env
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/db/asteriskcdr.sql -O /root/asterisk16webrtc/db/asteriskcdr.sql
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/db/asteriskdb.sql -O /root/asterisk16webrtc/db/asteriskdb.sql
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/db/docker-entrypoint.sh -O /root/asterisk16webrtc/db/docker-entrypoint.sh
wget https://raw.githubusercontent.com/lordbasex/docker/master/docker-asterisk16webrtc/createextension -O /root/asterisk16webrtc/createextension
touch /root/asterisk16webrtc/fop2.cfg
touch /root/asterisk16webrtc/buttons_custom_webrtc.cfg
chmod 777 /root/asterisk16webrtc/db/docker-entrypoint.sh /root/asterisk16webrtc/createextension
cd /root/asterisk16webrtc
```

### Docker Creación certificado SSL Let's Encrypt
NOTA: Modifique el archivo **.env** antes de hacer **docker-compose -f certbot.yml up**

```
docker-compose -f certbot.yml up
docker-compose -f certbot.yml down
```

### Docker run
```
cd /root/asterisk16webrtc
docker-compose up -d
```

### Firewall
```bash
ufw  --force enable
ufw default deny incoming
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 4445/tcp
ufw allow 8089/tcp
ufw status
```

### Crear manual de extensión

**pjsip_template_aor.conf**

```bash
vim /root/asterisk16webrtc/user-data/etc/asterisk/pjsip_template_aor.conf
[2324](template-aor)
````
**pjsip_template_auth.conf**

```bash
vim /root/asterisk16webrtc/user-data/etc/asterisk/pjsip_template_auth.conf 
[2324-auth](template-auth)
username=2324
password=mi_clave
```

**pjsip_template_endpoint.conf**

```bash
vim /root/asterisk16webrtc/user-data/etc/asterisk/pjsip_template_endpoint.conf
[2324](template-endpoint)
aors=2324
auth=2324-auth
callerid=2324 <2324>
```

```bash
cd /root/asterisk16webrtc/
docker-compose exec voip asterisk -rx "core reload"
```

### Creación automática de extensión (scripting)

```bash
cd /root/asterisk16webrtc/
./createextension
```
