#!/usr/bin/env bash

export PATH=/opt/homebrew/bin:~/bin:$PATH

function sm {
  /Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/smerge -n .
}

function backup-terminal-config { (
  cp ~/Library/Preferences/com.apple.Terminal.plist \
    ~/Dropbox/ProgramData/MacOsTerminal/com.apple.Terminal.plist
); }

function restore-terminal-config { (
  cp ~/Dropbox/ProgramData/MacOsTerminal/com.apple.Terminal.plist \
    ~/Library/Preferences/com.apple.Terminal.plist
); }

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
  # asdf update
  # asdf plugin update --all
); }
