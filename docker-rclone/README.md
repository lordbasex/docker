# rclone-gui
Sample run command:

## docker run
```bash
docker run -d --name=rclone-gui \
-v /home/lordbasex/.config/rclone:/config \
-v `pwd`/media:/media \
-e GROUP_ID=501 -e USER_ID=20 -e TZ=America/Argentina/Buenos_Aires -e RCUSER=admin -e RCPASS=XXXX \
-p 5572:5572 \
lordbasex/rclone-gui
```
## docer-compose

```bash
version: '3.2'

services:

    rclone:
        image: lordbasex/rclone-gui
        container_name: rclone-gui
        restart: always
        volumes:
          - /home/lordbasex/.config/rclone:/config
          - ./user-data:/media
          - /etc/passwd:/etc/passwd:ro
          - /etc/group:/etc/group:ro

        ports:
          - 5572:5572

        environment:
          - ROUP_ID=501
          - USER_ID=20
          - TZ=America/Argentina/Buenos_Aires
          - RCUSER=admin
          - RCPASS=XXXXXXXXX
```


Go to http://your-host-ip:5572 to access the Rclone GUI.

## Environment Variables
To customize some properties of the container, the following environment variables can be passed via the -e parameter (one for each variable). Value of this parameter has the format <VARIABLE_NAME>=<VALUE>.

## Variable	Description	Default
* RCUSER =	Username to be used to authenticate into the web interface.	
* RCPASS =	Password to be used to authenticate into the web interface.	

## Data Volumes
    
The following table describes data volumes used by the container. The mappings are set via the -v parameter. Each mapping is specified with the following format: <HOST_DIR>:<CONTAINER_DIR>[:PERMISSIONS].

## Container path	Permissions	Description
  
/config	rw	This is where the application stores its configuration. Expects rclone.conf to be present.
    
/media	rw	This is where downloaded files are stored, or where you put files in your host for uploading.

## Ports
  
Here is the list of ports used by the container. They can be mapped to the host via the -p parameter (one per port mapping). Each mapping is defined in the following format: <HOST_PORT>:<CONTAINER_PORT>. The port number inside the container cannot be changed, but you are free to use any port on the host side.


