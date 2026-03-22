#!/usr/bin/env bash
set -euo pipefail

OPENSRC_DIR="opensrc"
SOURCES_FILE="${OPENSRC_DIR}/sources.json"

if [[ ! -f "$SOURCES_FILE" ]]; then
  echo "# opensrc sources: none (${SOURCES_FILE} not found)"
  exit 0
fi

echo "# opensrc sources (in ${OPENSRC_DIR}/)"
echo "# package -> subpath"
jq -r '
  (.packages // [] | .[] | "\(.registry)/\(.name)@\(.version) -> \(.path)"),
  (.repos // [] | .[] | "\(.name)@\(.version) -> \(.path)")
' "$SOURCES_FILE"
