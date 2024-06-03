#!/usr/bin/env bash
set -euo pipefail

cat >>deb/DEBIAN/control <<EOF
Version: 0.0.0
Description: Metapackage containing all the packages needed in Sirikon's workstation
Depends: jq, yq, sway, ssh-askpass, firefox-esr, fonts-noto-color-emoji, libgtk-3-dev, python3-gpg, waybar, mise, sublime-merge, gajim, vlc, docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin, docker-compose-plugin, zip, unzip, qbittorrent, samba, minidlna, libsecret-tools, libreoffice, libreoffice-gtk3, age, meson, ninja-build, wayland-protocols, scdoc, wl-clipboard, libgtk-4-dev, libadwaita-1-dev, libgstreamer1.0-dev, libgstreamer-plugins-base1.0-dev, libpulse-dev, gettext, xdg-desktop-portal-wlr, pipewire, gstreamer1.0-pipewire
EOF
