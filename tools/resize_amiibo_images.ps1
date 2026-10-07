# Project   : Garmin-MonkeyC-Fenix8-Solar-51mm
# Author    : AzzureSkyy
# Watermark : AzzureSkyy
# Source    : https://github.com/AzzureSkyy/Garmin-MonkeyC-Fenix8-Solar-51mm
# Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
param(
	[string]$MatchesJson = "$env:TEMP\amiibo_image_matches.json",
	[string]$OutDir = "E:\Garmin Fenix\resources\drawables\amiibo_icons",
	[int]$IconSize = 32
)

Add-Type -AssemblyName System.Drawing

if (-not (Test-Path $OutDir)) {
	New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
}

$data = Get-Content $MatchesJson -Raw | ConvertFrom-Json
$matched = $data | Where-Object { $_.ImagePath -ne $null }

$index = 0
$manifest = @()
foreach ($entry in $matched) {
	$outName = "icon_{0:D4}.png" -f ($index + 1)
	$outPath = Join-Path $OutDir $outName

	try {
		$src = [System.Drawing.Image]::FromFile($entry.ImagePath)
		$bmp = New-Object System.Drawing.Bitmap($IconSize, $IconSize)
		$g = [System.Drawing.Graphics]::FromImage($bmp)
		$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
		$g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
		$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
		$g.DrawImage($src, 0, 0, $IconSize, $IconSize)
		$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
		$g.Dispose()
		$bmp.Dispose()
		$src.Dispose()

		$index += 1
		$manifest += [PSCustomObject]@{
			Category = $entry.Category
			ItemName = $entry.ItemName
			IconFile = $outName
			ResourceId = "AmiiboIcon$index"
		}
	} catch {
		Write-Output "FAILED: $($entry.ImagePath) - $($_.Exception.Message)"
	}
}

$manifest | ConvertTo-Json -Depth 5 | Out-File -FilePath "$env:TEMP\amiibo_icon_manifest.json" -Encoding utf8
Write-Output "Resized $($manifest.Count) icons to $OutDir"
# AzzureSkyy
