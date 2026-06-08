# Ship Definitions

Each ship lives in `src/ship/{shipname}/`:
- `{shipname}.ship` — config script (Lua-like HW2 DSL, executed by the engine)
- `{shipname}.hod` — binary 3D model (not text-editable)
- `{shipname}.events` — event bindings (optional)

## .ship File Structure

```lua
NewShipType = StartShipConfig()

-- Identity ($<ID> = locale string in src/locale/english/slipstream.dat, IDs 8000-8999;
--           see docs/locale_system.md. Use $<ID>, not raw literals.)
NewShipType.displayedName = "$STRING_ID"
NewShipType.sobDescription = "$STRING_ID"

-- Combat
NewShipType.maxhealth = 240000
NewShipType.regentime = 2000
NewShipType.sideArmourDamage = 1.2            -- damage multiplier for side/rear hits
NewShipType.rearArmourDamage = 1.2

-- Movement (TPOF capital values ~1.5x vanilla; vanilla BC was 69)
NewShipType.mainEngineMaxSpeed = 110
NewShipType.thrusterMaxSpeed = 100
NewShipType.rotationMaxSpeed = 6

-- Build
NewShipType.buildCost = 4000
NewShipType.buildTime = 280
NewShipType.unitCapsNumber = 8                -- how many count toward unit cap

-- Family identifiers (AI, docking, collision, display)
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

## Weapons

```lua
-- Fixed weapon (always present, not swappable):
StartShipWeaponConfig(NewShipType, "WeaponScriptName", "HardpointName", "HardpointName")

