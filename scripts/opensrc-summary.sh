#!/usr/bin/env bash
set -euo pipefail

OPENSRC_DIR="opensrc"

echo "# opensrc sources (in ${OPENSRC_DIR}/)"
echo "# package -> subpath"
jq -r '
  (.packages[] | "\(.registry)/\(.name)@\(.version) -> \(.path)"),
  (.repos[] | "\(.name)@\(.version) -> \(.path)")
' "${OPENSRC_DIR}/sources.json"
