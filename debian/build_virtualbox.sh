#!/bin/bash

set -e

PACKCONFIG=${1:-debian9.x.json}

export PACKER_KEY_INTERVAL=10ms
packer build --only=virtualbox-iso $PACKCONFIG
