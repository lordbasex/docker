# docker-whisper

### Step 0

```
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
/etc/init.d/ssh restart
apt update
apt -y upgrade
apt install -y vim screen mc curl
lspci |grep -E "VGA|3D"
wget https://us.download.nvidia.com/XFree86/Linux-x86_64/525.78.01/NVIDIA-Linux-x86_64-525.78.01.run
chmod +x NVIDIA-Linux-*.run
apt autoremove $(dpkg -l nvidia-driver* |grep ii |awk '{print $2}')
apt install linux-headers-$(uname -r) gcc make acpid dkms libglvnd-core-dev libglvnd0 libglvnd-dev dracut
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
sed -i 's#^\(GRUB_CMDLINE_LINUX_DEFAULT="quiet\)"$#\1 rd.driver.blacklist=nouveau"#' <<<'GRUB_CMDLINE_LINUX_DEFAULT="quiet"' /etc/default/grub
update-grub2
mv /boot/initrd.img-$(uname -r) /boot/initrd.img-$(uname -r)-nouveau
dracut -q /boot/initrd.img-$(uname -r) $(uname -r)
systemctl set-default multi-user.target
reboot
```


```
./NVIDIA-Linux-x86_64-525.78.01.run

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

apt-get update
apt-get -y install -y nvidia-docker2
systemctl restart docker
```

### Step 1

```
git clone https://github.com/lordbasex/docker.git
cd docker/docker-whisper
```

### Step 2
```
 docker-compose up -d
```

### Step 3
```
docker-compose exec whisper bash
```

### Step 4
```
./test.py demo0.wav
```

### Step 5
```
cat demo0.wav_transcription.json | jq
```

### tools
```
nvidia-smi -l 2 
time  whisper demo0.wav --model medium --language es --device cuda:0
time  whisper demo1.wav --model medium --language es --device cuda:1
```
