#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/emersion/slurp"
REF="v1.4.0"

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
cp "repo/build/slurp" "deb/usr/local/bin/slurp"

cat >>deb/DEBIAN/control <<EOF
Description: Emersion's Slurp
EOF
