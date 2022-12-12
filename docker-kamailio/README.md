# Docker Kamailio 5.6.2

Lord BaseX (c) 2014-2022
 Federico Pereira <fpereira@cnsoluciones.com>


### Instalación Paquetes para Debian 11

Nos conectamos al servidor utilizando algún cliente SSH e instalamos los siguientes paquetes.

Lista de paquetes a instalar:

* vim
* curl
* screen
* sngrep
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
apt -y install vim curl screen mc git unzip net-tools links2 sudo nmap make mycli ufw sngrep
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
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
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

## Clone Repository 
```
cd /root
git clone https://github.com/lordbasex/docker.git
mv /root/docker/docker-kamailio /root
rm -fr /root/docker
```


## Docker run

```
cd /root/docker-kamailio
docker-compose up -d
```

## Firewall
```bash
ufw  --force enable
ufw default deny incoming
ufw allow ssh
ufw allow 5060/udp
ufw allow 5060/tcp
ufw allow 10000:20000/udp
ufw status
```

## Build images - OPTIONAL

### KAMAILIO 
```
cd /root/docker-kamailio/kamailio/
make
```

### RTPPROXY
```
cd /root/docker-kamailio/rtpproxy/
make
```

## KAMAILIO 

### KAMCTL ADD USER
```bash
docker-compose exec kamailio kamctl add 100 PASS100LAkc44lcalks244
docker-compose exec kamailio kamctl add 101 PASS101OKAkcklas33dS22
```

### KAMCTL UL SHOW
```
docker-compose exec kamailio kamctl ul show
```


