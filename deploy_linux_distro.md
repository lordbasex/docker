# Deploy GNU/Linux distro Debian,Ubuntu,CentOS

# Install
```bash
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
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
