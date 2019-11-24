#!/bin/bash

set -e

export PACKER_KEY_INTERVAL=10ms
packer build --only=virtualbox-iso "$@"
