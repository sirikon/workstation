#!/usr/bin/env bash
set -euo pipefail

export SRK_ROOT="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"

function main {
    install-metapackage

    mkdir -p "$HOME/.config"

    link "$SRK_ROOT/config/neovim" \
        "$HOME/.config/nvim"

    link "$SRK_ROOT/config/xdg-desktop-portal-wlr" \
        "$HOME/.config/xdg-desktop-portal-wlr"
    
    sudo systemctl disable systemd-networkd systemd-networkd.socket systemd-networkd-wait-online
    sudo systemctl stop systemd-networkd systemd-networkd.socket systemd-networkd-wait-online

    sudo rm -f /etc/network/interfaces

    sudo systemctl enable NetworkManager
    sudo systemctl start NetworkManager

    sudo mkdir -p /srv/public
    sudo chmod -R +rx /srv/public
    sudo chown sirikon:sirikon /srv/public

    if ! file_exists /etc/samba/smb.conf.bak; then
        copy_sudo "/etc/samba/smb.conf" "/etc/samba/smb.conf.bak"
    fi
    copy_sudo "$SRK_ROOT/config/samba/smb.conf" \
        "/etc/samba/smb.conf"
    sudo systemctl restart smbd.service

    if ! file_exists /etc/minidlna.conf.bak; then
        copy_sudo "/etc/minidlna.conf" "/etc/minidlna.conf.bak"
    fi
    copy_sudo "$SRK_ROOT/config/minidlna/minidlna.conf" \
        "/etc/minidlna.conf"
    sudo systemctl restart minidlna.service
}

function install-metapackage {
    log "Installing metapackage"
    "$SRK_ROOT/scripts/bin/linux/srkdeb" workstation
    sudo usermod -aG docker "$USER"
}

function command_exists {
    log "Checking command exists: $1"
    command -v "$1" >/dev/null
}

function directory_exists {
    log "Checking directory exists: $1"
    [ -d "$1" ]
}

function file_exists {
    log "Checking file exists: $1"
    [ -f "$1" ]
}

function link {
    log "Linking $1 to $2"
    rm -rf "$2"
    ln -fFs "$1" "$2"
}

function copy_sudo {
    log "Copying (as root) $1 to $2"
    sudo rm -rf "$2"
    sudo cp -r "$1" "$2"
}

function log {
    printf "\e[1m\033[38;5;208m###\033[0m \e[1m%s\n\033[0m" "${1}"
}

main "$@"
