# Weapon Definitions (`.wepn` files)

`.wepn` files are the **mechanical** definition of a weapon — damage, range, projectile
velocity, rate of fire, turret tracking, accuracy-per-target-class, and
armour-penetration. They live in `src/weapon/{name}/{name}.wepn` and are referenced by
name (the directory name) from `StartShipWeaponConfig` / `StartSubSystemWeaponConfig`
calls in `.ship` / `.subs` files.

Do not confuse a `.wepn` with a `.wf`: the `.wepn` defines what the weapon *does*; the
[`.wf` weapon-fire script](weaponfire_scripts.md) defines what it *looks and sounds
like*. The chain is:

```
.ship / .subs                 StartShipWeaponConfig(ship, "hgn_bc_gatlinggunturret", ...)
  └─> .wepn  (this file)       names the weapon-fire effect + (for missiles) a .miss
        ├─> .wf  / stock FX    3rd arg of StartWeaponConfig — projectile/hit/fire FX & audio
        └─> .miss              for "Missile" / "SphereBurst" types, 3rd arg names a .miss
```

The weapon-fire effect named in the 3rd argument may be a TPOF `.wf`
(`vgr_pulsecannonburst`, `ionbeam`) **or** a stock Homeworld 2 effect baked into the
engine (`improved_plasma_bomb`, `energycannonmedium`) — there is no TPOF file for the
latter. For `Missile`/`SphereBurst` weapons the same argument instead names a `.miss`
missile definition under `src/missile/` (e.g. `Vgr_SmallMissile` →
`src/missile/vgr_smallmissile/`).

## Format

A `.wepn` is a Lua script that calls a small set of HW2 built-ins against the engine-
provided `NewWeaponType`. Every file calls `StartWeaponConfig` and at least one
`AddWeaponResult`; the `set*` calls are optional tuning. Trailing semicolons are
optional. Most TPOF `.wepn` files were decompiled from Lua bytecode (LuaDC), so
formatting varies; many carry a hand-written header comment describing the weapon's role
and balance intent — keep that convention when editing.

```lua
-- VGR Battlecruiser Swarm Missile Burst variant. Role: anti-strikecraft burst.
StartWeaponConfig(NewWeaponType, "AnimatedTurret", "Bullet", "improved_plasma_bomb",
    "Normal", 7500, 10000, 0, 0, 0, 0, 1, 1, 1, 0.2, 5, 10, 1, 0, 60, 60, 1,
    "Normal", 0, 0, 0)

AddWeaponResult(NewWeaponType, "Hit", "DamageHealth", "Target", 550, 550, "")
AddWeaponResult(NewWeaponType, "Hit", "Push",         "Target",   5,  10, "")

setAngles(NewWeaponType, 10, -160, 160, 0, 60)
setMiscValues(NewWeaponType, 4, 0.1)
setPenetration(NewWeaponType, 5, 1, { Unarmoured = 1, }, ... )
setAccuracy(NewWeaponType, 1, { Fighter = 0, }, ... )
addAnimTurretSound(NewWeaponType, "Data:Sound/SFX/...")
```

## `StartWeaponConfig` — the 25 positional arguments

The parameter meanings below come from the richly commented reference weapon
`refs\hwat-0-2-32-0-src\weapon\unh_ftbgun\unh_ftbgun.wepn`. Arguments are **positional**
— there are no defaults, so all 25 must be supplied in order after `NewWeaponType`.

