# Setup portable MinGW for AfkPreventer build
# Run: .\setup-portable-mingw.ps1
$ErrorActionPreference = "Stop"
$url = "https://github.com/brechtsanders/winlibs_mingw/releases/download/15.2.0posix-13.0.0-ucrt-r5/winlibs-i686-posix-dwarf-gcc-15.2.0-mingw-w64ucrt-13.0.0-r5.zip"
$zip = Join-Path $env:TEMP "winlibs-i686.zip"
$toolsDir = Join-Path $PSScriptRoot "tools"
$mingwDir = Join-Path $toolsDir "mingw32"

if (Test-Path (Join-Path $mingwDir "bin\g++.exe")) {
    Write-Host "Portable MinGW already present at tools\mingw32\bin\g++.exe" -ForegroundColor Green
    exit 0
}

Write-Host "Downloading WinLibs i686 MinGW (~100MB)..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing

Write-Host "Extracting..." -ForegroundColor Cyan
$extractTemp = Join-Path $env:TEMP "winlibs-extract"
if (Test-Path $extractTemp) { Remove-Item $extractTemp -Recurse }
Expand-Archive -Path $zip -DestinationPath $extractTemp -Force

# WinLibs zip has root folder like "mingw32" or versioned name - find bin/g++.exe
$gpp = Get-ChildItem -Path $extractTemp -Recurse -Filter "g++.exe" -ErrorAction SilentlyContinue | Where-Object { $_.DirectoryName -match "bin$" } | Select-Object -First 1
if (-not $gpp) {
    Write-Host "Could not find g++.exe in extracted archive." -ForegroundColor Red
    exit 1
}

$rootBin = $gpp.Directory.Parent.FullName   # parent of bin
New-Item -ItemType Directory -Path $toolsDir -Force | Out-Null
if (Test-Path $mingwDir) { Remove-Item $mingwDir -Recurse }
Move-Item -Path $rootBin -Destination $mingwDir -Force

Remove-Item $zip -Force -ErrorAction SilentlyContinue
Remove-Item $extractTemp -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Done. Portable MinGW at tools\mingw32\bin\g++.exe" -ForegroundColor Green
Write-Host "Run .\build.ps1 to build AfkPreventer.dll" -ForegroundColor Cyan
