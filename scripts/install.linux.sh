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
