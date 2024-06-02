#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/SeaDve/Kooha"
TAG="v2.2.3"

if [ ! -d "repo" ]; then
    git clone "$REPO" "repo"
fi
build_prefix="/usr/local"
destdir="$(pwd)/deb"
(
    cd "repo"
    if [ "$(git describe --tags)" != "$TAG" ]; then
        git fetch --all
        git reset --hard >/dev/null
        git clean -dfx
        git checkout "$TAG"
    fi
    echo "rust 1.78.0" >.tool-versions
    mise install
    eval "$(mise env)"
    meson setup _build --prefix="${build_prefix}"
    DESTDIR="${destdir}" ninja -C _build install
)

cat >>deb/DEBIAN/control <<EOF
Description: SeaDve's Kooha
EOF
