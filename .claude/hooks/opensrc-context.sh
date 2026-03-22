#!/bin/bash
set -euo pipefail

INPUT=$(cat)
EVENT=$(echo "$INPUT" | jq -r '.hook_event_name')

SOURCES="$CLAUDE_PROJECT_DIR/opensrc/sources.json"
HASH_FILE="/tmp/opensrc-sources-hash-$(echo "$CLAUDE_PROJECT_DIR" | sha256sum | cut -d' ' -f1)"

if [ "$EVENT" = "SessionStart" ]; then
  # Always output summary on session start
  bash "$CLAUDE_PROJECT_DIR/scripts/opensrc-summary.sh" 2>/dev/null || true
  # Save hash for change detection
  if [ -f "$SOURCES" ]; then
    sha256sum "$SOURCES" | cut -d' ' -f1 > "$HASH_FILE"
  fi

elif [ "$EVENT" = "UserPromptSubmit" ]; then
  # Only output if sources.json has changed since last hook fire
  if [ ! -f "$SOURCES" ]; then
    exit 0
  fi

  CURRENT_HASH=$(sha256sum "$SOURCES" | cut -d' ' -f1)
  STORED_HASH=""
  if [ -f "$HASH_FILE" ]; then
    STORED_HASH=$(cat "$HASH_FILE")
  fi

  if [ "$CURRENT_HASH" != "$STORED_HASH" ]; then
    bash "$CLAUDE_PROJECT_DIR/scripts/opensrc-summary.sh" 2>/dev/null || true
    echo "$CURRENT_HASH" > "$HASH_FILE"
  fi
fi

exit 0
