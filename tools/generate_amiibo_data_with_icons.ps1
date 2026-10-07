# Project   : Garmin-MonkeyC-Fenix8-Solar-51mm
# Author    : AzzureSkyy
# Watermark : AzzureSkyy
# Source    : https://github.com/AzzureSkyy/Garmin-MonkeyC-Fenix8-Solar-51mm
# Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
param(
	[string]$FullJsonPath = "$env:TEMP\amiibo_scan_full.json",
	[string]$ManifestJsonPath = "$env:TEMP\amiibo_icon_manifest.json",
	[string]$OutPath = "E:\Garmin Fenix\source\AmiiboData.mc"
)

function Escape-MonkeyString {
	param([string]$s)
	$s = $s -replace '\\','\\\\'
	$s = $s -replace '"','\"'
	return $s
}

$data = Get-Content $FullJsonPath -Raw | ConvertFrom-Json
$manifest = Get-Content $ManifestJsonPath -Raw | ConvertFrom-Json

# Build lookup: "Category||ItemName" -> Rez.Drawables resource id string
$iconLookup = @{}
foreach ($m in $manifest) {
	$key = "$($m.Category)||$($m.ItemName)"
	$iconLookup[$key] = $m.ResourceId
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("import Toybox.Lang;")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("//! Bundled Amiibo category + item dataset, generated at build time from")
[void]$sb.AppendLine("//! local .bin dump filenames, their unencrypted header bytes (UID and")
[void]$sb.AppendLine("//! Amiibo character/game ID), and matched icon images. No key-encrypted")
[void]$sb.AppendLine("//! data or key material is included anywhere in this file.")
[void]$sb.AppendLine("module AmiiboData {")
[void]$sb.AppendLine("")

$categoryVars = @()
foreach ($cat in $data) {
	$varName = "ITEMS_" + (($cat.Category -replace '[^a-zA-Z0-9]','_'))
	$categoryVars += $varName
	[void]$sb.AppendLine("`tconst $varName as Array<Dictionary> = [")
	$items = @($cat.Items)
	for ($i = 0; $i -lt $items.Count; $i++) {
		$it = $items[$i]
		$name = Escape-MonkeyString $it.Name
		$uid = Escape-MonkeyString $it.UID
		$aid = Escape-MonkeyString $it.AmiiboId
		$key = "$($cat.Category)||$($it.Name)"
		$iconExpr = "null"
		if ($iconLookup.ContainsKey($key)) {
			$iconExpr = "Rez.Drawables.$($iconLookup[$key])"
		}
		$comma = if ($i -lt $items.Count - 1) { "," } else { "" }
		[void]$sb.AppendLine("`t`t{ :name => `"$name`", :uid => `"$uid`", :amiiboId => `"$aid`", :size => $($it.SizeBytes), :icon => $iconExpr }$comma")
	}
	[void]$sb.AppendLine("`t];")
	[void]$sb.AppendLine("")
}

[void]$sb.AppendLine("`tconst CATEGORY_NAMES as Array<String> = [")
for ($i = 0; $i -lt $data.Count; $i++) {
	$escaped = Escape-MonkeyString $data[$i].Category
	$comma = if ($i -lt $data.Count - 1) { "," } else { "" }
	[void]$sb.AppendLine("`t`t`"$escaped`"$comma")
}
[void]$sb.AppendLine("`t];")
[void]$sb.AppendLine("")

[void]$sb.AppendLine("`tconst CATEGORY_ITEMS as Array<Array<Dictionary> > = [")
for ($i = 0; $i -lt $categoryVars.Count; $i++) {
	$comma = if ($i -lt $categoryVars.Count - 1) { "," } else { "" }
	[void]$sb.AppendLine("`t`t$($categoryVars[$i])$comma")
}
[void]$sb.AppendLine("`t];")
[void]$sb.AppendLine("")

[void]$sb.AppendLine("`t//! Returns the list of item dictionaries ({:name, :uid, :amiiboId, :size, :icon})")
[void]$sb.AppendLine("`t//! for a given category index. :icon is null when no matching icon exists.")
[void]$sb.AppendLine("`tfunction getItems(categoryIndex as Number) as Array<Dictionary> {")
[void]$sb.AppendLine("`t`treturn CATEGORY_ITEMS[categoryIndex];")
[void]$sb.AppendLine("`t}")
[void]$sb.AppendLine("}")

[System.IO.File]::WriteAllText($OutPath, $sb.ToString(), (New-Object System.Text.UTF8Encoding $false))
$totalItems = (($data | ForEach-Object { $_.Items.Count }) | Measure-Object -Sum).Sum
Write-Output "Generated $OutPath with $($data.Count) categories, $totalItems items, $($manifest.Count) icon mappings"
# AzzureSkyy
