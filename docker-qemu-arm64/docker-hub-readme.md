# QEMU ARM64 Docker Container

[![Docker Pulls](https://img.shields.io/docker/pulls/cnsoluciones/docker-qemu-arm64.svg)](https://hub.docker.com/r/cnsoluciones/docker-qemu-arm64/)
[![Docker Stars](https://img.shields.io/docker/stars/cnsoluciones/docker-qemu-arm64.svg)](https://hub.docker.com/r/cnsoluciones/docker-qemu-arm64/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/lordbasex/docker/blob/master/docker-qemu-arm64/LICENSE)

This project is a modified fork of [qemus/qemu-docker](https://github.com/qemus/qemu-docker) with specific support for ARM64 architecture.

🔗 **Repository**: [github.com/lordbasex/docker](https://github.com/lordbasex/docker)  
📦 **Project**: [docker/docker-qemu-arm64](https://github.com/lordbasex/docker/tree/master/docker-qemu-arm64)

## Features 🔄

- Specific support for ARM64 architecture
- Extended disk format configurations (VMDK, VDI, VPC, VHDX)
- Additional environment variables for fine disk control
- Performance optimizations for ARM64
- Multiple disk formats support (QCOW2, VMDK, VDI, VPC/VHDX, RAW)
- Granular disk configuration control
- Dynamic/Static allocation
- Advanced cache and I/O modes
- TRIM/Discard support
- Multiple controller types

## Quick Start 🚀

```yaml
services:
  qemu:
    container_name: qemu
    image: cnsoluciones/docker-qemu-arm64:1.0.0
    privileged: true
    environment:
      BOOT: "https://deb.debian.org/debian/dists/bookworm/main/installer-arm64/current/images/netboot/mini.iso"
      CPU_CORES: "2"
      RAM_SIZE: "4G"
      DISK_SIZE: "50G"
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
    volumes:
      - ./storage:/storage
```

Or via CLI:

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

## Environment Variables 🔧

### Basic Configuration
| Variable | Default | Description |
|----------|---------|-------------|
| `BOOT` | - | Boot image URL or path |
| `CPU_CORES` | "1" | Number of cores |
| `RAM_SIZE` | "1G" | Amount of RAM |

### Disk Configuration
| Variable | Default | Description |
|----------|---------|-------------|
| `DISK_SIZE` | "16G" | Maximum disk size |
| `DISK_FORMAT` | "qcow2" | Format: raw, qcow2, vmdk, vdi, vpc, vhdx |
| `DISK_TYPE` | "scsi" | Type: ide, sata, nvme, usb, scsi, blk, auto |
| `DISK_ALLOC` | "off" | Allocation: off = dynamic, on = pre-allocated |

For more detailed documentation and advanced configuration options, visit our [GitHub Repository](https://github.com/lordbasex/docker/tree/master/docker-qemu-arm64).

## Support & Issues 💡

For support, feature requests, or bug reports:
- GitHub Repository: [lordbasex/docker](https://github.com/lordbasex/docker)
- Issues: [docker-qemu-arm64/issues](https://github.com/lordbasex/docker/issues)
- Docker Hub: [cnsoluciones/docker-qemu-arm64](https://hub.docker.com/r/cnsoluciones/docker-qemu-arm64)

## Maintainer 👤

Federico Pereira <fpereira@cnsoluciones.com>
- GitHub: [@lordbasex](https://github.com/lordbasex)
- Website: [CNSoluciones](https://www.cnsoluciones.com)

## License 📄

This project is released under the [MIT License](https://github.com/lordbasex/docker/blob/master/docker-qemu-arm64/LICENSE). 