# Mikrotik RouterOS in Docker

Lord BaseX (c) 2014-2022
 Federico Pereira <fpereira@cnsoluciones.com>

This docker image is made for laboratory use and testing only. We are not responsible if you use it for commercial purposes or if you use it in production.


### Use image from docker hub

```bash
docker pull cnsoluciones/mikrotik
```


### Use in docker-compose.yml

Example is [here](docker-compose.yml).

```yml
version: "3"

services:
    routeros:
        container_name: "mkt"
        image: cnsoluciones/mikrotik:6.49.7
        privileged: true
        ports:
            - "8291:8291"
            - "8729:8729"
            - "8728:8728"
            - "2222:22"
        cap_add:
            - NET_ADMIN
        devices:
            - /dev/net/tun
```
