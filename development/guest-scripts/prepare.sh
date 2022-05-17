#!/usr/bin/env bash
set -euo pipefail

apt-get update
apt-get upgrade -y
apt-get install -y cifs-utils console-keymaps
mkdir -p /root/.srk
mount -t cifs -o guest //10.0.2.4/qemu/ /root/.srk
