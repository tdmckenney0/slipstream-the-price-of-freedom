# Weapon Tuning Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Re-tune the non-damage properties (range, velocity, fire cadence, turret tracking, penetration) of every combat `.wepn` to one coherent class-based system, without changing per-hit damage.

**Architecture:** Each `.wepn`'s `StartWeaponConfig` line and `setPenetration` call are rewritten to the targets in this plan's per-class tables. Range scales by carrying-hull class; cadence follows a per-archetype interval ladder checked against per-class TTK budgets; penetration uses five role profiles plus four strength tiers. A final pass adjusts ship sensor ranges and re-runs the validators.

**Tech Stack:** HW2 `.wepn` DSL (Lua-like), PowerShell 7 validators (`tools/weapon-dps.ps1`, `tools/ship-stats.ps1`). No unit-test harness exists; each task's "test" is a static validator/grep with expected output, plus an in-engine playtest as final authority.

## Global Constraints

- **Per-hit `DamageHealth` bounds are immutable.** Never edit `AddWeaponResult` damage values.
- **Never touch `keeper.txt` files** (required by the big-file packer).
- **Edit only the dictated args.** Leave `setMiscValues`, `addAnimTurretSound`, FX/`.miss` names, mount/weapon/activation-type strings untouched. Do not edit `.miss` files.
- **Keep each file's header role comment;** add a one-line note when a value changes for a non-obvious reason.
- **Shell is PowerShell 7+** (`pwsh`). Paths use backslashes in commands.
- **Commit after each task.** No `Co-Authored-By:` trailer (repo preference). Branch is `last-leg-of-v4-series` (not master) — no new branch needed.

### Reference: `StartWeaponConfig` arg positions (1-indexed after `NewWeaponType`)

`arg5` = projectile velocity · `arg6` = max firing range · `arg14` = inter-shot interval (s) · `arg19` = horizontal tracking °/s · `arg20` = vertical tracking °/s. (Full table: `docs/weapon_definitions.md`.)

### Reference: Range bands (arg6) by carrying-hull class

| Class | Std range | Over-range specialist (siege/spinal, ≈+40%) |
|---|---|---|
| Strikecraft | 2500 | — |
| Corvette | 3500 | — |
| Frigate | 4500 | — |
| Destroyer | 6000 | — |
| Battlecruiser | 7500 | 10500 |
| Flagship | 9000 | — |
| Superweapon | 10000+ (per weapon) | up to 20000 |
| Mine | 12000 (deployment, not engagement) | |

### Reference: Velocity rule (arg5, `Bullet` only)

`velocity = max(2600, round(range / 2))`. Beams (`InstantHit`) stay `0`. Missiles: launch speed only — set to `150` (real flight lives in the `.miss`; do not edit the `.miss`).

Resulting per-class bullet velocity: Strikecraft/Corvette/Frigate `2600` · Destroyer `3000` · Battlecruiser `3800` · Flagship `4500`.

### Reference: Cadence ladder (arg14, seconds) by archetype

| Archetype | Interval |
|---|---|
| Gatling / rapid PD / fighter cannon | 0.2 |
| Rapid laser / autocannon | 0.3 |
| Flak / scattershot | 1.0 |
| Pulse / generalist gun | 0.8 |
| Plasma-burst generalist | 1.0 |
| Light beam/lance (pulsed) | 0.5 |
| Heavy ion beam / superlance (recharge) | 4.0 |
| Missile — anti-strike | 0.8 |
| Missile — anti-capital | 2.0 |
| Siege missile / torpedo | 6.0 |
| Mine | 4.0 |

Per-class TTK budget to sanity-check against (`requiredDPS = health ÷ TTK`): Corvette ≈670 · Frigate ≈1330 · Destroyer ≈3750 · BC ≈8330 · Flagship ≈6000. The ladder is the starting point; if `weapon-dps.ps1` shows a hull's standard battery far off budget, scale that hull's intervals proportionally and note it.

### Reference: Turret tracking (arg19/arg20 °/s) by archetype

Anti-strike / PD / flak = `120/120` · Generalist = `75/75` · Anti-capital = `40/20` · Siege/spinal = `35/20` · Beams keep their existing traverse unless listed. Fixed/Gimble fighter guns with `0/0` stay `0/0`.

