#!/bin/sh

if [ ! -e '/data/mac_hdd.img' ]
then
  qemu-img create -f qcow2 '/data/mac_hdd.img' 128G
fi

clover1=""
clover2=""
installer1=""
installer2=""

if [ $CLOVER -ne 0 ]
then
  clover1="-device ide-drive,bus=ide.2,drive=Clover"
  clover2="-drive id=Clover,if=none,snapshot=on,format=qcow2,file=Clover.qcow2"
fi

if [ $INSTALLER -ne 0 ]
then
  installer1="-device ide-drive,bus=ide.0,drive=MacDVD"
  installer2="-drive id=MacDVD,if=none,snapshot=on,media=cdrom,file=/data/macOS.iso"
fi

MY_OPTIONS="+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+xsave,+xsaveopt,check"

qemu-system-x86_64 -enable-kvm \
          -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS\
          -machine pc-q35-2.10 \
          -usb -device usb-kbd -device usb-tablet \
          -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
          -drive if=pflash,format=raw,readonly,file=OVMF_CODE.fd \
          -drive if=pflash,format=raw,file=OVMF_VARS-1024x768.fd \
          -smbios type=2 \
          -device ich9-intel-hda -device hda-duplex \
          -device ide-drive,bus=ide.1,drive=MacHDD \
          -drive id=MacHDD,if=none,file=/data/mac_hdd.img,format=qcow2 \
          -netdev user,id=net0 -device e1000-82545em,netdev=net0,id=net0,mac=52:54:00:c9:18:27 -redir tcp:2222::22\
          -vnc 0.0.0.0:0,password -monitor telnet:127.0.0.1:4444,server,nowait -k $KEYBOARD \
          -smp $(($CORE * 2)),cores=$CORE \
          -m $MEMORY \
          $clover1 \
          $clover2 \
          $installer1 \
          $installer2 \
          "$@"
