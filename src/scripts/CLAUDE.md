# Scripts

All Lua game logic lives here. These scripts are loaded by the HW2 engine at runtime.

## Lua API Reference

Relic's doxygen-generated HTML is the authoritative source for SCAR function signatures. It lives in [refs/rdn/Documents/Scar/](../../refs/rdn/Documents/Scar/). When writing a new Rule or Event, check there first — module symbol counts and notable function names are already catalogued in §7 of [docs/rdn_modding_reference.md](../../docs/rdn_modding_reference.md).

Fast path by need:

| If you're doing... | Open... |
|---|---|
| Player state (race, RU, research, restrictions) | `_lua_player_8cpp.html` (`LuaPlayer.cpp`, 33 symbols) |
| Ordering ships (move, attack, dock, ability activation) | `_lua_sob_group_actions_8cpp.html` (58 symbols) |
| Querying ship groups (health, position, count, status) | `_lua_sob_group_query_8cpp.html` (51 symbols) |
| Universe / environment / fleet spawning | `_lua_universe_8cpp.html` (30 symbols) |
| Camera, hyperspace, subtitles, sound, objectives, ATI HUD | `_lua_camera_*`, `_lua_hyperspace_*`, `_lua_subtitle_*`, `_lua_sound_*`, `_lua_objectives_*`, `_lua_a_t_i_*` |

`Rule_Add`, `Rule_AddInterval`, `Rule_Remove`, `Event_Start`, `OnInit`, `OnStartOrLoad`, and the `HW2_*` event helpers are described in §2 of [docs/rdn_modding_reference.md](../../docs/rdn_modding_reference.md) (sourced from `HW2_SCAR.pdf`).

## Entry Point

`src/leveldata/multiplayer/deathmatch.lua` is the game rules file. It `dofilepath`s into several scripts here:
- `data:scripts/scar/restrict.lua` — restrictions
- `data:scripts/music.lua` — music system
- `data:scripts/race.lua` — race table (loaded on-demand for fleet counting)
- `data:scripts/building and research/{race}/build.lua` — build lists (loaded on-demand)

## File Reference

### `race.lua`
Defines the `races` table. Index 1 = Hiigaran, 2 = Vaygr, 3 = Keeper, 4 = Bentusi. Each entry:
```lua
{ "RaceName", "$locID", "hyperspaceGateType", "etgPath", hyperspaceSpeed, Playable, "PREFIX_" }
```
Only Hiigaran (1), Vaygr (2), and Random (5) are playable.

### `scar/restrict.lua`
`MPRestrict()` — called once in `OnInit()`. Loops all players, calls `RestrictOptions(playerid)`.

`RestrictOptions(playerid)` uses `Player_GetRace()` to branch, then calls:
- `Player_RestrictBuildOption(playerid, "EntityName")` — removes from build menu
- `Player_RestrictResearchOption(playerid, "ResearchName")` — removes from research menu

**Do not add entries here lightly** — the restriction list is intentional. Consult the docs on what is restricted and why before adding/removing.

### `music.lua`
`Play(settingString)` is called from `OnInit()` with the player's music selection from the game setup screen. Dispatches to shuffle functions that load playlists from `data:soundscripts/playlists/`.

`RandomMusic(tPlaylist)` implements shuffle-without-repeat via `playedBin` table. Schedules itself as an interval rule after each track using `Rule_AddInterval("RandomMusicRule", track_length)`.

**F1** is bound to `RandomMusicRule` to skip tracks.

### `startingfleets/hiigaran00.lua` and `vaygr00.lua`
Define `PersistantData` with:
- `Squadrons` — list of `{type, subsystems[], shiphold, name, number}` tables
  - `subsystems` is an array of `{index=0, name="subsystemName"}` — the loadout installed at spawn
- `Research` — list of `{name, progress=1}` for pre-granted technologies

**Currently pre-granted research (both races):** only `RepairAbility`.

The simplified tech tree is implemented primarily by *restricting* vanilla research in `scar/restrict.lua`, not by pre-granting. Starting fleets instead ship with the ships the player needs (destroyers, battlecruisers, frigates, corvettes, fighters) already built and fitted with their loadout.

When modifying starting fleets, the `subsystems` array must exactly match the hardpoints defined in the ship's `.ship` file.

### `building and research/hiigaran/build.lua` and `vaygr/build.lua`
Flat `build` table of all buildable items. Each entry:
```lua
{
    Type = Ship,           -- or SubSystem
    ThingToBuild = "EntityName",
    RequiredResearch = "ResearchName",  -- "" = no requirement
    RequiredShipSubSystems = "SubSysFamily",  -- "" = no requirement
    DisplayPriority = 20,  -- sort order in build menu
    DisplayedName = "$STRING_ID",
    Description = "$STRING_ID",
}
```

TPOF-specific weapon subsystems use `DisplayPriority = 1000+` so they sort at the bottom.

`DisplayedName`/`Description` use `$<ID>` locale references (IDs 8000-8999) resolved against
`src/locale/english/slipstream.dat`. A weapon's build entry reuses the same ID as its `.subs`
file. The game-rules/music strings in `deathmatch.lua` and the menu strings in `research.lua`
are localized the same way. See `docs/locale_system.md`.

`Player_NumberOfShips()` in `deathmatch.lua` loads this file dynamically to count fleet size. Only entries with `Type ~= 1` (i.e., `Type ~= SubSystem`) are counted.

### `attack/` scripts
Attack behavior scripts (flyby patterns, dogfight, strafe, etc.). These define how different ship classes engage different target classes. Generally do not need modification unless adding a new ship class that requires custom combat behavior.

### `weaponfire/` scripts
Weapon fire scripts. Each script lives in its own subdirectory (`weaponfire/{name}/{name}.wf`). The `.wf` extension is a Relic convention — the files use Lua global-assignment syntax (not SCAR game logic). They define bullet/hit/fire particle effects and sounds via named globals (`bulletfx`, `hitfx`, `firefx`, `fire_sfx`, etc.). See `docs/weaponfire_scripts.md` for the full field reference and script catalog.

### `teamcolour.lua`
Team color definitions.
