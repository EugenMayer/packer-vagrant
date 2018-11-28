#!/bin/bash

set -e

PACKCONFIG=${1:-debian9.json}

export PACKER_KEY_INTERVAL=10ms
packer build --only=virtualbox-iso $PACKCONFIG
