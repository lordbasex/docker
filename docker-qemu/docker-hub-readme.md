# QEMU Docker Container
Multi-architecture QEMU implementation (AMD64/ARM64) with VNC web interface.

## Supported tags
- `1.0.0`, `latest`
- `1.0.0-amd64`
- `1.0.0-arm64`

## Quick Start
```bash
docker run -it --rm \
  -e "DISK_SIZE=50G" \
  -p 8006:8006 \
  --device=/dev/kvm \
  --device=/dev/net/tun \
  --cap-add NET_ADMIN \
  --cap-add SYS_ADMIN \
  --security-opt seccomp=unconfined \
  cnsoluciones/docker-qemu-arm64:1.0.0
```

## Features
- AMD64 and ARM64 support
- VNC web interface (port 8006)
- Multiple disk formats (QCOW2, VMDK, VDI, VPC, VHDX, RAW)
- Debian Bookworm base

## Environment Variables

Essential:
- `ARCH`: System architecture (`amd64`/`arm64`, default: `amd64`)
- `CPU_CORES`: CPU cores (default: `1`)
- `RAM_SIZE`: RAM amount (default: `1G`)
- `DISK_SIZE`: Disk size (default: `16G`)
- `DISK_FORMAT`: Format type (default: `qcow2`)

## Docker Compose
```yaml
services:
  qemu:
    image: cnsoluciones/docker-qemu-arm64:1.0.0
    environment:
      - ARCH: "amd64"
      - CPU_CORES: "2"
      - RAM_SIZE: "4G"
      - DISK_SIZE: "50G"
    devices:
      - /dev/kvm
      - /dev/net/tun
    ports:
      - 8006:8006
    volumes:
      - ./storage:/storage
```

## Requirements
- Docker 20.10+
- KVM support for better performance
- 2GB RAM minimum

## Links
- [GitHub Repository](https://github.com/lordbasex/docker/docker-qemu)
- [Issues](https://github.com/lordbasex/docker/docker-qemu/issues)

## License
MIT License - Based on [qemus/qemu-docker](https://github.com/qemus/qemu-docker)