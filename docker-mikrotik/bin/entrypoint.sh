#!/usr/bin/env bash

# A bridge of this name will be created to host the TAP interface created for
# the VM
QEMU_BRIDGE='qemubr0'

# DHCPD must have an IP address to run, but that address doesn't have to
# be valid. This is the dummy address dhcpd is configured to use.
DUMMY_DHCPD_IP='10.0.0.254'

# These scripts configure/deconfigure the VM interface on the bridge.
QEMU_IFUP='/routeros/bin/qemu-ifup'
QEMU_IFDOWN='/routeros/bin/qemu-ifdown'

# The name of the dhcpd config file we make
DHCPD_CONF_FILE='/routeros/dhcpd.conf'

function default_intf() {
    ip -json route show | jq -r '.[] | select(.dst == "default") | .dev'
}

# First step, we run the things that need to happen before we start mucking
# with the interfaces. We start by generating the DHCPD config file based
# on our current address/routes. We "steal" the container's IP, and lease
# it to the VM once it starts up.
/routeros/bin/generate-dhcpd-conf.py $QEMU_BRIDGE > $DHCPD_CONF_FILE
default_dev=`default_intf`

# Now we start modifying the networking configuration. First we clear out
# the IP address of the default device (will also have the side-effect of
# removing the default route)
ip addr flush dev $default_dev

# Next, we create our bridge, and add our container interface to it.
ip link add $QEMU_BRIDGE type bridge
ip link set dev $default_dev master $QEMU_BRIDGE

# Then, we toggle the interface and the bridge to make sure everything is up
# and running.
ip link set dev $default_dev up
ip link set dev $QEMU_BRIDGE up

touch /var/lib/udhcpd/udhcpd.leases
# Finally, start our DHCPD server
udhcpd -I $DUMMY_DHCPD_IP -f $DHCPD_CONF_FILE &

# And run the VM! A brief explanation of the options here:
# -enable-kvm: Use KVM for this VM (much faster for our case).
# -nographic: disable SDL graphics.
# -serial mon:stdio: use "monitored stdio" as our serial output.
# -nic: Use a TAP interface with our custom up/down scripts.
# -drive: The VM image we're booting.
exec qemu-system-x86_64 \
    -nographic -serial mon:stdio \
    -m 256 \
    "$@" \
    -hda $ROUTEROS_IMAGE \
    -device e1000,netdev=net0 \
    -netdev user,id=net0 \
    -device e1000,netdev=net1 \
    -netdev user,id=net1 \
    -device e1000,netdev=net2 \
    -netdev user,id=net2 \
    -device e1000,netdev=net3 \
    -netdev user,id=net3 \
    -device e1000,netdev=net4 \
    -netdev user,id=net4 \
    -device e1000,netdev=net5 \
    -netdev user,id=net5 \
    -device e1000,netdev=net6 \
    -netdev user,id=net6 \
    -device e1000,netdev=net7 \
    -netdev user,id=net7 \
    -device e1000,netdev=net8 \
    -netdev user,id=net8 \
    -device e1000,netdev=net9 \
    -netdev user,id=net9 \
    -device e1000,netdev=net10 \
    -netdev user,id=net10,hostfwd=tcp::21-:21,hostfwd=tcp::22-:22,hostfwd=tcp::23-:23,hostfwd=tcp::80-:80,hostfwd=tcp::443-:443,hostfwd=tcp::8291-:8291,hostfwd=tcp::8728-:8728,hostfwd=tcp::8729-:8729,hostfwd=tcp::1194-:1194,hostfwd=tcp::1701-:1701,hostfwd=tcp::1723-:1723 \
    -nic tap,id=qemu0,script=$QEMU_IFUP,downscript=$QEMU_IFDOWN 

