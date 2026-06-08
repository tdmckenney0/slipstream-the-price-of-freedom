# Weapon Fire Scripts (`.wf` files)

`.wf` files define a weapon's projectile-lifecycle FX/audio — how the bullet looks in flight, what happens on hit, and what it sounds like. They live in `src/scripts/weaponfire/{name}/{name}.wf` and are referenced by name (the directory name) in `StartShipWeaponConfig`/`StartSubSystemWeaponConfig` calls in `.ship`/`.subs` files.

## Format

`.wf` files use Lua global-assignment syntax — **not** SCAR game logic (no functions, conditions, or loops); the engine reads the globals directly.

> Existing `.wf` files were decompiled from Lua bytecode with LuaDC 0.9.20 (2008): structurally correct, but may have minor formatting quirks.

```lua
-- Projectile visuals
bulletfx        = "effect_name"       -- particle effect attached to the projectile while in flight
firefx          = "effect_name"       -- muzzle flash / fire effect at the weapon hardpoint
scartype        = "iontrail"          -- special projectile trail type (beam weapons only)

-- Impact visuals
hitfx           = "effect_name"       -- particle effect spawned on a successful hit
nopenetratefx   = "effect_name"       -- effect when the shot hits but fails to penetrate armour
blowthroughfx   = "effect_name"       -- effect when the shot blows through a target

-- Behaviour
deathtype       = "deathCannon"       -- how the projectile dies: "deathCannon" or "deathBeam"

-- Audio
fire_sfx        = "Sound/Path"        -- sound event played at the weapon hardpoint on fire
hit_sfx         = "Sound/Path"        -- sound event played at the impact point
nopentrate_sfx  = "Sound/Path"        -- sound event on no-penetrate impact

-- Effect scaling
hit_clamp       = { 0.5, 1.25 }       -- {min, max} random scale applied to hitfx
```

All fields are optional — omit any that are not needed.

### `deathtype` values

| Value | Behaviour |
|-------|-----------|
| `"deathCannon"` | Projectile dies on impact (guns, missiles, plasma) |
| `"deathBeam"` | Projectile fades rather than exploding (beam weapons) |

### `scartype` values

| Value | Behaviour |
|-------|-----------|
| `"iontrail"` | Continuous ion beam trail (used by ion cannon weapons) |

### Alternative function syntax (not used in TPOF)

The vanilla RDN source uses a function-call form for some scripts. The equivalent globals are:

```lua
SetFireEffect(NewWeaponFireType, "effect_name", maxDistance)
SetBulletEffect(NewWeaponFireType, "effect_name", maxDistance)
SetHitEffect(NewWeaponFireType, "effect_name", maxDistance)
```

TPOF uses the global-assignment form throughout.

## Script Catalog

| Script name | `deathtype` | Notes |
|-------------|-------------|-------|
| `explosion` | `deathCannon` | Used by the SRI Sajuuk superweapon; `bulletfx = "explosion_nuke"`, enormous hit sound |
| `ionbeam` | `deathBeam` | Hiigaran/Vaygr ion cannon weapons; `scartype = "iontrail"`, continuous beam |
| `ionbeam_kpr` | `deathBeam` | Keeper variant of the ion beam; separate sound path |
| `thruster` | *(none)* | Used for thruster subsystems; minimal — only `nopenetratefx` defined |
| `vgr_pulsecannonburst` | `deathCannon` | Vaygr pulse cannon; `bulletfx = "vgr_pulsecannonburst"` |

## Adding a New Weapon Fire Script

1. Create `src/scripts/weaponfire/{name}/{name}.wf`
2. Set the globals you need (at minimum `bulletfx` or `hitfx` to see something on screen)
3. Reference it by `{name}` in `StartShipWeaponConfig` or `StartSubSystemWeaponConfig`

The engine discovers scripts by the directory name, so the directory and file must share the same name.