-- Swappable hardpoint (loadout slot):
StartShipHardPointConfig(
    NewShipType,
    "Slot Label",        -- display name in build menu
    "HardpointName",     -- matching hardpoint on the HOD model
    "Weapon|System",     -- hardpoint category
    "Generic|Innate",    -- Generic = player-swappable; Innate = always present
    "Destroyable|Damageable|Indestructible",  -- damage model
    "DefaultSubsystem",  -- installed at spawn (or "" for none)
    "Option1", "Option2", ...  -- up to ~10 swappable options
)
```

Common combos: `Generic`+`Destroyable` = swappable, can be destroyed; `Innate`+`Indestructible` = always present, indestructible (thrusters); `Innate`+`Damageable` = always present, damageable (engines).

## Abilities

```lua
addAbility(NewShipType, "HyperSpaceCommand", 1, 0, 0, 0, 0, 3)
addAbility(NewShipType, "CanBuildShips", 1, "Fighter_Hgn, Corvette_Hgn, ...", "Fighter, Corvette, ...")
addAbility(NewShipType, "CanAttack", 1, 1, 0, 0, 0.35, 1.2, "target families...", "AttackScriptName", {...})
addAbility(NewShipType, "ShipHold", 1, 0, 5, "rallypoint", "Fighter, Corvette", 25, {Fighter="12"}, {Corvette="75"})
addAbility(NewShipType, "MinelayerAbility", 1, 3.5)
```

### CRITICAL: ShipHold is required with CanBuild/CanDock/CanLaunch/ParadeCommand

If a ship declares `CanBuildShips` (or `CanDock`/`CanLaunch`/`ParadeCommand`) with **any ship class** in its type list — anything other than `SubSystemModule`/`SubSystemSensors` — it **MUST** also declare `ShipHold`. These code paths walk the ship-hold vector unconditionally on the sim tick; without `ShipHold` the first tick after config construction crashes with a NULL read (`config+0x5A8`). Full forensic post-mortem: `docs/crash_investigation.md`.

Empirical vanilla confirmation: the only three vanilla ships declaring `CanBuildShips` without `ShipHold` (`meg_asteroid`, `meg_asteroid_nosubs`, `meg_asteroidmp`) build `SubSystemModule`/`SubSystemSensors` *only*. No vanilla ship that builds actual ships lacks `ShipHold`.

**If the ship should NOT function as a carrier** (e.g. heavy-battlecruiser flagships, which build Capital-class ships but have no hangar), use the zero-capacity form — it allocates the engine's internal structures so nothing crashes, while accepting/holding nothing (copied from `meg_chimera`):

```lua
addAbility(NewShipType, "ShipHold", 1, 0, 0, "rallypoint", "", 0)
--   version flag ─┘  │  │            │   │   no squadron tables follow
--      hold size = 0 ┘  │            │   no ship classes accepted
--        launch count = 0            hold marker on the HOD
```

Omitting the trailing per-class cost tables (`{Fighter="12"}`, …) is fine when the accepted-classes string is empty. A real hold with capacity is the first `ShipHold` example above, where the trailing `{Class="N"}` tables are per-class dock-time costs.

## Death FX

```lua
SpawnSalvageOnDeath(NewShipType, "Slv_Chunk_Lrg03", count, chance, x, y, z, ...)
```

## Ship Roster

### Hiigaran
| Ship | Notes |
|------|-------|
| `hgn_battlecruiser` | 240k HP, speed 110, swappable weapon hardpoints; `ShipHold` + `CanBuildShips` (Utility) |
| `hgn_heavybattlecruiser` | Flagship (6 weapon hardpoints); zero-capacity `ShipHold` to satisfy the `CanBuildShips` rule |
| `hgn_destroyer` | Fast, fixed config; full custom `.events` (death + ion cannon fire) |
| `hgn_interceptor` | Fast strikecraft; custom death `.events` |
| `hgn_assaultcorvette`, `hgn_pulsarcorvette` | |
| `hgn_assaultfrigate`, `hgn_torpedofrigate`, `hgn_ioncannonfrigate` | |
| `hgn_resourcecollector` | |
| `hgn_resourcecontroller` | Mobile refinery; declares `ShipHold` |

TPOF does **not** ship `hgn_carrier`, `hgn_shipyard`, `hgn_gunturret`, or `hgn_ionturret` — restricted via `restrict.lua`, no `.ship` files.

### Vaygr
| Ship | Notes |
|------|-------|
| `vgr_battlecruiser` | More armor/damage vs. HGN BC; declares `ShipHold` |
| `vgr_qwaarjetii` | Taiidan "Qwaar-Jet II" heavy BC (240k HP, speed 163); 4 pulse-cannon + 4 super-lance turrets, no `ShipHold`, builds Battlecruiser/SuperCap |
| `vgr_vanaarjet` | Taiidan "Vanaar-Jet" carrier-class capital (280k HP, speed 163); 4 pulse-cannon turrets + 6 PD lasers |
| `vgr_destroyer` | Swappable primary turrets |
| `vgr_assaultfrigate`, `vgr_heavymissilefrigate` | Heavy missile frigate barrages |
| `vgr_interceptor`, `vgr_bomber`, `vgr_lancefighter` | |
| `vgr_missilecorvette`, `vgr_lasercorvette` | |
| `vgr_resourcecollector` | |
| `vgr_resourcecontroller` | Mobile refinery; declares `ShipHold` |

TPOF does **not** ship `vgr_carrier`, `vgr_shipyard`, or the vanilla weapon platforms — restricted via `restrict.lua`.

### SRI Corp (scenario-only)
| Ship | Notes |
|------|-------|
| `sri_dreadnaught` | 500k HP, `unitCapsNumber=1`, cannot be rebuilt; full custom death `.events` |
| `sri_sajuuk` | Special flagship (The Final Battle map); full custom death `.events` |
| `sri_commandbase` | Full custom death `.events` |
| `sri_drone` | |

### Scenario Objects
`meg_slipgate` (slipgate FX), `meg_leviathan`, `meg_starjumper`, `meg_chimera` (reference for the zero-capacity `ShipHold` form), `meg_bentus_ruins_core_1/2/3` (Bentusi ruins), `meg_tanisstructure_medium`/`_medium2` (Tanis derelicts), `meg_asteroid_inhibitor`, `vgr_prisonstation`.
</content>
