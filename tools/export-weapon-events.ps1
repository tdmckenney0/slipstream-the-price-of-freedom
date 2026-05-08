#!/usr/bin/env pwsh
#Requires -Version 7.0
<#
.SYNOPSIS
    Export every weapon config in src/ together with its fire-animation events
    from the corresponding .events file as a CSV.

.DESCRIPTION
    Scans every .ship and .subs under src/ for StartShipWeaponConfig and
    StartSubSystemWeaponConfig calls. For each call, locates the matching
    .events file (next to the .ship/.subs first; otherwise under
    refs/homeworld2-big/), and emits one CSV row per event whose `anim` field
    matches the weapon's fire-animation reference (the 4th argument of the
    weapon config call). Matching is case-insensitive, mirroring the engine.

    Weapons with no fire animation, no events file, or no matching events
    still appear (with blank event fields) so the CSV is a complete weapon
    inventory. Any unknown event keys beyond the standard set are appended as
    columns automatically.

    The export preserves enough identity (Ship or Subs Path, Events File,
    Events Source, Event Name) that the CSV can be edited and reversed back
    into .events files by a companion tool.

.PARAMETER OutputPath
    CSV file to write. Defaults to <repo>\.tmp\weapon-events.csv.

.PARAMETER SrcRoot
    Source root to scan. Defaults to <repo>\src.

.PARAMETER VanillaRoot
    Vanilla fallback root for .events lookups. Defaults to
    <repo>\refs\homeworld2-big.

.EXAMPLE
    .\tools\export-weapon-events.ps1
    .\tools\export-weapon-events.ps1 -OutputPath C:\out\fx.csv
    .\tools\export-weapon-events.ps1 -OutputPath .tmp\hgn-only.csv -SrcRoot src\ship
