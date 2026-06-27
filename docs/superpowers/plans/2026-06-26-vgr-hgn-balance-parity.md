# VGR→HGN Balance Parity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Raise Vaygr (VGR) to competitive parity with Hiigaran (HGN) by buffing VGR durability, mobility, economy, and destroyer/interceptor firepower, leaving HGN, VGR corvettes, and VGR heavy capitals unchanged.

**Architecture:** Pure data/value edits to VGR `.ship` and `.wepn` files (HW2 Classic DSL). Each change is verified headlessly by PowerShell parsers — the existing `tools/ship-stats.ps1` and a new `tools/weapon-dps.ps1` — then confirmed in-engine by playtest. No engine or Lua-logic changes.

**Tech Stack:** HW2 Classic DSL (`.ship`, `.wepn`), PowerShell 7+ tooling, git.

**Spec:** `docs/superpowers/specs/2026-06-26-vgr-hgn-balance-parity-design.md`

## Global Constraints

- Shell is **PowerShell 7+ (`pwsh`)**; Windows-style paths.
- Commits use **plain imperative messages** matching repo style (e.g. "Buff Vaygr destroyer hull and economy"). **NO `Co-Authored-By:` trailer** (repo convention — see `memory/feedback_no_cosign.md`).
- Edit **VGR files only.** Do NOT modify any HGN ship/weapon, VGR corvettes, or VGR heavy-capital HP (`vgr_qwaarjetii`, `vgr_vanaarjet`). These are already-fair asymmetric trades per the spec.
- Preserve each weapon's firing character: do **not** change `fireType`, `bulletType`, or the FX name in `StartWeaponConfig`. Tune only `DamageHealth` values and the inter-shot interval (10th numeric arg).
- The DPS numbers are **naive estimates** (avg damage ÷ interval); burst/beam/multi-pellet weapons differ in-engine. Treat parser targets as starting points; final tuning is playtest.
- `.big` is gitignored; never commit build artifacts.
- Base commit for final diff = **`8146c6b`** (the spec commit, before any balance edit).

## File map

| File | Task | Responsibility |
|---|---|---|
| `tools/weapon-dps.ps1` (new) | 1 | Headless weapon DPS estimator (verification instrument) |
| `src/ship/vgr_destroyer/vgr_destroyer.ship` | 2 | Destroyer hull, mobility, economy, unit cap |
| `src/weapon/vgr_dd_missileboxturret/vgr_dd_missileboxturret.wepn` | 3 | Primary universal destroyer turret DPS |
| `src/weapon/vgr_dd_scattershotturret/vgr_dd_scattershotturret.wepn` | 3 | Secondary destroyer turret fire rate |
| `src/ship/vgr_battlecruiser/vgr_battlecruiser.ship` | 4 | Battlecruiser HP + cost |
| `src/ship/vgr_assaultfrigate/vgr_assaultfrigate.ship` | 5 | Assault frigate HP, rotation, cost |
| `src/ship/vgr_heavymissilefrigate/vgr_heavymissilefrigate.ship` | 5 | Heavy missile frigate HP, rotation, cost |
| `src/ship/vgr_interceptor/vgr_interceptor.ship` | 6 | Interceptor HP + rotation |
| `src/weapon/vgr_pulsecannon/vgr_pulsecannon.wepn` | 6 | Interceptor weapon damage |

**Explicitly NOT changed:** all `hgn_*` files; `vgr_lasercorvette`, `vgr_missilecorvette` (already out-gun HGN corvettes); `vgr_qwaarjetii`, `vgr_vanaarjet` HP/weapons (alpha already offsets HP); `vgr_bomber`, `vgr_lancefighter` (VGR strikecraft identity); `vgr_dd_rapidlaserturret`, `vgr_dd_pulsecannonturret` (situational, deferred to playtest); scenario/`sri_*`/`meg_*` ships (consistency check only, Task 7).

---

### Task 1: Add the weapon DPS estimator tool

**Files:**
- Create: `tools/weapon-dps.ps1`

