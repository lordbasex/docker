# Deploy GNU/Linux distro Raspberry Pi OS

# Active SSH (mount SSD Windows, Linux or MAC)
```
cd /Volumes/boot
touch ssh
```
Safely remove or eject the card from the computer and insert it again in your Raspberry Pi.

Boot up Raspberry Pi.

More info: **https://phoenixnap.com/kb/enable-ssh-raspberry-pi**

# Install

```
sudo su
apt update
apt -y upgrade
apt -y install vim curl screen mc git unzip net-tools links2 sudo nmap make mycli
```

```bash
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
rm -fr get-docker.sh
```

## Custom Docker
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

## Docker Compose
```bash
curl -L "https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-armv7" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
```