| # | Example | Meaning |
|---|---------|---------|
| 1 | `"Gimble"` | **Mount type**: `Gimble`, `AnimatedTurret`, or `Fixed`. |
| 2 | `"Bullet"` | **Weapon type**: `InstantHit`, `Bullet`, `Mine`, `Missile`, or `SphereBurst`. |
| 3 | `"energycannonmedium"` | **Weapon-fire effect name** — a `.wf`/stock FX for guns/beams, or a `.miss` name for `Missile`/`SphereBurst`. |
| 4 | `"Normal"` | **Activation type**: `Normal`, `Special Attack`, `Normal Only`, or `Dropped`. |
| 5 | `1600` | **Projectile velocity** (≈ m/s). |
| 6 | `2103` | **Maximum firing range** — the range at which the weapon will open fire. Not necessarily the projectile's max travel distance. |
| 7 | `0` | **Blast radius** — only affects `SphereBurst` weapons. |
| 8 | `0` | **Projectile lifetime** — affects beams only (per karos' notes in the reference). |
| 9 | `0` | **Delay before firing / beam appearing** — beam weapons. |
| 10 | `0` | **Missile fire direction**: `0` = forward, `1` = left, `2` = up. |
| 11 | `1` | **MaxEffectsSpawned** — caps hit-effect spawns (keeps a beam from spawning too many). |
| 12 | `1` | **Lead target**: `1` leads the target; anything else fires without leading. |
| 13 | `1` | **Check for friendlies**: `1` holds fire when a friendly is in the line of fire; anything else fires regardless. |
| 14 | `3.75` | **Delay between shots in a burst**, seconds. This is the primary rate-of-fire knob; `tools\weapon-dps.ps1` reads it as the inter-shot interval. |
| 15 | `0` | **Burst duration**, seconds. |
| 16 | `0` | **Delay between bursts**, seconds. |
| 17 | `1` | **Bandbox targeting**: `1` picks bandbox targets when it can't hit the main target. |
| 18 | `1` | **Targets of opportunity**: `1` picks opportunity targets when it can't hit the main target (karos notes this is slow). |
| 19 | `60` | **Horizontal tracking speed** (≈ degrees/second). |
| 20 | `30` | **Vertical tracking speed** (≈ degrees/second). |
| 21 | `0.1` | **On-target tracking factor** — makes the gun track faster/slower once it's on target. |
| 22 | `"Normal"` | `Normal`, `Enhanced`, or `Bypass` — karos notes this has no observable effect. |
| 23 | `1` | **Track outside range**: `1` keeps tracking targets outside firing range; anything else doesn't. |
| 24 | `0` | **Wait for animation**: `1` waits for the `.mad` fire animation to finish before firing. |
| 25 | `0` | **Beam blow-through threshold** — beams punch through targets with less than this much health. |

## `AddWeaponResult` — what a shot does on hit/miss

Each call adds one effect that resolves when the weapon connects (or misses). A weapon
may have several — e.g. a gun that both damages and pushes, or a missile that detonates
into a `SphereBurst`.

```lua
AddWeaponResult(NewWeaponType, "Hit", "DamageHealth", "Target", 550, 550, "")
```

| # | Example | Meaning |
|---|---------|---------|
| 1 | `"Hit"` | **Condition**: `Hit` or `Miss`. |
| 2 | `"DamageHealth"` | **Effect**: `DamageHealth` (damage HP), `Disable` (EMP-style disable), `Push` (shove the target), or `SpawnWeaponFire` (fire another weapon at the impact point). |
| 3 | `"Target"` | **Recipient**: `Target` or `Self`. |
| 4 | `140` | **Lower bound** of the effect's random range (e.g. min damage). |
| 5 | `175` | **Upper bound** of the effect's random range (e.g. max damage). Equal bounds = fixed value. |
| 6 | `""` | **Spawned effect** — the weapon name to fire when the effect is `SpawnWeaponFire`; empty otherwise. |

`SpawnWeaponFire` is how layered weapons work: e.g. `vgr_smallmissile` impacts for
`DamageHealth`, then both on `Hit` and on `Miss` spawns `vgr_pulsecannonburst` at the
point for the visible detonation.

## `setPenetration` — per-armour-class damage multipliers

```lua
setPenetration(NewWeaponType, 5, 1,
    { Unarmoured     = 1,   },
    { LightArmour    = 1,   },
    { MediumArmour   = 0.6, },
    { HeavyArmour    = 0.4, },
    { SubSystemArmour= 0.5, },
    { TurretArmour   = 1.5, },
    { ResArmour      = 0.6, },
    { MoverArmour    = 1,   },
    { PlanetKillerArmour = 0, },   -- 0 = cannot damage Planet Killer / Dreadnaught-class armour
    { MineArmour     = 1,   },
    { ChunkArmour    = 1,   })
```

The trailing tables map each **armour class** to a **damage multiplier**: `1` = full
damage, `0.5` = half, `0` = no effect, and values **above 1** amplify (e.g.
`TurretArmour = 1.5` deals 150% to turrets). Omit a class to leave it at the engine
default. `PlanetKillerArmour = 0` is the standard way to make a weapon unable to scratch
Dreadnaught/Planet-Killer-class hulls.

The two leading numbers (`5, 1` above; `30, 1` for the ion beam) are the weapon's
penetration strength and a second value that is uniformly `1` across TPOF. Their precise
formula is **not** documented in the reference comments — copy the values from a
comparable existing weapon rather than guessing.

> The reference weapon (an HW1/HWAT file) lists only `PlanetKillerArmour`. TPOF is HW2,
> which uses the full armour-class set shown above — see any TPOF `.wepn` for the
> canonical list.

## `setAccuracy` — chance to hit, per target class

```lua
setAccuracy(NewWeaponType, 1,
    { Fighter         = 0,   },   -- 0 = effectively never hits fighters
    { Corvette        = 0,   },
    { Frigate         = 0,   },
    { Utility         = 1,   },
    { munition        = 0.1, },
    { SmallCapitalShip= 1,   },
    { BigCapitalShip  = 1,   },
    { Mothership      = 1,   },
    { Emplacement     = 1,   },
    { UnAttackable    = 1,   },
    { SubSystem       = 1,   },
    { Resource        = 1,   },
    { ResourceLarge   = 1,   },
    { Capturer        = 1,   },
    { Chimera         = 1,   })
```

The second argument is the **base accuracy**; each trailing table overrides the **chance
out of 1** of hitting that target class. This is the main lever for making capital
weapons useless against strikecraft (set `Fighter`/`Corvette`/`Frigate` low) and vice
versa. A weapon with uniform accuracy can pass just the base value and omit the tables —
e.g. missiles use `setAccuracy(NewWeaponType, 1)`.

> The reference weapon's class names (`FT_Tiny`, `CT_Small`, `FF_Small`, `DD`, `CA`,
> `MS`, …) are HW1/HWAT attack families and **do not apply** in HW2/TPOF. Use the HW2
> classes above (the ones present in every TPOF `.wepn`).

