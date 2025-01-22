# QEMU ARM64 Docker Container

[![Docker Pulls](https://img.shields.io/docker/pulls/cnsoluciones/docker-qemu-arm64.svg)](https://hub.docker.com/r/cnsoluciones/docker-qemu-arm64/)
[![Docker Stars](https://img.shields.io/docker/stars/cnsoluciones/docker-qemu-arm64.svg)](https://hub.docker.com/r/cnsoluciones/docker-qemu-arm64/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[🇪🇸 Ver en Español](README-ES.md)

This project is a modified fork of [qemus/qemu-docker](https://github.com/qemus/qemu-docker) with the following modifications:

## Modifications 🔄

- Specific support for ARM64 architecture
- Extended disk format configurations (VMDK, VDI, VPC, VHDX)
- Additional environment variables for fine disk control
- Performance optimizations for ARM64
- Maintainer: Federico Pereira <fpereira@cnsoluciones.com>

## Additional Features ✨

- Support for multiple disk formats:
  - QCOW2 (default)docker-qemu-arm64.svg
  - VMDK (VMware)
  - VDI (VirtualBox)
  - VPC/VHDX (Hyper-V)
  - RAW
- Granular disk configuration control:
  - Dynamic/Static allocation
  - Cache and I/O modes
  - TRIM/Discard support
  - Multiple controller types

---

# QEMU Docker Container

Docker container for running virtual machines using QEMU.

## Complete Environment Variables 🔧

### Basic Configuration
| Variable | Default Value | Description | File |
|----------|--------------|-------------|------|
| `BOOT` | - | Boot image URL or path | `install.sh` |
| `CPU_CORES` | "1" | Number of cores | `proc.sh` |
| `RAM_SIZE` | "1G" | Amount of RAM | `proc.sh` |
| `ARGUMENTS` | - | Additional QEMU arguments | `config.sh` |

### Main Disk Configuration
| Variable | Default Value | Description | File |
|----------|--------------|-------------|------|
| `DISK_NAME` | "data" | Base name for disk files | `disk.sh` |
| `DISK_SIZE` | "16G" | Maximum disk size | `disk.sh` |
| `DISK_FORMAT` | "qcow2" | Disk format | `install.sh` |
| `DISK_TYPE` | "scsi" | Controller type | `disk.sh` |
| `DISK_ALLOC` | "off" | Allocation mode | `disk.sh` |
| `DISK_IO` | "native" | I/O mode | `disk.sh` |
| `DISK_CACHE` | "none" | Cache mode | `disk.sh` |
| `DISK_DISCARD` | "unmap" | TRIM support | `disk.sh` |
| `DISK_FLAGS` | "" | Additional qcow2 options | `disk.sh` |

### Additional Disks
| Variable | Default Value | Description | File |
|----------|--------------|-------------|------|
| `DISK2_SIZE` | - | Second disk size | `disk.sh` |
| `DISK3_SIZE` | - | Third disk size | `disk.sh` |
| `DISK4_SIZE` | - | Fourth disk size | `disk.sh` |

### Block Devices
| Variable | Default Value | Description | File |
|----------|--------------|-------------|------|
| `DEVICE` | - | Main block device | `disk.sh` |
| `DEVICE2` | - | Second device | `disk.sh` |
| `DEVICE3` | - | Third device | `disk.sh` |
| `DEVICE4` | - | Fourth device | `disk.sh` |

### Network and Display
| Variable | Default Value | Description | File |
|----------|--------------|-------------|------|
| `NET_DEVICE` | - | Network device | `network.sh` |
| `NET_DRIVER` | - | Network driver | `network.sh` |
| `NET_MODEL` | - | Network card model | `network.sh` |
| `DHCP` | "N" | Enable DHCP server | `network.sh` |
| `MEDIA_TYPE` | - | Media type for CD/DVD | `disk.sh` |
| `BOOT_MODE` | - | Boot mode (legacy, uefi) | `boot.sh` |

### CPU and Performance
| Variable | Default Value | Description | File |
|----------|--------------|-------------|------|
| `CPU_PIN` | - | Pin CPU to specific cores | `proc.sh` |

## Usage 🐳
docker-qemu-arm64.svg
Via Docker Compose:

```yaml
#version: '3' #deprecated in newer docker compose versions

services:
  qemu:
    container_name: qemu
    image: cnsoluciones/docker-qemu-arm64:1.0.0
    privileged: true
    environment:
      # Boot variables
      BOOT: "https://deb.debian.org/debian/dists/bookworm/main/installer-arm64/current/images/netboot/mini.iso"
      
      # Basic configuration
      CPU_CORES: "2"            # Number of cores
      RAM_SIZE: "4G"            # Amount of RAM
      
      # Main disk configuration
      DISK_NAME: "disk"         # Base name for disk files
      DISK_SIZE: "50G"          # Maximum disk size
      DISK_FORMAT: "qcow2"      # Format: raw, qcow2, vmdk, vdi, vpc, vhdx
      DISK_TYPE: "scsi"         # Type: ide, sata, nvme, usb, scsi, blk, auto
      DISK_ALLOC: "off"         # Allocation: off = dynamic, on = pre-allocated
      #DISK_IO: "native"         # I/O mode: native, threads, io_uring
      #DISK_CACHE: "none"        # Cache: none, writeback (better performance)
      #DISK_DISCARD: "unmap"     # TRIM/Discard: unmap, ignore
      #DISK_FLAGS: ""            # Additional qcow2 options
      
      # CPU (optional)
      #CPU_PIN: ""              # Optional: Pin CPU to specific cores (e.g., "0,1,2")
      
      # Additional disks (optional)
      #DISK2_SIZE: ""           # Second disk size (if needed)
      #DISK3_SIZE: ""           # Third disk size
      #DISK4_SIZE: ""           # Fourth disk size
      
      # Block devices (optional)
      #DEVICE: ""               # Main block device (e.g., /dev/sda)
      #DEVICE2: ""              # Second device
      #DEVICE3: ""              # Third device
      #DEVICE4: ""              # Fourth device
      
      # Network configuration (optional)
      #NET_DEVICE: ""           # Network device to use
      #NET_DRIVER: ""           # Network driver
      #NET_MODEL: ""            # Network card model
      
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

## License 📄

This project is a modified fork of [qemus/qemu-docker](https://github.com/qemus/qemu-docker) and is released under the [MIT License](LICENSE). See the LICENSE file for more details. 