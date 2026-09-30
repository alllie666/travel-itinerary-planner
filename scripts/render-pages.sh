#!/usr/bin/env bash
# Usage: bash render-pages.sh trip.html out/pages [width]
set -euo pipefail
HTML="${1:?HTML path required}"; OUT_DIR="${2:?Output directory required}"; WIDTH="${3:-760}"
[[ -f "$HTML" ]] || { echo "HTML file not found: $HTML" >&2; exit 2; }
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PAGES=$(grep -o 'data-page="[0-9]*"' "$HTML" | sed 's/[^0-9]//g' | sort -nu)
[[ -n "$PAGES" ]] || { echo "No data-page attributes found" >&2; exit 2; }
mkdir -p "$OUT_DIR"
EXPECTED=1
while IFS= read -r PAGE; do
  [[ "$PAGE" == "$EXPECTED" ]] || { echo "data-page numbers must be contiguous from 1" >&2; exit 2; }
  EXPECTED=$((EXPECTED + 1))
done <<< "$PAGES"
while IFS= read -r PAGE; do
  PREFIX=$(printf '%02d' "$PAGE")
  bash "$SCRIPT_DIR/render.sh" "$HTML" "$OUT_DIR/$PREFIX" "$WIDTH" png "$PAGE"
done <<< "$PAGES"
