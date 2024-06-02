#!/usr/bin/env bash
set -euo pipefail

REPO="https://git.sr.ht/~emersion/grim"
REF="v1.4.1"

if [ ! -d "repo" ]; then
    git clone "$REPO" repo
fi
(
    cd "repo"
    git fetch --all
    git reset --hard >/dev/null
    git clean -dfx
    git checkout "$REF"

    meson setup build
    ninja -C build
)
mkdir -p "deb/usr/local/bin"
cp "repo/build/grim" "deb/usr/local/bin/grim"

cat >>deb/DEBIAN/control <<EOF
Description: Emersion's Grim
EOF
