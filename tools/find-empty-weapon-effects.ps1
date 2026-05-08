#!/usr/bin/env pwsh
#Requires -Version 7.0
<#
.SYNOPSIS
    Find weapon configs with an empty fire/effect hardpoint argument.

.DESCRIPTION
    Scans every .ship and .subs file under src/ for StartShipWeaponConfig
    and StartSubSystemWeaponConfig calls whose final argument is the empty
    string "". Reports each hit as file:line: <call>.

    Exits 1 if any hits are found, 0 otherwise — useful for scripted checks.

.PARAMETER Quiet
    Suppress the trailing summary line and the "no hits" message. Per-hit
    lines are still printed.

.EXAMPLE
    .\tools\find-empty-weapon-effects.ps1
    .\tools\find-empty-weapon-effects.ps1 -Quiet
#>
param(
    [switch]$Quiet
)

Set-StrictMode -Version Latest

$RepoRoot = git rev-parse --show-toplevel 2>$null
if (-not $RepoRoot) { $RepoRoot = Split-Path $PSScriptRoot -Parent }
$RepoRoot = $RepoRoot.Replace('/', '\')

$SrcDir = Join-Path $RepoRoot 'src'

$Files = @()
$Files += Get-ChildItem -Path $SrcDir -Recurse -Filter '*.ship' -File
$Files += Get-ChildItem -Path $SrcDir -Recurse -Filter '*.subs' -File

# Matches:
#   StartShipWeaponConfig(NewShipType, "weapon", "Hardpoint", "")
#   StartSubSystemWeaponConfig(NewSubSystemType, "weapon", "Hardpoint", "")
# The final "" may have surrounding whitespace and may be followed by ; or comment.
$Pattern = 'Start(?:Ship|SubSystem)WeaponConfig\s*\([^)]*,\s*""\s*\)'

$Hits = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($file in $Files | Sort-Object FullName) {
    $relPath = $file.FullName.Replace($RepoRoot + '\', '')
    $lineNum = 0
    foreach ($line in Get-Content -LiteralPath $file.FullName) {
        $lineNum++
        if ($line -match $Pattern) {
            $Hits.Add([PSCustomObject]@{
                File = $relPath
                Line = $lineNum
                Text = $line.Trim()
            })
        }
    }
}

if ($Hits.Count -eq 0) {
    if (-not $Quiet) { Write-Host 'No empty weapon effects found.' -ForegroundColor Green }
    exit 0
}

foreach ($hit in $Hits) {
    Write-Host ("{0}:{1}: {2}" -f $hit.File, $hit.Line, $hit.Text)
}

if (-not $Quiet) {
    Write-Host ''
    Write-Host ("Found {0} empty weapon effect(s)." -f $Hits.Count) -ForegroundColor Yellow
}

exit 1
