
# docker run
```
docker run --net=host --name amigo --rm  -it --env AMI_HOST=127.0.0.1 --env AMI_PORT=5038 --env AMI_USERNAME=admin --env AMI_PASSWORD=1234 cnsoluciones/amigo:latest
```

# docker-compose.yml
```
version: '3.0'
services:

  amigo:
    container_name: amigo
    image: cnsoluciones/amigo:latest
    environment:
        - AMI_HOST
        - AMI_PORT
        - AMI_USERNAME
        - AMI_PASSWORD
    restart: always
    network_mode: host
```

# manager.conf
````
[admin]
secret = 1234
deny = 0.0.0.0/0.0.0.0
permit = 127.0.0.1/255.255.255.0
read = all
write = all
writetimeout = 1000
eventfilter=!Event: RTCP*
eventfilter=!Event: VarSet
eventfilter=!Event: Cdr
eventfilter=!Event: DTMF
eventfilter=!Event: AGIExec
eventfilter=!Event: ExtensionStatus
eventfilter=!Event: ChannelUpdate
eventfilter=!Event: ChallengeSent
eventfilter=!Event: SuccessfulAuth
eventfilter=!Event: DeviceStateChange
eventfilter=!Event: RequestBadFormat
eventfilter=!Event: MusicOnHoldStart
eventfilter=!Event: MusicOnHoldStop
eventfilter=!Event: NewAccountCode
eventfilter=!Event: DeviceStateChange
````

