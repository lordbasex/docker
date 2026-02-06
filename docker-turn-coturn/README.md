# TURN Server (coturn) en AWS con Docker Compose (Network Host) + TLS + NAT

Este documento describe el deploy de **coturn** en una instancia EC2 (Amazon Linux) usando **Docker Compose** con `network_mode: host`, detrás de **NAT de AWS** (IP privada + Elastic IP), habilitando **STUN/TURN** y **TURN-TLS/DTLS** con certificado válido (`*.example.com`).

---

## 1) Requisitos / Supuestos

- EC2 con **Elastic IP** asociada (IP pública fija).
- La instancia tiene **IP privada** dentro de la VPC/subnet.
- Se usa un FQDN: `turn.example.com` apuntando a la Elastic IP.
- Se usará `coturn/coturn` y `network_mode: host` (no hay mapeo de puertos).
- Certificado y clave privada disponibles para el wildcard.

---

## 2) Variables a reemplazar (Plantilla)

Reemplazá estos valores por los reales:

| Variable | Ejemplo | Descripción |
|---|---|---|
| `TURN_DOMAIN` | `turn.example.com` | Subdominio TURN (A record a la Elastic IP) |
| `TURN_REALM` | `example.com` | Realm para credenciales (normalmente el dominio) |
| `PRIVATE_IP` | `172.xxx.xxx.xxx` | IP privada de la EC2 (VPC) |
| `PUBLIC_IP` | `xxx.xxx.xxx.xxx` | Elastic IP pública |
| `TURN_USER` | `my_user` | Usuario TURN (Long-Term) |
| `TURN_PASS` | `CAMBIAR_ESTA_PASSWORD` | Password TURN (Long-Term) |
| `CLI_PASS` | `CAMBIAR_ESTA_CLI_PASSWORD` | Password del CLI telnet (solo localhost) |

---

## 3) Estructura de carpetas

```bash
/opt/turn
├─ docker-compose.yml
├─ turnserver.conf
└─ certs/
   ├─ turn.crt
   └─ turn.key
```

Crear:
```bash
sudo mkdir -p /opt/turn/certs
cd /opt/turn
```

---

## 4) Certificados TLS (archivos en `certs/`)

Colocá:

- `certs/turn.crt`  → **Certificado público** del wildcard (idealmente incluyendo *chain* si tu proveedor lo entrega así).
- `certs/turn.key`  → **Clave privada** correspondiente.

Permisos recomendados:
```bash
sudo chown -R root:root /opt/turn/certs
sudo chmod 644 /opt/turn/certs/turn.key
sudo chmod 644 /opt/turn/certs/turn.crt
```

Validación rápida (opcional):
```bash
openssl x509 -in /opt/turn/certs/turn.crt -noout -subject -issuer -dates
openssl pkey -in /opt/turn/certs/turn.key -noout
```

---

## 5) docker-compose.yml (plantilla)

📌 Guardar como: `/opt/turn/docker-compose.yml`

```yaml
services:
  coturn:
    image: coturn/coturn
    container_name: coturn
    restart: unless-stopped
    network_mode: host
    volumes:
      - ./turnserver.conf:/etc/coturn/turnserver.conf:ro,Z
      - ./certs:/etc/coturn/certs:ro,Z
    command: >
      turnserver
      -c /etc/coturn/turnserver.conf
      --log-file=stdout
```

> Nota: `network_mode: host` hace que coturn escuche directo en la red del host, sin `ports:`.

---

## 6) turnserver.conf (plantilla con separadores)

📌 Guardar como: `/opt/turn/turnserver.conf`

> Reemplazá `TURN_REALM`, `TURN_DOMAIN`, `PRIVATE_IP`, `PUBLIC_IP`, `TURN_USER`, `TURN_PASS`, `CLI_PASS`.

