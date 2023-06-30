# Portainer

## First, create the volume that Portainer Server will use to store its database:
```
docker volume create portainer_data
```

## Then, download and install the Portainer Server container:
```
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```