### Reference: Penetration — five role profiles (per-armour multipliers)

Apply the matching profile's full armour table; `MineArmour`/`ChunkArmour` = 1, `MoverArmour` = 1, `ResArmour` = the profile's Medium value. `PlanetKillerArmour` as shown.

| Profile | Unarm | Light | Med | Heavy | SubSys | Turret | PlanetKiller |
|---|---|---|---|---|---|---|---|
| **anti-strike** | 1.0 | 1.0 | 0.5 | 0.2 | 0.5 | 1.0 | 0 |
| **generalist** | 1.0 | 1.0 | 0.8 | 0.5 | 0.7 | 1.2 | 0 |
| **anti-capital** | 0.5 | 0.4 | 0.8 | 1.0 | 1.0 | 1.5 | 0 |
| **siege** | 0.5 | 0.6 | 1.0 | 1.0 | 1.0 | 1.0 | 0.3 |
| **superweapon** | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1.5 | 1.0 |

### Reference: Penetration strength tiers (leading `setPenetration` number)

Strikecraft/Corvette `5` · Frigate/Destroyer `30` · Battlecruiser/Flagship `60` · Siege/Superweapon `100`. The second leading number stays `1`.

### Canonical `setPenetration` block to paste (substitute profile values + strength)

```lua
setPenetration(NewWeaponType, <STRENGTH>, 1,
    { Unarmoured = <U>, },
    { LightArmour = <L>, },
    { MediumArmour = <M>, },
    { HeavyArmour = <H>, },
    { SubSystemArmour = <S>, },
    { TurretArmour = <T>, },
    { ResArmour = <M>, },
    { MoverArmour = 1, },
    { PlanetKillerArmour = <PK>, },
    { MineArmour = 1, },
    { ChunkArmour = 1, })
```

> If a file's existing `setPenetration` uses a shorter table (e.g. only `PlanetKillerArmour`), replace it wholesale with the canonical block above.

**Fully-worked example** — `anti-strike` profile at Frigate strength `30` (copy and adjust the numbers per the profile/strength a task specifies):

```lua
setPenetration(NewWeaponType, 30, 1,
    { Unarmoured = 1, },
    { LightArmour = 1, },
    { MediumArmour = 0.5, },
    { HeavyArmour = 0.2, },
    { SubSystemArmour = 0.5, },
    { TurretArmour = 1, },
    { ResArmour = 0.5, },
    { MoverArmour = 1, },
    { PlanetKillerArmour = 0, },
    { MineArmour = 1, },
    { ChunkArmour = 1, })
```

---

## Task 1: Commit the DPS-validator fix (prerequisite)

The validator used by every later task was already corrected (beam detection now keys off `"InstantHit"`; damage sums all `DamageHealth`). Commit it so measurements are trustworthy and on the record.

**Files:**
- Modify: `tools/weapon-dps.ps1` (already edited in working tree)

- [ ] **Step 1: Confirm the fix is present and runs**

Run: `pwsh -NoProfile -File tools\weapon-dps.ps1 -Weapon ionbeam`
Expected: `hgn_ff_ionbeamturret` row shows `beam` in the Beam column (non-blank).

- [ ] **Step 2: Commit**

```bash
git add tools/weapon-dps.ps1
git commit -m "Fix weapon-dps beam detection and multi-damage summing"
```

---

## Task 2: Strikecraft & Corvette weapons

**Files (Modify each `.wepn`):**
- `src/weapon/hgn_interceptor_cannon/hgn_interceptor_cannon.wepn`
- `src/weapon/hgn_interceptor_beam/hgn_interceptor_beam.wepn`
- `src/weapon/vgr_pulsecannon/vgr_pulsecannon.wepn`
- `src/weapon/vgr_laser/vgr_laser.wepn`
- `src/weapon/vgr_autocannon/vgr_autocannon.wepn`
- `src/weapon/vgr_lightplasmalance/vgr_lightplasmalance.wepn`
- `src/weapon/vgr_bomberplasmadriver/vgr_bomberplasmadriver.wepn`
- `src/weapon/hgn_pulsar/hgn_pulsar.wepn`, `src/weapon/hgn_pulsarside/hgn_pulsarside.wepn` *(shared corvette+frigate — use Frigate band 4500; see note)*

**Targets:**

