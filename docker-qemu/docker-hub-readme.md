# QEMU Docker Container
Multi-architecture QEMU implementation (AMD64/ARM64) with VNC web interface.

## Supported tags
- `1.0.0`, `latest`
- `1.0.0-amd64`
- `1.0.0-arm64`

## Quick Start
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
  cnsoluciones/docker-qemu:1.0.0
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
- `USE_UEFI`: Enable/disable UEFI boot (default: `yes`)

## Docker Compose
```yaml
#version: '3.8' #deprecated in newer docker compose versions

services:
  qemu:
    container_name: qemu
    image: cnsoluciones/docker-qemu
    privileged: true
    environment:
      # Architecture selection: 'amd64' (default) or 'arm64'
      - DEBUG=yes
      - ARCH=amd64
      - USE_UEFI=no  # Force non-UEFI mode
      # Boot variables
      - BOOT=https://deb.debian.org/debian/dists/bookworm/main/installer-amd64/current/images/netboot/mini.iso
      
      # Basic configuration
      - CPU_CORES=2            # Number of cores
      - RAM_SIZE=2G            # Amount of RAM
      
      # Main disk configuration
      - DISK_NAME=disk         # Base name for disk files
      - DISK_SIZE=32G          # Maximum disk size
      - DISK_FORMAT=qcow2      # Format: raw, qcow2, vmdk, vdi, vpc, vhdx
      - DISK_TYPE=scsi         # Type: ide, sata, nvme, usb, scsi, blk, auto
      - DISK_ALLOC=off         # Allocation: off = dynamic, on = pre-allocated
      #- DISK_IO=native         # I/O mode: native, threads, io_uring
      #- DISK_CACHE=none        # Cache: none, writeback (better performance)
      #- DISK_DISCARD=unmap     # TRIM/Discard: unmap, ignore
      #- DISK_FLAGS=""          # Additional options for qcow2
      
      # CPU (optional)
      #- CPU_PIN=""            # Optional: Pin CPU to specific cores (e.g., "0,1,2")
      
      # Additional disks (optional)
      #- DISK2_SIZE=""         # Size of second disk (if needed)
      #- DISK3_SIZE=""         # Size of third disk
      #- DISK4_SIZE=""         # Size of fourth disk
      
      # Block devices (optional)
      #- DEVICE=""             # Main block device (e.g., /dev/sda)
      #- DEVICE2=""            # Second device
      #- DEVICE3=""            # Third device
      #- DEVICE4=""            # Fourth device
      
      # Network configuration (optional)
      #- NET_DEVICE=""         # Network device to use
      #- NET_DRIVER=""         # Network driver
      #- NET_MODEL=""          # Network card model
      
    devices:
      - /dev/kvm
      - /dev/net/tun
    cap_add:
      - NET_ADMIN
      - SYS_ADMIN
    security_opt:
      - seccomp=unconfined
    ports:
      - "8006:8006"
      - "5900:5900"
      - "22:22"
    stop_grace_period: 2m
    volumes:
      - ./storage:/storage
    restart: unless-stopped

```

## Requirements
- Docker 20.10+
- KVM support for better performance
- 2GB RAM minimum

## Troubleshooting

If you experience UEFI boot issues:
1. Try setting `USE_UEFI=no` to disable UEFI boot
2. This is especially useful when running ARM64 on AMD64 hosts


## Links
- [GitHub Repository](https://github.com/lordbasex/docker/docker-qemu)
- [Issues](https://github.com/lordbasex/docker/docker-qemu/issues)

## License
MIT License - Based on [qemus/qemu-docker](https://github.com/qemus/qemu-docker)