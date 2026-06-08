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
- `data:scripts/scar/restrict.lua` — restrictions
- `data:scripts/music.lua` — music
- `data:scripts/race.lua` — race table (on-demand, for fleet counting)
- `data:scripts/building and research/{race}/build.lua` — build lists (on-demand)

## File Reference

### `race.lua`
Defines the `races` table. Each entry: `{ "RaceName", "$locID", "hyperspaceGateType", "etgPath", hyperspaceSpeed, Playable, "PREFIX_" }`. Index 1 = Hiigaran, 2 = Vaygr, 3 = Keeper, 4 = Bentusi. Only Hiigaran (1), Vaygr (2), and Random (5) are playable.

### `scar/restrict.lua`
`MPRestrict()` (called once in `OnInit()`) loops all players and calls `RestrictOptions(playerid)`, which branches on `Player_GetRace()` then calls `Player_RestrictBuildOption(playerid, "EntityName")` and `Player_RestrictResearchOption(playerid, "ResearchName")`. **Do not add entries lightly** — the list is intentional; consult the docs on what's restricted and why first.

### `music.lua`
`Play(settingString)` (called from `OnInit()` with the player's menu selection) dispatches to shuffle functions that load playlists from `data:soundscripts/playlists/`. `RandomMusic(tPlaylist)` does shuffle-without-repeat via a `playedBin` table, rescheduling itself with `Rule_AddInterval("RandomMusicRule", track_length)`. **F1** is bound to `RandomMusicRule` to skip tracks.

### `startingfleets/hiigaran00.lua`, `vaygr00.lua`
Define `PersistantData` with:
- `Squadrons` — `{type, subsystems[], shiphold, name, number}`; `subsystems` is an array of `{index=0, name="subsystemName"}` = the spawn loadout (must exactly match the ship's `.ship` hardpoints).
- `Research` — `{name, progress=1}` for pre-granted tech. **Currently both races pre-grant only `RepairAbility`.**

The simplified tech tree is implemented primarily by *restricting* vanilla research in `restrict.lua`, not by pre-granting; starting fleets instead ship with the ships the player needs already built and fitted.

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

### `attack/` scripts
Per-class combat behavior (flyby, dogfight, strafe, etc.). Rarely need modification unless adding a ship class needing custom behavior.

### `weaponfire/` scripts
Projectile FX/sound, one per subdirectory (`weaponfire/{name}/{name}.wf`). `.wf` is a Relic convention using Lua global-assignment syntax (not SCAR logic) — bullet/hit/fire effects and sounds via named globals. See `docs/weaponfire_scripts.md`.

### `teamcolour.lua`
Team color definitions.
</content>