| File | Archetype | arg6 range | arg5 vel | arg14 int | track H/V | profile | strength |
|---|---|---|---|---|---|---|---|
| hgn_interceptor_cannon | anti-strike | 2500 | 2600 | 0.2 | 0/0 | anti-strike | 5 |
| hgn_interceptor_beam | anti-strike (beam) | 2500 | 0 | — | 0/0 | anti-strike | 5 |
| vgr_pulsecannon | anti-strike | 2500 | 2600 | 0.3 | 0/0 | anti-strike | 5 |
| vgr_laser | anti-strike | 2500 | 2600 | 0.3 | keep | anti-strike | 5 |
| vgr_autocannon | anti-strike | 3500 | 2600 | 0.2 | 120/120 | anti-strike | 5 |
| vgr_lightplasmalance | generalist (beam) | 3500 | 0 | 0.5 | keep | generalist | 5 |
| vgr_bomberplasmadriver | anti-capital | 3500 | 2600 | 0.5 | 120/120 | anti-capital | 5 |
| hgn_pulsar | anti-strike (beam) | 4500 | 0 | keep | keep | anti-strike | 30 |
| hgn_pulsarside | anti-strike (beam) | 4500 | 0 | keep | keep | anti-strike | 30 |

> **Note (hgn_pulsar host):** `hgn_pulsar` is referenced by both `hgn_ff_pulsarturret.subs` (assault frigate) and the pulsar corvette path. Use the Frigate band (4500) and strength 30, since the frigate is the larger host it must serve. `arg14`/tracking are beam-pulse values — leave as-is.

- [ ] **Step 1: Edit each file** — set arg5/arg6/arg14/arg19/arg20 per the table; replace `setPenetration` with the canonical block using the row's profile + strength. Beams (`InstantHit`, vel column `0`) keep arg5=0 and existing arg14. Add/keep a header comment line if changing role-affecting values.

- [ ] **Step 2: Validate ranges & penetration**

Run: `pwsh -NoProfile -File tools\weapon-dps.ps1 -Weapon interceptor`
Expected: `hgn_interceptor_beam` shows `beam`; per-hit `Dmg` unchanged from before (12.50 / 15.00).
Run: `git grep -n "setPenetration(NewWeaponType, 5," src/weapon/hgn_interceptor_cannon src/weapon/vgr_pulsecannon src/weapon/vgr_laser src/weapon/vgr_autocannon`
Expected: each shows strength `5`.

- [ ] **Step 3: Commit**

```bash
git add src/weapon/hgn_interceptor_cannon src/weapon/hgn_interceptor_beam src/weapon/vgr_pulsecannon src/weapon/vgr_laser src/weapon/vgr_autocannon src/weapon/vgr_lightplasmalance src/weapon/vgr_bomberplasmadriver src/weapon/hgn_pulsar src/weapon/hgn_pulsarside
git commit -m "Tune strikecraft and corvette weapon ranges, velocity, cadence, penetration"
```

---

## Task 3: Frigate weapons

**Files (Modify):**
- `src/weapon/hgn_ff_gatlinggunturret/hgn_ff_gatlinggunturret.wepn`
- `src/weapon/hgn_ff_ionbeamturret/hgn_ff_ionbeamturret.wepn`
- `src/weapon/vgr_pulsecannonassaultfrigateleft/...left.wepn`, `...right/...right.wepn`, `...bottom/...bottom.wepn`
- `src/weapon/vgr_concussionmissilelauncher/vgr_concussionmissilelauncher.wepn`
- `src/weapon/vgr_heavyconcussionmissilelauncher/vgr_heavyconcussionmissilelauncher.wepn` *(confirm host)*

**Targets:**

| File | Archetype | arg6 | arg5 | arg14 | track H/V | profile | strength |
|---|---|---|---|---|---|---|---|
| hgn_ff_gatlinggunturret | anti-strike | 4500 | 2600 | 0.2 | 120/120 | anti-strike | 30 |
| hgn_ff_ionbeamturret | anti-capital (beam) | 4500 | 0 | keep | 40/20 | anti-capital | 30 |
| vgr_pulsecannonassaultfrigateleft | generalist | 4500 | 2600 | 0.8 | 75/75 | generalist | 30 |
| vgr_pulsecannonassaultfrigateright | generalist | 4500 | 2600 | 0.8 | 75/75 | generalist | 30 |
| vgr_pulsecannonassaultfrigatebottom | generalist | 4500 | 2600 | 0.8 | 75/75 | generalist | 30 |
| vgr_concussionmissilelauncher | generalist (missile) | 4500 | 150 | 0.8 | keep | generalist | 30 |
| vgr_heavyconcussionmissilelauncher | anti-capital (missile) | 4500 | 150 | 2.0 | keep | anti-capital | 30 |

