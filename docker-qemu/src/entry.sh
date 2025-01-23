#!/usr/bin/env bash
set -Eeuo pipefail

# Information function
info() {
    echo -e "\033[0;32m➜\033[0m $1"
}

# Add after existing functions (after line 6)

show_environment() {
    info "=== QEMU Environment Variables ==="
    echo "Architecture Configuration:"
    echo "  ARCH=${ARCH:-'not defined'}"
    echo "  USE_UEFI=${USE_UEFI:-'not defined'}"
    echo "  QEMU_BIN=${QEMU_BIN:-'not defined'}"
    echo "  UEFI_ARGS=${UEFI_ARGS:-'not defined'}"
    
    echo -e "\nBoot Configuration:"
    echo "  BOOT=${BOOT:-'not defined'}"
    echo "  BOOT_MODE=${BOOT_MODE:-'not defined'}"
    
    echo -e "\nBasic Configuration:"
    echo "  CPU_CORES=${CPU_CORES:-'not defined'}"
    echo "  RAM_SIZE=${RAM_SIZE:-'not defined'}"
    echo "  MACHINE=${MACHINE:-'not defined'}"
    
    echo -e "\nMain Disk Configuration:"
    echo "  DISK_NAME=${DISK_NAME:-'not defined'}"
    echo "  DISK_SIZE=${DISK_SIZE:-'not defined'}"
    echo "  DISK_FORMAT=${DISK_FORMAT:-'not defined'}"
    echo "  DISK_TYPE=${DISK_TYPE:-'not defined'}"
}


APP="QEMU"
SUPPORT="https://github.com/lordbasex/docker/docker-qemu"

# Architecture validation and configuration
ARCH=${ARCH:-"amd64"}  # Default to amd64 if not set
USE_UEFI=${USE_UEFI:-"no"}  # Default to no UEFI as specified

# Validate ARCH can only be amd64 or arm64
if [[ "$ARCH" != "amd64" && "$ARCH" != "arm64" ]]; then
    echo "Error: ARCH can only be 'amd64' or 'arm64'"
    echo "Usage: ARCH=[amd64|arm64] $0"
    exit 1
fi

# Select correct binary based on architecture and configure UEFI
QEMU_BIN="qemu-system-x86_64"
UEFI_ARGS=""

if [ "$ARCH" = "amd64" ]; then
    if [ "${USE_UEFI}" = "yes" ]; then
        if [ -f "/usr/share/OVMF/OVMF_CODE.fd" ]; then
            UEFI_ARGS="-bios /usr/share/OVMF/OVMF_CODE.fd"
            info "UEFI firmware found for AMD64"
        else
            echo "⚠️ Warning: UEFI firmware not found for AMD64, falling back to non-UEFI boot"
            UEFI_ARGS=""
        fi
    else
        info "UEFI boot disabled for AMD64"
        UEFI_ARGS=""
    fi
fi

if [ "$ARCH" = "arm64" ]; then
    QEMU_BIN="qemu-system-aarch64"
    if [ "${USE_UEFI}" = "yes" ]; then
        if [ -f "/usr/share/AAVMF/AAVMF_CODE.fd" ]; then
            UEFI_ARGS="-bios /usr/share/AAVMF/AAVMF_CODE.fd"
            info "UEFI firmware found for ARM64"
        elif [ -f "/usr/share/qemu-efi-aarch64/QEMU_EFI.fd" ]; then
            UEFI_ARGS="-bios /usr/share/qemu-efi-aarch64/QEMU_EFI.fd"
            info "Alternative UEFI firmware found for ARM64"
        else
            echo "⚠️ Warning: UEFI firmware not found, falling back to non-UEFI boot"
            UEFI_ARGS=""
        fi
    else
        info "UEFI boot disabled for ARM64"
        UEFI_ARGS=""
    fi
fi

cd /run

# Initialize variables with defaults
: "${CPU_PIN:=""}"          # CPU pinning
: "${BOOT_MODE:=""}"        # Boot mode
: "${DISK_IO:=""}"          # Disk I/O mode
: "${DISK_CACHE:=""}"       # Disk cache mode
: "${DISK_DISCARD:=""}"     # Disk discard mode
: "${DISK_FLAGS:=""}"       # Additional disk flags
: "${NET_DEVICE:=""}"       # Network device
: "${NET_DRIVER:=""}"       # Network driver
: "${NET_MODEL:=""}"        # Network card model
: "${ARGS:=""}"             # Additional QEMU arguments

# Show all environment variables at startup
show_environment

# Primero cargar los scripts
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
if [ -z "$BOOT" ]; then
    info "Booting from disk using QEMU v$version (Architecture: $ARCH)..."
else
    info "Booting image${BOOT_DESC} using QEMU v$version (Architecture: $ARCH)..."
fi

# Add UEFI args to the final command if they exist
if [ -n "$UEFI_ARGS" ]; then
    ARGS="$UEFI_ARGS $ARGS"
fi


# Execute QEMU
if [ -z "${CPU_PIN:-}" ]; then
    exec $QEMU_BIN ${ARGS:+ $ARGS}
else
    exec taskset -c "$CPU_PIN" $QEMU_BIN ${ARGS:+ $ARGS}
fi
