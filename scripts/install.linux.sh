#!/usr/bin/env bash
set -euo pipefail

export SRK_ROOT="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"

function main {
    # install-metapackage

    link "$SRK_ROOT/config/sway" \
        "$HOME/.config/sway"

    link "$SRK_ROOT/config/waybar" \
        "$HOME/.config/waybar"

    link "$SRK_ROOT/config/alacritty/alacritty.toml" \
        "$HOME/.alacritty.toml"

    link "$SRK_ROOT/config/vscode/settings.json" \
        "$HOME/.config/Code/User/settings.json"
}

function install-metapackage {
    command_exists dpkg-deb || apt-get install -y dpkg-deb
    log "Installing metapackage"
    (
        cd packages
        dpkg-deb --build sirikon-workstation
    )
    sudo apt-get install ./packages/sirikon-workstation.deb
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

function log {
    printf "\e[1m\033[38;5;208m###\033[0m \e[1m%s\n\033[0m" "${1}"
}

main "$@"
