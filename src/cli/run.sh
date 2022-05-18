#!/usr/bin/env bash
set -euo pipefail

ROOT="$(dirname "${BASH_SOURCE[0]}")"
export SRK_ROOT=~/.srk
export DENO_INSTALL="${SRK_ROOT}/deno/install"
export DENO_DIR="${SRK_ROOT}/deno/cache"

"${DENO_INSTALL}/bin/deno" run \
  -A --no-check \
  --config "${ROOT}/deno.json" \
  --import-map "${ROOT}/import_map.json" \
  "${ROOT}/main.ts" "${@}"
