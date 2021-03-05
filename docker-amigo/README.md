
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
