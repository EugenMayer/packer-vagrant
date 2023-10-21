#!/bin/bash

set -e

PACKCONFIG=${1:-debian12.1.pkr.hcl}
qemu-img create -f qcow2 system_disk_qemu.qcow2 40G
qemu-img create -f qcow2 data_disk_qemu.qcow2 1G
export PACKER_KEY_INTERVAL=10ms
packer build --only=qemu $PACKCONFIG

packer init -upgrade "$@"
packer build -force --only=virtualbox-iso.vm "$@"
