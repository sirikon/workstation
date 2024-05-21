#!/usr/bin/env bash
set -euo pipefail

export SRK_ROOT="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"

function main {
    command_exists git || apt-get install -y git
    command_exists i3 || apt-get install -y i3

    link "$SRK_ROOT/config/i3" "$HOME/.config/i3"
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