> **Confirm host** of `vgr_heavyconcussionmissilelauncher`: `git grep -n heavyconcussionmissilelauncher src/ship src/subsystem`. If it is carried by a Battlecruiser, move it to Task 5 with BC range 7500 / strength 60 instead. If no host is found, it is unused — leave the file unchanged and note it.

- [ ] **Step 1: Edit each file per the table** (canonical `setPenetration` block, profile + strength as shown).

- [ ] **Step 2: Validate**

Run: `pwsh -NoProfile -File tools\weapon-dps.ps1 -Weapon assaultfrigate`
Expected: three `vgr_pulsecannonassaultfrigate*` rows, `Dmg` unchanged at 500.00, `Interval` now 0.80.
Run: `git grep -n "30, 1," src/weapon/hgn_ff_gatlinggunturret src/weapon/hgn_ff_ionbeamturret`
Expected: each shows strength `30`.

- [ ] **Step 3: Commit**

```bash
git add src/weapon/hgn_ff_gatlinggunturret src/weapon/hgn_ff_ionbeamturret src/weapon/vgr_pulsecannonassaultfrigateleft src/weapon/vgr_pulsecannonassaultfrigateright src/weapon/vgr_pulsecannonassaultfrigatebottom src/weapon/vgr_concussionmissilelauncher src/weapon/vgr_heavyconcussionmissilelauncher
git commit -m "Tune frigate weapon ranges, velocity, cadence, penetration"
```

---

## Task 4: Destroyer weapons

**Files (Modify):** `hgn_dd_gatlinggunturret`, `hgn_dd_plasmaburstturret`, `vgr_dd_pulsecannonturret`, `vgr_dd_rapidlaserturret`, `vgr_dd_scattershotturret`, `vgr_dd_missileboxturret` (each under `src/weapon/<name>/<name>.wepn`).

**Targets:**

| File | Archetype | arg6 | arg5 | arg14 | track H/V | profile | strength |
|---|---|---|---|---|---|---|---|
| hgn_dd_gatlinggunturret | anti-strike | 6000 | 3000 | 0.2 | 120/120 | anti-strike | 30 |
| hgn_dd_plasmaburstturret | flak | 6000 | 3000 | 0.4 | 120/120 | anti-strike | 30 |
| vgr_dd_pulsecannonturret | generalist | 6000 | 3000 | 0.8 | 75/75 | generalist | 30 |
| vgr_dd_rapidlaserturret | anti-strike | 6000 | 3000 | 0.3 | 120/120 | anti-strike | 30 |
| vgr_dd_scattershotturret | flak | 6000 | 3000 | 1.0 | 120/120 | anti-strike | 30 |
| vgr_dd_missileboxturret | anti-capital (missile) | 6000 | 150 | 2.0 | 75/75 | anti-capital | 30 |

> Biggest cadence fixes here: `vgr_dd_pulsecannonturret` 5.0→0.8s and `vgr_dd_scattershotturret` range 8000→6000.

- [ ] **Step 1: Edit each file per the table** (canonical `setPenetration` block).

- [ ] **Step 2: Validate**

Run: `pwsh -NoProfile -File tools\weapon-dps.ps1 -Weapon vgr_dd`
Expected: `vgr_dd_pulsecannonturret` `Interval` now 0.80 (was 5.00); all `Dmg` unchanged.
Run: `pwsh -NoProfile -File tools\weapon-dps.ps1 -Weapon hgn_dd`
Expected: `Dmg` unchanged (412.50 for both).

- [ ] **Step 3: Commit**

```bash
git add src/weapon/hgn_dd_gatlinggunturret src/weapon/hgn_dd_plasmaburstturret src/weapon/vgr_dd_pulsecannonturret src/weapon/vgr_dd_rapidlaserturret src/weapon/vgr_dd_scattershotturret src/weapon/vgr_dd_missileboxturret
git commit -m "Tune destroyer weapon ranges, velocity, cadence, penetration"
```

