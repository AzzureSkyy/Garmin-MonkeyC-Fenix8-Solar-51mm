# Project   : Garmin-MonkeyC-Fenix8-Solar-51mm
# Author    : AzzureSkyy
# Watermark : AzzureSkyy
# Source    : https://github.com/AzzureSkyy/Garmin-MonkeyC-Fenix8-Solar-51mm
# Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
$root = "E:\Downloads\roms\Nintendo Switch\Amiibos"
$exclude = @('Amiibo NFC','!Essential Files')
$result = @()
Get-ChildItem $root -Directory | Where-Object { $exclude -notcontains $_.Name } | ForEach-Object {
	$files = Get-ChildItem $_.FullName -Recurse -Filter '*.bin' -ErrorAction SilentlyContinue
	if ($files.Count -gt 0) {
		$names = $files | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.Name) }
		$result += [PSCustomObject]@{ Category = $_.Name; Items = $names }
	}
}
$result | ConvertTo-Json -Depth 5 | Out-File "$env:TEMP\amiibo_scan.json" -Encoding utf8
$totalItems = (($result | ForEach-Object { $_.Items.Count }) | Measure-Object -Sum).Sum
Write-Output "Categories: $($result.Count), TotalItems: $totalItems"
# AzzureSkyy
