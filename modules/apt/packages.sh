#!/usr/bin/env bash
set -euo pipefail

cd "${EBRO_ROOT}"
"${EBRO_BIN}" -i --query 'tasks | filter("apt.packages" in .labels) | map(.labels["apt.packages"]) | join("\n")'
