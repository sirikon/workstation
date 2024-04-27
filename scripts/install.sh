#!/usr/bin/env bash
set -euo pipefail

export SRK_ROOT="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"

function main {
    install_mise
    link_alacritty_config
    link_vscode_config
    link_sublime_merge_config
    link_dbeaver_config
}

function install_mise {
    command_exists mise || brew install mise
}

function link_alacritty_config {
    link "$SRK_ROOT/config/alacritty/alacritty.toml" \
        "$HOME/.alacritty.toml"
}

function link_vscode_config {
    link "$SRK_ROOT/config/vscode/settings.json" \
        "$HOME/Library/Application Support/Code/User/settings.json"
}

function link_sublime_merge_config {
    link "$SRK_ROOT/config/sublime-merge/preferences.json" \
        "$HOME/Library/Application Support/Sublime Merge/Packages/User/Preferences.sublime-settings"
}

function link_dbeaver_config {
    link "$HOME/Dropbox/_SoftwareConfig/dbeaver" \
        "$HOME/Library/DBeaverData/workspace6/General"
}

function command_exists {
    log "Checking command exists: $1"
    command -v "$1" >/dev/null
}

function link {
    log "Linking $1 to $2"
    ln -fFs "$1" "$2"
}

function log {
    printf "\e[1m\033[38;5;208m###\033[0m \e[1m%s\n\033[0m" "${1}"
}

main "$@"
