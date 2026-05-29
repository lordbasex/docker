# Docker Remote Desktop

Accedé a distintos servicios de escritorio remoto directamente desde tu navegador.

Este contenedor está basado en **Docker Baseimage Selkies** e incluye un entorno gráfico ligero accesible vía web.

## Aplicaciones incluidas

El contenedor viene con las siguientes herramientas preinstaladas:

### Remmina

Protocolos soportados:

* RDP
* SSH
* SPICE
* VNC
* X2GO
* HTTP/HTTPS

### NoMachine

Protocolos soportados:

* NX

### Parsec

Cliente de acceso remoto de alto rendimiento.

### RustDesk

Solución de escritorio remoto open source.

---

## Consideraciones de seguridad

⚠️ **No expongas este contenedor directamente a Internet** salvo que sepas exactamente lo que estás haciendo.

Se recomienda publicar el servicio únicamente:

* Dentro de una red privada.
* Detrás de un Reverse Proxy con autenticación.
* A través de una VPN.

Si deseas utilizar RustDesk Web Viewer sin abrir puertos adicionales, puedes habilitar:

```bash
AUTOSTART_RUSTDESK=true
```

---

# Acceso a la aplicación

Una vez iniciado el contenedor podrás acceder desde:

```text
http://IP_DEL_SERVIDOR:3000
```

Usuario:

```text
tu_usuario
```

Contraseña:

```text
tu_password
```

---

# Despliegue con Docker Compose

Crear un archivo llamado `docker-compose.yml`:

```yaml
services:
  docker-remote-desktop:
    image: ghcr.io/lanjelin/docker-remote-desktop:latest
    container_name: docker-remote-desktop

    environment:
      PUID: 1000
      PGID: 1000
      CUSTOM_USER: tu_usuario
      PASSWORD: tu_password
      TZ: America/Argentina/Buenos_Aires
      AUTOSTART_RUSTDESK: "false"

    ports:
      - "3000:3001"

    volumes:
      - ./config:/config

    restart: unless-stopped
```

Crear el directorio de configuración:

```bash
mkdir -p config
```

Iniciar el servicio:

```bash
docker compose up -d
```

Ver logs:

```bash
docker compose logs -f
```

Detener el servicio:

```bash
docker compose down
```

---

# Despliegue con Docker CLI

```bash
docker run -d \
  --name=docker-remote-desktop \
  -e PUID=1000 \
  -e PGID=1000 \
  -e CUSTOM_USER=tu_usuario \
  -e PASSWORD=tu_password \
  -e TZ=America/Argentina/Buenos_Aires \
  -e AUTOSTART_RUSTDESK=false \
  -p 3000:3001 \
  -v $(pwd)/config:/config \
  --restart unless-stopped \
  ghcr.io/lanjelin/docker-remote-desktop:latest
```

Ver logs:

```bash
docker logs -f docker-remote-desktop
```

Detener el contenedor:

```bash
docker stop docker-remote-desktop
```

Eliminar el contenedor:

```bash
docker rm -f docker-remote-desktop
```

---

# Variables de entorno utilizadas

| Variable           | Valor                          |
| ------------------ | ------------------------------ |
| PUID               | 1000                           |
| PGID               | 1000                           |
| CUSTOM_USER        | tu_usuario                     |
| PASSWORD           | tu_password                    |
| TZ                 | America/Argentina/Buenos_Aires |
| AUTOSTART_RUSTDESK | false                          |

---

# Persistencia de datos

La configuración se almacena en:

```text
./config
```

Este directorio se monta dentro del contenedor como:

```text
/config
```

Por lo tanto, las configuraciones y preferencias permanecerán disponibles incluso si el contenedor es recreado o actualizado.
