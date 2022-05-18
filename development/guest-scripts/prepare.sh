#!/usr/bin/env bash
set -euo pipefail

apt-get update
apt-get upgrade -y
apt-get install -y cifs-utils keyboard-configuration console-setup
mkdir -p /srk-src
printf "%s\n" "//10.0.2.4/qemu/ /srk-src cifs guest,ro 0 0" >>"/etc/fstab"
mount -t cifs -o guest,ro //10.0.2.4/qemu/ /srk-src
mkdir -p /root/.srk
ln -s /srk-src/src /root/.srk/src
ln -s /srk-src/.tool-versions /root/.srk/.tool-versions
ln -s /srk-src/install /root/.srk/install
