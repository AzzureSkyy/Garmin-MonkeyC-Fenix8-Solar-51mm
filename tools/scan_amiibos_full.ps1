# Project   : Garmin-MonkeyC-Fenix8-Solar-51mm
# Author    : AzzureSkyy
# Watermark : AzzureSkyy
# Source    : https://github.com/AzzureSkyy/Garmin-MonkeyC-Fenix8-Solar-51mm
# Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
param(
	[string]$Root = "E:\Downloads\roms\Nintendo Switch\Amiibos",
	[string]$JsonPath = "$env:TEMP\amiibo_scan_full.json"
)

$exclude = @('Amiibo NFC','!Essential Files')
$result = @()

Get-ChildItem $Root -Directory | Where-Object { $exclude -notcontains $_.Name } | ForEach-Object {
	$catName = $_.Name
	$files = Get-ChildItem $_.FullName -Recurse -Filter '*.bin' -ErrorAction SilentlyContinue
	if ($files.Count -gt 0) {
		$items = @()
		foreach ($f in $files) {
			$bytes = [System.IO.File]::ReadAllBytes($f.FullName)
			$name = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)

			# Standard NTAG215 amiibo dump layout:
			# UID: bytes 0-8 (9 bytes incl. BCC), commonly reported as 7-byte UID (0-2,4-7)
			# Amiibo ID (character/game/series info): bytes 84-91 (8 bytes) - stored in
			# cleartext (not key-encrypted) in the dump, used by identification tools
			# without needing the retail key.
			$uidHex = ""
			$amiiboIdHex = ""
			if ($bytes.Length -ge 92) {
				$uidBytes = $bytes[0..6]
				$uidHex = ($uidBytes | ForEach-Object { $_.ToString("X2") }) -join ""
				$idBytes = $bytes[84..91]
				$amiiboIdHex = ($idBytes | ForEach-Object { $_.ToString("X2") }) -join ""
			}

			$items += [PSCustomObject]@{
				Name = $name
				SizeBytes = $bytes.Length
				UID = $uidHex
				AmiiboId = $amiiboIdHex
			}
		}
		$result += [PSCustomObject]@{ Category = $catName; Items = $items }
	}
}

$result | ConvertTo-Json -Depth 6 | Out-File -FilePath $JsonPath -Encoding utf8
$totalItems = (($result | ForEach-Object { $_.Items.Count }) | Measure-Object -Sum).Sum
Write-Output "Categories: $($result.Count), TotalItems: $totalItems"
# AzzureSkyy