---

## Task 5: Battlecruiser & mothership-hull weapons

**Files (Modify):** `hgn_bc_gatlinggunturret`, `hgn_bc_plasmaburstturret`, `hgn_bc_plasmaburstturret_left`, `hgn_bc_plasmaburstturret_right`, `vgr_bclaser`, `vgr_bcforwardweapon`, `vgr_bc_concussionmissile`, `vgr_bc_sunshattermissile`, `vgr_heavyfusionmissilelauncherbc`, `hgn_mshulldefensegun`, `hgn_mshulldefensegunside`, `hgn_vulcanplasmaturret` *(confirm host)*, `hgn_hc_nucleartorpedolauncher` *(heavy cruiser; confirm)*.

**Targets:**

| File | Archetype | arg6 | arg5 | arg14 | track H/V | profile | strength |
|---|---|---|---|---|---|---|---|
| hgn_bc_gatlinggunturret | anti-strike | 7500 | 3800 | 0.2 | 120/120 | anti-strike | 60 |
| hgn_bc_plasmaburstturret | generalist | 7500 | 3800 | 1.0 | 75/75 | generalist | 60 |
| hgn_bc_plasmaburstturret_left | generalist | 7500 | 3800 | 1.0 | 75/75 | generalist | 60 |
| hgn_bc_plasmaburstturret_right | generalist | 7500 | 3800 | 1.0 | 75/75 | generalist | 60 |
| vgr_bclaser | anti-capital (beam) | 7500 | 0 | keep | 40/20 | anti-capital | 60 |
| vgr_bcforwardweapon | siege/spinal (beam) | 10500 | 0 | keep | 35/20 | siege | 100 |
| vgr_bc_concussionmissile | anti-strike (missile) | 7500 | 150 | 0.8 | keep | anti-strike | 60 |
| vgr_bc_sunshattermissile | siege (missile) | 10500 | 150 | 6.0 | keep | siege | 100 |
| vgr_heavyfusionmissilelauncherbc | siege (missile) | 10000 | 150 | 6.0 | keep | siege | 100 |
| hgn_mshulldefensegun | PD/anti-strike | 7500 | 3800 | 0.5 | keep | anti-strike | 60 |
| hgn_mshulldefensegunside | PD/anti-strike | 7500 | 3800 | 0.5 | keep | anti-strike | 60 |
| hgn_vulcanplasmaturret | PD/anti-strike | 7500 | 3800 | 0.3 | 120/40 | anti-strike | 60 |
| hgn_hc_nucleartorpedolauncher | siege (missile) | 10500 | 150 | 6.0 | keep | siege | 100 |

> Biggest fixes: `hgn_bc_gatlinggunturret` range 10000→7500; `vgr_bcforwardweapon` 15000→10500; `vgr_bc_sunshattermissile` 14000→10500; `hgn_vulcanplasmaturret` interval 8.0→0.3.
> **Confirm hosts:** `git grep -n -e vulcanplasmaturret -e nucleartorpedolauncher src/ship src/subsystem`. `hgn_hc_nucleartorpedolauncher` is wired in `hgn_heavycruiser.ship` (heavy cruiser = capital tier) — siege/100 is correct. If `hgn_vulcanplasmaturret` turns out to be a Flagship/carrier weapon, its targets are identical except set strength per its host tier.

- [ ] **Step 1: Edit each file per the table** (canonical `setPenetration` block; `siege` profile sets `PlanetKillerArmour = 0.3`).

- [ ] **Step 2: Validate**

Run: `pwsh -NoProfile -File tools\weapon-dps.ps1 -Weapon hgn_bc`
Expected: `hgn_bc_gatlinggunturret` `Dmg` 550.00 unchanged; `hgn_vulcanplasmaturret` (run `-Weapon vulcan`) `Interval` now 0.30.
Run: `git grep -n "10500" src/weapon/vgr_bcforwardweapon src/weapon/vgr_bc_sunshattermissile`
Expected: range arg present as `10500`.

- [ ] **Step 3: Commit**

