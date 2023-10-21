#!/bin/bash

set -e

export PACKER_KEY_INTERVAL=10ms
packer init -upgrade "$@"
packer build -force --only=virtualbox-iso.vm "$@"
