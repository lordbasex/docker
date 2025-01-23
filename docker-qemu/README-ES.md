# Contenedor Docker QEMU

Este contenedor Docker proporciona una implementación de QEMU con soporte para múltiples arquitecturas (AMD64 y ARM64).

## Modificaciones

### 2024-03-XX: Soporte Multi-Arquitectura
- ✨ **Nueva Característica**: Soporte dual para AMD64 y ARM64 a través de la variable `ARCH`
- 🔄 Cambios principales:
  - Nuevo sistema de selección de arquitectura mediante variable de entorno
  - Soporte para `qemu-system-x86_64` (AMD64) y `qemu-system-aarch64` (ARM64)
  - Validación de arquitectura para prevenir configuraciones incorrectas
- 🛠️ Uso:
  - AMD64: `ARCH=amd64` (valor por defecto)
  - ARM64: `ARCH=arm64`

[![Docker Pulls](https://img.shields.io/docker/pulls/cnsoluciones/docker-qemu.svg)](https://hub.docker.com/r/cnsoluciones/docker-qemu/)
[![Docker Stars](https://img.shields.io/docker/stars/cnsoluciones/docker-qemu.svg)](https://hub.docker.com/r/cnsoluciones/docker-qemu/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[🇺🇸 See in English](README.md)

Este proyecto es una bifurcación modificada de [qemus/qemu-docker](https://github.com/qemus/qemu-docker) con las siguientes modificaciones:

## Modificaciones 🔄

- Soporte específico para arquitectura ARM64
- Configuraciones extendidas de formato de disco (VMDK, VDI, VPC, VHDX)
- Variables de entorno adicionales para control preciso del disco
- Optimizaciones de rendimiento para ARM64
- Mantenedor: Federico Pereira <fpereira@cnsoluciones.com>

## Características Adicionales ✨

- Soporte para múltiples formatos de disco:
  - QCOW2 (por defecto)
  - VMDK (VMware)
  - VDI (VirtualBox)
  - VPC/VHDX (Hyper-V)
  - RAW
- Control granular de configuración de disco:
  - Asignación Dinámica/Estática
  - Modos de caché y E/S
  - Soporte TRIM/Discard
  - Múltiples tipos de controladores

## Características

- Soporte para arquitecturas AMD64 y ARM64
- Interfaz web VNC para acceso remoto
- Configuración flexible mediante variables de entorno
- Basado en Debian Bookworm

## Variables de Entorno

### Variables Principales

| Variable | Descripción | Valores Permitidos | Valor por Defecto |
|----------|-------------|-------------------|-------------------|
| ARCH | Arquitectura del sistema emulado | `amd64`, `arm64` | `amd64` |
| CPU_CORES | Número de núcleos de CPU | Entero | `1` |
| RAM_SIZE | Cantidad de RAM | Ejemplo: "1G", "2G" | `1G` |
| DISK_SIZE | Tamaño del disco virtual | Ejemplo: "16G", "32G" | `16G` |
| DISK_FORMAT | Formato del disco virtual | `qcow2`, `raw`, etc. | `qcow2` |
| BOOT | URL de imagen de arranque | URL válida | URL de Debian mini.iso |

### Variables Adicionales

| Variable | Descripción | Valor por Defecto |
|----------|-------------|-------------------|
| CPU_PIN | Pin específico de CPU | No establecido |
| ... | ... | ... |

## Uso

### Ejecutar con AMD64 (por defecto)

Vía Docker Compose:

```yaml
#version: '3' #obsoleto en versiones más nuevas de docker compose

services:
  qemu:
    container_name: qemu
    image: cnsoluciones/docker-qemu-arm64:1.0.0
    privileged: true
    environment:
      # Selección de arquitectura
      - ARCH: "amd64"          # Arquitectura: amd64 o arm64
      
      # Variables de arranque
      - BOOT: "https://deb.debian.org/debian/dists/bookworm/main/installer-arm64/current/images/netboot/mini.iso"
      
      # Configuración básica
      - CPU_CORES: "2"            # Número de núcleos
      - RAM_SIZE: "4G"            # Cantidad de RAM
      
      # Configuración del disco principal
      - DISK_NAME: "disk"         # Nombre base para archivos de disco
      - DISK_SIZE: "50G"          # Tamaño máximo del disco
      - DISK_FORMAT: "qcow2"      # Formato: raw, qcow2, vmdk, vdi, vpc, vhdx
      - DISK_TYPE: "scsi"         # Tipo: ide, sata, nvme, usb, scsi, blk, auto
      - DISK_ALLOC: "off"         # Asignación: off = dinámica, on = pre-asignada
      #- DISK_IO: "native"         # Modo E/S: native, threads, io_uring
      #- DISK_CACHE: "none"        # Caché: none, writeback (mejor rendimiento)
      #- DISK_DISCARD: "unmap"     # TRIM/Discard: unmap, ignore
      #- DISK_FLAGS: ""            # Opciones adicionales qcow2
      
      # CPU (opcional)
      #- CPU_PIN: ""              # Opcional: Fijar CPU a núcleos específicos (ej: "0,1,2")
      
      # Discos adicionales (opcional)
      #- DISK2_SIZE: ""           # Tamaño segundo disco (si es necesario)
      #- DISK3_SIZE: ""           # Tamaño tercer disco
      #- DISK4_SIZE: ""           # Tamaño cuarto disco
      
      # Dispositivos de bloque (opcional)
      #- DEVICE: ""               # Dispositivo de bloque principal (ej: /dev/sda)
      #- DEVICE2: ""              # Segundo dispositivo
      #- DEVICE3: ""              # Tercer dispositivo
      #- DEVICE4: ""              # Cuarto dispositivo
      
      # Configuración de red (opcional)
      #- NET_DEVICE: ""           # Dispositivo de red a usar
      #- NET_DRIVER: ""           # Controlador de red
      #- NET_MODEL: ""            # Modelo de tarjeta de red
      
    devices:
      - /dev/kvm
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
      - SYS_ADMIN
    security_opt:
      - seccomp=unconfined
    ports:
      - 8006:8006
    stop_grace_period: 2m
    volumes:
      - ./storage:/storage
```

Vía Docker CLI:

```bash
docker run -it --rm \
  -e "BOOT=https://deb.debian.org/debian/dists/bookworm/main/installer-arm64/current/images/netboot/mini.iso" \
  -e "DISK_SIZE=50G" \
  -p 8006:8006 \
  --device=/dev/kvm \
  --device=/dev/net/tun \
  --cap-add NET_ADMIN \
  --cap-add SYS_ADMIN \
  --security-opt seccomp=unconfined \
  cnsoluciones/docker-qemu-arm64:1.0.0
```

## Solución de Problemas

Solución: Asegúrese de especificar correctamente la variable ARCH

2. Problemas de rendimiento:
- Para AMD64: Verificar la virtualización del host
- Para ARM64: Esperar tiempos de emulación más lentos en hosts x86

## Soporte

Para soporte y reportes de errores, por favor abra un issue en el repositorio:
[https://github.com/lordbasex/docker/docker-qemu-arm64](https://github.com/lordbasex/docker/docker-qemu)

## Licencia

[Incluir información de licencia] 