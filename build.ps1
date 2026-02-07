# Build AfkPreventer.dll — Windows. Prefers portable MinGW in tools\mingw32, else Visual Studio.
$ErrorActionPreference = "Stop"
$scriptDir = $PSScriptRoot
$binDir = Join-Path $scriptDir "bin"
$dll = Join-Path $binDir "AfkPreventer.dll"
$gpp = Join-Path $scriptDir "tools\mingw32\bin\g++.exe"

if (Test-Path $gpp) {
    New-Item -ItemType Directory -Path $binDir -Force | Out-Null
    $env:PATH = (Join-Path $scriptDir "tools\mingw32\bin") + ";" + $env:PATH
    & g++ -shared -O2 -s -Wall -DWIN32_LEAN_AND_MEAN -o $dll (Join-Path $scriptDir "dllmain.cpp") -static -luser32 -lkernel32
    if ($LASTEXITCODE -eq 0) { Write-Host "Built: bin\AfkPreventer.dll" -ForegroundColor Green }
    exit $LASTEXITCODE
}

$msbuild = (Get-ChildItem -Path "C:\Program Files*" -Recurse -Filter "MSBuild.exe" -ErrorAction SilentlyContinue | Where-Object { $_.FullName -match "Current\\Bin" } | Select-Object -First 1).FullName
if ($msbuild) {
    & $msbuild (Join-Path $scriptDir "AfkPreventer.vcxproj") /p:Configuration=Release /p:Platform=Win32 /v:minimal
    if ($LASTEXITCODE -eq 0) { Write-Host "Built: bin\AfkPreventer.dll" -ForegroundColor Green }
    exit $LASTEXITCODE
}

Write-Host "No compiler found. Either:" -ForegroundColor Red
Write-Host "  1. Download a 32-bit MinGW (e.g. WinLibs i686), extract so you have tools\mingw32\bin\g++.exe here, then run this script again." -ForegroundColor Yellow
Write-Host "  2. Install Visual Studio with C++ workload and run this script again." -ForegroundColor Yellow
Write-Host "See README.md for portable (no install) steps." -ForegroundColor Yellow
exit 1
