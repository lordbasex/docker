# QEMU Docker Container

This Docker container provides a QEMU implementation with support for multiple architectures (AMD64 and ARM64).

## Modifications

### 2024-03-XX: Multi-Architecture Support
- ✨ **New Feature**: Dual support for AMD64 and ARM64 through `ARCH` variable
- 🔄 Main changes:
  - New architecture selection system via environment variable
  - Support for `qemu-system-x86_64` (AMD64) and `qemu-system-aarch64` (ARM64)
  - Architecture validation to prevent incorrect configurations
- 🛠️ Usage:
  - AMD64: `ARCH=amd64` (default value)
  - ARM64: `ARCH=arm64`

[![Docker Pulls](https://img.shields.io/docker/pulls/cnsoluciones/docker-qemu.svg)](https://hub.docker.com/r/cnsoluciones/docker-qemu/)
[![Docker Stars](https://img.shields.io/docker/stars/cnsoluciones/docker-qemu.svg)](https://hub.docker.com/r/cnsoluciones/docker-qemu/)
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

## Features

- Support for AMD64 and ARM64 architectures
- VNC web interface for remote access
- Flexible configuration through environment variables
- Based on Debian Bookworm

## Environment Variables

### Main Variables

| Variable | Description | Allowed Values | Default Value |
|----------|-------------|----------------|---------------|
| ARCH | Emulated system architecture | `amd64`, `arm64` | `amd64` |
| CPU_CORES | Number of CPU cores | Integer | `1` |
| RAM_SIZE | Amount of RAM | Example: "1G", "2G" | `1G` |
| DISK_SIZE | Virtual disk size | Example: "16G", "32G" | `16G` |
| DISK_FORMAT | Virtual disk format | `qcow2`, `raw`, etc. | `qcow2` |
| BOOT | Boot image URL | Valid URL | Debian mini.iso URL |

### Additional Variables

| Variable | Description | Default Value |
|----------|-------------|---------------|
| CPU_PIN | Specific CPU pin | Not set |
| ... | ... | ... |

## Uso

### Ejecutar con AMD64 (por defecto)

Via Docker Compose:

```yaml
#version: '3' #deprecated in newer docker compose versions

services:
  qemu:
    container_name: qemu
    image: cnsoluciones/docker-qemu-arm64:1.0.0
    privileged: true
    environment:
      # Architecture selection
      - ARCH: "amd64"          # Architecture: amd64 or arm64
      
      # Boot variables
      - BOOT: "https://deb.debian.org/debian/dists/bookworm/main/installer-arm64/current/images/netboot/mini.iso"
      
      # Basic configuration
      - CPU_CORES: "2"            # Number of cores
      - RAM_SIZE: "4G"            # Amount of RAM
      
      # Main disk configuration
      - DISK_NAME: "disk"         # Base name for disk files
      - DISK_SIZE: "50G"          # Maximum disk size
      - DISK_FORMAT: "qcow2"      # Format: raw, qcow2, vmdk, vdi, vpc, vhdx
      - DISK_TYPE: "scsi"         # Type: ide, sata, nvme, usb, scsi, blk, auto
      - DISK_ALLOC: "off"         # Allocation: off = dynamic, on = pre-allocated
      #- DISK_IO: "native"         # I/O mode: native, threads, io_uring
      #- DISK_CACHE: "none"        # Cache: none, writeback (better performance)
      #- DISK_DISCARD: "unmap"     # TRIM/Discard: unmap, ignore
      #- DISK_FLAGS: ""            # Additional qcow2 options
      
      # CPU (optional)
      #- CPU_PIN: ""              # Optional: Pin CPU to specific cores (e.g., "0,1,2")
      
      # Additional disks (optional)
      #- DISK2_SIZE: ""           # Second disk size (if needed)
      #- DISK3_SIZE: ""           # Third disk size
      #- DISK4_SIZE: ""           # Fourth disk size
      
      # Block devices (optional)
      #- DEVICE: ""               # Main block device (e.g., /dev/sda)
      #- DEVICE2: ""              # Second device
      #- DEVICE3: ""              # Third device
      #- DEVICE4: ""              # Fourth device
      
      # Network configuration (optional)
      #- NET_DEVICE: ""           # Network device to use
      #- NET_DRIVER: ""           # Network driver
      #- NET_MODEL: ""            # Network card model
      
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

Solución: Make sure to correctly specify the ARCH variable

2. Performance issues:
- For AMD64: Verify host virtualization
- For ARM64: Expect slower emulation times on x86 hosts

## Support

For support and bug reports, please open an issue in the repository:
[https://github.com/lordbasex/docker/docker-qemu-arm64](https://github.com/lordbasex/docker/docker-qemu)

## License

[Include license information] 