```bash
git add src/weapon/hgn_bc_gatlinggunturret src/weapon/hgn_bc_plasmaburstturret src/weapon/hgn_bc_plasmaburstturret_left src/weapon/hgn_bc_plasmaburstturret_right src/weapon/vgr_bclaser src/weapon/vgr_bcforwardweapon src/weapon/vgr_bc_concussionmissile src/weapon/vgr_bc_sunshattermissile src/weapon/vgr_heavyfusionmissilelauncherbc src/weapon/hgn_mshulldefensegun src/weapon/hgn_mshulldefensegunside src/weapon/hgn_vulcanplasmaturret src/weapon/hgn_hc_nucleartorpedolauncher
git commit -m "Tune battlecruiser and mothership-hull weapon ranges, velocity, cadence, penetration"
```

---

## Task 6: Flagship weapons

**Files (Modify):** `vgr_qj2_pulsecannonturret_left`, `vgr_qj2_pulsecannonturret_right`, `vgr_vj_pulsecannonturret_left`, `vgr_vj_pulsecannonturret_right`, `vgr_qj2_scattershotturret_left`, `vgr_qj2_scattershotturret_right`, `vgr_qj2_superlanceturret`, `vgr_qj2_superlanceturretside`, `vgr_vj_superlanceturret`, `vgr_vj_rapidlaserturret`, `vgr_vulcanpulseturret` *(confirm host)*.

**Targets:**

| File | Archetype | arg6 | arg5 | arg14 | track H/V | profile | strength |
|---|---|---|---|---|---|---|---|
| vgr_qj2_pulsecannonturret_left | generalist | 9000 | 4500 | 1.0 | 75/75 | generalist | 60 |
| vgr_qj2_pulsecannonturret_right | generalist | 9000 | 4500 | 1.0 | 75/75 | generalist | 60 |
| vgr_vj_pulsecannonturret_left | generalist | 9000 | 4500 | 1.0 | 75/75 | generalist | 60 |
| vgr_vj_pulsecannonturret_right | generalist | 9000 | 4500 | 1.0 | 75/75 | generalist | 60 |
| vgr_qj2_scattershotturret_left | flak | 9000 | 4500 | 1.0 | 120/120 | anti-strike | 60 |
| vgr_qj2_scattershotturret_right | flak | 9000 | 4500 | 1.0 | 120/120 | anti-strike | 60 |
| vgr_qj2_superlanceturret | anti-capital (beam) | 9000 | 0 | 4.0 | keep | anti-capital | 100 |
| vgr_qj2_superlanceturretside | anti-capital (beam) | 9000 | 0 | 4.0 | keep | anti-capital | 100 |
| vgr_vj_superlanceturret | anti-capital (beam) | 9000 | 0 | 4.0 | keep | anti-capital | 100 |
| vgr_vj_rapidlaserturret | anti-strike | 9000 | 4500 | 0.3 | 120/120 | anti-strike | 60 |
| vgr_vulcanpulseturret | PD/anti-strike | 9000 | 4500 | 0.5 | 120/120 | anti-strike | 60 |

> Biggest fix: the four `*_pulsecannonturret_*` at 5.0→1.0s. `vgr_vulcanpulseturret` host: `git grep -n vulcanpulseturret src/ship src/subsystem` — if BC-hosted, use range 7500.

- [ ] **Step 1: Edit each file per the table** (canonical `setPenetration` block).

- [ ] **Step 2: Validate**

Run: `pwsh -NoProfile -File tools\weapon-dps.ps1 -Weapon qj2`
Expected: `vgr_qj2_pulsecannonturret_*` `Interval` now 1.00 (was 5.00); `Dmg` unchanged (1750.00); superlance rows show `beam`.

- [ ] **Step 3: Commit**

```bash
git add src/weapon/vgr_qj2_pulsecannonturret_left src/weapon/vgr_qj2_pulsecannonturret_right src/weapon/vgr_vj_pulsecannonturret_left src/weapon/vgr_vj_pulsecannonturret_right src/weapon/vgr_qj2_scattershotturret_left src/weapon/vgr_qj2_scattershotturret_right src/weapon/vgr_qj2_superlanceturret src/weapon/vgr_qj2_superlanceturretside src/weapon/vgr_vj_superlanceturret src/weapon/vgr_vj_rapidlaserturret src/weapon/vgr_vulcanpulseturret
git commit -m "Tune flagship weapon ranges, velocity, cadence, penetration"
```

