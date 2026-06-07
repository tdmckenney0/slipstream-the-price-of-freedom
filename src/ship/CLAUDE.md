# Ship Definitions

Each ship lives in its own subdirectory: `src/ship/{shipname}/`. The directory contains:
- `{shipname}.ship` — ship config script (Lua-like HW2 DSL, executed by the engine)
- `{shipname}.hod` — binary 3D model (not text-editable)
- `{shipname}.events` — event bindings (optional)

## .ship File Structure

```lua
NewShipType = StartShipConfig()

-- Identity ($<ID> = locale string in src/locale/english/slipstream.dat, IDs 8000-8999;
--           see docs/locale_system.md. New display text should use $<ID>, not raw literals.)
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

### ShipHold is required when CanBuildShips includes non-subsystem classes

**Rule:** if a ship declares `CanBuildShips` with *any* ship class in its type list
(`Fighter`, `Corvette`, `Frigate`, `Capital`, `Platform`, `Utility`, etc. — anything
other than `SubSystemModule`/`SubSystemSensors`), it MUST also declare `ShipHold`.
The engine allocates the ship-hold vector from the `ShipHold` handler and the
`CanBuildShips` code path at sim-tick time dereferences that vector unconditionally.
Without `ShipHold`, the first tick after the config is constructed crashes with a
NULL read at the vector's field offset (`+0x5A8`).

The vanilla-HW2 rule is empirical: the only three vanilla ships that declare
`CanBuildShips` without `ShipHold` are `meg_asteroid`, `meg_asteroid_nosubs`, and
`meg_asteroidmp` — all three build `SubSystemModule`/`SubSystemSensors` *only*.
No vanilla ship that builds actual ships (Fighter/Corvette/Frigate/Capital/etc.)
lacks `ShipHold`.

`CanDock`, `CanLaunch`, and `ParadeCommand` have the same requirement in practice —
they all walk the hold vector on the sim tick.

**If the ship is not supposed to function as a carrier** (heavybattlecruiser
flagships are the TPOF example — they build Capital-class ships but have no
hangar), use the minimal zero-capacity form so the vector allocates but nothing
can actually dock:

```lua
addAbility(NewShipType, "ShipHold", 1, 0, 0, "rallypoint", "", 0)
--                                  ^  ^  ^  ^             ^   ^
--                                  |  |  |  |             |   no squadron tables follow
--                                  |  |  |  |             no ship classes accepted
--                                  |  |  |  hold marker on the HOD
--                                  |  |  launch count = 0
--                                  |  hold size = 0
--                                  version flag
```

This is copied from `meg_chimera`'s form — it allocates the engine's internal
structures without letting any ship dock or launch. Omitting the trailing
squadron-count tables (`{Fighter="12"}`, etc.) is fine when the accepted-classes
string is empty.

A real ShipHold with actual capacity looks like this (from `hgn_battlecruiser`):

```lua
addAbility(NewShipType, "ShipHold", 1, 0, 5, "rallypoint", "Fighter, Corvette", 25,
    {Fighter="12"}, {Corvette="75"})
```

Where the trailing `{Class="N"}` tables are per-class dock-time costs.

## Death FX

```lua
SpawnSalvageOnDeath(NewShipType, "Slv_Chunk_Lrg03", count, chance, x, y, z, ...)
```

## Ship Roster

### Hiigaran
| Ship | Notes |
|------|-------|
| `hgn_battlecruiser` | 240k HP, speed 110, swappable weapon hardpoints; `ShipHold` + `CanBuildShips` (Utility) |
| `hgn_heavybattlecruiser` | Flagship (6 weapon hardpoints); zero-capacity `ShipHold` to satisfy the `CanBuildShips` constraint |
| `hgn_destroyer` | Fast, fixed config; full custom `.events` (death + ion cannon fire) |
| `hgn_interceptor` | Fast strikecraft; custom death `.events` |
| `hgn_assaultcorvette` | |
| `hgn_pulsarcorvette` | |
| `hgn_assaultfrigate` | |
| `hgn_torpedofrigate` | |
| `hgn_ioncannonfrigate` | |
| `hgn_resourcecollector` | |
| `hgn_resourcecontroller` | Mobile refinery; declares `ShipHold` |

TPOF does **not** ship `hgn_carrier`, `hgn_shipyard`, `hgn_gunturret`, or `hgn_ionturret` — those vanilla units are restricted via `restrict.lua` and have no TPOF `.ship` files.

### Vaygr
| Ship | Notes |
|------|-------|
| `vgr_battlecruiser` | More armor/damage vs. HGN BC; declares `ShipHold` |
| `vgr_qwaarjetii` | Taiidan-derived "Qwaar-Jet II" heavy battlecruiser (240k HP, speed 163); 4 pulse-cannon + 4 super-lance turrets, no `ShipHold`, builds Battlecruiser/SuperCap |
| `vgr_vanaarjet` | Taiidan-derived "Vanaar-Jet" carrier-class capital (280k HP, speed 163); 4 pulse-cannon turrets + 6 PD lasers |
| `vgr_destroyer` | Swappable primary turrets |
| `vgr_assaultfrigate` | |
| `vgr_heavymissilefrigate` | Heavy missile barrage frigate |
| `vgr_interceptor` | |
| `vgr_bomber` | |
| `vgr_lancefighter` | |
| `vgr_missilecorvette` | |
| `vgr_lasercorvette` | |
| `vgr_resourcecollector` | |
| `vgr_resourcecontroller` | Mobile refinery; declares `ShipHold` |

TPOF does **not** ship `vgr_carrier`, `vgr_shipyard`, or the vanilla weapon platforms — those are restricted via `restrict.lua`.

### SRI Corp (scenario-only)
| Ship | Notes |
|------|-------|
| `sri_dreadnaught` | 500k HP, `unitCapsNumber=1`, cannot be rebuilt; full custom death `.events` |
| `sri_sajuuk` | Special flagship (The Final Battle map); full custom death `.events` |
| `sri_commandbase` | Full custom death `.events` |
| `sri_drone` | |

### Scenario Objects
| Ship | Notes |
|------|-------|
| `meg_slipgate` | Slipgate activation FX |
| `meg_leviathan` | |
| `meg_starjumper` | |
| `meg_chimera` | Reference example for zero-capacity `ShipHold` form |
| `meg_bentus_ruins_core_1/2/3` | Bentusi ruins |
| `meg_tanisstructure_medium`, `meg_tanisstructure_medium2` | Tanis derelicts |
| `meg_asteroid_inhibitor` | |
| `vgr_prisonstation` | |
