#!/usr/bin/env bash
set -euo pipefail

HEAD="### srk shell"
TAIL="### end srk shell"

if ! (cat $HOME/.bashrc | grep "$HEAD" >/dev/null); then
    echo "$HEAD" >> $HOME/.bashrc
    echo "$TAIL" >> $HOME/.bashrc
fi

before="$(sed -zE "s/$HEAD\n.*//" "$HOME/.bashrc")"
after="$(sed -zE "s/.*$TAIL\n//" "$HOME/.bashrc")"
srk_root="$(git rev-parse --show-toplevel)"

printf "%s\n" "$before" > $HOME/.bashrc
echo "" >> $HOME/.bashrc
echo "$HEAD" >> $HOME/.bashrc
echo "export SRK_ROOT='$srk_root'" >> $HOME/.bashrc
echo 'source "$SRK_ROOT/scripts/shell/activate.linux.sh"' >> $HOME/.bashrc
echo 'source "$SRK_ROOT/scripts/shell/activate.sh"' >> $HOME/.bashrc
echo "$TAIL" >> $HOME/.bashrc
printf "%s\n" "$after" >> $HOME/.bashrc
