#!/usr/bin/env bash

# Enable colors
export CLICOLOR=1 # ls

# Add asdf
. ~/.asdf/asdf.sh
. ~/.asdf/completions/asdf.bash

# Prevent virtualenv automatic prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

alias ll="ls -lahF"

function git_branch {
  branch=$(git branch 2>/dev/null | grep '^\*' | colrm 1 2)
  if [ "$branch" == "" ]; then
    echo ""
  else
    echo "[${branch}] "
  fi
}

function python_venv {
  if [ "$VIRTUAL_ENV" == "" ]; then
    echo ""
  else
    echo "[🐍$(basename "${VIRTUAL_ENV}")] "
  fi
}

function prompt-normal {
  PS1="\[\033[38;5;208m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] \[\033[38;5;248m\]\w \$(git_branch)\$(python_venv)\[$(tput sgr0)\]\[\033[38;5;214m\]\\$\[$(tput sgr0)\] "
  export PS1
}

function prompt-tiny {
  PS1="\[\033[38;5;214m\]\\$\[$(tput sgr0)\] "
  export PS1
}

prompt-normal

function docker-destroy {
  docker ps -aq | while IFS=$'\n' read -r containerId; do
    docker rm -f "$containerId"
  done
  docker volume prune -f
  docker network prune -f
}

function docker-prune {
  docker-destroy
  docker image prune -af
}

function gradle-destroy { (
  pkill -9 -f gradle
); }

function gradle-prune { (
  rm -rf ~/.gradle
); }

function ssh-forget { (
  local host="${1}"
  ssh-keygen -f ~/.ssh/known_hosts -R "${host}"
); }
