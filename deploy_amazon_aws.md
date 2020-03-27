# Deploy Amazon AWS - EC2 - Install Docker - Amazon Linux 2 AMI
```

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
```
## Install
```
sudo su
yum -y update
yum -y install docker
yum -y install git wget mc screen htop
```

* Custom Docker
```
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<ENDLINE
{
  "bip": "172.17.0.1/24"
}
ENDLINE

systemctl enable docker
systemctl start docker
```

* Docker Compose
```bash
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o  /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
```

* Install Firewall
```
yum -y install firewalld
systemctl start firewalld
systemctl enable firewalld
systemctl status firewalld
```
