#!/usr/bin/env bash
set -euo pipefail

apt-get update
apt-get upgrade -y
apt-get install -y cifs-utils keyboard-configuration console-setup
mkdir -p /srk-src
printf "%s\n" "//10.0.2.4/qemu/ /srk-src cifs guest,ro 0 0" >>"/etc/fstab"
printf "%s\n" "127.0.0.1 $(hostname)" >>"/etc/hosts"
mount -t cifs -o guest,ro //10.0.2.4/qemu/ /srk-src
useradd \
  --create-home \
  --shell /bin/bash \
  sirikon
passwd -d sirikon
usermod -aG sudo sirikon
mkdir -p /home/sirikon/.srk
chown sirikon:sirikon /home/sirikon/.srk
ln -s /srk-src/src /home/sirikon/.srk/src
ln -s /srk-src/.tool-versions /home/sirikon/.srk/.tool-versions
ln -s /srk-src/install /home/sirikon/.srk/install
