#!/usr/bin/env bash
set -euo pipefail

export SRK_ROOT="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"

function main {
    command_exists wget || sudo apt-get install -y wget

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

    link "$SRK_ROOT/config/sway" \
        "$HOME/.config/sway"

    link "$SRK_ROOT/config/waybar" \
        "$HOME/.config/waybar"

    link "$SRK_ROOT/config/alacritty" \
        "$HOME/.config/alacritty"

    link "$SRK_ROOT/config/vscode/settings.json" \
        "$HOME/.config/Code/User/settings.json"

    link "$SRK_ROOT/config/sublime-merge/preferences.json" \
        "$HOME/.config/sublime-merge/Packages/User/Preferences.sublime-settings"
}

function install-metapackage {
    directory_exists /usr/share/doc/apt-transport-https || sudo apt-get install -y apt-transport-https
    command_exists dpkg-deb || sudo apt-get install -y dpkg-deb
    log "Installing metapackage"
    (
        cd packages
        dpkg-deb --build sirikon-workstation
    )
    sudo apt-get install -y ./packages/sirikon-workstation.deb
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
