# Scripts

All Lua game logic, loaded by the HW2 engine at runtime.

## Lua API Reference

Relic's doxygen-generated HTML in [refs/rdn/Documents/Scar/](../../refs/rdn/Documents/Scar/) is the authoritative source for SCAR function signatures — check it first when writing a new Rule or Event. Module symbol counts and notable function names are catalogued in §7 of [docs/rdn_modding_reference.md](../../docs/rdn_modding_reference.md); `Rule_Add`/`Rule_AddInterval`/`Rule_Remove`, `Event_Start`, `OnInit`/`OnStartOrLoad`, and the `HW2_*` helpers are in §2.

Fast path by need:

| Doing... | Open... |
|---|---|
| Player state (race, RU, research, restrictions) | `_lua_player_8cpp.html` (33 symbols) |
| Ordering ships (move, attack, dock, ability activation) | `_lua_sob_group_actions_8cpp.html` (58) |
| Querying ship groups (health, position, count, status) | `_lua_sob_group_query_8cpp.html` (51) |
| Universe / environment / fleet spawning | `_lua_universe_8cpp.html` (30) |
| Camera, hyperspace, subtitles, sound, objectives, ATI HUD | `_lua_camera_*`, `_lua_hyperspace_*`, `_lua_subtitle_*`, `_lua_sound_*`, `_lua_objectives_*`, `_lua_a_t_i_*` |

## Entry Point

`src/leveldata/multiplayer/deathmatch.lua` is the game rules file. It `dofilepath`s into:
- `data:scripts/scar/restrict.lua` — `MPRestrict()` (currently a no-op stub; see below)
- `data:scripts/music.lua` — music shuffle
- `data:scripts/director/director.lua` — AI Tactical Director (runs only when the "director" game-setup option is on; default off)
- `data:scripts/race.lua` — race table (on-demand, for fleet counting)
- `data:scripts/building and research/{race}/build.lua` — build lists (on-demand)

## File Reference

### `race.lua`
Defines the `races` table. Each entry: `{ "RaceName", "$locID", "hyperspaceGateType", "etgPath", hyperspaceSpeed, Playable, "PREFIX_" }`. Index 1 = Hiigaran, 2 = Vaygr, 3 = Keeper, 4 = Bentusi. Only Hiigaran (1), Vaygr (2), and Random (5) are playable.

### `scar/restrict.lua`
`MPRestrict()` (called once in `OnInit()`) loops all players and calls `RestrictOptions(playerid)` — which is currently an **empty stub** (the `Player_GetRace()` branches are commented out). TPOF no longer restricts vanilla content at runtime: the custom `build.lua`/`research.lua` data files simply define only what TPOF offers. The `MPRestrict()` plumbing stays wired into `OnInit()` so per-player restrictions (`Player_RestrictBuildOption`/`Player_RestrictResearchOption`) can be reintroduced without touching `deathmatch.lua`.

### `music.lua`
Defines a hardcoded TPOF `PlayList` table (`{filepath, title, length_seconds}` per track, under `sound\music\slipstream\`). `ShufflePlaylist()` (called from `OnInit()`) binds **F1** to `RandomMusicRule` (skip track) and starts the rule. `RandomMusic(tPlaylist)` does shuffle-without-repeat via a `playedBin` table, announces the track with `Subtitle_Message`, and reschedules itself with `Rule_AddInterval("RandomMusicRule", track_length)`. The old `Play(settingString)` dispatcher, the in-game music menu option, and `data:soundscripts/playlists/` loading are gone.

### `startingfleets/hiigaran00.lua`, `vaygr00.lua`
Selected by the engine per race; `SetStartFleetSuffix("")` in `OnInit()` pins the default (no-suffix) files. Define `PersistantData` with:
- `StrikeGroups` — `{}` (empty).
- `Squadrons` — `{type, subsystems[], shiphold, name, size, number}`; `subsystems` is an array of `{index=0, name="subsystemName"}` = the spawn loadout (must exactly match the ship's `.ship` hardpoints); `size` = ships per squadron, `number` = squadron count.
- `Research` — `{name, progress=1}` for pre-granted tech. **Currently both races pre-grant only `RepairAbility`.**

The simplified tech tree lives in the trimmed `research.lua`/`build.lua` data files (see `docs/research_tree.md`); starting fleets ship with the ships the player needs already built and fitted (each race's flagship — `hgn_heavycruiser` / `vgr_qwaarjetii` — spawns here and only here; they are not buildable).

### `building and research/{hiigaran,vaygr}/build.lua`
Flat `build` table of all buildable items:
```lua
{ Type = Ship,                       -- or SubSystem
  ThingToBuild = "EntityName",
  RequiredResearch = "ResearchName", -- "" = none
  RequiredShipSubSystems = "Family", -- "" = none
  DisplayPriority = 20,              -- sort order; TPOF weapon swaps use 1000+
  DisplayedName = "$STRING_ID", Description = "$STRING_ID" }  -- $<ID> locale refs (8000-8999)
```
A weapon's build entry reuses the same `$<ID>` as its `.subs`. See `docs/locale_system.md`. `Player_NumberOfShips()` in `deathmatch.lua` loads this file dynamically to count fleet size, counting only entries with `Type ~= SubSystem`.

### `director/` — AI Tactical Director
`director.lua` (init + per-AI-player tick loop), `tactics.lua` (weighted strike composition, load-balanced target selection, difficulty-scaled `Tactics_Knobs`), `strikegroup.lua` (per-player `FORM → OUT → ENGAGE → BACK → REGROUP` state machine). Drives each AI player's expendable capitals in hyperspace jump-strikes on top of the cpu brain (`src/ai/`). Loaded by `deathmatch.lua`; runs only when the "director" game-setup option is enabled (default off). Design notes and hard-won engine gotchas: `docs/ai_director.md`.

### `tuning.lua`
Engine-global tuning constants (`Resource`, `Formation`, `ShipController`, `CombatInfo`, `StrikeGroupInfo`, `UnitCapsInfo`, …) — a decompiled copy that shadows the engine's built-in `scripts/tuning.lua` so global ship-behavior values can be tweaked. Loaded by the engine itself, not referenced by any TPOF script.

### `attack/` scripts
Per-class combat behavior (flyby, dogfight, strafe, etc.). Rarely need modification unless adding a ship class needing custom behavior.

### `weaponfire/` scripts
Projectile FX/sound, one per subdirectory (`weaponfire/{name}/{name}.wf`). `.wf` is a Relic convention using Lua global-assignment syntax (not SCAR logic) — bullet/hit/fire effects and sounds via named globals. See `docs/weaponfire_scripts.md`.

### `teamcolour.lua`
Team color definitions.
</content>
