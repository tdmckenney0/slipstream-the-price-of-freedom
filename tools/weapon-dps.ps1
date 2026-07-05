#!/usr/bin/env pwsh
#Requires -Version 7.0
<#
.SYNOPSIS
    Estimate sustained weapon DPS across all .wepn files.
.DESCRIPTION
    Parses every .wepn under src/weapon/ and reports total per-hit DamageHealth
    (summing every DamageHealth result -- a weapon may carry several), the
    inter-shot interval (arg 14 of StartWeaponConfig -- the 10th numeric token),
    and naive sustained DPS = damage / interval. Flags burst weapons
    (SpawnWeaponFire spawn extra salvos -> DPS is a floor) and beam weapons
    ("InstantHit" type, whose continuous damage the arg-14 interval does not
    capture -> DPS unreliable). Final balance authority is in-engine playtest,
    not this estimate.
.PARAMETER Weapon
    Filter to weapons whose file name matches (partial, case-insensitive).
.EXAMPLE
    .\tools\weapon-dps.ps1
    .\tools\weapon-dps.ps1 -Weapon vgr_dd
#>
param([string]$Weapon)
Set-StrictMode -Version Latest

$RepoRoot = git rev-parse --show-toplevel 2>$null
if (-not $RepoRoot) { $RepoRoot = Split-Path $PSScriptRoot -Parent }
$RepoRoot = $RepoRoot.Replace('/', '\')

$WepnFiles = Get-ChildItem -Path (Join-Path $RepoRoot 'src\weapon') -Recurse -Filter '*.wepn'
if ($Weapon) { $WepnFiles = $WepnFiles | Where-Object { $_.BaseName -ilike "*$Weapon*" } }

$rows = foreach ($f in $WepnFiles) {
    $raw = Get-Content $f.FullName -Raw
    if ($raw -notmatch '(?s)StartWeaponConfig\s*\((.*?)\)') { continue }
    $tokens = $Matches[1] -split ',' | ForEach-Object { ($_ -replace '--.*$', '').Trim() }
    $nums = @($tokens | Where-Object { $_ -match '^-?[0-9.]+$' } | ForEach-Object { [double]$_ })
    $interval = if ($nums.Count -ge 10) { $nums[9] } else { $null }
    # arg 2 is the weapon type (InstantHit | Bullet | Mine | Missile | SphereBurst).
    $weaponType = if ($tokens.Count -ge 3) { $tokens[2].Trim('"') } else { '' }

    # Sum every DamageHealth result; a weapon may carry several (see weapon_definitions.md).
    $dmgMatches = [regex]::Matches($raw, 'AddWeaponResult\([^)]*?"DamageHealth"[^)]*?,\s*([0-9.]+)\s*,\s*([0-9.]+)\s*,')
    $dmg = $null
    if ($dmgMatches.Count -gt 0) {
        $dmg = 0
        foreach ($m in $dmgMatches) {
            $dmg += ([double]$m.Groups[1].Value + [double]$m.Groups[2].Value) / 2
        }
    }
    $dps = if ($dmg -and $interval -gt 0) { [math]::Round($dmg / $interval, 0) } else { $null }

    [PSCustomObject]@{
        Weapon   = $f.BaseName
        Dmg      = $dmg
        Interval = $interval
        DPS      = $dps
        Burst    = if ($raw -match 'SpawnWeaponFire') { 'B' } else { '' }
        # Beams are "InstantHit", not a "Beam" type; their continuous damage makes DPS unreliable.
        Beam     = if ($weaponType -eq 'InstantHit') { 'beam' } else { '' }
    }
}
$rows | Sort-Object Weapon | Format-Table -AutoSize
