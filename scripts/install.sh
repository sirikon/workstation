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
    command -v "$1" >/dev/null
}

function link {
    ln -fFs "$1" "$2"
}

set -x
main "$@"
