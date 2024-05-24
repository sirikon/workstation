#!/usr/bin/env bash

function log {
    printf "\e[1m\033[38;5;208m###\033[0m \e[1m%s\n\033[0m" "${1}"
}

function command_exists {
    command -v "$1" >/dev/null
}
