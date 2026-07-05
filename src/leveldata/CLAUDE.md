# Level Data

All multiplayer maps live in `src/leveldata/multiplayer/`.

## Game Mode

`deathmatch.lua` — the "Slipstream" game rules file. **This is the central game logic entry point**, not a map file.

`GameSetupOptions` exposes: resource multiplier (1x/2x/3x), unit caps, lock teams, and **"Enhance CPU Players"** (`name = "director"`, default off) — the toggle that enables the AI Tactical Director (`src/scripts/director/`, see `docs/ai_director.md`). Starting resources and start locations are fixed via hidden options. There is no music option — music is a fixed shuffle playlist in `src/scripts/music.lua`.

Its player-facing strings (`GameRulesName` `$8300`, setup `Description` `$8301`, and the director option's `locName`/`tooltip` `$8302`/`$8303`) are TPOF locale refs; the other setup options reuse vanilla `$32xx` strings. See `docs/locale_system.md`. `.level` `levelDesc` map names are a separate concern, not part of the locale conversion.

## Map Directory: `slipstream/`

Each map has:
- `{Np}_{map_name}.level` — map script (Lua)
- `{Np}_{map_name}.jpg` — full preview image (shown in README/ModDB)
- `{Np}_{map_name}_thumb.tga` — thumbnail shown in the in-game map list

Where `N` = number of players and `p` = a disambiguating character if needed.

## `.level` File Structure

```lua
levelDesc = "Display Name"
maxPlayers = 2

player = {}
player[0] = {
    id = 0,
    name = "StartPos0",
    resources = 1500,         -- starting RUs
    raceID = 1,               -- 1=Hiigaran, 2=Vaygr
    startPos = 1,
}
-- ... more players ...

function DetermChunk()
    -- Called by engine to populate the map

    addPoint("StartPos0", {x, y, z}, {rx, ry, rz})  -- player start position + rotation
    addAsteroid("AsteroidType", {x, y, z}, density, ...)
    addNonCombatObject("ShipName", {x, y, z}, ...)   -- for derelict/scenario ships
end
```

Coordinates use HW2's 3D space (Y = vertical). Symmetrical maps mirror coordinates around origin.

## Current Map Roster

| File | Players | Type | Notes |
|------|---------|------|-------|
| `2p_as_sirat.level` | 2 | 1v1 symmetric | Resources abundant, no cover |
| `2p_kadiir_nebula.level` | 2 | 1v1 asymmetric | Mirrored starts, one-sided terrain |
| `2p_research_outpost.level` | 2 | 1v1 asymmetric | Hyperspace **disabled** |
| `2p_the_graveyard.level` | 2 | 1v1 symmetric | |
| `3p_assault.level` | 3 | 1v2 asymmetric | Hyperspace **disabled**, based on HW2 mission Thaddis Sabbah; the solo player starts with an `sri_dreadnaught` |
| `3p_standoff.level` | 3 | FFA asymmetric | 3-player FFA |
| `3p_trigs_bones.level` | 3 | 3p FFA | Ported from HWC, high verticality |
| `4p_high_dive.level` | 4 | 4p FFA | Ported from HWC ("Kristalzupacken") |
| `4p_the_battlefield.level` | 4 | 2v2 symmetric | |
| `4p_the_unbound.level` | 4 | 4p FFA CQB | Based on HW2 Mission 11 |
| `5p_gulf_sector.level` | 5 | 1v4 asymmetric | Ported from HWC; special ship: `vgr_vanaarjet` |
| `5p_mining_outpost.level` | 5 | 2v3 asymmetric | Hyperspace **disabled** |
| `5p_the_final_battle.level` | 5 | 2v3 asymmetric | Special ship: `sri_sajuuk` (SRI flagship), remix of HW2 Mission 15 |
| `6p_badlands.level` | 6 | 3v3 or FFA | Minimal resources, center-only |
| `6p_garrison.level` | 6 | 3v3 symmetric | Hyperspace **disabled** (3 inhibitors); central `vgr_prisonstation`; one team's players start with `vgr_vanaarjet` guards, the other's with `sri_dreadnaught` guards |

"Hyperspace **disabled**" = the map places `meg_asteroid_inhibitor` (the engine-enforced mechanism; also the cross-VM signal the AI director keys off — see `docs/ai_director.md`).

## Adding a New Map

1. Create `{Np}_{name}.level` in `src/leveldata/multiplayer/slipstream/`
2. Create matching `{Np}_{name}.jpg` and `{Np}_{name}_thumb.tga`
3. The map is automatically picked up by the game mode's `Directories = { Levels = "data:LevelData\\Multiplayer\\slipstream\\" }` setting in `deathmatch.lua`
4. No registration in other files required — the engine discovers maps by directory scan
