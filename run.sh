#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

vagrant destroy -f && vagrant up

vagrant ssh -- -t <<HEREDOC
set -euo pipefail
IFS=$'\n\t'

sudo bash /vagrant/setup.sh
sudo bash /tests/test.sh NILFS2-DEDUP
sudo bash /vagrant/teardown.sh
sudo bash /tests/test_nilfs_dedup.sh
HEREDOC

vagrant destroy -f