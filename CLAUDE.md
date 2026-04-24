# CLAUDE.md — Slipstream: The Price of Freedom

## Development Environment

**This repository is primarily developed on Windows (Windows 10/11).** The game engine (Homeworld 2 Classic), the HW2 Workshop Tool, and the Relic Developer's Network (RDN) are Windows-native. Wine (on Linux/macOS) is a supported fallback for running these tools when a Windows machine is not available.

- **OS**: Windows 10/11 (x64) — primary. Wine on Linux/macOS — fallback for running HW2 and the Workshop Tool.
- **Shell / scripting**: PowerShell 7+ (`pwsh`) for all shell commands, scripts, and automation tasks outside of `src/`. Do not use Windows PowerShell 5.x, bash, cmd, or Unix shell syntax.
- **File paths**: Use Windows-style paths with backslashes (e.g. `src\ship\hgn_battlecruiser\`) in scripts and documentation. Forward slashes are acceptable inside Lua source files (HW2 engine accepts both), but all host-side tooling uses backslashes.
- **Text editor**: Any editor that runs on Windows or Linux/macOS; VS Code is the primary editor used in this project.
- **Temp directory**: Always use `.tmp\` inside the repo root for temporary files — never the system temp directory (`%TEMP%`, `%TMP%`, or `$TMPDIR`). The `.tmp\` directory is gitignored. The `TEMP`, `TMP`, and `TMPDIR` environment variables are set to this path in `.claude\settings.local.json`, so they will be inherited automatically by all tools and subprocesses.

Agents (including Claude) operating in this repository must assume a Windows environment and use PowerShell 7+ syntax for any shell operations. On Wine, paths and PowerShell conventions remain the same — Wine presents a Windows filesystem view to the tools it runs.

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
- `Squadrons`: list of `{type, subsystems, shiphold, name, number}` — ships spawned at game start (subsystem loadouts are set here via the `subsystems` array)
- `Research`: list of `{name, progress=1}` — technologies pre-granted at game start

TPOF currently pre-grants only `RepairAbility` in both `hiigaran00.lua` and `vaygr00.lua`. The "no tech race" feel is achieved mainly by *disabling* research options via `restrict.lua`, not by pre-granting them — players start with the ships and tech they need already built into the starting fleet.

## Restriction System (`src/scripts/scar/restrict.lua`)

`MPRestrict()` iterates all players and calls `RestrictOptions(playerid)`, which uses:
- `Player_RestrictBuildOption(playerid, "UnitName")` — hides a ship/subsystem from the build menu
- `Player_RestrictResearchOption(playerid, "TechName")` — hides a research option

Key restricted Hiigaran units: `Hgn_Scout`, `Hgn_AttackBomber`, `Hgn_MarineFrigate`, `Hgn_DefenseFieldFrigate`, `Hgn_MinelayerCorvette`, `Hgn_ECMProbe`, `Hgn_ProximitySensor`, `Hgn_Probe`, `Hgn_Shipyard`, `Hgn_Carrier`, plus research/production modules (`Hgn_C_Module_Research`, `Hgn_MS_Module_Research`, `Hgn_C_Production_*`, `Hgn_MS_Production_CorvetteMover`).

Key restricted Vaygr units: `Vgr_Scout`, `Vgr_MinelayerCorvette`, `Vgr_CommandCorvette`, `vgr_infiltratorfrigate`, `Vgr_HyperSpace_Platform`, `Vgr_Probe`, `Vgr_Probe_Ecm`, `Vgr_Probe_Prox`, `Vgr_ShipYard`, `Vgr_Carrier`, `Vgr_PlanetKillerMissile`, plus research modules (`Vgr_C_Module_Research`, `Vgr_MS_Module_Research`).

Research restrictions on both sides are extensive (see `restrict.lua` for the full list) — most vanilla research is disabled outright.

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

## Developer Tools (`tools/`)

Use these scripts when debugging or validating the mod. All require PowerShell 7+ (`pwsh`).

| Script | Purpose |
|--------|---------|
| `tools\parse-logs.ps1` | Read/tail `Hw2.log`, surface errors, summarize minidumps |
| `tools\launch-tpof.ps1` | Launch HW2 Classic with TPOF active |
| `tools\debug-tpof.ps1` | Launch HW2 under the `cdb` console debugger (crash capture) |
| `tools\ship-stats.ps1` | Extract ship stats from all `.ship` files; can diff against a git ref |
| `tools\build-tpof.ps1` | Pack `src/` into `TPOF.big` headlessly via the RDN `Archive.exe` (no Workshop Tool GUI required); `-Install` copies into the HW2 `Data/` dir |
| `tools\link-src.ps1` | Symlink/junction this repo's `src/` into the HW2 install as `DataTPOF/` (for iterative testing without repacking) |
| `tools\link-bin.ps1` | Link the HW2 `Bin/` directory into `refs/bin/` for log/minidump access |
| `tools\link-rdn.ps1` | Link the RDN installation into `refs/rdn/` for reference access |

### `tools\parse-logs.ps1` — Log reader / crash analyzer

When the user reports a crash, load error, or Lua error after launching HW2 with the mod, **run this script first** before reading any source files. It auto-detects the HW2 Classic install (via `HW2_ROOT` env var, Steam registry, or common paths) and reads `Bin\Release\Hw2.log`.

```powershell
# Show all errors and Lua errors
pwsh tools\parse-logs.ps1 -Errors

# Show only Lua output (LUA: lines + LUA ERROR lines)
pwsh tools\parse-logs.ps1 -Lua

# Show TPOF/slipstream mod-loading events
pwsh tools\parse-logs.ps1 -Mod

# Live-tail while the game is running
pwsh tools\parse-logs.ps1 -Tail

# Summarize crash dump artifacts
pwsh tools\parse-logs.ps1 -Dumps

# Specify install path manually
pwsh tools\parse-logs.ps1 -HWPath 'D:\Steam\steamapps\common\Homeworld\Homeworld2Classic' -Errors
```

Exits with code 1 if any ERROR or LUA ERROR lines were found — useful for scripted checks.

## Release Workflow

Two equivalent ways to pack `src/` into `TPOF.big`:

**A. CLI (recommended for iteration / CI)**

```powershell
pwsh tools\build-tpof.ps1 -Install
```

Generates a build script under `.tmp\`, invokes `refs\rdn\tools\bin\Archive\Archive.exe`, writes `.tmp\TPOF.big`, and (with `-Install`) copies it to `<HW2>\Data\TPOF.big`. Then launch with `-mod TPOF.big`.

**B. Steam Workshop Tool (required for publishing to the Workshop)**

1. Open the HW2 Workshop Tool (Windows only) and point it at `src/config.txt`
2. Tool packs into `TPOF.big` and uploads using the `WorkshopID` in `config.txt`

The `.big` file is gitignored. Binary assets (`.hod`, `.tga`, etc.) are committed directly to the repo.

For day-to-day iteration without repacking at all, use `tools\link-src.ps1` to expose `src/` as `DataTPOF/` and launch via `tools\launch-tpof.ps1` (which uses `-moddatapath DataTPOF -overridebigfile`).

## Key Balance Philosophy

- Ships are **significantly faster and more durable** than vanilla HW2
- **No tech race** — vanilla research is disabled outright, and starting fleets ship with the tech/ships players need
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
