# Weapon Tuning — Design Spec

- **Date:** 2026-06-28
- **Status:** Approved framework + reviewer addenda (2026-06-28), pending implementation plan
- **Scope:** Re-tune non-damage weapon properties across `src/weapon/*.wepn` to a
  coherent, class-based system. **Per-hit damage values are NOT changed.**

## Problem

The 61 `.wepn` files were authored piecemeal. Damage-per-hit feels right, but the
*other* properties — firing range, projectile velocity, fire cadence, turret tracking,
penetration strength, and per-armour multipliers — are internally inconsistent and don't
express any single design intent. Concrete symptoms found in the current files:

- **Range vs. hull is incoherent.** `hgn_bc_gatlinggunturret` reaches 10000 (its BC only
  sees 7000); `vgr_bcforwardweapon` 15000; `vgr_bc_sunshattermissile` 14000. Meanwhile the
  Hiigaran *frigate* gatling fires at 2500 but a *corvette* pulsar reaches 5500–6500 — a
  bigger, slower ship out-ranged by a smaller, faster one.
- **Fire cadence has wild outliers.** `hgn_vulcanplasmaturret` fires every 8s and
  `vgr_dd_pulsecannonturret` every 5s, while same-class siblings fire 10–25× faster.
- **Penetration is unsystematic.** The leading `setPenetration` strength number is
  scattered across `5 / 30 / 60 / 100` with no consistent mapping, and per-armour
  multipliers vary weapon-to-weapon without a role rationale.
- **Velocity nonsense.** Several missile launchers use `40` m/s launch velocity.
- **Turret tracking is inverted** on several capital guns (slow point-defense, fast
  capital mains).

## Goals

1. Range, cadence, penetration, velocity, tracking, and accuracy each follow **one stated
   rule**, applied uniformly, so the sandbox reads as a designed rock-paper-scissors arena.
2. Preserve the per-hit damage numbers (the author is happy with lethality magnitude).
3. Leave the files readable: keep/refresh the header role comments; change only the values
   the rules dictate.

## Non-Goals

- No change to `.ship` / `.subs` loadout wiring, hardpoint slots, or which weapon a ship
  carries.
- No change to per-hit `DamageHealth` values.
- No new weapons; no `.wf` / `.miss` / FX changes (a velocity fix may require reading a
  `.miss` to confirm, but not editing it unless a launch-speed lives there).
- Superweapons are tuned to their own top tier, not folded into same-class TTK math.

## Design Decisions

### Axis 1 — Range: class hierarchy

Standard direct-fire weapon range is set by the **carrying hull's class**. Bigger always
out-reaches smaller. Sensors get a follow-up pass so a hull's primary sensor ≥ its longest
standard weapon (it can see what it shoots).

| Class | Std weapon range | Primary sensor target |
|---|---|---|
| Strikecraft | 2500 | 3000 |
| Corvette | 3500 | 4000 |
| Frigate | 4500 | 5000 |
| Destroyer | 6000 | 6500 |
| Battlecruiser | 7500 | 8000 |
| Flagship | 9000 | 9500 |
| Superweapon (Dreadnaught/Sajuuk) | 10000+ | top tier |

> **Hiigaran heavy cruiser** is flagship-tier (320 000 HP — the tankiest hull). Its exact
> turret list is to be confirmed from `hgn_heavycruiser.ship` during implementation; it
> likely re-uses `hgn_bc_*` turrets. Apply the **Flagship** range band (9000 / 9500
> sensor) to its standard weapons, and feed its own 320 000 HP into the cadence math.

**Over-range specialist exceptions** (the *only* weapons allowed past their hull band):

- **Anti-capital beams (sniper sub-band):** `InstantHit` anti-capital weapons (ion-beam
  frigate, BC beam laser, flagship superlances) keep a reach premium of **×1.25 over the
  hull band, capped at 9500**, preserving the established "out-range what you can't
  outrun" beam identity. Examples: frigate ion 4500→5625, BC beam 7500→9375, flagship
  superlance 9000→9500 (capped). They pay for the reach through slow tracking + low
  small-target accuracy, *not* through shorter range.
- **Siege / spinal** (torpedoes, sunshatter, BC forward ion): up to ≈ +40% over the hull
  band (e.g. a BC spinal ≈ 10500, BC siege missile long).
- **Mines:** range is *deployment* distance, not engagement; left on a separate long value
  (current 12000 retained unless playtest says otherwise).

`Bullet`/`Missile` `velocity` is a separate property (Axis 4); the range value here is
arg 6 (max firing range), and for beams (`InstantHit`) the same band applies to arg 6.

### Axis 2 — Cadence: derive intervals from per-class TTK

Per-hit damage is the fixed building block; the **fire interval (arg 14) is the derived
knob**. Target same-class time-to-kill for a hull's *default* offensive loadout:

