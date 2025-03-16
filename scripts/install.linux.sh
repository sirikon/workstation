#!/usr/bin/env bash
set -euo pipefail

export SRK_ROOT="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"

function main {
    install-metapackage
}

function install-metapackage {
    log "Installing metapackage"
    "$SRK_ROOT/scripts/bin/linux/srkdeb" workstation
    sudo usermod -aG docker "$USER"
}

function log {
    printf "\e[1m\033[38;5;208m###\033[0m \e[1m%s\n\033[0m" "${1}"
}

main "$@"
