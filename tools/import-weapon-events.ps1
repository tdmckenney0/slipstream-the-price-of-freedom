#!/usr/bin/env pwsh
#Requires -Version 7.0
<#
.SYNOPSIS
    Import a weapon-events CSV back into per-ship/subs .events files under src/.

.DESCRIPTION
    Reverses the export from export-weapon-events.ps1. Reads the CSV produced
    by that tool (or an edited copy) and writes weapon-fire events back into
    .events files under src/.

    For each Ship or Subs Path in the CSV that has at least one row with a
    non-empty Weapon Animation Name, this script:
      - Resolves the target events file at src/<...>/<name>.events alongside
        the .ship/.subs file.
      - Uses the existing src events file as the base when present; otherwise
        copies the vanilla refs/homeworld2-big/<ship|subsystem>/<name>/<name>.events
        file to src/ and uses it as the base. If neither exists, starts from
        an empty effects skeleton.
      - Strips events from the base whose `anim` matches any weapon animation
        name referenced in the CSV — those will be replaced.
      - Re-emits weapon-fire events from CSV rows with a non-empty Event Name.
        `anim` is set from Weapon Animation Name; remaining columns become
        `{ "key", "value" }` pairs (empty values are skipped). Custom event
        keys discovered in CSV columns are preserved.
      - Preserves all other (non-weapon) events such as Death and damage, plus
        the animations block. Adds a default animation entry for any weapon
        animation referenced in the CSV but missing from the base, so the
        engine has something to bind events to.
      - Writes the file in the compact mod-style format. Vanilla LuaDC
        formatting is normalized away — only the semantics matter to the
        engine.

    .ship and .subs files are NOT modified. The identity columns in the CSV
    (Ship or Subs Path, Weapon Hardpoint, Weapon Name) are read-only keys —
    they identify which events file and which weapon animation each row
    belongs to.

.PARAMETER InputPath
    CSV file to read. Defaults to <repo>\.tmp\weapon-events.csv.

.PARAMETER SrcRoot
    Source root. Defaults to <repo>\src.

.PARAMETER VanillaRoot
    Vanilla fallback root for .events lookups. Defaults to
    <repo>\refs\homeworld2-big.

.PARAMETER DryRun
    Print what would be written without modifying any files.

.EXAMPLE
    .\tools\import-weapon-events.ps1
    .\tools\import-weapon-events.ps1 -InputPath C:\edits\fx.csv
    .\tools\import-weapon-events.ps1 -DryRun
