# Subsystem Definitions

Each subsystem lives in `src/subsystem/{subsysname}/`:
- `{subsysname}.subs` — config (Lua-like HW2 DSL)
- `{subsysname}.hod` — binary 3D model
- `{subsysname}.events` — event bindings (optional)

## .subs File Structure

```lua
NewSubSystemType = StartSubSystemConfig()
-- $<ID> = locale string in src/locale/english/slipstream.dat (IDs 8000-8999; see
-- docs/locale_system.md). A weapon's name/description should reuse the SAME ID as its
-- build.lua entry so the build menu and selection UI stay in sync.
NewSubSystemType.displayedName = "$STRING_ID"
NewSubSystemType.sobDescription = "$STRING_ID"

-- Combat
NewSubSystemType.maxhealth = 35000
NewSubSystemType.regentime = 250
NewSubSystemType.type = "Weapon"                     -- "Weapon" or "System"
NewSubSystemType.typeString = "BCGatlingGunTurret1"  -- unique type identifier

-- Build
NewSubSystemType.costToBuild = 500
NewSubSystemType.timeToBuild = 35
NewSubSystemType.isResearch = 0           -- 0 = buildable, 1 = research item

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

`_1`/`_2` variants have slightly different stats/positions.

**Hiigaran Battlecruiser weapons** (`hgn_bc_`) — go in the two swappable `Weapon Top`/`Weapon Bottom` slots on `hgn_battlecruiser`:
`gatlinggunturret_1/2` (rapid-fire, anti-strikecraft/corvette), `ionbeamturret_1/2` (continuous beam, anti-capital), `minelauncher_1/2` (area denial), `plasmaburstturret_1/2` (burst, anti-frigate/capital).

**Hiigaran Destroyer weapons** (`hgn_dd_`): `gatlinggunturret_1/2`, `plasmaburstturret_1/2`.

**Hiigaran Frigate weapons** (`hgn_ff_`): `gatlinggunturret`, `ionbeamturret`, `pulsarturret`.

**Hiigaran sensors/modules**: `hgn_c_sensors_advancedarray`.

**Vaygr Destroyer weapons** (`vgr_dd_`) — used by the Vaygr destroyer swappable turrets and both `vgr_heavybattlecruiser` starting loadouts: `scattershotturret_1/2`, `pulsecannonturret_1/2`, `rapidlaserturret_1/2`, `missileboxturret_1/2`.

**Vaygr sensors/modules**: `vgr_c_sensors_advancedarray`, `vgr_c_module_research` (kept for research-tree hooks even though most research is restricted).

## Adding a New Weapon Subsystem

1. Create `src/subsystem/{name}/{name}.subs` (structure above) and provide `{name}.hod`.
2. Add entries to the relevant `build.lua` with `DisplayPriority = 1000+`.
3. Register the name in the relevant `StartShipHardPointConfig(...)` call in the `.ship` file.
4. Optional: add `.events` for visual/audio events.
</content>
