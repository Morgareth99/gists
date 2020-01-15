#!/bin/sh
screen -S vm-xxxxxxxx -d -R \
 qemu-system-x86_64 \
  -enable-kvm \
  -M q35 \
  -cpu host \
  -m 1G \
  -smp 1 \
  -nographic \
  -vga none \
  -nic tap,ifname=tap0,mac=xx:xx:xx:xx:xx:xx,model=virtio,script=/bin/true \
  -drive file=vm-xxxxxxxx.qcow2,format=qcow2,if=virtio,cache=writeback \
  $@