**Interfaces:**
- Consumes: nothing (pure file parser; reads `src/weapon/**/*.wepn`).
- Produces: `tools/weapon-dps.ps1`, runnable as `pwsh -NoProfile -File tools/weapon-dps.ps1 [-Weapon <substr>]`, printing a table with columns `Weapon, Dmg, Interval, DPS, Burst, Beam`. Tasks 3 and 6 use it to verify weapon edits.

- [ ] **Step 1: Create the tool with this exact content**

```powershell
#!/usr/bin/env pwsh
#Requires -Version 7.0
<#
.SYNOPSIS
    Estimate sustained weapon DPS across all .wepn files.
.DESCRIPTION
    Parses every .wepn under src/weapon/ and reports per-hit DamageHealth, the
    inter-shot interval (the 10th numeric argument of StartWeaponConfig, decoded
    empirically), and naive sustained DPS = avgDamage / interval. Flags burst
    weapons (SpawnWeaponFire spawn extra salvos -> DPS is a floor) and beam
    weapons (continuous damage -> DPS under-counted). Final balance authority is
    in-engine playtest, not this estimate.
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

    $dmg = $null
    if ($raw -match 'AddWeaponResult\([^)]*"DamageHealth"[^)]*?,\s*([0-9.]+)\s*,\s*([0-9.]+)\s*,') {
        $dmg = ([double]$Matches[1] + [double]$Matches[2]) / 2
    }
    $dps = if ($dmg -and $interval -gt 0) { [math]::Round($dmg / $interval, 0) } else { $null }

    [PSCustomObject]@{
        Weapon   = $f.BaseName
        Dmg      = $dmg
        Interval = $interval
        DPS      = $dps
        Burst    = if ($raw -match 'SpawnWeaponFire') { 'B' } else { '' }
        Beam     = if ($raw -match '"Beam"') { 'beam' } else { '' }
    }
}
$rows | Sort-Object Weapon | Format-Table -AutoSize
```

- [ ] **Step 2: Run it to verify it works and shows current baselines**

Run: `pwsh -NoProfile -File tools/weapon-dps.ps1 -Weapon vgr_dd`
Expected: a table including `vgr_dd_missileboxturret  225  0.4  562` and `vgr_dd_scattershotturret  225  1  225`.

- [ ] **Step 3: Commit**

```bash
git add tools/weapon-dps.ps1
git commit -m "Add weapon DPS estimator tool"
```

---

### Task 2: Buff Vaygr destroyer hull, mobility, and economy

**Files:**
- Modify: `src/ship/vgr_destroyer/vgr_destroyer.ship`

**Interfaces:**
- Consumes: existing `tools/ship-stats.ps1`.
- Produces: none (data-only). Independent of all other tasks.

Targets (HGN destroyer reference in parentheses): `maxhealth` 70000→75000 (75000), `rotationMaxSpeed` 11→19 (19), `buildTime` 165→60 (60, approved), `buildCost` 3000→4500 (5000; normalization), `unitCapsNumber` 4→3 (3).

- [ ] **Step 1: Confirm the current ("before") values**

Run: `pwsh -NoProfile -File tools/ship-stats.ps1 -Ship vgr_destroyer -Fields maxhealth,rotationMaxSpeed,buildCost,buildTime`
Expected: `maxhealth 70000`, `rotationMaxSpeed 11`, `buildCost 3000`, `buildTime 165`.

- [ ] **Step 2: Edit `maxhealth`**

Replace `NewShipType.maxhealth = 70000` with `NewShipType.maxhealth = 75000`

- [ ] **Step 3: Edit `unitCapsNumber`**

Replace `NewShipType.unitCapsNumber = 4` with `NewShipType.unitCapsNumber = 3`

- [ ] **Step 4: Edit `rotationMaxSpeed`**

Replace `NewShipType.rotationMaxSpeed = 11` with `NewShipType.rotationMaxSpeed = 19`

- [ ] **Step 5: Edit `buildCost`**

Replace `NewShipType.buildCost = 3000` with `NewShipType.buildCost = 4500`

