# Render an itinerary HTML page into a 2x long PNG and a PDF (Windows, PowerShell 5.1+).
# Usage: powershell -File render.ps1 -Html path\to\trip.html -OutPrefix path\to\output\MyTrip
# Produces <OutPrefix>.png and <OutPrefix>.pdf
# The HTML must set body[data-h] to document.documentElement.scrollHeight (the template does).
param(
  [Parameter(Mandatory=$true)][string]$Html,
  [Parameter(Mandatory=$true)][string]$OutPrefix,
  [int]$Width = 760
)
# Browsers print harmless warnings to stderr; keep going and check results explicitly instead.
$ErrorActionPreference = 'Continue'

$candidates = @(
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
)
$browser = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $browser) { throw "Edge or Chrome not found. Install one of them." }

$full = (Resolve-Path $Html).Path
$url = "file:///" + ($full -replace '\\','/')

# 1) measure page height from the data-h attribute written by the page's script
$dom = & $browser --headless=new --disable-gpu --window-size="$Width,1000" --virtual-time-budget=3000 --dump-dom $url 2>$null | Out-String
$m = [regex]::Match($dom, 'data-h="(\d+)"')
if (-not $m.Success) { throw "Could not read page height (body[data-h] missing)." }
$h = [int]$m.Groups[1].Value + 4

# 2) long PNG at 2x, 3) PDF with backgrounds
& $browser --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=2 --window-size="$Width,$h" --virtual-time-budget=3000 --screenshot="$OutPrefix.png" $url 2>$null | Out-Null
& $browser --headless=new --disable-gpu --no-pdf-header-footer --virtual-time-budget=3000 --print-to-pdf="$OutPrefix.pdf" $url 2>$null | Out-Null
Start-Sleep -Seconds 2
foreach ($f in "$OutPrefix.png", "$OutPrefix.pdf") { if (-not (Test-Path $f)) { throw "Render failed: $f was not created." } }
Get-Item "$OutPrefix.png", "$OutPrefix.pdf" | Select-Object Name, Length
