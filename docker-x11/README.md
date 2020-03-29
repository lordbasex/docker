# X11Docker - Run GUI applications and desktops in Docker.

Lord BaseX (c) 2019
 Federico Pereira <fpereira@cnsoluciones.com>


### MacOS
```bash
brew install socat
brew cask install xquartz
```

### RUN X11

Start XQuartz from command line using open -a XQuartz. In the XQuartz preferences, go to the “Security” tab and make sure you’ve got “Allow connections from network clients” ticked:

```bash
open -a Xquartz
IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
xhost + $IP
```

![ScreenShot](https://raw.githubusercontent.com/lordbasex/docker/master/docker-x11/xquartz_preferences.png)


## CONTAINER

### Winbox
```bash
curl -fsSL https://raw.githubusercontent.com/lordbasex/docker/master/docker-x11/winbox/winbox.sh | bash
```