---

## Task 7: Superweapons (top tier) & mines

Light touch: these are intentional outliers. Apply only the **penetration profile + strength**, and pull any range that exceeds the superweapon tier into 10000–20000. Do **not** rework cadence/velocity (their feel is deliberate).

**Files (Modify):** `sri_dreadnaughtautogun`, `sri_dreadnaughtchinturret`, `sri_dreadnaughtioncannon`, `sri_sajuukheavycannon`, `sri_sajuukkineticdriver`, `sri_sajuuknanitecannon`, `hgn_minelauncher`, `hgn_bc_minelauncher`.

**Targets:**

| File | profile | strength | range note |
|---|---|---|---|
| sri_dreadnaughtautogun | superweapon | 100 | keep 4000 |
| sri_dreadnaughtchinturret | superweapon | 100 | keep 8000 |
| sri_dreadnaughtioncannon | superweapon | 100 | keep 9000 |
| sri_sajuukheavycannon | superweapon | 100 | keep 20000 |
| sri_sajuukkineticdriver | superweapon | 100 | keep 7500 |
| sri_sajuuknanitecannon | superweapon | 100 | keep 7500 |
| hgn_minelauncher | generalist | 30 | keep 12000 (deployment) |
| hgn_bc_minelauncher | generalist | 60 | keep 12000 (deployment) |

- [ ] **Step 1: Edit `setPenetration` only** (profile + strength) on each file. Leave `StartWeaponConfig` untouched except trimming any range >20000 down to 20000 (none expected). Mines keep all `StartWeaponConfig` values.

- [ ] **Step 2: Validate**

Run: `pwsh -NoProfile -File tools\weapon-dps.ps1 -Weapon sri`
Expected: all `sri_*` `Dmg` and `Interval` unchanged from baseline.
Run: `git grep -n "setPenetration(NewWeaponType, 100," src/weapon/sri_sajuukheavycannon src/weapon/sri_dreadnaughtioncannon`
Expected: strength `100`.

- [ ] **Step 3: Commit**

```bash
git add src/weapon/sri_dreadnaughtautogun src/weapon/sri_dreadnaughtchinturret src/weapon/sri_dreadnaughtioncannon src/weapon/sri_sajuukheavycannon src/weapon/sri_sajuukkineticdriver src/weapon/sri_sajuuknanitecannon src/weapon/hgn_minelauncher src/weapon/hgn_bc_minelauncher
git commit -m "Tune superweapon and mine penetration profiles"
```

---

## Task 8: Spawned burst sub-weapons (penetration alignment only)

These fire at an impact point via `SpawnWeaponFire` and have no engagement range/cadence of their own. Align their **penetration profile** to their parent's role; leave `StartWeaponConfig` untouched.

**Files (Modify `setPenetration` only):**
- `src/weapon/vgr_pulsecannonburst/...` → generalist, strength 30 (parent: concussion missile family).
- `src/weapon/vgr_bc_swarmmissile/...` → anti-strike, strength 60 (BC anti-strike burst).
- `src/weapon/hgn_plasmaburst/...` → anti-strike, strength 5.
- `src/weapon/neu_nuclearblast/...` → siege, strength 100.

- [ ] **Step 1: Edit `setPenetration` only** on the four files above (canonical block, profile + strength).

- [ ] **Step 2: Validate**

Run: `pwsh -NoProfile -File tools\weapon-dps.ps1 -Weapon burst`
Expected: `vgr_pulsecannonburst` / `vgr_bc_swarmmissile` `Dmg` unchanged (125.00 / 635.00).

- [ ] **Step 3: Commit**

```bash
git add src/weapon/vgr_pulsecannonburst src/weapon/vgr_bc_swarmmissile src/weapon/hgn_plasmaburst src/weapon/neu_nuclearblast
git commit -m "Align spawned burst sub-weapon penetration profiles"
```

---

## Task 9: Sensor-range follow-up (`.ship`)

Make each hull's **primary sensor range ≥ its longest standard weapon** (so it can see what it shoots). Only raise where currently below the band; never lower below current.

**Files (Modify `prmSensorRange`; raise `secSensorRange` to keep ≥ primary):**

