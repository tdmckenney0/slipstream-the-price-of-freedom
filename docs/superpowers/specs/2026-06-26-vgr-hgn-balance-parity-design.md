# VGR→HGN Balance Parity Pass — Design Spec

**Date:** 2026-06-26
**Status:** Implemented (pending playtest tuning)
**Validated 2026-06-27:** Headless checks pass — `ship-stats.ps1` diff vs base `8146c6b` shows only the 5 intended VGR ships changed; `weapon-dps.ps1` confirms destroyer missilebox 1650 / scattershot 450 / interceptor pulsecannon 90, all other VGR weapons unchanged; `TPOF.big` packs cleanly (338 MB). Scenario combatants (sri_dreadnaught 550k, sri_sajuuk 400k, command base, prison station, meg furniture) remain coherent — no changes. **Pending:** in-engine `parse-logs` and a VGR-vs-HGN playtest to tune the flagged dials (destroyer `unitCapsNumber`, frigate rotation 80, interceptor damage, corvette nudge).
**Author:** balance run (HGN identified as overpowered vs VGR; ref `docs/todo.md` "Balance Run — Yeah the Hiigarans obliterate the Vaygr")

## Goal

Bring Vaygr (VGR) to competitive parity with Hiigaran (HGN) in standard
HGN-vs-VGR multiplayer. HGN is the reference and stays put (the "high-water mark");
VGR is raised to meet it. Preserve the mod's "everything is fast and durable"
power fantasy — close the gap by **buffing VGR**, not by nerfing HGN.

## Approved decisions (from brainstorming)

1. **Direction:** Buff VGR up to HGN; leave HGN as-is.
2. **Approach A — targeted parity pass:** class-by-class, raise VGR's *deficient*
   stats toward the HGN counterpart; preserve VGR identity (alpha-strike missiles,
   broadside frigates, top speed, strikecraft variety); right-size VGR's
   over-compensations so buffs land at parity, not superiority.
3. **Economy normalization: YES.** VGR is 10–40% cheaper; once it is equally
   durable/nimble that discount is pure advantage, so VGR costs rise toward HGN.
4. **Destroyer build time: 60s for both.** VGR destroyer 165s → 60s (pure VGR
   buff; HGN untouched at 60s).
5. **Heavy capitals: verify only** — do not stack HGN HP onto VGR heavies.
6. **Scope = "everything,"** handled by tier (see Scope).

## Method & data provenance

- Hull/mobility/economy stats pulled from every `.ship` via `tools/ship-stats.ps1`.
- Weapon DPS extracted from every `.wepn` via a parser (`scratchpad/weapon-dps.ps1`,
  to be promoted to `tools/` — see Implementation). The `StartWeaponConfig` format
  is undocumented in-repo; decoded empirically: **the 10th numeric argument is the
  inter-shot interval in seconds.** Sustained DPS = avg(DamageHealth) / interval.
- **Caveats (must verify in-engine):**
  - **Beam** weapons (ion beam) deal continuous damage; the naive formula
    *under-counts* them.
  - **Burst** weapons (those with `SpawnWeaponFire`, e.g. `vgr_dd_pulsecannonturret`
    → `vgr_pulsecannonburst`) spawn extra salvos; naive DPS is a *floor*.
  - **Multi-pellet** weapons (scattershot/flak, "vulcan") may fire multiple
    projectiles per shot; naive DPS may *under-count*.
  - Per-mount DPS ignores firing arcs; broadside/PD mounts can't all hit one target.
  - Final authority on weapon balance is **playtest**, not the spreadsheet.

## Diagnosis — per-class findings

Total ship DPS = per-mount DPS × mount count (fixed + swappable). Swappable
capital turret slots default empty and the AI fits them itself (see
`memory/ai_subsystem_constants_and_arming.md`); totals below assume both swappable
slots filled.

| Class | HGN | VGR | Verdict |
|---|---|---|---|
| **Destroyer** | 75k HP, rot 19, ~7000–7800 DPS, build 60s, cost 5000, cap 3 | 70k HP, rot 11, ~2400–3400 DPS, build 165s, cost 3000, cap 4 | **HGN dominant (~2–2.5× DPS + tankier + nimbler). PRIMARY FIX.** |
| **Battlecruiser** | 250k HP, ~3484 DPS fixed + swap | 220k HP, ~3204 DPS fixed | Weapons even; **HP gap only.** |
| **Assault Frigate** | 16k HP, rot 150 | 14k HP, rot 28, broadside pulse ~1000 DPS | Weapons even; **HP + rotation gap.** |
| **Heavy Missile Frigate** | (cf. HGN torpedo/ion frigates) 16k, rot 150 | 14k HP, rot 28, missile alpha | Weapons even; **HP + rotation gap.** |
| **Corvettes** | 4k HP, rot 219–313, pulsar 155 / vulcan ~34 DPS | 3.5k HP, rot 164, laser 200 / missile 296 DPS | **Already fair** — VGR out-guns, HGN out-tanks/turns. Minimal/no change. |
| **Interceptor** | 400 HP, ~150+ DPS, squad 5 | 300 HP, 30 DPS, squad 7 | HGN-favored, but VGR adds bomber + lancefighter. **Modest buff.** |
| **Heavy caps** | heavycruiser 320k HP | qwaarjetii ~12,500 DPS / vanaarjet ~8,950 DPS, 240k/280k HP | **Already fair / VGR-favored on alpha. Verify only — no HP buff.** |

**Headline:** This is chiefly a **destroyer** problem, plus durability/mobility
gaps on **capitals and frigates**. It is *not* "VGR is weaker everywhere" —
corvettes and heavy caps are already balanced asymmetric trades and must not be
over-buffed.

## Changes

