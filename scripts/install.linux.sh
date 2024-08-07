#!/usr/bin/env bash
set -euo pipefail

export SRK_ROOT="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"

function main {
    command_exists wget || sudo apt-get install -y wget
    command_exists gpg || sudo apt-get install -y gnupg
    command_exists curl || sudo apt-get install -y curl
    command_exists gnome-keyring && sudo apt-get remove -y gnome-keyring

    file_exists /etc/apt/trusted.gpg.d/sublimehq-archive.gpg ||
        wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg >/dev/null
    file_exists /etc/apt/keyrings/mise-archive-keyring.gpg ||
        wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg >/dev/null
    file_exists /etc/apt/keyrings/docker.asc || (
        sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
    )

    copy_sudo "$SRK_ROOT/config/apt/sirikon-workstation.list" \
        "/etc/apt/sources.list.d/sirikon-workstation.list"

    sudo apt-get update

    install-metapackage

    mkdir -p "$HOME/.config"

    link "$SRK_ROOT/config/sway" \
        "$HOME/.config/sway"

    link "$SRK_ROOT/config/waybar" \
        "$HOME/.config/waybar"

    link "$SRK_ROOT/config/alacritty" \
        "$HOME/.config/alacritty"

    mkdir -p "$HOME/.config/Code/User"
    link "$SRK_ROOT/config/vscode/settings.json" \
        "$HOME/.config/Code/User/settings.json"

    mkdir -p "$HOME/.config/sublime-merge/Packages/User"
    link "$SRK_ROOT/config/sublime-merge/preferences.json" \
        "$HOME/.config/sublime-merge/Packages/User/Preferences.sublime-settings"

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