- [ ] **Step 6: Edit `buildTime`**

Replace `NewShipType.buildTime = 165` with `NewShipType.buildTime = 60`

- [ ] **Step 7: Verify the new values**

Run: `pwsh -NoProfile -File tools/ship-stats.ps1 -Ship vgr_destroyer -Fields maxhealth,rotationMaxSpeed,buildCost,buildTime`
Expected: `maxhealth 75000`, `rotationMaxSpeed 19`, `buildCost 4500`, `buildTime 60`.
Then run: `pwsh -NoProfile -Command "Select-String -Path src/ship/vgr_destroyer/vgr_destroyer.ship -Pattern 'unitCapsNumber'"`
Expected: `NewShipType.unitCapsNumber = 3`.

- [ ] **Step 8: Commit**

```bash
git add src/ship/vgr_destroyer/vgr_destroyer.ship
git commit -m "Buff Vaygr destroyer hull and economy to HGN parity"
```

---

### Task 3: Raise Vaygr destroyer swappable turret firepower

**Files:**
- Modify: `src/weapon/vgr_dd_missileboxturret/vgr_dd_missileboxturret.wepn`
- Modify: `src/weapon/vgr_dd_scattershotturret/vgr_dd_scattershotturret.wepn`

**Interfaces:**
- Consumes: `tools/weapon-dps.ps1` from Task 1.
- Produces: none (data-only).

Plan: missilebox is VGR's full-accuracy universal turret → raise per-hit damage to land naive DPS ≈ 1650 (HGN gatling/plasma band) at its existing 0.4s interval. Scattershot is a flak specialist → halve its interval (1.0→0.5) for a modest rate buff to keep it a viable second pick, without inflating per-hit.

- [ ] **Step 1: Confirm current ("before") DPS**

Run: `pwsh -NoProfile -File tools/weapon-dps.ps1 -Weapon vgr_dd`
Expected: `vgr_dd_missileboxturret  225  0.4  562` and `vgr_dd_scattershotturret  225  1  225`.

- [ ] **Step 2: Raise missilebox per-hit damage (562 → ~1650 DPS)**

In `vgr_dd_missileboxturret.wepn`, replace
`AddWeaponResult(NewWeaponType,"Hit","DamageHealth","Target",200,250,"")`
with
`AddWeaponResult(NewWeaponType,"Hit","DamageHealth","Target",640,680,"")`

(avg 660 ÷ 0.4s interval = 1650 DPS)

- [ ] **Step 3: Halve scattershot interval (225 → ~450 DPS)**

In `vgr_dd_scattershotturret.wepn`, replace
`"FlakShell","Normal",5000,8000,0,0,0,0,1,1,0,1,1,3`
with
`"FlakShell","Normal",5000,8000,0,0,0,0,1,1,0,0.5,1,3`

(changes only the 10th numeric arg — the inter-shot interval — from 1 to 0.5)

- [ ] **Step 4: Verify the new DPS**

Run: `pwsh -NoProfile -File tools/weapon-dps.ps1 -Weapon vgr_dd`
Expected: `vgr_dd_missileboxturret  660  0.4  1650` and `vgr_dd_scattershotturret  225  0.5  450`.

- [ ] **Step 5: Commit**

```bash
git add src/weapon/vgr_dd_missileboxturret/vgr_dd_missileboxturret.wepn src/weapon/vgr_dd_scattershotturret/vgr_dd_scattershotturret.wepn
git commit -m "Raise Vaygr destroyer turret DPS toward HGN parity"
```

---

### Task 4: Buff Vaygr battlecruiser durability

**Files:**
- Modify: `src/ship/vgr_battlecruiser/vgr_battlecruiser.ship`

**Interfaces:**
- Consumes: existing `tools/ship-stats.ps1`. Produces: none. Independent.

Targets: `maxhealth` 220000→250000 (HGN BC 250000), `buildCost` 4500→4900 (normalization toward HGN 5000). Weapons already ≈ HGN — unchanged.

- [ ] **Step 1: Confirm current values**