All changes are to VGR files only (plus one shared verification of HGN parity
references). Exact weapon numbers finalized during implementation against a
re-run DPS table; **bold** = high confidence, *italic* = playtest-tuned.

### Tier 1 — Destroyer (primary)

`vgr_destroyer.ship`:
- `maxhealth` 70000 → **75000**
- `rotationMaxSpeed` 11 → **19**
- `buildTime` 165 → **60**
- `buildCost` 3000 → **4500** (economy normalization; removes the largest discount)
- `unitCapsNumber` 4 → *3* (match HGN so VGR fields equal destroyer numbers — verify cap math)

VGR destroyer swappable turrets — raise sustained DPS into HGN's ~1650–2000 band
while keeping each turret's character (adjust per-hit damage and/or interval):
- `vgr_dd_missileboxturret` (~562 DPS) → *~1650* (missile feel: raise damage/rate)
- `vgr_dd_scattershotturret` (~225 DPS, flak) → *~1650* (verify pellet count first)
- `vgr_dd_pulsecannonturret` (~45 + burst) → *~1650 effective* (raise burst salvo)
- `vgr_dd_rapidlaserturret` (~45, PD) → *leave low or modest* (keep an anti-strike PD option)

Fixed weapons (`vgr_bclaser` ×4, `vgr_bcforwardweapon`, fusion missile) are shared
with other ships — review but prefer turret changes to avoid side effects.

### Tier 1 — Battlecruiser

`vgr_battlecruiser.ship`:
- `maxhealth` 220000 → **250000**
- `buildCost` 4500 → *4900* (normalization toward HGN 5000)
- Weapons: comparable — **leave.**

### Tier 1 — Frigates

`vgr_assaultfrigate.ship`:
- `maxhealth` 14000 → **16000**
- `rotationMaxSpeed` 28 → *80* (closes most of the gap; stays below HGN 150 to keep
  the heavy broadside feel — tunable)
- `buildCost` 650 → *800*

`vgr_heavymissilefrigate.ship`:
- `maxhealth` 14000 → **16000**
- `rotationMaxSpeed` 28 → *80*
- `buildCost` 700 → *800*
- Weapons: missile alpha — **leave.**

### Tier 1 — Interceptor (modest)

`vgr_interceptor.ship`:
- `maxhealth` 300 → **400**
- `rotationMaxSpeed` 131 → *160* (optional)
- `vgr_pulsecannon` 30 DPS → *raise toward ~100–150* (do not exceed HGN given VGR's
  broader strikecraft roster)

### Tier 1 — Corvettes (minimal — already fair)

`vgr_lasercorvette.ship` / `vgr_missilecorvette.ship`:
- *Tentative* `maxhealth` 3500 → 4000 (HP parity), **hold rotation at 164** (lower
  rotation is the fair trade for VGR's higher corvette DPS). Default to **no change
  pending playtest** if the asymmetric trade already feels balanced.

### Tier 1 — VGR-unique strikecraft

`vgr_bomber.ship`, `vgr_lancefighter.ship`: VGR identity — **leave** (optional tiny
HP consistency nudge only).

### Tier 2 — Heavy capitals (verify only)

`vgr_qwaarjetii.ship`, `vgr_vanaarjet.ship`: **no HP buff.** Their alpha already
offsets the HP deficit vs HGN heavycruiser (320k). Optional `buildCost` 10000 →
*11000* toward HGN 12000. Confirm head-to-head in playtest before any change.

### Tier 3 — Scenario combatants (consistency check only)

`sri_dreadnaught` (550k, super-unit), `sri_sajuuk`, `sri_commandbase`, `sri_drone`,
`vgr_prisonstation`, `meg_chimera`/`meg_leviathan` if combat-capable: verify they
sit coherently in the power band; change only obvious bugs. They are boss/super
units by design, **not** subject to race-parity tuning.

## Scope

- **In:** all HGN-vs-VGR combat ships (Tiers 1–2) + a consistency check of scenario
  combatants (Tier 3).
- **Excluded:** invulnerable map furniture — `meg_slipgate`, `meg_starjumper`,
  `meg_leviathan` (if non-combat), `meg_asteroid_inhibitor`, Bentusi ruins,
  Tanis structures (400M–10B HP set-dressing).
- **Untouched:** resource collectors/controllers (already mirrored between races).

## Non-goals

- No HGN nerfs. (The only HGN-adjacent item — destroyer build time — was resolved
  by bringing VGR *down to* HGN's 60s, not changing HGN.)
- Not folding in the separate `docs/todo.md` items (map starting resources, frigate
  formations, Kadiir positions, HGN Dreadnaught weapon config, nukes, icons).
- No new weapons, ships, or mechanics — stat/value tuning only.

## Validation

1. `tools/ship-stats.ps1 -GitRef HEAD -Changed` — confirm only intended hull deltas.
2. Re-run the weapon DPS parser — confirm VGR destroyer turrets land in the target band.
3. `tools/build-tpof.ps1 -Install` then `tools/parse-logs.ps1 -Errors` — no load/Lua errors.
4. **Playtest** at least one VGR-vs-HGN map: destroyer-vs-destroyer, frigate skirmish,
   and a heavy-cap opening engagement. Tune *italic* values from observed results.

## Open questions / playtest items

- VGR destroyer `unitCapsNumber` 4→3: confirm the cap families make this a real
  numbers buff before committing.
- Corvette HP nudge: needed, or is the current DPS-vs-durability trade already fair?
- Frigate rotation target (80): enough to matter without erasing broadside identity?
- Heavy-cap tier: does VGR's alpha truly offset 80k less HP in practice?
- HGN vulcan/burst real DPS: confirm corvette/burst weapons aren't badly under-counted.