```ini
# =========================
# Identidad / Realm
# =========================
realm=TURN_REALM
server-name=TURN_DOMAIN
fingerprint

# =========================
# Autenticación (Long-Term Credentials)
# =========================
lt-cred-mech
user=TURN_USER:TURN_PASS

# =========================
# Puertos de escucha (STUN/TURN + TLS/DTLS)
# =========================
listening-port=3478
tls-listening-port=5349

# =========================
# Interfaces / NAT (AWS)
# =========================
listening-ip=0.0.0.0
relay-ip=PRIVATE_IP
external-ip=PUBLIC_IP/PRIVATE_IP

# =========================
# TLS (Certificado + Private Key)
# =========================
cert=/etc/coturn/certs/turn.crt
pkey=/etc/coturn/certs/turn.key

# =========================
# Seguridad básica
# =========================
no-multicast-peers
stale-nonce=600

# =========================
# Relay ports (RTP/UDP)
# =========================
min-port=49152
max-port=65535

# =========================
# Admin CLI (telnet) - habilitado SOLO localhost
# =========================
cli-password=CLI_PASS
cli-ip=127.0.0.1

# =========================
# Logs
# =========================
log-file=stdout
simple-log
verbose
```

---

## 7) Iniciar / Parar / Ver logs

Desde `/opt/turn`:

```bash
docker-compose up -d
docker-compose ps
docker-compose logs -f coturn
```

Reiniciar (por cambios en config/certs):
```bash
docker-compose restart coturn
```

Parar:
```bash
docker-compose down
```

---

## 8) Verificación en el host (listeners)

```bash
ss -lntup | egrep ':(3478|5349|5766)\b'
```

Deberías ver:
- `3478/tcp` y `3478/udp` (STUN/TURN)
- `5349/tcp` y `5349/udp` (TLS/DTLS)
- `5766/tcp` SOLO en `127.0.0.1` (CLI)

---

## 9) Security Group (Inbound) recomendado

**Importante:** el TURN necesita que Internet pueda llegar a:
- 3478 TCP/UDP
- 5349 TCP/UDP
- 49152–65535 UDP

Tabla:

| Servicio | Protocolo | Puerto(s) | Source recomendado |
|---|---|---:|---|
| STUN/TURN | UDP | 3478 | 0.0.0.0/0 (o restringir a tus IPs si aplica) |
| TURN TCP (fallback) | TCP | 3478 | 0.0.0.0/0 |
| TURN over TLS | TCP | 5349 | 0.0.0.0/0 |
| TURN over DTLS | UDP | 5349 | 0.0.0.0/0 |
| Relay media (RTP/UDP) | UDP | 49152–65535 | 0.0.0.0/0 |
| SSH | TCP | 22 | Tu IP /32 |
| CLI coturn | TCP | 5766 | **NO ABRIR** (solo localhost) |

> Si tu uso es exclusivamente interno (pocas IPs conocidas), podés **restringir** 3478/5349 a esas IPs, pero **el rango UDP 49152–65535 normalmente debe quedar abierto** para media (si no, vas a tener “conexión” pero sin audio/video).

---

## 10) Debug / Consola

### Logs del servicio
```bash
docker-compose logs -f coturn
```

### Entrar al contenedor
```bash
docker exec -it coturn sh
ls -l /etc/coturn/certs
cat /etc/coturn/turnserver.conf
```

### CLI de coturn (en localhost)
Instalar telnet si hace falta:
```bash
sudo dnf install -y telnet
```

Conectar:
```bash
telnet 127.0.0.1 5766
```

---

## 11) Tips importantes (NAT AWS)

- `external-ip=PUBLIC_IP/PRIVATE_IP` es **clave** en AWS para que el server anuncie la IP pública correcta pero relaye desde la privada.
- `relay-ip=PRIVATE_IP` debe ser la IP privada real de la instancia (interfaz principal).
- Usar `network_mode: host` evita problemas de mapping/conntrack dentro de Docker con rangos grandes de UDP.

---

## 12) Ejemplo de ICE servers (my_user)

En tu app my_user:

- STUN/TURN:
  - `turn:turn.example.com:3478?transport=udp`
  - `turn:turn.example.com:3478?transport=tcp`

- TURN sobre TLS:
  - `turns:turn.example.com:5349?transport=tcp`

Usuario/clave: `TURN_USER` / `TURN_PASS`

---

## 13) Checklist final

- [ ] A record `turn.example.com` apunta a la Elastic IP
- [ ] `turn.crt` + `turn.key` correctos y con permisos OK
- [ ] `turnserver.conf` con `PUBLIC_IP/PRIVATE_IP` correcto
- [ ] SG inbound abierto para 3478/tcp+udp, 5349/tcp+udp, 49152-65535/udp
- [ ] `ss -lntup` muestra listeners en 3478 y 5349
- [ ] Logs no muestran errores de cert/key
