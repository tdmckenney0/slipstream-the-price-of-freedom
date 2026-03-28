# Scripts

All Lua game logic lives here. These scripts are loaded by the HW2 engine at runtime.

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

**Pre-granted Hiigaran research:** `DestroyerTech`, `BattlecruiserIonWeapons`, `PlatformIonWeapons`, `RepairAbility`

**Pre-granted Vaygr research:** `CorvetteTech`, `FrigateTech`, `LanceBeams`, `PlasmaBombs`, `CorvetteLaser`, `PlatformHeavyMissiles`, `FrigateAssault`, `BattlecruiserIonWeapons`, `DestroyerGuns`, `HyperspaceGateTech`, `RepairAbility`

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

`Player_NumberOfShips()` in `deathmatch.lua` loads this file dynamically to count fleet size. Only entries with `Type ~= 1` (i.e., `Type ~= SubSystem`) are counted.

### `attack/` scripts
Attack behavior scripts (flyby patterns, dogfight, strafe, etc.). These define how different ship classes engage different target classes. Generally do not need modification unless adding a new ship class that requires custom combat behavior.

### `weaponfire/` scripts
Weapon fire scripts (`.wf` format) for special weapons like ion beams, explosion VFX, thrusters.

### `teamcolour.lua`
Team color definitions.
