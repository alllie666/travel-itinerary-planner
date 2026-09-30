# Render an itinerary HTML page as a set of phone-sized images, one per page (Windows, PowerShell 5.1+).
# Each top-level block in the HTML carries data-page="N"; the page script shows only page N when the URL has #page=N.
# Usage (call with & from an existing PowerShell session so non-ASCII names survive):
#   & .\render-pages.ps1 -Html trip.html -OutDir out\pages -Names "01_封面,02_10.5,..."
param(
  [Parameter(Mandatory=$true)][string]$Html,
  [Parameter(Mandatory=$true)][string]$OutDir,
  [string]$Names = "",
  [int]$Width = 760
)
$ErrorActionPreference = 'Continue'
$nameList = @($Names -split ',' | Where-Object { $_ -ne '' })

$candidates = @(
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
)
$browser = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $browser) { throw "Edge or Chrome not found." }

$full = (Resolve-Path $Html).Path
$base = "file:///" + ($full -replace '\\','/')
New-Item -ItemType Directory -Force $OutDir | Out-Null

# number of pages = highest data-page value in the file
$pages = ([regex]::Matches([IO.File]::ReadAllText($full), 'data-page="(\d+)"') | ForEach-Object { [int]$_.Groups[1].Value } | Measure-Object -Maximum).Maximum
if (-not $pages) { throw "No data-page attributes found in $Html." }

for ($n = 1; $n -le $pages; $n++) {
  $url = "$base#page=$n"
  # small viewport so short pages aren't padded up to the window height
  $dom = & $browser --headless=new --disable-gpu --window-size="$Width,200" --virtual-time-budget=3000 --dump-dom $url 2>$null | Out-String
  $m = [regex]::Match($dom, 'data-h="(\d+)"')
  if (-not $m.Success) { throw "Could not read height of page $n." }
  $h = [int]$m.Groups[1].Value + 2
  $name = if ($nameList.Count -ge $n) { $nameList[$n-1] } else { "{0:D2}" -f $n }
  $out = Join-Path $OutDir "$name.png"
  & $browser --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=2 --window-size="$Width,$h" --virtual-time-budget=3000 --screenshot="$out" $url 2>$null | Out-Null
  if (-not (Test-Path $out)) { throw "Render failed for page $n." }
  "{0,-28} {1,5} px tall" -f "$name.png", ($h*2)
}
