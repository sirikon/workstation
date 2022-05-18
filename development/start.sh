#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

function main {
  if [ "$(sysctl net.ipv4.ip_forward)" != "net.ipv4.ip_forward = 1" ]; then
    echo "ipv4 forwarding not enabled:"
    echo "  https://wiki.archlinux.org/title/Internet_sharing#Enable_packet_forwarding"
    exit 1
  fi

  if [ ! -f "base.qcow2" ]; then
    log "Downloading Debian image"
    wget -O "base.qcow2" \
      "https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-nocloud-amd64.qcow2"
    rm -f "image.qcow2"
  fi

  log "Ensuring APT dependencies"
  sudo apt-get install -y qemu-system libvirt-daemon-system libguestfs-tools samba

  if [ ! -f "image.qcow2" ]; then
    log "Customising base image"
    cp "base.qcow2" "image.qcow2"
    sudo mkdir -p "temp-mount"
    sudo guestmount -a "image.qcow2" -m "/dev/sda1" --rw "temp-mount"

    # customisation
    sudo mkdir -p "temp-mount/usr/local/bin"
    sudo cp -r "guest-scripts/prepare.sh" "temp-mount/usr/local/bin/guest-prepare"

    sudo umount "temp-mount"

    qemu-img resize "image.qcow2" +15G
  fi

  if [ ! -f "bridge.conf" ]; then
    printf "%s\n" "allow virbr0" | tee "bridge.conf"
    sudo mkdir -p "/etc/qemu"
    sudo rm -f "/etc/qemu/bridge.conf"
    sudo ln -s "$(pwd)/bridge.conf" "/etc/qemu/bridge.conf"
  fi

  log "Ensuring libvirtd is up"
  sudo systemctl start libvirtd.service
  set +e
  sudo virsh net-start --network default 2>/dev/null >/dev/null
  set -e
  ip addr show virbr0

  log "Starting VM"
  sudo qemu-system-x86_64 \
    -net nic \
    -net user,smb="$(pwd)/../" \
    -netdev "bridge,id=hn0,br=virbr0" \
    -device "virtio-net-pci,netdev=hn0,id=nic1" \
    -hda "image.qcow2" \
    -m "1024" \
    --enable-kvm
}

function log {
  printf "\e[1m\033[38;5;208m###\033[0m \e[1m%s\n\033[0m" "${1}"
}

main "${@}"
