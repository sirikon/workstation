#!/usr/bin/env bash
set -euo pipefail

export SRK_ROOT="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"

function main {
    command_exists mise || brew install mise
    command_exists alacritty || brew install --cask alacritty
    directory_exists '/Applications/iCanHazShortcut.app' || brew install --cask icanhazshortcut
    file_exists '/opt/homebrew/bin/bash' || brew install bash

    link "$SRK_ROOT/config/alacritty/alacritty.toml" \
        "$HOME/.alacritty.toml"

    link "$SRK_ROOT/config/vscode/settings.json" \
        "$HOME/Library/Application Support/Code/User/settings.json"

    link "$SRK_ROOT/config/sublime-merge/preferences.json" \
        "$HOME/Library/Application Support/Sublime Merge/Packages/User/Preferences.sublime-settings"

    link "$SRK_ROOT/config/icanhazshortcut" \
        "$HOME/.config/iCanHazShortcut"

    link "$HOME/Dropbox/_SoftwareConfig/dbeaver" \
        "$HOME/Library/DBeaverData/workspace6/General"
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