Run: `pwsh -NoProfile -File tools/ship-stats.ps1 -Ship vgr_battlecruiser -Fields maxhealth,buildCost`
Expected: `maxhealth 220000`, `buildCost 4500`.

- [ ] **Step 2: Edit `maxhealth`**

Replace `NewShipType.maxhealth = 220000` with `NewShipType.maxhealth = 250000`

- [ ] **Step 3: Edit `buildCost`**

Replace `NewShipType.buildCost = 4500` with `NewShipType.buildCost = 4900`

- [ ] **Step 4: Verify**

Run: `pwsh -NoProfile -File tools/ship-stats.ps1 -Ship vgr_battlecruiser -Fields maxhealth,buildCost`
Expected: `maxhealth 250000`, `buildCost 4900`.

- [ ] **Step 5: Commit**

```bash
git add src/ship/vgr_battlecruiser/vgr_battlecruiser.ship
git commit -m "Buff Vaygr battlecruiser HP to HGN parity"
```

---

### Task 5: Buff Vaygr frigates (assault + heavy missile)

**Files:**
- Modify: `src/ship/vgr_assaultfrigate/vgr_assaultfrigate.ship`
- Modify: `src/ship/vgr_heavymissilefrigate/vgr_heavymissilefrigate.ship`

**Interfaces:**
- Consumes: existing `tools/ship-stats.ps1`. Produces: none. Independent.