## `setAngles` — firing arc / turret traverse limits

```lua
setAngles(NewWeaponType, 10, -160, 160, 0, 60)
```

The reference file leaves this call uncommented; the meanings below are inferred from
TPOF usage. Argument 1 is the firing-cone / max off-bore angle (degrees). Arguments 2–5
are the turret traverse limits — horizontal min/max then vertical min/max, in degrees —
and matter for `AnimatedTurret` mounts:

- `AnimatedTurret` example: `10, -160, 160, 0, 60` → ±160° horizontal, 0–60° vertical.
- Full-traverse turret (ion beam): `20, -180, 180, 0, 60`.
- `Fixed` missile: `180, 0, 0, 0, 0` → wide firing cone, no traverse.

When in doubt, copy from a turret with the same mount type and physical model.

## `setMiscValues` and `addAnimTurretSound`

```lua
setMiscValues(NewWeaponType, 4, 0.1)
addAnimTurretSound(NewWeaponType, "Data:Sound/SFX/ETG/SPECIAL/SPECIAL_ABILITIES_TURRET_ON")
```

- **`setMiscValues`** — two tuning values whose exact meaning is not documented in the
  reference comments. Observed pairs: `0, 0` (ion beam), `4, 0.1` (gatling), `0, 3`
  (missile). Leave them as-is when adapting an existing weapon.
- **`addAnimTurretSound`** — the looping/activation sound for an `AnimatedTurret`
  (a `Data:Sound/...` event path). Only meaningful for animated turrets.

## Adding or editing a weapon

1. Create `src/weapon/{name}/{name}.wepn` (directory and file share the same name).
2. Start from an existing weapon of the same **mount type** and **weapon type** rather
   than from scratch — the positional arguments are unforgiving.
3. Set the 3rd `StartWeaponConfig` argument to an existing weapon-fire effect (`.wf` or
   stock) or, for missiles, an existing `.miss` name.
4. Reference the weapon by `{name}` from a `.ship`/`.subs` `StartShipWeaponConfig` /
   `StartSubSystemWeaponConfig` call (or a hardpoint loadout slot).
5. Sanity-check rate-of-fire/DPS with `tools\weapon-dps.ps1 -Weapon {name}`; final
   balance is always an in-engine playtest, not the static estimate.

See also: [`weaponfire_scripts.md`](weaponfire_scripts.md) (the `.wf` FX layer),
[`loadout_system.md`](loadout_system.md) (how weapons attach to hardpoint slots), and
`src\ship\CLAUDE.md` / `src\subsystem\CLAUDE.md` (the `StartShipWeaponConfig` /
`StartSubSystemWeaponConfig` callers).
