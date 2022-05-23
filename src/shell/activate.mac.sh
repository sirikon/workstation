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

function upgrade-xcodes { (
  mkdir -p ~/Software/xcodes
  cd ~/Software/xcodes || return
  rm -rf ./*
  latest_version=$(curl --silent "https://api.github.com/repos/RobotsAndPencils/xcodes/releases/latest" | jq -r ".tag_name")
  printf "%s\n\n" "Downloading xcodes ${latest_version}"
  curl -Lo "xcodes.zip" "https://github.com/RobotsAndPencils/xcodes/releases/download/${latest_version}/xcodes.zip"
  unzip "xcodes.zip"
  rm -f ~/bin/xcodes
  ln -s "$(pwd)/xcodes" ~/bin/xcodes
); }
