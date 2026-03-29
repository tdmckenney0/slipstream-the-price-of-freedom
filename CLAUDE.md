# CLAUDE.md — Slipstream: The Price of Freedom

## Shell and Scripting

All shell commands, scripts, and automation tasks outside of `src/` must use **PowerShell 7+** (`pwsh`). This applies to all agents (including Claude) operating in this repository. Do not use Windows PowerShell (5.x), bash, cmd, or Unix shell syntax for any scripting or shell activities.

## What This Project Is

**Slipstream: The Price of Freedom (TPOF)** is a mod for **Homeworld 2 Classic** (HW2). It is packaged as a `.big` archive (compiled by the HW2 Workshop Tool using `src/config.txt`) and loaded by the game engine at runtime. The mod transforms HW2 into a fast-paced tactical arena focused on ship loadouts and cooperative/competitive multiplayer.

Everything under `src/` is source content that gets compiled into `TPOF.big`. There is **no build script** — the HW2 Workshop Tool reads `src/config.txt` and packs all files in `src/` into the `.big` file. The `.big` file is gitignored.

## Technology Stack

The mod is authored entirely in **Lua** (HW2's scripting language) plus HW2-proprietary binary/text formats:

| Extension | Purpose |
|-----------|---------|
| `.ship` | Ship type definition (Lua-like HW2 DSL) |
| `.subs` | Subsystem definition (Lua-like HW2 DSL) |
| `.level` | Multiplayer map layout (Lua) |
| `.lua` | Game rules, AI, music, build lists, starting fleets |
| `.hod` | Binary 3D model (HOD format, not text-editable) |
| `.tga` | Texture images |
| `.miss` | Missile definition |
| `.wf` | Weapon fire script — global-assignment Lua defining bullet/hit/fire FX and sounds. See `docs/weaponfire_scripts.md`. |
| `.st` | Shader definition |
| `.fp` / `.fpa` / `.fpk` / `.fpz` | Fragment program (GPU shader) |
| `.rot` | Binary particle/effect/texture file (not text-editable) |
| `.anim` | Animation file |
| `.events` | Ship/subsystem event bindings — animation-driven death/damage/fire FX and sounds. See `docs/events_system.md`. |
| `.mres` | Multi-resolution icon definition |

## Repository Layout

```
src/
  config.txt                  # Workshop metadata and BigFilename (TPOF.big)
  ship/                       # Ship type definitions (.ship + .hod + .events)
  subsystem/                  # Subsystem definitions (.subs + .hod + .events)
  scripts/
    building and research/
      hiigaran/build.lua      # Hiigaran buildable unit/subsystem list
      vaygr/build.lua         # Vaygr buildable unit/subsystem list
    startingfleets/
      hiigaran00.lua          # Hiigaran starting PersistantData (fleet + pre-granted research)
      vaygr00.lua             # Vaygr starting PersistantData (fleet + pre-granted research)
    scar/
      restrict.lua            # MPRestrict() — disables vanilla units/research per-player
    music.lua                 # Music shuffle system; Play() entry point
    race.lua                  # Race table (Hiigaran=1, Vaygr=2, Keeper=3, Bentusi=4)
    teamcolour.lua            # Team color definitions
    attack/                   # Attack scripts (flyby, strafe, dogfight, etc.)
    weaponfire/               # Weapon fire scripts
  leveldata/multiplayer/
    deathmatch.lua            # "Slipstream" game mode entry point (GameRulesName = "Slipstream")
    slipstream/               # All multiplayer maps (.level + thumbnails + preview images)
  ai/
    classdef.lua              # AI ship class definitions
  art/fx/                     # Visual effects (Lua FX scripts + textures)
  background/                 # Skybox/background definitions
  shaders/                    # GPU shader files (.st, .fp, etc.)
  badges/                     # Player badge textures
  effect/                     # Trail and lens flare effects
  missile/                    # Missile definitions
docs/
  loadout_system.md           # Hardpoint/weapon loadout system documentation
  research_tree.md            # Tech tree simplification documentation
  events_system.md            # .events file format reference
  weaponfire_scripts.md       # .wf file format reference + script catalog
  relic_developers_network.md # RDN toolkit reference
  tools_backlog.md            # Planned tools to build under tools/
artwork/                      # ModDB/promotional artwork (Krita .kra files + exports)
screenshots/                  # In-game screenshots
legacy/                       # Legacy PDFs from original 2008 TPOF release
```

## Naming Conventions

Ship/subsystem names follow a strict prefix scheme:

| Prefix | Faction |
|--------|---------|
| `hgn_` | Hiigaran |
| `vgr_` | Vaygr |
| `sri_` | SRI Corp (special scenario ships) |
| `meg_` | Megaliths / neutral scenario objects |
| `neu_` | Neutral / shared subsystems (e.g. `neu_directionalthruster`) |
| `kpr_` | Keeper (non-playable) |

Ship-type identifiers within a name:
- `_bc_` = Battlecruiser subsystem
- `_dd_` = Destroyer subsystem
- `_ff_` = Frigate subsystem
- `_c_` = Carrier module
- `_ms_` = Mothership module

## Game Mode Entry Point

`src/leveldata/multiplayer/deathmatch.lua` is the game rules file (`GameRulesName = "Slipstream"`). It:
1. Calls `MPRestrict()` on init to disable unwanted vanilla units/research
2. Calls `Play()` with the player's music selection
3. Registers `findSlipgatesAndStartEvent` (activates slipgate FX on applicable maps)
4. Registers `CheckTeamAnyShipsLeftRule` (kill a player when their entire team has no ships)
5. Registers `MainRule` (ends game when all enemies are dead)

All maps in `src/leveldata/multiplayer/slipstream/` use this game mode.

## Ship Definitions (`.ship` files)

Each ship file is a Lua script that calls HW2 built-in functions:

```lua
NewShipType = StartShipConfig()
NewShipType.maxhealth = 240000         -- TPOF ships have significantly higher health than vanilla
NewShipType.mainEngineMaxSpeed = 110   -- TPOF ships are significantly faster (vanilla was 69)
-- ... many more properties ...

-- Fixed weapons (always present):
StartShipWeaponConfig(NewShipType, "WeaponScriptName", "HardpointName", "HardpointName")

-- Swappable hardpoints (player-configurable loadout slots):
StartShipHardPointConfig(NewShipType, "Slot Label", "HardpointName", "Weapon|System",
    "Generic|Innate", "Destroyable|Damageable|Indestructible",
    "DefaultSubsystem", "Option1", "Option2", ...)

-- Abilities:
addAbility(NewShipType, "HyperSpaceCommand", ...)
addAbility(NewShipType, "CanBuildShips", ...)
```

Key balance facts vs. vanilla HW2:
- Hiigaran Battlecruiser: `mainEngineMaxSpeed = 110` (vanilla: 69), `maxhealth = 240000`
- SRI Dreadnaught: `maxhealth = 500000`, `unitCapsNumber = 1` (hard cap: one per player)
- Dreadnaughts cannot be rebuilt once destroyed

## Subsystem Definitions (`.subs` files)

```lua
NewSubSystemType = StartSubSystemConfig()
NewSubSystemType.type = "Weapon"         -- or "System"
NewSubSystemType.costToBuild = 500
NewSubSystemType.timeToBuild = 35
NewSubSystemType.isResearch = 0
-- ...
StartSubSystemWeaponConfig(NewSubSystemType, "WeaponScriptName", "HardpointName", "HardpointName")
```

## Starting Fleets (`src/scripts/startingfleets/`)

Files define a `PersistantData` table with two sections:
- `Squadrons`: list of `{type, subsystems, number}` — ships spawned at game start
- `Research`: list of `{name, progress=1}` — technologies pre-granted at game start

This is how the simplified tech tree works: most key technologies are in the `Research` list with `progress = 1` so they are immediately available without any research needed.

## Restriction System (`src/scripts/scar/restrict.lua`)

`MPRestrict()` iterates all players and calls `RestrictOptions(playerid)`, which uses:
- `Player_RestrictBuildOption(playerid, "UnitName")` — hides a ship/subsystem from the build menu
- `Player_RestrictResearchOption(playerid, "TechName")` — hides a research option

Key restricted units (Hiigaran): Scout, AttackBomber, MarineFrigate, DefenseFieldFrigate, MinelayerCorvette, ECMProbe, ProximitySensor, Shipyard (standard)
Key restricted units (Vaygr): Scout, MinelayerCorvette, InfiltratorFrigate, CommandCorvette, HyperSpacePlatform, Shipyard

## Build Lists (`src/scripts/building and research/*/build.lua`)

Each race has a `build` table — a flat list of `{Type, ThingToBuild, RequiredResearch, RequiredShipSubSystems, DisplayPriority, ...}` entries for all buildable ships and subsystems. TPOF weapons (hardpoint swaps) appear at `DisplayPriority = 1000+`.

`deathmatch.lua` loads the race-appropriate `build.lua` dynamically when counting a player's fleet size.

## Maps (`.level` files)

Maps are Lua scripts defining:
- `maxPlayers` — number of player slots
- `player[]` — per-player start position, resources, raceID
- `DetermChunk()` — places asteroids, start positions, and special ships

Maps live in `src/leveldata/multiplayer/slipstream/` and are named `{Np}_{map_name}.level` where N is the player count.

## Music System

`src/scripts/music.lua` implements shuffle playlists. `Play(settingString)` dispatches to one of several `Shuffle*()` functions that load a playlist from `data:soundscripts/playlists/` and register the `RandomMusicRule` interval rule. **F1** skips to the next track.

## Playable Races

Only Hiigaran and Vaygr are playable (`Playable = 1` in `race.lua`). SRI Corp and Keeper units appear as special scenario ships on specific maps. The "Random" race option is also playable (selects either Hiigaran or Vaygr randomly).

## Release Workflow

1. Edit source files in `src/`
2. Use the HW2 Workshop Tool (Windows only) with `src/config.txt` to pack into `TPOF.big`
3. Place `TPOF.big` in the `Homeworld2Classic\Data\` directory
4. Launch with `-mod TPOF.big` flag

The `.big` file is gitignored. Binary assets (`.hod`, `.tga`, etc.) are committed directly to the repo.

## Key Balance Philosophy

- Ships are **significantly faster and more durable** than vanilla HW2
- **No tech race** — most research is pre-granted at match start
- **Loadout decisions** happen in the build menu (swapping hardpoint weapons), not the research menu
- **Dreadnaughts** are irreplaceable (one per player, cannot rebuild) — losing one is catastrophic
- Strikecraft (fighters/corvettes) are faster, more evasive, and break formation during combat
- Platforms are mobile and can be hyperspace-deployed but are slow and weakly armored

## Sub-directory CLAUDE.md Files

Each major source subdirectory has its own CLAUDE.md with format details, field references, and catalogs specific to that area. Check these before working in that directory:

| File | Covers |
|------|--------|
| `src/ship/CLAUDE.md` | `.ship` file structure, full ship roster by faction, ability syntax, death FX |
| `src/subsystem/CLAUDE.md` | `.subs` file structure, full subsystem catalog, how to add a new weapon subsystem |
| `src/scripts/CLAUDE.md` | Entry point wiring, `PersistantData` format, build table format, attack/weaponfire scripts |
| `src/leveldata/CLAUDE.md` | `.level` file structure, full map roster, how to add a new map |
