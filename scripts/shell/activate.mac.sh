#!/usr/bin/env bash

export SRK_ROOT="$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")"
export PATH="/opt/homebrew/bin:~/bin:~/.local/bin:$PATH"
source "$(dirname "${BASH_SOURCE[0]}")/activate.sh"

function sm {
    /Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/smerge -n .
}

function xcode-prune { (
    rm -rf ~/Library/Developer/Xcode/DerivedData
    rm -rf ~/Library/Developer/Xcode/Archives
    rm -rf ~/Library/Caches/com.apple.dt.Xcode
); }

function cocoapods-prune { (
    pod cache clean --all
); }

function upgrade { (
    brew update
    brew upgrade
); }
