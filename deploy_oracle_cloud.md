# Deploy Oracle Cloud - Install Docker - Oracle Linux 9


## Install
```
sudo su
dnf -y update
dnf -y install git wget mc screen
```

## Docker
```
dnf remove -y podman buildah  
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce 
```

## Install Repo

* Custom Docker
```
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<ENDLINE
{
  "bip": "172.17.0.1/24"
}
ENDLINE

systemctl enable docker.service
systemctl start docker.service
systemctl status docker.service
```

* Docker Compose
```bash
dnf install -y docker-compose-plugin
```

* Install Firewall
```
dnf -y install firewalld
systemctl start firewalld
systemctl enable firewalld
systemctl status firewalld
```

* Rules Firewall
```
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-all
```