| Matchup | TTK | Required sustained DPS = health ÷ TTK |
|---|---|---|
| Strikecraft | ~4s | 400 ÷ 4 ≈ 100 |
| Corvette | ~6s | 4000 ÷ 6 ≈ 670 |
| Frigate | ~12s | 16000 ÷ 12 ≈ 1330 |
| Destroyer | ~20s | 75000 ÷ 20 ≈ 3750 |
| Battlecruiser | ~30s | 250000 ÷ 30 ≈ 8330 |
| Flagship | ~40s | 240000 ÷ 40 ≈ 6000 |
| Heavy cruiser (HGN flagship) | ~40s | 320000 ÷ 40 ≈ 8000 |

> **Design artifact (conscious):** because flagships are both more durable *and* get the
> longest TTK, their required DPS (~6000) lands *below* a BC's (~8330). Flagships
> therefore grind slightly slower than BCs — a defensible "more HP, longer fight" outcome
> consistent with the durability philosophy, called out so it's a choice, not a surprise.

**Derivation method (per hull):**

1. Read the hull's `.ship` / `.subs` to find its **default** offensive weapons (the first
   option on each weapon hardpoint + any fixed weapons) and how many barrels bear.
2. Sum per-hit damage across that default loadout = `dmgPerVolley`.
3. Set each weapon's interval so the combined sustained DPS ≈ the table's required DPS:
   `interval ≈ dmgPerVolley ÷ requiredDPS`, then distribute so sibling weapons on the same
   hull share a sane, consistent cadence by archetype (rapid guns fast, heavy guns slow)
   rather than every barrel landing on the identical number.
4. Beams (`InstantHit`) deal continuous damage the interval doesn't capture — tune by
   playtest feel toward the same TTK; `weapon-dps.ps1` flags them as unreliable estimates.

The estimate is a starting point; final cadence is an in-engine playtest. `weapon-dps.ps1`
is the static check (now fixed to read arg 14 correctly, sum all `DamageHealth`, and flag
`InstantHit` beams).

### Axis 3 — Penetration: role profiles + tiered strength

**Per-armour multiplier profiles** (the counter system). Each weapon adopts exactly one:

| Profile | Unarm | Light | Med | Heavy | SubSys | Turret | PlanetKiller |
|---|---|---|---|---|---|---|---|
| Anti-strike (gatling / flak / PD) | 1.0 | 1.0 | 0.5 | 0.2 | 0.5 | 1.0 | 0 |
| Generalist (pulse / laser / autocannon) | 1.0 | 1.0 | 0.8 | 0.5 | 0.7 | 1.2 | 0 |
| Anti-capital (ion / lance / heavy cannon) | 0.5 | 0.4 | 0.8 | 1.0 | 1.0 | 1.5 | 0 |
| Siege (torpedo / sunshatter / spinal) | 0.5 | 0.6 | 1.0 | 1.0 | 1.0 | 1.0 | >0 |
| Superweapon (Sajuuk / Dread ion) | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1.5 | 1.0 |

`MoverArmour`, `ResArmour`, `MineArmour`, `ChunkArmour` retain sensible defaults
(`MineArmour`/`ChunkArmour` = 1; `ResArmour` ≈ Medium of the profile). The exact trailing
table follows the canonical TPOF armour-class list (see `docs/weapon_definitions.md`).

**Strength-number tiers** (the leading `setPenetration` value):

| Tier | Strength | Weapons |
|---|---|---|
| Strikecraft | 5 | interceptor/fighter/corvette guns |
| Frigate / Destroyer | 30 | frigate + destroyer guns |
| Capital | 60 | BC + flagship guns |
| Siege / Superweapon | 100 | torpedoes, spinal ion, Sajuuk/Dread |

> The strength number's exact engine effect is **undocumented** (see
> `docs/weapon_definitions.md`). These tiers are a **consistency cleanup**, not a proven
> balance lever — the per-armour multiplier profiles above do the real counter work.
> Treat strength re-tiering as cosmetic until playtest shows otherwise; don't credit or
> blame it for balance shifts the multipliers actually cause.

### Axis 4 — Supporting properties (so the counters actually work)

- **Velocity (arg 5):** rule `velocity ≥ 3 × fastest intended target speed` AND
  `velocity ≥ range ÷ 2` (flight time ≤ ~2s). Fix the `40` m/s missile launch speeds; for
  `Missile` types confirm whether actual flight speed lives in the `.miss` before changing
  arg 5 (do not edit the `.miss`). Beams/`InstantHit` are instant — leave velocity 0.
- **Turret tracking (args 19–20):** anti-strike / PD = fast (≥120°/s); generalist =
  medium (60–75); anti-capital = slow (≤40). Currently inverted on several capital mains —
  normalize. This is the "can't track" half of the counter system.
