# Project   : Garmin-MonkeyC-Fenix8-Solar-51mm
# Author    : AzzureSkyy
# Watermark : AzzureSkyy
# Source    : https://github.com/AzzureSkyy/Garmin-MonkeyC-Fenix8-Solar-51mm
# Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
# Builds the Amiibo app and runs it in the Connect IQ simulator (fenix 8 Solar 51mm).
$ErrorActionPreference = 'Stop'
$proj   = 'E:\Garmin Fenix'
$ciq    = 'C:\Users\Azzur\AppData\Roaming\Garmin\ConnectIQ'
$sdk    = ((Get-Content "$ciq\current-sdk.cfg" -Raw).Trim()).TrimEnd('\')
$bin    = "$sdk\bin"
$device = 'fenix8solar51mm'
$prg    = "$proj\build\AmiiboApp.prg"

Set-Location $proj

# --- Make sure Java is available (the Monkey C compiler needs it) ---
function Find-Java {
    $c = Get-Command java.exe -ErrorAction SilentlyContinue
    if ($c) { return Split-Path $c.Source }
    if ($env:JAVA_HOME -and (Test-Path "$env:JAVA_HOME\bin\java.exe")) { return "$env:JAVA_HOME\bin" }
    $roots = @("$env:ProgramFiles\Java", "$env:ProgramFiles\Eclipse Adoptium", "$env:ProgramFiles\Microsoft",
               "$env:ProgramFiles\Zulu", "$env:ProgramFiles\Amazon Corretto", "$env:ProgramFiles\BellSoft",
               "${env:ProgramFiles(x86)}\Java", "$env:LOCALAPPDATA\Programs")
    foreach ($r in $roots) {
        if (Test-Path $r) {
            $j = Get-ChildItem $r -Recurse -Filter java.exe -ErrorAction SilentlyContinue -Depth 4 |
                 Sort-Object FullName -Descending | Select-Object -First 1
            if ($j) { return $j.DirectoryName }
        }
    }
    return $null
}

$javaBin = Find-Java
if (-not $javaBin) {
    Write-Host "Java not found. Installing Microsoft OpenJDK 21 via winget..." -ForegroundColor Yellow
    winget install --id Microsoft.OpenJDK.21 -e --accept-package-agreements --accept-source-agreements
    $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')
    $javaBin = Find-Java
    if (-not $javaBin) { Write-Host "Java install failed. Install a JDK 17+ and re-run." -ForegroundColor Red; exit 1 }
}
$env:Path = "$javaBin;$env:Path"
Write-Host "Java: $javaBin" -ForegroundColor Cyan
& "$javaBin\java.exe" -version
Write-Host "SDK: $sdk" -ForegroundColor Cyan

Write-Host "Building..." -ForegroundColor Cyan
& "$bin\monkeyc.bat" -f "$proj\monkey.jungle" -d $device -o $prg -y "$proj\developer_key.der" -w
if ($LASTEXITCODE -ne 0) { Write-Host "BUILD FAILED" -ForegroundColor Red; exit 1 }
Write-Host "Build OK: $prg" -ForegroundColor Green

if (-not (Get-Process simulator -ErrorAction SilentlyContinue)) {
    Write-Host "Starting simulator..." -ForegroundColor Cyan
    Start-Process "$bin\simulator.exe"
    Start-Sleep -Seconds 6
}

Write-Host "Loading app into simulator..." -ForegroundColor Cyan
& "$bin\monkeydo.bat" $prg $device
# AzzureSkyy
