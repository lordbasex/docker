# Portainer

```
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -e TZ='America/Argentina/Buenos_Aires' -v /var/run/docker.sock:/var/run/docker.sock -v /srv/dev-disk-by-id-ata-ST2000LM005_HN-M201AAD_H1853H462A3PMS-part1/DOCKERCONF/portainer:/data portainer/portainer-ce
```
