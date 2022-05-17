#!/usr/bin/env bash
set -euo pipefail
ROOT="$(dirname "${BASH_SOURCE[0]}")"
deno run \
  -A --no-check \
  --config "${ROOT}/deno.json" \
  --import-map "${ROOT}/import_map.json" \
  "${ROOT}/main.ts" "${@}"
