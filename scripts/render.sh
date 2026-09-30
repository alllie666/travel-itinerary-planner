#!/usr/bin/env bash
# Render an itinerary HTML page into a 2x long PNG and a PDF (macOS / Linux).
# Usage: ./render.sh path/to/trip.html path/to/output/MyTrip [width]
# Produces <prefix>.png and <prefix>.pdf
# The HTML must set body[data-h] to document.documentElement.scrollHeight (the template does).
set -euo pipefail
HTML="$1"; OUT="$2"; WIDTH="${3:-760}"

for c in "google-chrome" "chromium" "chromium-browser" "microsoft-edge" \
         "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
         "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"; do
  if command -v "$c" >/dev/null 2>&1 || [ -x "$c" ]; then BROWSER="$c"; break; fi
done
: "${BROWSER:?Chrome, Chromium or Edge not found}"

URL="file://$(cd "$(dirname "$HTML")" && pwd)/$(basename "$HTML")"
H=$("$BROWSER" --headless=new --disable-gpu --window-size="$WIDTH,1000" --virtual-time-budget=3000 --dump-dom "$URL" 2>/dev/null \
    | grep -o 'data-h="[0-9]*"' | head -1 | grep -o '[0-9]*')
[ -n "$H" ] || { echo "Could not read page height (body[data-h] missing)"; exit 1; }
H=$((H + 4))

"$BROWSER" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=2 \
  --window-size="$WIDTH,$H" --virtual-time-budget=3000 --screenshot="$OUT.png" "$URL" >/dev/null 2>&1
"$BROWSER" --headless=new --disable-gpu --no-pdf-header-footer --virtual-time-budget=3000 \
  --print-to-pdf="$OUT.pdf" "$URL" >/dev/null 2>&1
ls -l "$OUT.png" "$OUT.pdf"
