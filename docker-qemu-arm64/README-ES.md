# QEMU ARM64 Docker Container

[![Docker Pulls](https://img.shields.io/docker/pulls/cnsoluciones/docker-qemu-arm64.svg)](https://hub.docker.com/r/cnsoluciones/docker-qemu-arm64/)
[![Docker Stars](https://img.shields.io/docker/stars/cnsoluciones/docker-qemu-arm64.svg)](https://hub.docker.com/r/cnsoluciones/docker-qemu-arm64/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Este proyecto es un fork modificado de [qemus/qemu-docker](https://github.com/qemus/qemu-docker) con las siguientes modificaciones:

## Modificaciones 🔄

- Soporte específico para arquitectura ARM64
- Configuración extendida de formatos de disco (VMDK, VDI, VPC, VHDX)
- Variables de entorno adicionales para control fino del disco
- Optimizaciones para rendimiento en ARM64
- Maintainer: Federico Pereira <fpereira@cnsoluciones.com>

## Características Adicionales ✨

- Soporte para múltiples formatos de disco:
  - QCOW2 (por defecto)
  - VMDK (VMware)
  - VDI (VirtualBox)
  - VPC/VHDX (Hyper-V)
  - RAW
- Control granular de la configuración del disco:
  - Asignación dinámica/estática
  - Caché y modos de I/O
  - Soporte TRIM/Discard
  - Múltiples tipos de controladores

---

# QEMU Docker Container

Docker container para ejecutar máquinas virtuales usando QEMU.

## Variables de Entorno Completas 🔧

### Configuración Básica
| Variable | Valor por Defecto | Descripción | Archivo |
|----------|------------------|-------------|----------|
| `BOOT` | - | URL o ruta de la imagen de arranque | `install.sh` |
| `CPU_CORES` | "1" | Número de cores | `proc.sh` |
| `RAM_SIZE` | "1G" | Cantidad de RAM | `proc.sh` |
| `ARGUMENTS` | - | Argumentos adicionales para QEMU | `config.sh` |

### Configuración de Disco Principal
| Variable | Valor por Defecto | Descripción | Archivo |
|----------|------------------|-------------|----------|
| `DISK_NAME` | "data" | Nombre base para los archivos de disco | `disk.sh` |
| `DISK_SIZE` | "16G" | Tamaño máximo del disco | `disk.sh` |
| `DISK_FORMAT` | "qcow2" | Formato del disco | `install.sh` |
| `DISK_TYPE` | "scsi" | Tipo de controlador | `disk.sh` |
| `DISK_ALLOC` | "off" | Modo de asignación | `disk.sh` |
| `DISK_IO` | "native" | Modo de I/O | `disk.sh` |
| `DISK_CACHE` | "none" | Modo de caché | `disk.sh` |
| `DISK_DISCARD` | "unmap" | Soporte TRIM | `disk.sh` |
| `DISK_FLAGS` | "" | Opciones adicionales para qcow2 | `disk.sh` |

### Discos Adicionales
| Variable | Valor por Defecto | Descripción | Archivo |
|----------|------------------|-------------|----------|
| `DISK2_SIZE` | - | Tamaño del segundo disco | `disk.sh` |
| `DISK3_SIZE` | - | Tamaño del tercer disco | `disk.sh` |
| `DISK4_SIZE` | - | Tamaño del cuarto disco | `disk.sh` |

### Dispositivos de Bloque
| Variable | Valor por Defecto | Descripción | Archivo |
|----------|------------------|-------------|----------|
| `DEVICE` | - | Dispositivo de bloque principal | `disk.sh` |
| `DEVICE2` | - | Segundo dispositivo | `disk.sh` |
| `DEVICE3` | - | Tercer dispositivo | `disk.sh` |
| `DEVICE4` | - | Cuarto dispositivo | `disk.sh` |

### Red y Display
| Variable | Valor por Defecto | Descripción | Archivo |
|----------|------------------|-------------|----------|
| `NET_DEVICE` | - | Dispositivo de red | `network.sh` |
| `NET_DRIVER` | - | Driver de red | `network.sh` |
| `NET_MODEL` | - | Modelo de tarjeta de red | `network.sh` |
| `DHCP` | "N" | Habilitar servidor DHCP | `network.sh` |
| `MEDIA_TYPE` | - | Tipo de medio para CD/DVD | `disk.sh` |
| `BOOT_MODE` | - | Modo de arranque (legacy, uefi) | `boot.sh` |

### CPU y Rendimiento
| Variable | Valor por Defecto | Descripción | Archivo |
|----------|------------------|-------------|----------|
| `CPU_PIN` | - | Pinear CPU a cores específicos | `proc.sh` |

## Uso 🐳

Via Docker Compose:

```yaml
#version: '3' #deprecated versiones nuevas de docker compose

services:
  qemu:
    container_name: qemu
    image: cnsoluciones/docker-qemu-arm64:1.0.0
    privileged: true
    environment:
      # Variables de arranque
      BOOT: "https://deb.debian.org/debian/dists/bookworm/main/installer-arm64/current/images/netboot/mini.iso"
      
      # Configuración básica
      CPU_CORES: "2"            # Número de cores
      RAM_SIZE: "4G"            # Cantidad de RAM
      
      # Configuración de disco principal
      DISK_NAME: "disk"         # Nombre base para los archivos de disco
      DISK_SIZE: "50G"          # Tamaño máximo del disco
      DISK_FORMAT: "qcow2"      # Formato: raw, qcow2, vmdk, vdi, vpc, vhdx
      DISK_TYPE: "scsi"         # Tipo: ide, sata, nvme, usb, scsi, blk, auto
      DISK_ALLOC: "off"         # Asignación: off = dinámico, on = pre-asignado
      #DISK_IO: "native"         # Modo I/O: native, threads, io_uring
      #DISK_CACHE: "none"        # Cache: none, writeback (mejor rendimiento)
      #DISK_DISCARD: "unmap"     # TRIM/Discard: unmap, ignore
      #DISK_FLAGS: ""            # Opciones adicionales para qcow2
      
      # CPU (opcional)
      #CPU_PIN: ""              # Opcional: Pinear CPU a cores específicos (ej: "0,1,2")
      
      # Discos adicionales (opcional)
      #DISK2_SIZE: ""           # Tamaño del segundo disco (si se necesita)
      #DISK3_SIZE: ""           # Tamaño del tercer disco
      #DISK4_SIZE: ""           # Tamaño del cuarto disco
      
      # Dispositivos de bloque (opcional)
      #DEVICE: ""               # Dispositivo de bloque principal (ej: /dev/sda)
      #DEVICE2: ""              # Segundo dispositivo
      #DEVICE3: ""              # Tercer dispositivo
      #DEVICE4: ""              # Cuarto dispositivo
      
      # Configuración de red (opcional)
      #NET_DEVICE: ""           # Dispositivo de red a usar
      #NET_DRIVER: ""           # Driver de red
      #NET_MODEL: ""            # Modelo de tarjeta de red
      
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

Via Docker CLI:

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

## Licencia 📄

Este proyecto es un fork modificado de [qemus/qemu-docker](https://github.com/qemus/qemu-docker) y está publicado bajo la [Licencia MIT](LICENSE). Consulta el archivo LICENSE para más detalles. 