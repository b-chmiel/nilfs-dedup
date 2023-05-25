#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

source test_template_env.sh

fallocate -l $FILESYSTEM_FILE_SIZE $FILESYSTEM_FILE
mkfs -t nilfs2 $FILESYSTEM_FILE
mkdir -pv $DESTINATION
mount -i -v -t nilfs2 $FILESYSTEM_FILE $DESTINATION
