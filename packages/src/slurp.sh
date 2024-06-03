#!/usr/bin/env bash
set -euo pipefail

VERSION="1.4.0"

REPO="https://github.com/emersion/slurp"
REF="v${VERSION}"

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
Version: ${VERSION}
Description: Emersion's Slurp
EOF