#>
param(
    [string]$OutputPath,
    [string]$SrcRoot,
    [string]$VanillaRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = git rev-parse --show-toplevel 2>$null
if (-not $RepoRoot) { $RepoRoot = Split-Path $PSScriptRoot -Parent }
$RepoRoot = $RepoRoot.Replace('/', '\')

if (-not $SrcRoot)     { $SrcRoot     = Join-Path $RepoRoot 'src' }
if (-not $VanillaRoot) { $VanillaRoot = Join-Path $RepoRoot 'refs\homeworld2-big' }
if (-not $OutputPath)  { $OutputPath  = Join-Path $RepoRoot '.tmp\weapon-events.csv' }

# Resolve relative inputs against the repo root so callers can pass short paths.
if (-not [System.IO.Path]::IsPathRooted($SrcRoot))     { $SrcRoot     = Join-Path $RepoRoot $SrcRoot }
if (-not [System.IO.Path]::IsPathRooted($VanillaRoot)) { $VanillaRoot = Join-Path $RepoRoot $VanillaRoot }
if (-not [System.IO.Path]::IsPathRooted($OutputPath))  { $OutputPath  = Join-Path $RepoRoot $OutputPath }

$OutputDir = Split-Path -Parent $OutputPath
if ($OutputDir -and -not (Test-Path -LiteralPath $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Stable column order. Extras discovered in events files are appended at the end.
$IdColumns = @(
    'Ship or Subs Path',
    'Weapon Hardpoint',
    'Weapon Name',
    'Weapon Animation Name',
    'Events File',
    'Events Source',
    'Event Name'
)
$KnownEventKeys = @('animtime', 'marker', 'fx', 'fx_scale', 'sound', 'fx_sm', 'fx_nlips')

# --- Parsers ------------------------------------------------------------

# Captures: weapon script (2nd arg), hardpoint (3rd), fire-animation name (4th).
$WeaponConfigRegex = [regex]'(?m)Start(?:Ship|SubSystem)WeaponConfig\s*\(\s*\w+\s*,\s*"(?<weapon>[^"]*)"\s*,\s*"(?<hardpoint>[^"]*)"\s*,\s*"(?<animation>[^"]*)"\s*\)'

# An event block: eventN = { { "k", "v", }, { "k", "v", }, ... }. The body
# never contains nested braces beyond one level of pairs, so [^}]* is safe
# inside each pair.
$EventBlockRegex = [regex]'(?s)(?<name>event\w+)\s*=\s*\{(?<body>(?:\s*\{[^}]*\}\s*,?)+)\s*\}'
$PairRegex       = [regex]'(?s)\{\s*"(?<key>[^"]+)"\s*,\s*"(?<value>[^"]*)"\s*,?\s*\}'

function Read-EventsFile([string]$Path) {
    if (-not $Path -or -not (Test-Path -LiteralPath $Path)) { return ,@() }
    $content = Get-Content -LiteralPath $Path -Raw

    $events = [System.Collections.Generic.List[object]]::new()
    foreach ($m in $EventBlockRegex.Matches($content)) {
        $entry = [ordered]@{ EventName = $m.Groups['name'].Value }
        foreach ($pm in $PairRegex.Matches($m.Groups['body'].Value)) {
            $entry[$pm.Groups['key'].Value] = $pm.Groups['value'].Value
        }
        $events.Add([PSCustomObject]$entry)
    }
    return ,$events
}

# Cache parsed events files by full path to avoid re-parsing.
$EventsCache = @{}

function Get-EventsForFile([string]$Path) {
    if (-not $Path) { return @() }
    if (-not $EventsCache.ContainsKey($Path)) {
        $EventsCache[$Path] = Read-EventsFile $Path
    }
    return $EventsCache[$Path]
}

function Resolve-EventsFile([System.IO.FileInfo]$ConfigFile) {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($ConfigFile.Name)

    $localEvents = Join-Path $ConfigFile.DirectoryName "$baseName.events"
    if (Test-Path -LiteralPath $localEvents) {
        return @{ Path = $localEvents; Source = 'local' }
    }

    # .ship -> ship/, .subs -> subsystem/
    $vanillaSubdir = if ($ConfigFile.Extension -eq '.subs') { 'subsystem' } else { 'ship' }
    $vanillaPath = Join-Path $VanillaRoot "$vanillaSubdir\$baseName\$baseName.events"
    if (Test-Path -LiteralPath $vanillaPath) {
        return @{ Path = $vanillaPath; Source = 'vanilla' }
    }

    return @{ Path = ''; Source = 'none' }
}

function Get-RelativePath([string]$FullPath) {
    if (-not $FullPath) { return '' }
    return $FullPath.Replace($RepoRoot + '\', '')
}

# --- Scan ---------------------------------------------------------------

$ConfigFiles = @()
$ConfigFiles += Get-ChildItem -Path $SrcRoot -Recurse -Filter '*.ship' -File
$ConfigFiles += Get-ChildItem -Path $SrcRoot -Recurse -Filter '*.subs' -File

$Rows = [System.Collections.Generic.List[object]]::new()
$ExtraKeys = @{}

foreach ($file in $ConfigFiles | Sort-Object FullName) {
    $configRel = Get-RelativePath $file.FullName
    $content = Get-Content -LiteralPath $file.FullName -Raw

    $resolved = Resolve-EventsFile $file
    $eventsRel = Get-RelativePath $resolved.Path
    $eventsSource = $resolved.Source
    $events = Get-EventsForFile $resolved.Path

    foreach ($wm in $WeaponConfigRegex.Matches($content)) {
        $weapon    = $wm.Groups['weapon'].Value
        $hardpoint = $wm.Groups['hardpoint'].Value
        $animation = $wm.Groups['animation'].Value

        $eventMatches = @()
        if ($events -and $animation) {
            $eventMatches = @($events | Where-Object {
                $_.PSObject.Properties['anim'] -and
                $_.anim -ieq $animation
            })
        }

        if ($eventMatches.Count -eq 0) {
            $row = [ordered]@{
                'Ship or Subs Path'     = $configRel
                'Weapon Hardpoint'      = $hardpoint
                'Weapon Name'           = $weapon
                'Weapon Animation Name' = $animation
                'Events File'           = $eventsRel
                'Events Source'         = $eventsSource
                'Event Name'            = ''
            }
            foreach ($k in $KnownEventKeys) { $row[$k] = '' }
            $Rows.Add($row)
            continue
        }

        foreach ($evt in $eventMatches) {
            $row = [ordered]@{
                'Ship or Subs Path'     = $configRel
                'Weapon Hardpoint'      = $hardpoint
                'Weapon Name'           = $weapon
                'Weapon Animation Name' = $animation
                'Events File'           = $eventsRel
                'Events Source'         = $eventsSource
                'Event Name'            = $evt.EventName
            }
            foreach ($k in $KnownEventKeys) { $row[$k] = '' }
            foreach ($prop in $evt.PSObject.Properties) {
                $key = $prop.Name
                if ($key -eq 'EventName' -or $key -eq 'anim') { continue }
                $row[$key] = $prop.Value
                if ($KnownEventKeys -notcontains $key) { $ExtraKeys[$key] = $true }
            }
            $Rows.Add($row)
        }
    }
}

# --- Output -------------------------------------------------------------

$Columns = @()
$Columns += $IdColumns
$Columns += $KnownEventKeys
$Columns += ($ExtraKeys.Keys | Sort-Object)

$Output = foreach ($row in $Rows) {
    $obj = [ordered]@{}
    foreach ($col in $Columns) {
        $obj[$col] = if ($row.Contains($col)) { $row[$col] } else { '' }
    }
    [PSCustomObject]$obj
}

$Output | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8

Write-Host ("Wrote {0} row(s) to {1}" -f $Rows.Count, $OutputPath) -ForegroundColor Green
if ($ExtraKeys.Count -gt 0) {
    $extra = ($ExtraKeys.Keys | Sort-Object) -join ', '
    Write-Host "Discovered extra event keys: $extra" -ForegroundColor Yellow
}
