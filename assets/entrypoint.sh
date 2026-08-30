#!/usr/bin/env bash
set -Eeuo pipefail

ENTRYPOINT_DIR="/entrypoint.d"

if [[ -d "$ENTRYPOINT_DIR" ]]; then
  echo "[entrypoint] scanning $ENTRYPOINT_DIR"
  ls -la "$ENTRYPOINT_DIR" || true

  shopt -s nullglob

  # 1) Run *.sh in lexical order
  scripts=( "$ENTRYPOINT_DIR"/*.sh )
  for f in "${scripts[@]}"; do
    # Skip unreadable files / broken symlinks, but keep going
    if [[ ! -r "$f" ]]; then
      echo "[entrypoint] WARN: skipping unreadable or missing: $f"
      continue
    fi

    echo "[entrypoint] running: $f"
    bash "$f"
  done

fi
