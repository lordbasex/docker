# Docker Asterisk FastAGI for GO


## Asterisk Conf

iax.conf
```
[general]
mailboxdetail=yes
tos=ef
language=en
disallow=all
allow=ulaw
allow=alaw
allow=gsm

[100]
deny=0.0.0.0/0.0.0.0
secret=12345
transfer=yes
host=dynamic
type=friend
port=4569
qualify=yes
dial=IAX2/100
accountcode=
permit=0.0.0.0/0.0.0.0
requirecalltoken=yes
context=from-internal
secret_origional=8a283a10d3f1768e024d06a2c44489b8
callerid=Test <100>
setvar=REALCALLERIDNUM=
```

extension.conf
```
[general]
static=yes
writeprotect=no
autofallthrough=yes
extenpatternmatchnew=true
clearglobalvars=no
priorityjumping=yes
userscontext=default
AL_OPTIONS = trwW

[default]
exten => s,1,Playback(demo-congrats)
exten => h,1,Hangup()

[from-internal]
include => app-echo-test
include => fastagi

exten => 510,1,NoOp(QUEUE 510 ADMIN)
exten => 510,n,Wait(2)
exten => 510,n,Playback(vm-goodbye)
exten => 510,n,Hangup

exten => 520,1,NoOp(QUEUE 520 SALES)
exten => 520,n,Wait(2)
exten => 520,n,Playback(vm-goodbye)
exten => 520,n,Hangup

exten => 540,1,NoOp(QUEUE 540 SUPPORT)
exten => 540,n,Wait(2)
exten => 540,n,Playback(vm-goodbye)
exten => 540,n,Hangup

[app-echo-test]
exten => *43,1,Answer
exten => *43,n,Wait(1)
exten => *43,n,Playback(demo-echotest)
exten => *43,n,Echo()
exten => *43,n,Playback(demo-echodone)
exten => *43,n,Hangup
exten => h,1,Hangup

[hints]
exten = 100,hint,IAX/100

[fastagi]
exten => 12345,1,NoOp(DOCKER ASTERISK FASTAGI GO)
exten => 12345,n,AGI(agi://fastagi:8000, ivrdemo1,es)
exten => 12345,n,Hangup()
```

## Docker-compose

### RUN
```
docker-compose up -d
```

### PS
```
docker-compose ps
```

### DOWN
```
docker-compose down
```

### CLI ASTERISK
```
docker-compose exec voip asterisk -rvvvvvvvvvv
agi set debug on
```

## Asterisk IAX2 (Use Zoiper client) 

Download: **https://www.zoiper.com/en/voip-softphone/download/current**

user: 100

pass: 12345

port: 4569


## Audios

```
audio1: Demo de IVR
audio2: Por favor, ingrese un número entre el 1 y el 111
audio3: El numero que usted a ingresado es
aduio4: Muchas gracias por hacer esta demo. Hasta la próxima.
not_dtmf: No hemos registrado su ingreso.

audio1: IVR demo
audio2: Please enter a number between 1 and 111
audio3: The number you entered is
aduio4: Thank you very much for making this demo. Until next time.
not_dtmf: We have not registered your entry.
```

## Build Multi Architecture
```
docker run --privileged --rm tonistiigi/binfmt --install arm64,riscv64,arm
docker buildx create --name multiarchitecture
docker buildx use multiarchitecture 


#asterisk-iax2
cd asterisk-iax2
docker buildx build --platform linux/amd64,linux/arm64 -t cnsoluciones/asterisk-iax2:latest --push .
cd ..
    
#fastagi
cd fastagi
docker buildx build --platform linux/amd64,linux/arm64 -t cnsoluciones/fastagi:latest --push .
cd ..
```
