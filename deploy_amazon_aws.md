# Deploy Amazon AWS - EC2 - Install Docker - Amazon Linux 2 AMI
```   ,     #_
   ~\_  ####_        Amazon Linux 2023
  ~~  \_#####\
  ~~     \###|
  ~~       \#/ ___   https://aws.amazon.com/linux/amazon-linux-2023
   ~~       V~' '->
    ~~~         /
      ~~._.   _/
         _/ _/
       _/m/'
```
## Install
```
sudo su
dnf -y update
dnf -y install docker
dnf -y install git wget mc screen htop
```

## Install Repo
```
amazon-linux-extras install epel
dnf -y install p7zip
```

* Custom Docker
```
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<ENDLINE
{
  "bip": "172.17.0.1/24",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "50m",
    "max-file": "3"
  }
}
ENDLINE

systemctl enable docker
systemctl start docker
```

* Docker Compose
```bash
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m) -o /usr/bin/docker-compose && sudo chmod 755 /usr/bin/docker-compose && docker-compose --version
```

* Install Firewall
```
dnf -y install firewalld
systemctl start firewalld
systemctl enable firewalld
systemctl status firewalld
```
