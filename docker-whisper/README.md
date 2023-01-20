# docker-whisper

### Step 0
```
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

apt-get update
apt-get install -y nvidia-docker2
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
