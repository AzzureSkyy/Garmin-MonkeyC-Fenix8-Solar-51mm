# Project   : Garmin-MonkeyC-Fenix8-Solar-51mm
# Author    : AzzureSkyy
# Watermark : AzzureSkyy
# Source    : https://github.com/AzzureSkyy/Garmin-MonkeyC-Fenix8-Solar-51mm
# Copyright : (c) 2026 AzzureSkyy. All rights reserved. See LICENSE.
param(
	[string]$JsonPath = "$env:TEMP\amiibo_scan.json",
	[string]$OutPath = "E:\Garmin Fenix\source\AmiiboData.mc"
)

function Escape-MonkeyString {
	param([string]$s)
	$s = $s -replace '\\','\\\\'
	$s = $s -replace '"','\"'
	return $s
}

$data = Get-Content $JsonPath -Raw | ConvertFrom-Json

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("import Toybox.Lang;")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("//! Bundled Amiibo category + name dataset, generated at build time from")
[void]$sb.AppendLine("//! local .bin dump filenames. No key/encrypted data included - names only.")
[void]$sb.AppendLine("module AmiiboData {")
[void]$sb.AppendLine("")

$categoryNamesVar = @()
foreach ($cat in $data) {
	$varName = "ITEMS_" + (($cat.Category -replace '[^a-zA-Z0-9]','_'))
	$categoryNamesVar += $varName
	[void]$sb.AppendLine("`tconst $varName as Array<String> = [")
	$items = @($cat.Items)
	for ($i = 0; $i -lt $items.Count; $i++) {
		$escaped = Escape-MonkeyString $items[$i]
		$comma = if ($i -lt $items.Count - 1) { "," } else { "" }
		[void]$sb.AppendLine("`t`t`"$escaped`"$comma")
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

[void]$sb.AppendLine("`tconst CATEGORY_ITEMS as Array<Array<String>> = [")
for ($i = 0; $i -lt $categoryNamesVar.Count; $i++) {
	$comma = if ($i -lt $categoryNamesVar.Count - 1) { "," } else { "" }
	[void]$sb.AppendLine("`t`t$($categoryNamesVar[$i])$comma")
}
[void]$sb.AppendLine("`t];")
[void]$sb.AppendLine("")

[void]$sb.AppendLine("`t//! Returns the list of item names for a given category index.")
[void]$sb.AppendLine("`tfunction getItems(categoryIndex as Number) as Array<String> {")
[void]$sb.AppendLine("`t`treturn CATEGORY_ITEMS[categoryIndex];")
[void]$sb.AppendLine("`t}")
[void]$sb.AppendLine("}")

[System.IO.File]::WriteAllText($OutPath, $sb.ToString(), (New-Object System.Text.UTF8Encoding $false))
Write-Output "Generated $OutPath with $($data.Count) categories"
# AzzureSkyy
