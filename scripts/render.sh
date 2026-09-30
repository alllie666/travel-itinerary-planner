#!/usr/bin/env bash
# Render an itinerary HTML page into a 2x long PNG and a PDF (macOS / Linux).
# Usage: bash render.sh trip.html out/MyTrip [width] [png|pdf|both] [page-number]
# Produces only the selected formats; page-number renders a #page=N PNG.
# The HTML must set body[data-h] to document.documentElement.scrollHeight (the template does).
set -euo pipefail
HTML="${1:?HTML path required}"; OUT="${2:?Output prefix required}"; WIDTH="${3:-760}"
FORMAT="${4:-both}"; PAGE="${5:-}"
case "$FORMAT" in png|pdf|both) ;; *) echo "Format must be png, pdf or both" >&2; exit 2 ;; esac
[[ "$WIDTH" =~ ^[1-9][0-9]*$ ]] || { echo "Width must be positive" >&2; exit 2; }
[[ -z "$PAGE" || "$PAGE" =~ ^[1-9][0-9]*$ ]] || { echo "Page must be positive" >&2; exit 2; }
[[ -f "$HTML" ]] || { echo "HTML file not found: $HTML" >&2; exit 2; }
mkdir -p "$(dirname "$OUT")"

for c in "google-chrome" "chromium" "chromium-browser" "microsoft-edge" \
         "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
         "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"; do
  if command -v "$c" >/dev/null 2>&1 || [ -x "$c" ]; then BROWSER="$c"; break; fi
done
: "${BROWSER:?Chrome, Chromium or Edge not found}"
COMMON_FLAGS=(--headless=new --disable-gpu --no-first-run --no-default-browser-check --disable-background-networking --disable-component-update --disable-sync --timeout=10000)

URL="file://$(cd "$(dirname "$HTML")" && pwd)/$(basename "$HTML")"
[[ -z "$PAGE" ]] || URL="$URL#page=$PAGE"
# Isolate headless rendering from the user's live browser profile.
TASK_PROFILE=$(mktemp -d "${TMPDIR:-/tmp}/travel-render.XXXXXX")
trap 'rm -rf "$TASK_PROFILE"' EXIT
# Some Chrome builds write the capture but remain alive. Bound each invocation,
# terminate only our child, then let the caller validate the actual capture.
run_chrome() {
  "$BROWSER" --user-data-dir="$TASK_PROFILE" "${COMMON_FLAGS[@]}" "$@" &
  local child=$! watchdog status=0
  ( sleep 15; kill -TERM "$child" 2>/dev/null || true ) &
  watchdog=$!
  wait "$child" || status=$?
  kill -TERM "$watchdog" 2>/dev/null || true
  wait "$watchdog" 2>/dev/null || true
  if [[ "$status" != 0 && "$status" != 143 ]]; then return "$status"; fi
}
if [[ "$FORMAT" == png || "$FORMAT" == both ]]; then
run_chrome --window-size="$WIDTH,200" --dump-dom "$URL" > "$TASK_PROFILE/dom.txt" 2>/dev/null
H=$(grep -o 'data-h="[0-9]*"' "$TASK_PROFILE/dom.txt" | head -1 | grep -o '[0-9]*' || true)
[ -n "$H" ] || { echo "Could not read page height (body[data-h] missing)"; exit 1; }
H=$((H + 4))

run_chrome --hide-scrollbars --force-device-scale-factor=2 \
  --window-size="$WIDTH,$H" --screenshot="$TASK_PROFILE/capture.png" "$URL" >/dev/null 2>&1
[[ -s "$TASK_PROFILE/capture.png" ]] || { echo "PNG render failed" >&2; exit 1; }
mv "$TASK_PROFILE/capture.png" "$OUT.png"
ls -l "$OUT.png"
fi
if [[ "$FORMAT" == pdf || "$FORMAT" == both ]]; then
run_chrome --no-pdf-header-footer \
  --print-to-pdf="$TASK_PROFILE/capture.pdf" "$URL" >/dev/null 2>&1
[[ -s "$TASK_PROFILE/capture.pdf" ]] || { echo "PDF render failed" >&2; exit 1; }
mv "$TASK_PROFILE/capture.pdf" "$OUT.pdf"
ls -l "$OUT.pdf"
fi
