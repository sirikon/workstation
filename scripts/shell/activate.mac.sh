#!/usr/bin/env bash

export PATH="/opt/homebrew/bin:~/bin:~/.local/bin:$SRK_ROOT/scripts/bin:$PATH"

function sm {
    /Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/smerge -n .
}

function xcode-cleanup { (
    rm -rf ~/Library/Developer/Xcode/DerivedData
    rm -rf ~/Library/Developer/Xcode/Archives
    rm -rf ~/Library/Caches/com.apple.dt.Xcode
); }

function slack-reinstall { (
    brew reinstall --cask slack
); }

function cocoapods-cleanup { (
    pod cache clean --all
); }

function upgrade { (
    brew update
    brew upgrade
); }
