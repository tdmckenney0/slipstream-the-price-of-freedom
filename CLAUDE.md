# CLAUDE.md — Slipstream: The Price of Freedom

## Development Environment

**Primarily developed on Windows 10/11 (x64).** The game engine (Homeworld 2 Classic), the HW2 Workshop Tool, and the Relic Developer's Network (RDN) are Windows-native. Wine on Linux/macOS is a supported fallback (it presents a Windows filesystem view, so paths and conventions are unchanged).

- **Shell**: PowerShell 7+ (`pwsh`) for all host-side commands and scripts. Not PowerShell 5.x, bash, cmd, or Unix syntax.
- **Paths**: Windows-style backslashes (e.g. `src\ship\hgn_battlecruiser\`) in scripts/docs. Forward slashes are fine inside Lua source (the engine accepts both).
- **Temp dir**: Always `.tmp\` in the repo root — never the system temp. It's gitignored, and `TEMP`/`TMP`/`TMPDIR` are pointed at it in `.claude\settings.local.json`, so subprocesses inherit it.

## What This Project Is

**Slipstream: The Price of Freedom (TPOF)** is a mod for **Homeworld 2 Classic** that turns HW2 into a fast-paced tactical arena focused on ship loadouts and multiplayer. Everything under `src/` is packed into `TPOF.big` and loaded at runtime. There is **no build script** in the traditional sense — the HW2 Workshop Tool (or `tools\build-tpof.ps1`) packs `src/` per `src/config.txt`. The `.big` is gitignored.

## Technology Stack

Authored in **Lua** (HW2's scripting language) plus HW2-proprietary formats:

| Extension | Purpose |
|-----------|---------|
| `.ship` | Ship type definition (Lua-like HW2 DSL) |
| `.subs` | Subsystem definition (Lua-like HW2 DSL) |
| `.level` | Multiplayer map layout (Lua) |
| `.lua` | Game rules, AI, music, build lists, starting fleets |
| `.hod` | Binary 3D model (not text-editable) |
| `.tga` | Texture images |
| `.wepn` | Weapon definition — damage, range, ROF, tracking, accuracy, penetration (Lua-like HW2 DSL). See `docs/weapon_definitions.md`. |
| `.miss` | Missile definition |
| `.wf` | Weapon fire script (bullet/hit/fire FX + sounds). See `docs/weaponfire_scripts.md`. |
| `.st` / `.fp` / `.fpa` / `.fpk` / `.fpz` | Shader definition / fragment programs (GPU shaders) |
| `.rot` | Binary particle/effect/texture file (not text-editable) |
| `.anim` | Animation file |
| `.events` | Animation-driven death/damage/fire FX + sound bindings. See `docs/events_system.md`. |
| `.mres` | Multi-resolution icon definition |
| `.dat` | Locale dictionary — plain text: `<ID>⇥<text>` rows referenced via `$<ID>`. See `docs/locale_system.md`. |

## Repository Layout

```
src/
  config.txt                  # Workshop metadata and BigFilename (TPOF.big)
  ship/                       # Ship definitions (.ship + .hod + .events)
  subsystem/                  # Subsystem definitions (.subs + .hod + .events)
  scripts/
    building and research/{hiigaran,vaygr}/build.lua  # Buildable unit/subsystem lists
    startingfleets/{hiigaran00,vaygr00}.lua           # Starting PersistantData (fleet + research)
    scar/restrict.lua         # MPRestrict() — disables vanilla units/research per-player
    music.lua                 # Music shuffle system; Play() entry point
    race.lua                  # Race table (Hiigaran=1, Vaygr=2, Keeper=3, Bentusi=4)
    teamcolour.lua            # Team color definitions
    attack/                   # Attack scripts (flyby, strafe, dogfight, etc.)
    weaponfire/               # Weapon fire scripts (.wf)
  leveldata/multiplayer/
    deathmatch.lua            # "Slipstream" game mode entry point
    slipstream/               # All multiplayer maps (.level + thumbnails + previews)
  locale/
    localedat.lua             # Dictionary list (vanilla 8 + slipstream.dat)
    english/slipstream.dat    # TPOF display strings (IDs 8000-8999)
  ai/classdef.lua             # AI ship class definitions
  art/fx/                     # Visual effects (Lua FX scripts + textures)
  background/  shaders/  badges/  effect/  missile/   # Skybox, GPU shaders, badges, trails, missiles
docs/                         # See the doc index in "Sub-directory CLAUDE.md Files" below + docs/*.md
artwork/  screenshots/  legacy/   # Promotional art, screenshots, original 2008 PDFs
```

## Naming Conventions

Ship/subsystem name prefixes: `hgn_` Hiigaran · `vgr_` Vaygr · `sri_` SRI Corp (scenario) · `meg_` Megaliths/neutral scenario objects · `neu_` neutral/shared subsystems · `kpr_` Keeper (non-playable).

Ship-type infixes: `_bc_` Battlecruiser · `_dd_` Destroyer · `_ff_` Frigate subsystems · `_c_` Carrier module · `_ms_` Mothership module.

## Game Mode Entry Point

`src/leveldata/multiplayer/deathmatch.lua` is the game rules file (`GameRulesName = "$8300"`). On init it: (1) `MPRestrict()` to disable vanilla units/research; (2) `Play()` for music; (3) registers `findSlipgatesAndStartEvent` (slipgate FX), `CheckTeamAnyShipsLeftRule` (kill a player whose team has no ships), and `MainRule` (ends the game when all enemies are dead). All maps in `slipstream/` use this mode.

## Ship Definitions (`.ship`)

A Lua script calling HW2 built-ins. Details and full roster: `src/ship/CLAUDE.md`.

```lua
NewShipType = StartShipConfig()
NewShipType.maxhealth = 240000         -- TPOF ships far more durable than vanilla
NewShipType.mainEngineMaxSpeed = 110   -- and far faster (vanilla BC was 69)
StartShipWeaponConfig(NewShipType, "WeaponScript", "Hardpoint", "Hardpoint")  -- fixed weapons
StartShipHardPointConfig(NewShipType, "Slot Label", "Hardpoint", "Weapon|System",
    "Generic|Innate", "Destroyable|Damageable|Indestructible", "Default", "Opt1", ...)  -- swappable loadout slots
addAbility(NewShipType, "HyperSpaceCommand", ...)
```

Balance facts vs. vanilla: Hiigaran BC `mainEngineMaxSpeed=110` (vanilla 69), `maxhealth=240000`. SRI Dreadnaught `maxhealth=500000`, `unitCapsNumber=1` (one per player), cannot be rebuilt once destroyed.

## Subsystem Definitions (`.subs`)

Details and full catalog: `src/subsystem/CLAUDE.md`.

```lua
NewSubSystemType = StartSubSystemConfig()
NewSubSystemType.type = "Weapon"      -- or "System"
NewSubSystemType.costToBuild = 500
NewSubSystemType.isResearch = 0
StartSubSystemWeaponConfig(NewSubSystemType, "WeaponScript", "Hardpoint", "Hardpoint")
```

## Starting Fleets (`src/scripts/startingfleets/`)

Each file defines a `PersistantData` table with `Squadrons` (`{type, subsystems, shiphold, name, number}` — ships spawned at start, loadouts set via the `subsystems` array) and `Research` (`{name, progress=1}` — pre-granted tech). TPOF pre-grants only `RepairAbility`; the "no tech race" feel comes mainly from *disabling* research in `restrict.lua` while shipping needed ships/tech in the starting fleet.

## Restriction System (`src/scripts/scar/restrict.lua`)

`MPRestrict()` loops players and calls `RestrictOptions(playerid)`, using `Player_RestrictBuildOption(playerid, "Unit")` (hide a ship/subsystem) and `Player_RestrictResearchOption(playerid, "Tech")` (hide research).

- **Restricted Hiigaran units**: `Hgn_Scout`, `Hgn_AttackBomber`, `Hgn_MarineFrigate`, `Hgn_DefenseFieldFrigate`, `Hgn_MinelayerCorvette`, `Hgn_ECMProbe`, `Hgn_ProximitySensor`, `Hgn_Probe`, `Hgn_Shipyard`, `Hgn_Carrier`, plus research/production modules (`Hgn_C_Module_Research`, `Hgn_MS_Module_Research`, `Hgn_C_Production_*`, `Hgn_MS_Production_CorvetteMover`).
- **Restricted Vaygr units**: `Vgr_Scout`, `Vgr_MinelayerCorvette`, `Vgr_CommandCorvette`, `vgr_infiltratorfrigate`, `Vgr_HyperSpace_Platform`, `Vgr_Probe`, `Vgr_Probe_Ecm`, `Vgr_Probe_Prox`, `Vgr_ShipYard`, `Vgr_Carrier`, `Vgr_PlanetKillerMissile`, plus research modules (`Vgr_C_Module_Research`, `Vgr_MS_Module_Research`).

Research restrictions are extensive on both sides — most vanilla research is disabled (see `restrict.lua` for the full list).

## Build Lists (`src/scripts/building and research/*/build.lua`)

A flat `build` table of `{Type, ThingToBuild, RequiredResearch, RequiredShipSubSystems, DisplayPriority, ...}` for all buildable ships/subsystems. TPOF weapon swaps appear at `DisplayPriority = 1000+`. `deathmatch.lua` loads the race's `build.lua` dynamically to count fleet size.

## Maps (`.level`)

Lua scripts defining `maxPlayers`, per-player `player[]` (start pos, resources, raceID), and `DetermChunk()` (places asteroids, start positions, special ships). Maps live in `src/leveldata/multiplayer/slipstream/`, named `{Np}_{map_name}.level`. Details/roster: `src/leveldata/CLAUDE.md`.

## Music System

`src/scripts/music.lua` implements shuffle playlists. `Play(settingString)` dispatches to `Shuffle*()` functions that load a playlist from `data:soundscripts/playlists/` and register `RandomMusicRule`. **F1** skips to the next track.

## Display Strings (Locale)

Player-facing text is referenced by ID as `"$<ID>"`, not hardcoded — resolved against the TPOF dictionary `src/locale/english/slipstream.dat` (registered in `localedat.lua`). **IDs must be 8000–8999**; outside that range the engine renders the raw literal. Packed through the normal `Data` TOC by `build-tpof.ps1` (no build-script changes). Use `$<ID>` for `displayedName`/`sobDescription` (`.ship`/`.subs`), `DisplayedName`/`Description` (`build.lua`/`research.lua`), and game-rules/music strings in `deathmatch.lua`. Full reference: `docs/locale_system.md`.

## Playable Races

Only Hiigaran and Vaygr are playable (`Playable = 1` in `race.lua`); "Random" is also selectable. SRI Corp and Keeper units are scenario-only on specific maps.

## Developer Tools (`tools/`)

PowerShell 7+ scripts for debugging/validating the mod:

| Script | Purpose |
|--------|---------|
| `parse-logs.ps1` | Read/tail `Hw2.log`, surface errors, summarize minidumps |
| `launch-tpof.ps1` | Launch HW2 Classic with TPOF active |
| `debug-tpof.ps1` | Launch HW2 under the `cdb` console debugger (crash capture) |
| `ship-stats.ps1` | Extract ship stats from all `.ship` files; can diff against a git ref |
| `find-empty-weapon-effects.ps1` | Find weapon configs whose 4th arg is `""` (no fire animation) |
| `export-weapon-events.ps1` / `import-weapon-events.ps1` | Export weapon configs joined to fire-animation events as CSV / rewrite `.events` from an edited CSV |
| `build-tpof.ps1` | Pack `src/` into `TPOF.big` headlessly via RDN `Archive.exe`; `-Install` copies to the HW2 `Data/` dir |
| `link-src.ps1` | Junction `src/` into the HW2 install as `DataTPOF/` (iterative testing without repacking) |
| `link-bin.ps1` / `link-rdn.ps1` | Link the HW2 `Bin/` and RDN install into `refs/` for log/reference access |

**When the user reports a crash, load error, or Lua error, run `parse-logs.ps1` first** before reading source. It auto-detects the install (`HW2_ROOT` env var, Steam registry, common paths) and reads `Bin\Release\Hw2.log`. Flags: `-Errors` (errors + Lua errors), `-Lua` (Lua output only), `-Mod` (mod-loading events), `-Tail` (live), `-Dumps` (crash artifacts), `-HWPath <path>` (manual install). Exits 1 if any ERROR/LUA ERROR found (useful for scripted checks).

## Release Workflow

Two ways to pack `src/` into `TPOF.big`:

- **CLI (iteration/CI):** `pwsh tools\build-tpof.ps1 -Install` — generates a build script in `.tmp\`, runs `refs\rdn\tools\bin\Archive\Archive.exe`, writes `.tmp\TPOF.big`, and (with `-Install`) copies it to `<HW2>\Data\TPOF.big`. Launch with `-mod TPOF.big`.
- **Steam Workshop Tool (publishing):** point it at `src/config.txt`; it packs and uploads using the `WorkshopID`.

For iteration without repacking, `tools\link-src.ps1` exposes `src/` as `DataTPOF/`; launch via `tools\launch-tpof.ps1` (`-moddatapath DataTPOF -overridebigfile`).

## Key Balance Philosophy

- Ships are **significantly faster and more durable** than vanilla.
- **No tech race** — vanilla research is disabled; starting fleets ship with needed tech/ships.
- **Loadout decisions** happen in the build menu (hardpoint weapon swaps), not research.
- **Dreadnaughts** are irreplaceable (one per player, no rebuild) — losing one is catastrophic.
- Strikecraft are fast and evasive and break formation in combat; platforms are mobile and hyperspace-deployable but slow and lightly armored.

## Sub-directory CLAUDE.md Files

Each major source subdirectory has its own CLAUDE.md — check it before working there:

| File | Covers |
|------|--------|
| `src/ship/CLAUDE.md` | `.ship` structure, full ship roster, ability syntax (incl. the `ShipHold`/`CanBuildShips` crash rule), death FX |
| `src/subsystem/CLAUDE.md` | `.subs` structure, full subsystem catalog, adding a weapon subsystem |
| `src/scripts/CLAUDE.md` | Entry-point wiring, `PersistantData` format, build table, attack/weaponfire scripts |
| `src/leveldata/CLAUDE.md` | `.level` structure, full map roster, adding a map |
| `src/locale/CLAUDE.md` | `slipstream.dat` format, ID range, adding a display string |

Other docs: `docs/loadout_system.md`, `research_tree.md`, `locale_system.md`, `events_system.md`, `weapon_definitions.md` (`.wepn` mechanics), `weaponfire_scripts.md` (`.wf` FX), `crash_investigation.md`, `relic_developers_network.md` (RDN toolkit inventory), `rdn_modding_reference.md` (RDN API/format reference), `tools_backlog.md`.
</content>
</invoke>