| Ship file(s) | prmSensorRange target |
|---|---|
| `hgn_interceptor`, `vgr_interceptor`, `vgr_bomber`, `vgr_lancefighter` | ≥ 3000 (already 3000 — no change) |
| `hgn_assaultcorvette`, `hgn_pulsarcorvette`, `vgr_lasercorvette`, `vgr_missilecorvette` | ≥ 4000 (already 4000 — no change) |
| `hgn_assaultfrigate`, `hgn_ioncannonfrigate`, `hgn_torpedofrigate`, `vgr_assaultfrigate`, `vgr_heavymissilefrigate` | ≥ 5000 (already 5000 — no change) |
| `hgn_destroyer`, `vgr_destroyer` | ≥ 6500 (already 6500 — no change) |
| `hgn_battlecruiser`, `vgr_battlecruiser` | raise 7000 → 8000 |
| `hgn_heavycruiser`, `vgr_qwaarjetii`, `vgr_vanaarjet` | ≥ 9000 (already 9000 — no change) |

> Net effect: only the two battlecruisers need a sensor bump (their longest standard gun is now range 7500, above the current 7000 sensor). If a later playtest shows a hull's specialist over-range weapon (siege) wants spotting, raise `secSensorRange`, not primary.

- [ ] **Step 1: Edit `hgn_battlecruiser.ship` and `vgr_battlecruiser.ship`** — set `prmSensorRange = 8000` (leave `secSensorRange` at 16000, already ≥ primary).

- [ ] **Step 2: Validate**

Run: `pwsh -NoProfile -File tools\ship-stats.ps1 2>&1 | Select-String battlecruiser`
Expected: both battlecruisers show `prmSensorRange` 8000.

- [ ] **Step 3: Commit**

```bash
git add src/ship/hgn_battlecruiser src/ship/vgr_battlecruiser
git commit -m "Raise battlecruiser sensor range to match tuned weapon reach"
```

---

## Task 10: Final validation sweep & doc note

- [ ] **Step 1: Full DPS/penetration sweep**

Run: `pwsh -NoProfile -File tools\weapon-dps.ps1`
Expected: no combat weapon's `Dmg` differs from the pre-tuning baseline; the 8s/5s cadence outliers are gone; `Beam` column populated for all `InstantHit` weapons.

- [ ] **Step 2: Penetration-strength sweep**

Run (PowerShell): `Get-ChildItem src\weapon -Recurse -Filter *.wepn | Select-String -Pattern 'setPenetration\(NewWeaponType,\s*(\d+)' | ForEach-Object { $_.Matches.Groups[1].Value } | Group-Object | Sort-Object Name | Format-Table Name,Count`
Expected: only strengths `5`, `30`, `60`, `100` appear (plus `0` only if `sri_dreadnaughtautogun` was intentionally left at its baseline; Task 7 otherwise sets it to `100`).

- [ ] **Step 3: Range-band sweep**

Run: `pwsh -NoProfile -File tools\weapon-dps.ps1` and manually confirm against the range table, or `git grep -n "StartWeaponConfig" src/weapon` and spot-check arg6 sits in each hull's band / documented over-range.

- [ ] **Step 4: Update `docs/weapon_definitions.md`** — append a short "Tuning conventions" subsection summarizing the range bands, cadence ladder, penetration profiles, and strength tiers (point to this plan and the spec), so future weapons follow the system.

- [ ] **Step 5: Commit**

```bash
git add docs/weapon_definitions.md
git commit -m "Document weapon tuning conventions"
```

---

## Self-Review Notes (coverage vs. spec)

- Axis 1 Range → Tasks 2–7 (per-class arg6) + Task 9 (sensors). ✓
- Axis 2 Cadence → Tasks 2–6 (arg14 ladder) + Task 10 budget check. ✓
- Axis 3 Penetration → Tasks 2–8 (profiles + strength). ✓
- Axis 4 Velocity/Tracking/Accuracy → Tasks 2–6 (arg5, arg19/20). **Accuracy (`setAccuracy`) is folded into the profile intent but not given per-weapon numbers here** — if playtest shows capital weapons still hitting strikecraft, a follow-up task sets `setAccuracy` Fighter/Corvette low on anti-capital/siege weapons. Flagged as a known deferral, consistent with "playtest is final authority."
- Host-ambiguous weapons → confirm steps in Tasks 3, 5, 6. ✓
