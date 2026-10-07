# Project   : Garmin-MonkeyC-Fenix8-Solar-51mm
# Author    : AzzureSkyy
# Watermark : AzzureSkyy
# Source    : https://github.com/AzzureSkyy/Garmin-MonkeyC-Fenix8-Solar-51mm
# Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
param(
	[string]$Root = "E:\Downloads\roms\Nintendo Switch\Amiibos",
	[string]$OutJson = "$env:TEMP\amiibo_image_matches.json"
)

$exclude = @('Amiibo NFC','!Essential Files')

function Normalize-Name {
	param([string]$s)
	$s = $s.ToLowerInvariant()
	$s = $s -replace '[^a-z0-9]', ''
	return $s
}

$results = @()

Get-ChildItem $Root -Directory | Where-Object { $exclude -notcontains $_.Name } | ForEach-Object {
	$catDir = $_.FullName
	$catName = $_.Name
	$imgDir = Join-Path $catDir 'Images'
	$imageMap = @{}
	if (Test-Path $imgDir) {
		Get-ChildItem $imgDir -File -Include '*.png','*.jpg','*.jpeg' -Recurse | ForEach-Object {
			$key = Normalize-Name ([System.IO.Path]::GetFileNameWithoutExtension($_.Name))
			if (-not $imageMap.ContainsKey($key)) {
				$imageMap[$key] = $_.FullName
			}
		}
	}

	$binFiles = Get-ChildItem $catDir -Recurse -Filter '*.bin' -ErrorAction SilentlyContinue
	foreach ($bin in $binFiles) {
		$itemName = [System.IO.Path]::GetFileNameWithoutExtension($bin.Name)
		$normItem = Normalize-Name $itemName
		$matchPath = $null

		if ($imageMap.ContainsKey($normItem)) {
			$matchPath = $imageMap[$normItem]
		} else {
			# try contains-match both directions
			foreach ($key in $imageMap.Keys) {
				if ($key.Length -ge 3 -and ($normItem.Contains($key) -or $key.Contains($normItem))) {
					$matchPath = $imageMap[$key]
					break
				}
			}
		}

		$results += [PSCustomObject]@{
			Category = $catName
			ItemName = $itemName
			ImagePath = $matchPath
		}
	}
}

$results | ConvertTo-Json -Depth 5 | Out-File -FilePath $OutJson -Encoding utf8
$matched = ($results | Where-Object { $_.ImagePath -ne $null }).Count
Write-Output "Total items: $($results.Count), Matched: $matched"
# AzzureSkyy
