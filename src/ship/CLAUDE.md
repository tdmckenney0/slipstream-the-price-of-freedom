# Ship Definitions

Each ship lives in its own subdirectory: `src/ship/{shipname}/`. The directory contains:
- `{shipname}.ship` — ship config script (Lua-like HW2 DSL, executed by the engine)
- `{shipname}.hod` — binary 3D model (not text-editable)
- `{shipname}.events` — event bindings (optional)

## .ship File Structure

```lua
NewShipType = StartShipConfig()

-- Identity
NewShipType.displayedName = "$STRING_ID"      -- localized string reference
NewShipType.sobDescription = "$STRING_ID"

-- Combat stats
NewShipType.maxhealth = 240000
NewShipType.regentime = 2000
NewShipType.sideArmourDamage = 1.2            -- damage multiplier for side hits
NewShipType.rearArmourDamage = 1.2

-- Movement (TPOF values are ~1.5x vanilla for capital ships)
NewShipType.mainEngineMaxSpeed = 110          -- vanilla HW2 battlecruiser was 69
NewShipType.thrusterMaxSpeed = 100
NewShipType.rotationMaxSpeed = 6

-- Build
NewShipType.buildCost = 4000
NewShipType.buildTime = 280
NewShipType.unitCapsNumber = 8                -- how many of this ship count toward unit cap

-- Family identifiers (used for AI, docking, collision, display)
NewShipType.BuildFamily = "Battlecruiser_Hgn"
NewShipType.AttackFamily = "BigCapitalShip"
NewShipType.DockFamily = "BattleCruiser"
NewShipType.UnitCapsFamily = "Capital"
NewShipType.UnitCapsShipType = "Battlecruiser"

-- AI threat values
NewShipType.frigateValue = 80
NewShipType.antiFrigateValue = 60
NewShipType.totalValue = 110
```

## Fixed Weapons

Weapons that are always present on the ship (not swappable via loadout):

```lua
StartShipWeaponConfig(NewShipType, "WeaponScriptName", "HardpointName", "HardpointName")
```

## Swappable Hardpoints (Loadout System)

```lua
StartShipHardPointConfig(
    NewShipType,
    "Slot Label",        -- display name in build menu
    "HardpointName",     -- matching hardpoint on the HOD model
    "Weapon|System",     -- hardpoint category
    "Generic|Innate",    -- Generic = player-swappable, Innate = always present
    "Destroyable|Damageable|Indestructible", -- Damage model
    "DefaultSubsystem",  -- installed at spawn (or "" for none)
    "Option1", "Option2", ...  -- up to ~10 swappable options
)
```

- `Generic` + `Destroyable` = player can swap it in the build menu, can be destroyed in combat
- `Innate` + `Indestructible` = always present, cannot be removed or destroyed (e.g. thrusters)
- `Innate` + `Damageable` = always present but can be damaged (e.g. engines)

## Abilities

```lua
addAbility(NewShipType, "HyperSpaceCommand", 1, 0, 0, 0, 0, 3)
addAbility(NewShipType, "CanBuildShips", 1, "Fighter_Hgn, Corvette_Hgn, ...", "Fighter, Corvette, ...")
addAbility(NewShipType, "CanAttack", 1, 1, 0, 0, 0.35, 1.2, "target families...", "AttackScriptName", {...})
addAbility(NewShipType, "ShipHold", 1, 0, 5, "rallypoint", "Fighter, Corvette", 25, ...)
addAbility(NewShipType, "MinelayerAbility", 1, 3.5)
addAbility(NewShipType, "CloakAbility", ...)
```

## Death FX

```lua
SpawnSalvageOnDeath(NewShipType, "Slv_Chunk_Lrg03", count, chance, x, y, z, ...)
```

## Ship Roster

### Hiigaran
| Ship | File | Notes |
|------|------|-------|
| `hgn_battlecruiser` | `hgn_battlecruiser/` | 240k HP, speed 110, 2 swappable weapon hardpoints |
| `hgn_heavybattlecruiser` | `hgn_heavybattlecruiser/` | Flagship (6 weapon hardpoints) |
| `hgn_destroyer` | `hgn_destroyer/` | Fast, fixed config |
| `hgn_carrier` | `hgn_carrier/` | Production platform |
| `hgn_assaultfrigate` | `hgn_assaultfrigate/` | |
| `hgn_torpedofrigate` | `hgn_torpedofrigate/` | |
| `hgn_ioncannonfrigate` | `hgn_ioncannonfrigate/` | |
| `hgn_interceptor` | `hgn_interceptor/` | Fast strikecraft |
| `hgn_assaultcorvette` | `hgn_assaultcorvette/` | |
| `hgn_pulsarcorvette` | `hgn_pulsarcorvette/` | |
| `hgn_gunturret` | `hgn_gunturret/` | Platform |
| `hgn_ionturret` | `hgn_ionturret/` | Platform |
| `hgn_resourcecontroller` | `hgn_resourcecontroller/` | |

### Vaygr
| Ship | File | Notes |
|------|------|-------|
| `vgr_battlecruiser` | `vgr_battlecruiser/` | More armor/damage vs. HGN BC |
| `vgr_heavybattlecruiser` | `vgr_heavybattlecruiser/` | Flagship |
| `vgr_destroyer` | `vgr_destroyer/` | 2 swappable primary turrets |
| `vgr_carrier` | `vgr_carrier/` | |
| `vgr_assaultfrigate` | `vgr_assaultfrigate/` | |
| `vgr_heavymissilefrigate` | `vgr_heavymissilefrigate/` | Heavy missile barrage frigate |
| `vgr_interceptor` | `vgr_interceptor/` | |
| `vgr_bomber` | `vgr_bomber/` | |
| `vgr_lancefighter` | `vgr_lancefighter/` | |
| `vgr_missilecorvette` | `vgr_missilecorvette/` | |
| `vgr_lasercorvette` | `vgr_lasercorvette/` | |
| `vgr_weaponplatform_gun` | `vgr_weaponplatform_gun/` | Platform |
| `vgr_weaponplatform_missile` | `vgr_weaponplatform_missile/` | Platform |
| `vgr_resourcecontroller` | `vgr_resourcecontroller/` | |

### SRI Corp (scenario-only)
| Ship | Notes |
|------|-------|
| `sri_dreadnaught` | 500k HP, `unitCapsNumber=1`, cannot be rebuilt |
| `sri_sajuuk` | Special flagship (The Final Battle map) |
| `sri_commandbase` | |

### Scenario Objects
| Ship | Notes |
|------|-------|
| `meg_slipgate` | Triggers SlipstreamEffect FX |
| `meg_leviathan` | |
| `meg_starjumper` | |
| `meg_chimera` | |
| `meg_bentus_ruins_core_*` | Bentusi ruins |
| `meg_tanisstructure_medium*` | |
| `meg_asteroid_inhibitor` | |
| `vgr_prisonstation` | |