- **Accuracy (`setAccuracy`):** align to profile. Anti-capital/siege weapons get low
  `Fighter`/`Corvette` hit chance (can't reliably hit small fast targets); anti-strike
  weapons get high. This is the "can't hit" half of the counter system, complementing
  penetration's "can't hurt" half.

## Weapon Classification (archetype per file)

Host-class inferred from naming (`_bc_`=BC, `_dd_`=Destroyer, `_ff_`=Frigate,
`qj2`/`vj`=Flagship, no infix + fighter/corvette name = Strikecraft/Corvette). Ambiguous
host mappings are flagged to confirm by reading the `.ship`/`.subs` during implementation.

- **Strikecraft / Corvette, anti-strike:** `hgn_interceptor_cannon`,
  `hgn_interceptor_beam`, `vgr_pulsecannon`, `vgr_laser`, `vgr_autocannon`, `hgn_pulsar`,
  `hgn_pulsarside`.
- **Strikecraft, generalist/anti-capital (bomber):** `vgr_bomberplasmadriver`,
  `vgr_lightplasmalance`.
- **Frigate:** `hgn_ff_gatlinggunturret` (anti-strike), `hgn_ff_ionbeamturret`
  (anti-capital beam), `vgr_pulsecannonassaultfrigate{left,right,bottom}` (generalist),
  `vgr_concussionmissilelauncher` (generalist), `vgr_heavyconcussionmissilelauncher`
  (anti-capital — *confirm host*), `hgn_hc_nucleartorpedolauncher` (siege — *confirm host*).
- **Destroyer:** `hgn_dd_gatlinggunturret` (anti-strike), `hgn_dd_plasmaburstturret`
  (flak/anti-strike), `vgr_dd_rapidlaserturret` (anti-strike),
  `vgr_dd_scattershotturret` (flak), `vgr_dd_pulsecannonturret` (generalist),
  `vgr_dd_missileboxturret` (anti-capital).
- **Battlecruiser:** `hgn_bc_gatlinggunturret` (anti-strike),
  `hgn_bc_plasmaburstturret{,_left,_right}` (generalist), `vgr_bclaser` (anti-capital
  beam), `vgr_bcforwardweapon` (siege/spinal), `vgr_bc_concussionmissile` (anti-strike),
  `vgr_bc_swarmmissile` (anti-strike burst), `vgr_bc_sunshattermissile` (siege),
  `vgr_heavyfusionmissilelauncherbc` (siege), `hgn_bc_minelauncher` (mine),
  `hgn_mshulldefensegun{,side}` (PD/anti-strike), `hgn_vulcanplasmaturret` (PD/anti-strike
  — *confirm host*).
- **Flagship:** `vgr_qj2_pulsecannonturret_{left,right}` /
  `vgr_vj_pulsecannonturret_{left,right}` (generalist),
  `vgr_qj2_scattershotturret_{left,right}` (flak), `vgr_vj_rapidlaserturret` (anti-strike),
  `vgr_qj2_superlanceturret{,side}` / `vgr_vj_superlanceturret` (anti-capital beam),
  `vgr_vulcanpulseturret` (PD/anti-strike — *confirm host*).
- **Mines (special, range = deployment):** `hgn_minelauncher`, `hgn_bc_minelauncher`.
- **Superweapon top tier:** `sri_dreadnaughtautogun`, `sri_dreadnaughtchinturret`,
  `sri_dreadnaughtioncannon`, `sri_sajuukheavycannon`, `sri_sajuukkineticdriver`,
  `sri_sajuuknanitecannon`.
- **Spawned burst sub-weapons (no range/cadence pass; inherit parent profile, damage
  fixed):** `vgr_pulsecannonburst`, `vgr_bc_swarmmissile` burst, `hgn_plasmaburst`,
  `neu_nuclearblast`.
- **Excluded (not combat — no pass):** `neu_thruster`, `vgr_booster_front`,
  `vgr_booster_rear`.

## Validation

1. `tools/weapon-dps.ps1` before/after — confirm no weapon's per-hit `Dmg` changed, and
   intervals/DPS move toward the per-class targets.
2. `tools/ship-stats.ps1 -Diff <ref>` — confirm sensor-range follow-up edits and nothing
   else on the ship side moved.
3. Spot-grep `setPenetration` leading numbers — confirm they collapse to `{5,30,60,100}`.
4. Spot-grep ranges (arg 6) — confirm each weapon sits in its hull band or is a documented
   over-range specialist.
5. In-engine playtest is the final authority for cadence/TTK and beam DPS.

## Guardrails / Invariants

- Never touch `keeper.txt` files (required by the big-file packer).
- Keep each file's header role comment; add a one-line note when a value changes for a
  non-obvious reason.
- Edit only the dictated values; leave `setMiscValues`, `addAnimTurretSound`, and FX names
  alone.
- Per-hit `DamageHealth` bounds are immutable in this pass.
- **Capital PD invariant:** every capital / flagship hull's *default* loadout must retain
  at least one anti-strike / point-defense weapon, so the anti-capital counter stack (low
  small-target accuracy + slow tracking + low light-armour multiplier) can't leave an
  irreplaceable capital defenseless against cheap strikecraft. Verify when reading each
  `.ship` / `.subs`.
