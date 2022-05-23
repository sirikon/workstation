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

function upgrade {(
  brew update
  brew upgrade
)}
