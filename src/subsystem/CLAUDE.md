# Subsystem Definitions

Each subsystem lives in `src/subsystem/{subsysname}/` and contains:
- `{subsysname}.subs` — subsystem config (Lua-like HW2 DSL)
- `{subsysname}.hod` — binary 3D model
- `{subsysname}.events` — event bindings (optional)

## .subs File Structure

```lua
NewSubSystemType = StartSubSystemConfig()
NewSubSystemType.displayedName = "$STRING_ID"
NewSubSystemType.sobDescription = "$STRING_ID"

-- Combat
NewSubSystemType.maxhealth = 35000
NewSubSystemType.regentime = 250
NewSubSystemType.type = "Weapon"          -- "Weapon" or "System"
NewSubSystemType.typeString = "BCGatlingGunTurret1"  -- unique type identifier

-- Build cost
NewSubSystemType.costToBuild = 500
NewSubSystemType.timeToBuild = 35
NewSubSystemType.isResearch = 0           -- 0 = buildable item, 1 = research item

-- Behavior
NewSubSystemType.collateralDamage = 100
NewSubSystemType.inactiveTimeAfterDamage = 90
NewSubSystemType.activateHealthPercentage = 0.1

-- Families
NewSubSystemType.BuildFamily = "SubSystem_Hgn"
NewSubSystemType.DisplayFamily = "SubSystemModule"
NewSubSystemType.ArmourFamily = "SubSystemArmour"
NewSubSystemType.DockFamily = "CantDock"

LoadHODFile(NewSubSystemType, 1)
StartSubSystemWeaponConfig(NewSubSystemType, "WeaponScriptName", "HardpointName", "HardpointName")
```

## Subsystem Catalog

### Hiigaran Battlecruiser Weapons (prefix: `hgn_bc_`)
All go in the two swappable `Weapon Top` / `Weapon Bottom` hardpoints on `hgn_battlecruiser`.

| Subsystem | Role |
|-----------|------|
| `hgn_bc_gatlinggunturret_1/2` | Rapid-fire, anti-strikecraft/corvette |
| `hgn_bc_ionbeamturret_1/2` | Continuous beam, anti-capital |
| `hgn_bc_minelauncher_1/2` | Area denial mine field |
| `hgn_bc_plasmaburstturret_1/2` | Burst damage, anti-frigate/capital |

Variants `_1` and `_2` have slightly different stats/positions.

### Hiigaran Destroyer Weapons (prefix: `hgn_dd_`)
| Subsystem | Notes |
|-----------|-------|
| `hgn_dd_gatlinggunturret_1/2` | |
| `hgn_dd_plasmaburstturret_1/2` | |

Variants `_1` and `_2` have slightly different stats/positions.

### Hiigaran Frigate Weapons (prefix: `hgn_ff_`)
| Subsystem | Notes |
|-----------|-------|
| `hgn_ff_gatlinggunturret` | |
| `hgn_ff_ionbeamturret` | |
| `hgn_ff_pulsarturret` | |

### Hiigaran Sensors / Modules
| Subsystem | Notes |
|-----------|-------|
| `hgn_c_sensors_advancedarray` | Advanced sensors module |

### Vaygr Destroyer Weapons (prefix: `vgr_dd_`)
Used by the Vaygr destroyer swappable primary turrets, and by both `vgr_heavybattlecruiser` starting-fleet loadouts.
| Subsystem | Notes |
|-----------|-------|
| `vgr_dd_scattershotturret_1/2` | |
| `vgr_dd_pulsecannonturret_1/2` | |
| `vgr_dd_rapidlaserturret_1/2` | |
| `vgr_dd_missileboxturret_1/2` | |

### Vaygr Sensors / Modules
| Subsystem | Notes |
|-----------|-------|
| `vgr_c_sensors_advancedarray` | Advanced sensors module |
| `vgr_c_module_research` | Research module (kept for research-tree hooks even though most research is restricted) |

### Misc
| Subsystem | Notes |
|-----------|-------|
| `neu_directionalthruster` | Shared thruster (used by many ships as innate/indestructible) |
| `hgn_interceptor_booster` | Speed booster for Hiigaran interceptor |
| `vgr_bc_booster` | Booster for Vaygr battlecruiser |

## Adding a New Weapon Subsystem

1. Create `src/subsystem/{name}/{name}.subs` following the structure above
2. Provide a `{name}.hod` 3D model
3. Add entries to both `src/scripts/building and research/hiigaran/build.lua` (or vaygr) with `DisplayPriority = 1000+`
4. Register the subsystem name in the relevant `StartShipHardPointConfig(...)` call in the `.ship` file
5. Optional: add `.events` for visual/audio events
