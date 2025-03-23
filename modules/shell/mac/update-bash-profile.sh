#!/usr/bin/env bash
set -euo pipefail

HEAD="### srk shell"
TAIL="### end srk shell"

if ! (cat $HOME/.bash_profile | grep "$HEAD" >/dev/null); then
    echo "$HEAD" >> $HOME/.bash_profile
    echo "$TAIL" >> $HOME/.bash_profile
fi

before="$(gsed -zE "s/$HEAD\n.*//" "$HOME/.bash_profile")"
after="$(gsed -zE "s/.*$TAIL\n//" "$HOME/.bash_profile")"
srk_root="$(git rev-parse --show-toplevel)"

printf "%s\n" "$before" > $HOME/.bash_profile
echo "" >> $HOME/.bash_profile
echo "$HEAD" >> $HOME/.bash_profile
echo "export SRK_ROOT='$srk_root'" >> $HOME/.bash_profile
echo 'source "$SRK_ROOT/scripts/shell/activate.mac.sh"' >> $HOME/.bash_profile
echo 'source "$SRK_ROOT/scripts/shell/activate.sh"' >> $HOME/.bash_profile
echo "$TAIL" >> $HOME/.bash_profile
printf "%s\n" "$after" >> $HOME/.bash_profile