#>
param(
    [string]$InputPath,
    [string]$SrcRoot,
    [string]$VanillaRoot,
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = git rev-parse --show-toplevel 2>$null
if (-not $RepoRoot) { $RepoRoot = Split-Path $PSScriptRoot -Parent }
$RepoRoot = $RepoRoot.Replace('/', '\')

if (-not $SrcRoot)     { $SrcRoot     = Join-Path $RepoRoot 'src' }
if (-not $VanillaRoot) { $VanillaRoot = Join-Path $RepoRoot 'refs\homeworld2-big' }
if (-not $InputPath)   { $InputPath   = Join-Path $RepoRoot '.tmp\weapon-events.csv' }

if (-not [System.IO.Path]::IsPathRooted($SrcRoot))     { $SrcRoot     = Join-Path $RepoRoot $SrcRoot }
if (-not [System.IO.Path]::IsPathRooted($VanillaRoot)) { $VanillaRoot = Join-Path $RepoRoot $VanillaRoot }
if (-not [System.IO.Path]::IsPathRooted($InputPath))   { $InputPath   = Join-Path $RepoRoot $InputPath }

if (-not (Test-Path -LiteralPath $InputPath)) {
    throw "Input CSV not found: $InputPath"
}

# Identity columns are read-only keys; everything else is an event-key column.
$IdColumns = @(
    'Ship or Subs Path',
    'Weapon Hardpoint',
    'Weapon Name',
    'Weapon Animation Name',
    'Events File',
    'Events Source',
    'Event Name'
)

# Standard event keys are emitted in this order before any custom keys.
$KnownEventKeyOrder = @('animtime', 'marker', 'fx', 'fx_scale', 'sound', 'fx_sm', 'fx_nlips')

# --- Parsers ---------------------------------------------------------------

# An animation block contains key=value pairs and one nested `markers = { ... }`
# table. The body matches non-brace/quote chars, quoted strings, and a single
# level of nested braces.
$AnimBlockRegex = [regex]'(?ms)(?<key>animation\w+)\s*=\s*\{(?<body>(?:[^{}"]|"[^"]*"|\{[^{}]*\})*?)\}'

# Event block: eventN = { { "k", "v", }, ... }
$EventBlockRegex = [regex]'(?s)(?<key>event\w+)\s*=\s*\{(?<body>(?:\s*\{[^}]*\}\s*,?)+)\s*\}'
$PairRegex       = [regex]'(?s)\{\s*"(?<key>[^"]+)"\s*,\s*"(?<value>[^"]*)"\s*,?\s*\}'

function Get-AnimField([string]$Body, [string]$Field) {
    $escaped = [regex]::Escape($Field)
    $m = [regex]::Match($Body, '(?ms)\b' + $escaped + '\s*=\s*"(?<v>[^"]*)"')
    if ($m.Success) { return $m.Groups['v'].Value }
    $m = [regex]::Match($Body, '(?ms)\b' + $escaped + '\s*=\s*(?<v>[-\d.]+)')
    if ($m.Success) { return $m.Groups['v'].Value }
    return ''
}

function Get-MarkersField([string]$Body) {
    $m = [regex]::Match($Body, '(?ms)\bmarkers\s*=\s*\{(?<list>[^}]*)\}')
    if (-not $m.Success) { return ,@('') }
    $items = @()
    foreach ($sm in [regex]::Matches($m.Groups['list'].Value, '"([^"]*)"')) {
        $items += $sm.Groups[1].Value
    }
    if ($items.Count -eq 0) { return ,@('') }
    return ,$items
}

function Read-EventsFileFull([string]$Path) {
    $animations = [System.Collections.Generic.List[object]]::new()
    $events     = [System.Collections.Generic.List[object]]::new()

    if (-not (Test-Path -LiteralPath $Path)) {
        return @{ Animations = $animations; Events = $events }
    }

    $content = Get-Content -LiteralPath $Path -Raw

    foreach ($am in $AnimBlockRegex.Matches($content)) {
        $body = $am.Groups['body'].Value
        $animations.Add([PSCustomObject]@{
            Name    = (Get-AnimField $body 'name')
            Length  = (Get-AnimField $body 'length')
            Loop    = (Get-AnimField $body 'loop')
            Parent  = (Get-AnimField $body 'parent')
            Minimum = (Get-AnimField $body 'minimum')
            Maximum = (Get-AnimField $body 'maximum')
            Markers = (Get-MarkersField $body)
        })
    }

    foreach ($em in $EventBlockRegex.Matches($content)) {
        $pairs = [System.Collections.Generic.List[object]]::new()
        foreach ($pm in $PairRegex.Matches($em.Groups['body'].Value)) {
            $pairs.Add([PSCustomObject]@{
                Key   = $pm.Groups['key'].Value
                Value = $pm.Groups['value'].Value
            })
        }
        $events.Add([PSCustomObject]@{
            Key   = $em.Groups['key'].Value
            Pairs = $pairs
        })
    }

    return @{ Animations = $animations; Events = $events }
}

# --- Output formatter ------------------------------------------------------

function Format-EventsFile($Animations, $Events) {
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine('effects = {')
    [void]$sb.AppendLine('  animations = {')
    for ($i = 0; $i -lt $Animations.Count; $i++) {
        $a = $Animations[$i]
        $idx = $i + 1
        $length  = if ($a.Length)  { $a.Length }  else { '0' }
        $loop    = if ($a.Loop)    { $a.Loop }    else { '0' }
        $minimum = if ($a.Minimum) { $a.Minimum } else { '0' }
        $maximum = if ($a.Maximum) { $a.Maximum } else { '0' }
        $markersStr = ($a.Markers | ForEach-Object { '"' + $_ + '"' }) -join ', '
        if (-not $markersStr) { $markersStr = '""' }

        [void]$sb.AppendLine("    animation$idx = {")
        [void]$sb.AppendLine("      name = ""$($a.Name)"",")
        [void]$sb.AppendLine("      length = $length,")
        [void]$sb.AppendLine("      loop = $loop,")
        [void]$sb.AppendLine("      parent = ""$($a.Parent)"",")
        [void]$sb.AppendLine("      minimum = $minimum,")
        [void]$sb.AppendLine("      maximum = $maximum,")
        [void]$sb.AppendLine("      markers = { $markersStr },")
        [void]$sb.AppendLine('    },')
    }
    [void]$sb.AppendLine('  },')
    [void]$sb.AppendLine('  events = {')
    foreach ($e in $Events) {
        [void]$sb.AppendLine("    $($e.Key) = {")
        foreach ($p in $e.Pairs) {
            [void]$sb.AppendLine("      { ""$($p.Key)"", ""$($p.Value)"" },")
        }
        [void]$sb.AppendLine('    },')
    }
    [void]$sb.AppendLine('  },')
    [void]$sb.AppendLine('}')
    return $sb.ToString()
}

# --- Main ------------------------------------------------------------------

$rows = @(Import-Csv -Path $InputPath)
if ($rows.Count -eq 0) {
    Write-Host 'CSV is empty.' -ForegroundColor Yellow
    exit 0
}

# Discover event-key columns from CSV headers (anything not in the ID set).
$csvHeaders = $rows[0].PSObject.Properties.Name
$eventKeyColumns = @($csvHeaders | Where-Object { $_ -notin $IdColumns })

# Stable emission order: standard keys first, then any extras (in CSV order).
$orderedEventKeys = @()
foreach ($k in $KnownEventKeyOrder) {
    if ($eventKeyColumns -contains $k) { $orderedEventKeys += $k }
}
foreach ($k in $eventKeyColumns) {
    if ($orderedEventKeys -notcontains $k) { $orderedEventKeys += $k }
}

$groupedByShip = $rows | Group-Object -Property 'Ship or Subs Path'

$filesProcessed = 0
$filesCopied    = 0
$filesCreated   = 0
$filesSkipped   = 0

foreach ($grp in $groupedByShip) {
    $shipPath = $grp.Name
    $groupRows = @($grp.Group)

    if (-not $shipPath) {
        Write-Warning "Skipping rows with empty 'Ship or Subs Path'."
        continue
    }

    # Process only ships/subs that have at least one row with a fire animation.
    $animatedRows = @($groupRows | Where-Object { $_.'Weapon Animation Name' })
    if ($animatedRows.Count -eq 0) {
        $filesSkipped++
        continue
    }

    # Target events file lives next to the .ship/.subs file in src/.
    $shipFullPath = Join-Path $RepoRoot $shipPath
    $shipDir   = Split-Path -Parent $shipFullPath
    $shipBase  = [System.IO.Path]::GetFileNameWithoutExtension($shipFullPath)
    $shipExt   = [System.IO.Path]::GetExtension($shipFullPath)
    $targetPath = Join-Path $shipDir "$shipBase.events"
    $targetRel  = $targetPath.Replace($RepoRoot + '\', '')

    # Determine the base file: existing src > vanilla copy > empty.
    $baseAction = $null
    if (Test-Path -LiteralPath $targetPath) {
        $base = Read-EventsFileFull $targetPath
        $baseAction = 'updated'
    } else {
        $vanillaSubdir = if ($shipExt -ieq '.subs') { 'subsystem' } else { 'ship' }
        $vanillaPath = Join-Path $VanillaRoot "$vanillaSubdir\$shipBase\$shipBase.events"
        if (Test-Path -LiteralPath $vanillaPath) {
            if (-not $DryRun) {
                $targetParent = Split-Path -Parent $targetPath
                if (-not (Test-Path -LiteralPath $targetParent)) {
                    New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
                }
                Copy-Item -LiteralPath $vanillaPath -Destination $targetPath -Force
            }
            $base = Read-EventsFileFull $vanillaPath
            $baseAction = 'copied-from-vanilla'
            $filesCopied++
        } else {
            $base = @{
                Animations = [System.Collections.Generic.List[object]]::new()
                Events     = [System.Collections.Generic.List[object]]::new()
            }
            $baseAction = 'created'
            $filesCreated++
        }
    }

    # Distinct weapon animation names referenced in the CSV for this ship/subs.
    $weaponAnimSet = [ordered]@{}
    foreach ($r in $animatedRows) {
        $weaponAnimSet[$r.'Weapon Animation Name'] = $true
    }

    # Preserve events whose `anim` is NOT a referenced weapon animation.
    $preservedEvents = [System.Collections.Generic.List[object]]::new()
    foreach ($e in $base.Events) {
        $animPair = $e.Pairs | Where-Object { $_.Key -eq 'anim' } | Select-Object -First 1
        $isWeapon = $false
        if ($animPair) {
            foreach ($wname in $weaponAnimSet.Keys) {
                if ($wname -ieq $animPair.Value) { $isWeapon = $true; break }
            }
        }
        if (-not $isWeapon) { $preservedEvents.Add($e) }
    }

    # Build new events from CSV rows that have both an Event Name and an animation.
    # An event shared by N weapons appears N times in the CSV (one row per weapon);
    # collapse those to a single event entry. Only warn if the duplicates carry
    # actually-different event field values.
    $newEvents = [System.Collections.Generic.List[object]]::new()
    $eventByName = [ordered]@{}
    foreach ($r in $groupRows) {
        $eventName = $r.'Event Name'
        $animName  = $r.'Weapon Animation Name'
        if (-not $eventName -or -not $animName) { continue }

        $rowFields = [ordered]@{ anim = $animName }
        foreach ($k in $orderedEventKeys) {
            $v = $r.$k
            if ($null -ne $v -and $v -ne '') { $rowFields[$k] = $v }
        }

        if ($eventByName.Contains($eventName)) {
            $existing = $eventByName[$eventName]
            $allKeys = ($existing.Keys + $rowFields.Keys) | Sort-Object -Unique
            foreach ($k in $allKeys) {
                $a = if ($existing.Contains($k))  { $existing[$k] }  else { '' }
                $b = if ($rowFields.Contains($k)) { $rowFields[$k] } else { '' }
                if ($a -ne $b) {
                    Write-Warning "Conflicting value for $eventName.$k in ${shipPath}: '$a' vs '$b' — keeping first."
                }
            }
            continue
        }
        $eventByName[$eventName] = $rowFields
    }
    foreach ($eventName in $eventByName.Keys) {
        $fields = $eventByName[$eventName]
        $pairs = [System.Collections.Generic.List[object]]::new()
        # Always emit anim first; remaining keys follow in $orderedEventKeys order.
        $pairs.Add([PSCustomObject]@{ Key = 'anim'; Value = $fields['anim'] })
        foreach ($k in $orderedEventKeys) {
            if ($fields.Contains($k)) {
                $pairs.Add([PSCustomObject]@{ Key = $k; Value = $fields[$k] })
            }
        }
        $newEvents.Add([PSCustomObject]@{ Key = $eventName; Pairs = $pairs })
    }

    # Combined: preserved (in original order) + new (in CSV order).
    $combinedEvents = [System.Collections.Generic.List[object]]::new()
    foreach ($e in $preservedEvents) { $combinedEvents.Add($e) }
    foreach ($e in $newEvents)       { $combinedEvents.Add($e) }

    # Animations: keep all existing, add a default entry for any weapon animation
    # missing from the base so the engine has something to bind to.
    $finalAnimations = [System.Collections.Generic.List[object]]::new()
    foreach ($a in $base.Animations) { $finalAnimations.Add($a) }
    foreach ($wname in $weaponAnimSet.Keys) {
        $exists = $false
        foreach ($a in $finalAnimations) {
            if ($a.Name -ieq $wname) { $exists = $true; break }
        }
        if (-not $exists) {
            $finalAnimations.Add([PSCustomObject]@{
                Name    = $wname
                Length  = '1'
                Loop    = '0'
                Parent  = ''
                Minimum = '0'
                Maximum = '0'
                Markers = @('')
            })
        }
    }

    $output = Format-EventsFile $finalAnimations $combinedEvents

    if ($DryRun) {
        Write-Host "[DRY-RUN] $baseAction $targetRel" -ForegroundColor Cyan
    } else {
        $targetParent = Split-Path -Parent $targetPath
        if (-not (Test-Path -LiteralPath $targetParent)) {
            New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
        }
        Set-Content -LiteralPath $targetPath -Value $output -Encoding UTF8 -NoNewline
        Write-Host "$baseAction $targetRel"
    }

    $filesProcessed++
}

Write-Host ''
Write-Host ("Files processed: {0}" -f $filesProcessed) -ForegroundColor Green
if ($filesCopied  -gt 0) { Write-Host ("  Copied from vanilla: {0}" -f $filesCopied)   -ForegroundColor Cyan }
if ($filesCreated -gt 0) { Write-Host ("  Created from scratch: {0}" -f $filesCreated) -ForegroundColor Cyan }
if ($filesSkipped -gt 0) { Write-Host ("  Skipped (no animated weapons): {0}" -f $filesSkipped) -ForegroundColor DarkGray }