Targets (both): `maxhealth` 14000→16000 (HGN frigate 16000), `rotationMaxSpeed` 28→80 (closes most of the gap to HGN's 150 while keeping the heavier broadside feel — playtest-tunable). Costs: assault 650→800, heavy missile 700→800 (normalization toward HGN frigate 800). Weapons unchanged (VGR missile/broadside alpha already ≈ HGN).

- [ ] **Step 1: Confirm current values**

Run: `pwsh -NoProfile -File tools/ship-stats.ps1 -Ship vgr_assaultfrigate -Fields maxhealth,rotationMaxSpeed,buildCost`
Expected: `maxhealth 14000`, `rotationMaxSpeed 28`, `buildCost 650`.
Run: `pwsh -NoProfile -File tools/ship-stats.ps1 -Ship vgr_heavymissilefrigate -Fields maxhealth,rotationMaxSpeed,buildCost`
Expected: `maxhealth 14000`, `rotationMaxSpeed 28`, `buildCost 700`.

- [ ] **Step 2: Edit assault frigate**

In `src/ship/vgr_assaultfrigate/vgr_assaultfrigate.ship`:
- Replace `NewShipType.maxhealth = 14000` with `NewShipType.maxhealth = 16000`
- Replace `NewShipType.rotationMaxSpeed = 28` with `NewShipType.rotationMaxSpeed = 80`
- Replace `NewShipType.buildCost = 650` with `NewShipType.buildCost = 800`

- [ ] **Step 3: Edit heavy missile frigate**

In `src/ship/vgr_heavymissilefrigate/vgr_heavymissilefrigate.ship`:
- Replace `NewShipType.maxhealth = 14000` with `NewShipType.maxhealth = 16000`
- Replace `NewShipType.rotationMaxSpeed = 28` with `NewShipType.rotationMaxSpeed = 80`
- Replace `NewShipType.buildCost = 700` with `NewShipType.buildCost = 800`

- [ ] **Step 4: Verify**

Run: `pwsh -NoProfile -File tools/ship-stats.ps1 -Ship vgr_assaultfrigate -Fields maxhealth,rotationMaxSpeed,buildCost`
Expected: `maxhealth 16000`, `rotationMaxSpeed 80`, `buildCost 800`.
Run: `pwsh -NoProfile -File tools/ship-stats.ps1 -Ship vgr_heavymissilefrigate -Fields maxhealth,rotationMaxSpeed,buildCost`
Expected: `maxhealth 16000`, `rotationMaxSpeed 80`, `buildCost 800`.

- [ ] **Step 5: Commit**

```bash
git add src/ship/vgr_assaultfrigate/vgr_assaultfrigate.ship src/ship/vgr_heavymissilefrigate/vgr_heavymissilefrigate.ship
git commit -m "Buff Vaygr frigate HP and rotation toward HGN parity"
```

---

### Task 6: Buff Vaygr interceptor durability and firepower

**Files:**
- Modify: `src/ship/vgr_interceptor/vgr_interceptor.ship`
- Modify: `src/weapon/vgr_pulsecannon/vgr_pulsecannon.wepn`

**Interfaces:**
- Consumes: `tools/ship-stats.ps1`, `tools/weapon-dps.ps1` (Task 1). Produces: none.

Targets: `maxhealth` 300→400 (HGN interceptor 400), `rotationMaxSpeed` 131→160 (toward HGN 190), `vgr_pulsecannon` DamageHealth 30→90 (30→90 DPS — modest; stays below HGN interceptor's ~150 because VGR also fields bombers + lance fighters). `vgr_pulsecannon` is used only by the interceptor, so the change is isolated.

- [ ] **Step 1: Confirm current values**

Run: `pwsh -NoProfile -File tools/ship-stats.ps1 -Ship vgr_interceptor -Fields maxhealth,rotationMaxSpeed`
Expected: `maxhealth 300`, `rotationMaxSpeed 131`.
Run: `pwsh -NoProfile -File tools/weapon-dps.ps1 -Weapon vgr_pulsecannon`
Expected: a row `vgr_pulsecannon  30  1  30`.

- [ ] **Step 2: Edit interceptor hull**

In `src/ship/vgr_interceptor/vgr_interceptor.ship`:
- Replace `NewShipType.maxhealth = 300` with `NewShipType.maxhealth = 400`
- Replace `NewShipType.rotationMaxSpeed = 131` with `NewShipType.rotationMaxSpeed = 160`

- [ ] **Step 3: Edit interceptor weapon damage**

In `src/weapon/vgr_pulsecannon/vgr_pulsecannon.wepn`, replace
`AddWeaponResult(NewWeaponType, "Hit", "DamageHealth", "Target", 30, 30, "")`
with
`AddWeaponResult(NewWeaponType, "Hit", "DamageHealth", "Target", 90, 90, "")`

- [ ] **Step 4: Verify**

Run: `pwsh -NoProfile -File tools/ship-stats.ps1 -Ship vgr_interceptor -Fields maxhealth,rotationMaxSpeed`
Expected: `maxhealth 400`, `rotationMaxSpeed 160`.
Run: `pwsh -NoProfile -File tools/weapon-dps.ps1 -Weapon vgr_pulsecannon`
Expected: `vgr_pulsecannon  90  1  90`.

- [ ] **Step 5: Commit**

```bash
git add src/ship/vgr_interceptor/vgr_interceptor.ship src/weapon/vgr_pulsecannon/vgr_pulsecannon.wepn
git commit -m "Buff Vaygr interceptor HP and firepower"
```

---

### Task 7: Full validation, scenario consistency check, and playtest handoff

**Files:**
- Modify (only if a load error or obvious scenario bug is found): none expected.

**Interfaces:**
- Consumes: `tools/ship-stats.ps1`, `tools/weapon-dps.ps1`, and (if the HW2 toolchain is installed) `tools/build-tpof.ps1`, `tools/parse-logs.ps1`.
- Produces: a validation summary; the spec's Status flipped to "Implemented (pending playtest)".

- [ ] **Step 1: Confirm only intended stat deltas vs the pre-balance base**

Run: `pwsh -NoProfile -File tools/ship-stats.ps1 -GitRef 8146c6b -Changed`
Expected: changed rows ONLY for `vgr_destroyer`, `vgr_battlecruiser`, `vgr_assaultfrigate`, `vgr_heavymissilefrigate`, `vgr_interceptor`. No `hgn_*`, corvette, qwaarjetii, or vanaarjet rows. If any unexpected ship appears, stop and investigate.

- [ ] **Step 2: Confirm weapon DPS targets**

Run: `pwsh -NoProfile -File tools/weapon-dps.ps1 -Weapon vgr`
Expected: `vgr_dd_missileboxturret` DPS 1650, `vgr_dd_scattershotturret` DPS 450, `vgr_pulsecannon` DPS 90. All other `vgr_*` weapons unchanged from baseline.

- [ ] **Step 3: Scenario consistency check (review only)**

Run: `pwsh -NoProfile -File tools/ship-stats.ps1 -Fields maxhealth,buildCost`
Review `sri_dreadnaught` (550000), `sri_sajuuk`, `sri_commandbase`, `vgr_prisonstation`, `meg_*`. Confirm they remain coherent boss/super-units in the new power band. These are NOT race-parity targets — change nothing unless a clear bug surfaces (e.g., a 0 HP combat ship). Record the conclusion in Step 6.

- [ ] **Step 4 (toolchain-gated): Pack and check for load/Lua errors**

If the HW2 install + RDN tools are present:
Run: `pwsh tools/build-tpof.ps1 -Install`
Then: `pwsh tools/parse-logs.ps1 -Errors`
Expected: build succeeds; `parse-logs` reports no ERROR / LUA ERROR (exit 0). If the toolchain is absent, note "skipped — toolchain unavailable" and rely on Steps 1–2.

- [ ] **Step 5 (human-in-loop): Playtest a VGR-vs-HGN map**

Launch via `pwsh tools/launch-tpof.ps1` and play at least:
1. Destroyer vs destroyer (1v1 and 3v3) — VGR should now trade roughly evenly.
2. Frigate skirmish — VGR frigates should survive and track targets noticeably better.
3. Opening heavy-cap engagement (heavycruiser vs qwaarjetii) — confirm the HP-vs-alpha trade feels fair (no VGR HP buff was applied).
Tune the playtest-flagged values if needed: destroyer `unitCapsNumber`, frigate `rotationMaxSpeed` (80), interceptor damage, and whether VGR corvettes need any nudge. Record adjustments as follow-up edits (re-running Steps 1–2 after each).

- [ ] **Step 6: Mark the spec implemented and commit the status update**

In `docs/superpowers/specs/2026-06-26-vgr-hgn-balance-parity-design.md`, change `**Status:** Awaiting review` to `**Status:** Implemented (pending playtest tuning)` and append a one-line note under it summarizing the Step 1–4 validation result and the Step 3 scenario conclusion.

```bash
git add docs/superpowers/specs/2026-06-26-vgr-hgn-balance-parity-design.md
git commit -m "Mark VGR-HGN balance spec implemented after validation"
```

---

## Self-review

**Spec coverage:**
- Destroyer (HP/rot/build/cost/cap + turret DPS) → Tasks 2, 3 ✓
- Battlecruiser (HP/cost) → Task 4 ✓
- Frigates (HP/rot/cost) → Task 5 ✓
- Interceptor (HP/rot/weapon) → Task 6 ✓
- Corvettes (no change) → covered by exclusion + Task 7 Step 1 guard ✓
- Heavy caps (verify only, no HP) → Task 7 Step 3 + exclusion ✓
- Scenario consistency check → Task 7 Step 3 ✓
- Economy normalization → folded into Tasks 2, 4, 5 ✓
- DPS tool promotion → Task 1 ✓
- Validation (ship-stats diff, DPS, build, parse-logs, playtest) → Task 7 ✓

**Placeholder scan:** No TBD/TODO; every edit gives exact old→new strings and exact verification commands with expected output. The optional heavy-cap cost bump (10000→11000) was dropped from the change set and left as a Task 7 review item to avoid an unverified edit; it is genuinely optional per the spec.

**Type/value consistency:** Field names (`maxhealth`, `rotationMaxSpeed`, `buildCost`, `buildTime`, `unitCapsNumber`) and the `AddWeaponResult` / `StartWeaponConfig` literal strings match the current files read during planning. Naive-DPS arithmetic checks: missilebox 660/0.4=1650 ✓, scattershot 225/0.5=450 ✓, pulsecannon 90/1=90 ✓.
