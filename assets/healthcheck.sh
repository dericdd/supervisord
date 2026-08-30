#!/usr/bin/env bash
set -euo pipefail

HC_DIR="${HEALTHCHECK_DIR:-/healthcheck.d}"
EXIT_CODE=0

if [[ ! -d "$HC_DIR" ]]; then
  echo "healthcheck: directory '$HC_DIR' not found, treating as healthy (no checks)" >&2
  exit 0
fi

shopt -s nullglob

checks=("$HC_DIR"/*)
if [[ "${#checks[@]}" -eq 0 ]]; then
  echo "healthcheck: no checks in '$HC_DIR', treating as healthy" >&2
  exit 0
fi

for f in "${checks[@]}"; do
  # Only run executable files
  if [[ ! -x "$f" ]] || [[ ! -f "$f" ]]; then
    continue
  fi

  name="$(basename "$f")"
  echo "healthcheck: running $name"

  # optional: per-check timeout (if `timeout` exists)
  if command -v timeout >/dev/null 2>&1; then
    if ! timeout "${HEALTHCHECK_TIMEOUT:-4s}" "$f"; then
      echo "healthcheck: FAILED -> $name" >&2
      EXIT_CODE=1
    else
      echo "healthcheck: OK -> $name"
    fi
  else
    if ! "$f"; then
      echo "healthcheck: FAILED -> $name" >&2
      EXIT_CODE=1
    else
      echo "healthcheck: OK -> $name"
    fi
  fi
done

exit "$EXIT_CODE"
