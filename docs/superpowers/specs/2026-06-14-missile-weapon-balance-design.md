# Missile Weapon Balance — Design

**Date:** 2026-06-14
**Status:** Approved (pending spec review)

## Goal

Bring every missile / torpedo launcher in TPOF into the same effective-DPS band as
the rest of the game's capital-class weapons, **while keeping the fast firing
cadence** introduced in the preceding `fireTime` changes. Missiles are currently
extreme outliers — the Battlecruiser siege missiles and the Heavy-BC nuclear
launcher sit far above the band, while the basic concussion launcher sits far
below it.

## Reference band

From the weapon audit, the game's capital-class **direct-fire** weapons cluster
around **~300–600 DPS** (e.g. pulsecannon turrets ~400, ion forward gun ~450,
plasmaburst turret ~550). Rapid anti-strikecraft guns and SRI super-weapons are
deliberate outliers outside this band and are out of scope.

DPS here means the first-order proxy:

```
effectiveDPS = (directDamage + spawnedBurstDamage) / fireTime
```

This is exact for single-shot weapons (where `fireTime` is the shot interval) and
ignores penetration tables — penetration is what differentiates *roles*
(anti-strikecraft vs anti-capital) and is **not** changed by this work. Two tiers:

- **Standard / anti-frigate missiles → ~450 DPS**
- **Long-range siege missiles → ~550 DPS** (upper band, earned by long range,
  projectile travel time, and single-target alpha)
- **Mid-tier ship torpedoes → ~380 DPS** (low-mid band; the HGN mine/torpedo
  launchers mount on the Destroyer and Torpedo Frigate, not capital hulls)

## Method

Keep each weapon's current `fireTime` (the fast cadence). Re-derive per-shot
damage from the target DPS:

```
newDirectDamage = targetDPS * fireTime - spawnedBurstDamage
```

Spawned-burst damage (`vgr_pulsecannonburst` and `hgn_plasmaburst` both deal 125
on impact) is folded into the total so the spawned splash counts toward DPS.

## Per-weapon changes

| Weapon | fireTime (kept) | Field | Old | New | Result |
|---|---|---|---|---|---|
| `vgr_bc_concussionmissile` | 0.8 | DamageHealth | 1500 | **235** | ~450 DPS (+125 burst) |
| `vgr_heavyconcussionmissilelauncher` | 0.8 | DamageHealth | 250–500 | **235** | ~450 DPS (+125 burst) |
| `vgr_bc_sunshattermissile` | 8 | DamageHealth | 15000 | **4400** | ~550 DPS, keeps huge alpha |
| `vgr_heavyfusionmissilelauncherbc` | 4 | DamageHealth | 7500 | **2200** | ~550 DPS |
| `hgn_minelauncher` | 4 | DamageHealth | 500 | **1400** | ~380 DPS (+125 burst) |
| `hgn_bc_minelauncher` | 4 | DamageHealth | 500 | **1400** | ~380 DPS (+125 burst) |
| `hgn_nuclearminelauncher` | 6 | DamageHealth | 4400 | **1500** | ~580 single-target |
| `neu_nuclearblast` (nuke AoE, used only by the launcher above) | — | DamageHealth | 8500–10000 | **2000** | splash kept, no one-shot |

### Special cases

**`vgr_concussionmissilelauncher` (basic buildable)** — currently has *no* direct
damage line; its only output is the spawned `vgr_pulsecannonburst` (~125), giving
~45 DPS. At its slow 2.8s cadence, reaching even the low band would require higher
per-shot alpha than the "heavy" variant, which inverts the tiering. **Cleaner
fix (approved):** drop `fireTime` 2.8 → **1.2** and add a direct `DamageHealth` of
**355**, giving ~400 DPS with sensible alpha. This is the one weapon that
intentionally breaks the "keep cadence" rule.

**`vgr_bc_swarmmissile`** — a `SphereBurst` with `fireTime 0` (instant burst, no
cooldown). The `damage / fireTime` formula does not apply, so its true DPS cannot
be derived from static config. Its header comment also mis-states the damage
(claims "235 × 32 = ~7500/burst"; the code sets `DamageHealth 635`). **Action:**
correct the comment to reflect reality and flag for an in-game DPS measurement
pass; **do not change mechanics blind.** Target once measured: ~450–550 DPS.

**`vgr_dd_missileboxturret`** — low-alpha anti-strikecraft burst turret already
roughly in line with other anti-strike weapons. **Left untouched.**

## Comment maintenance

Inline tuning comments that cite specific damage/DPS numbers will be updated to
the new values:

- `vgr_bc_concussionmissile`: now standard band (~450 DPS), no longer on the
  siege baseline — reword accordingly.
- `vgr_bc_sunshattermissile`: now 4400 dmg / cooldown 8 = ~550 DPS; still matches
  the heavy-fusion siege baseline (2200 / 4 = ~550).

## Out of scope

- Penetration tables, range, projectile speed (role identity — unchanged).
- All non-missile weapons (guns, beams, scatter, super-weapons).
- `vgr_bc_swarmmissile` mechanics (deferred to in-game measurement).
- `vgr_dd_missileboxturret`.

## Verification

Changes are static `.wepn` edits; the mod must be repacked
(`tools\build-tpof.ps1 -Install`) to test in-game. Post-change, re-run the audit
DPS proxy to confirm every touched weapon lands in its target band, and measure
`vgr_bc_swarmmissile` live to set its damage.
