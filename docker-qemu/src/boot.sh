#!/usr/bin/env bash
set -Eeuo pipefail

# Docker environment variables
: "${BIOS:=""}"             # BIOS file
: "${USE_UEFI:="no"}"       # Use UEFI boot

SECURE="off"
BOOT_OPTS=""
BOOT_DESC=""

if [ -n "$BIOS" ]; then
  BOOT_MODE="custom"
  BOOT_OPTS="-bios $BIOS"
  BOOT_DESC=" with custom BIOS file"
  return 0
fi

# Si USE_UEFI está desactivado, usar legacy boot
if [ "${USE_UEFI}" != "yes" ]; then
  BOOT_MODE="legacy"
  BOOT_DESC=" with SeaBIOS"
  return 0
fi

case "${BOOT_MODE,,}" in
  "legacy" )
    BOOT_DESC=" with SeaBIOS"
    ;;
  "uefi" | "" )
    BOOT_MODE="uefi"
    if [ "$ARCH" = "amd64" ]; then
      ROM="OVMF_CODE.fd"
      VARS="OVMF_VARS.fd"
      FIRMWARE_DIR="/usr/share/OVMF"
    else
      ROM="AAVMF_CODE.no-secboot.fd"
      VARS="AAVMF_VARS.fd"
      FIRMWARE_DIR="/usr/share/AAVMF"
    fi
    ;;
  "secure" )
    SECURE="on"
    BOOT_DESC=" securely"
    if [ "$ARCH" = "amd64" ]; then
      ROM="OVMF_CODE.secboot.fd"
      VARS="OVMF_VARS.fd"
      FIRMWARE_DIR="/usr/share/OVMF"
    else
      ROM="AAVMF_CODE.secboot.fd"
      VARS="AAVMF_VARS.fd"
      FIRMWARE_DIR="/usr/share/AAVMF"
    fi
    ;;
  "windows" )
    if [ "$ARCH" = "amd64" ]; then
      ROM="OVMF_CODE.fd"
      VARS="OVMF_VARS.fd"
      FIRMWARE_DIR="/usr/share/OVMF"
    else
      ROM="AAVMF_CODE.no-secboot.fd"
      VARS="AAVMF_VARS.fd"
      FIRMWARE_DIR="/usr/share/AAVMF"
    fi
    BOOT_OPTS="-rtc base=localtime"
    ;;
  "windows_secure" )
    SECURE="on"
    BOOT_DESC=" securely"
    if [ "$ARCH" = "amd64" ]; then
      ROM="OVMF_CODE.ms.fd"
      VARS="OVMF_VARS.ms.fd"
      FIRMWARE_DIR="/usr/share/OVMF"
    else
      ROM="AAVMF_CODE.ms.fd"
      VARS="AAVMF_VARS.ms.fd"
      FIRMWARE_DIR="/usr/share/AAVMF"
    fi
    BOOT_OPTS="-rtc base=localtime"
    ;;
  *)
    error "Unknown BOOT_MODE, value \"${BOOT_MODE}\" is not recognized!"
    exit 33
    ;;
esac

case "${BOOT_MODE,,}" in
  "uefi" | "secure" | "windows" | "windows_secure" )
    DEST="$STORAGE/${BOOT_MODE,,}"

    if [ ! -s "$DEST.rom" ] || [ ! -f "$DEST.rom" ]; then
      [ ! -s "$FIRMWARE_DIR/$ROM" ] || [ ! -f "$FIRMWARE_DIR/$ROM" ] && error "UEFI boot file ($FIRMWARE_DIR/$ROM) not found!" && exit 44
      rm -f "$DEST.rom"
      dd if=/dev/zero "of=$DEST.rom" bs=1M count=64 status=none
      dd "if=$FIRMWARE_DIR/$ROM" "of=$DEST.rom" conv=notrunc status=none
    fi

    if [ ! -s "$DEST.vars" ] || [ ! -f "$DEST.vars" ]; then
      [ ! -s "$FIRMWARE_DIR/$VARS" ] || [ ! -f "$FIRMWARE_DIR/$VARS" ] && error "UEFI vars file ($FIRMWARE_DIR/$VARS) not found!" && exit 45
      rm -f "$DEST.vars"
      dd if=/dev/zero "of=$DEST.vars" bs=1M count=64 status=none
      dd "if=$FIRMWARE_DIR/$VARS" "of=$DEST.vars" conv=notrunc status=none
    fi

    BOOT_OPTS+=" -drive file=$DEST.rom,if=pflash,unit=0,format=raw,readonly=on"
    BOOT_OPTS+=" -drive file=$DEST.vars,if=pflash,unit=1,format=raw"
    ;;
esac

return 0
