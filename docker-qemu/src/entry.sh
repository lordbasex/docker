#!/usr/bin/env bash
set -Eeuo pipefail

APP="QEMU"
SUPPORT="https://github.com/lordbasex/docker/docker-qemu-arm64"

# Validación de la arquitectura
ARCH=${ARCH:-"amd64"}  # Si no se define ARCH, usar amd64 por defecto

# Validar que ARCH solo pueda ser amd64 o arm64
if [[ "$ARCH" != "amd64" && "$ARCH" != "arm64" ]]; then
    echo "Error: ARCH solo puede ser 'amd64' o 'arm64'"
    echo "Uso: ARCH=[amd64|arm64] $0"
    exit 1
fi

# Seleccionar el binario correcto según la arquitectura
QEMU_BIN="qemu-system-x86_64"
if [ "$ARCH" = "arm64" ]; then
    QEMU_BIN="qemu-system-aarch64"
fi

cd /run

. reset.sh      # Initialize system
. install.sh    # Get bootdisk
. disk.sh       # Initialize disks
. display.sh    # Initialize graphics
. network.sh    # Initialize network
. boot.sh       # Configure boot
. proc.sh       # Initialize processor
. config.sh     # Configure arguments

trap - ERR

version=$($QEMU_BIN --version | head -n 1 | cut -d '(' -f 1 | awk '{ print $NF }')
info "Booting image${BOOT_DESC} using QEMU v$version (Architecture: $ARCH)..."

if [ -z "$CPU_PIN" ]; then
  exec $QEMU_BIN ${ARGS:+ $ARGS}
else
  exec taskset -c "$CPU_PIN" $QEMU_BIN ${ARGS:+ $ARGS}
fi
