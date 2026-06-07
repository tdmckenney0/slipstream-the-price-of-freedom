# Level Data

All multiplayer maps live in `src/leveldata/multiplayer/`.

## Game Mode

`deathmatch.lua` — the "Slipstream" game rules file. **This is the central game logic entry point**, not a map file.

Its player-facing strings (`GameRulesName`, setup `Description`, the Music option's
`locName`/`tooltip`, and every music-`choices` display label) are `$<ID>` locale references
(IDs 8300-8343) resolved against `src/locale/english/slipstream.dat`. The paired music
*values* (`"slipstream"`, `"ambient\\amb_01"`, …) are not display text and stay literal. See
`docs/locale_system.md`. Note: `.level` `levelDesc` map names are a separate concern and were
not part of the locale conversion.

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
| `2p_research_outpost.level` | 2 | 1v1 asymmetric | Hyperspace **disabled** |
| `2p_the_graveyard.level` | 2 | 1v1 symmetric | |
| `3p_assault.level` | 3 | 1v2 asymmetric | Hyperspace **disabled**, based on HW2 mission Thaddis Sabbah |
| `3p_kadiir_nebula.level` | 3 | 1v2 asymmetric | Ported from HWC; uses `meg_slipgate` for the connecting slipgate route |
| `3p_standoff.level` | 3 | FFA asymmetric | 3-player FFA |
| `3p_trigs_bones.level` | 3 | 3p FFA | Ported from HWC, high verticality |
| `4p_high_dive.level` | 4 | 4p FFA | Ported from HWC ("Kristalzupacken") |
| `4p_the_battlefield.level` | 4 | 2v2 symmetric | |
| `4p_the_unbound.level` | 4 | 4p FFA CQB | Based on HW2 Mission 11 |
| `5p_gulf_sector.level` | 5 | 1v4 asymmetric | Ported from HWC; special ship: `vgr_vanaarjet` |
| `5p_mining_outpost.level` | 5 | 2v3 asymmetric | Hyperspace **disabled** |
| `5p_the_final_battle.level` | 5 | 2v3 asymmetric | Special ship: `sri_sajuuk` (SRI flagship), remix of HW2 Mission 15 |
| `6p_badlands.level` | 6 | 3v3 or FFA | Minimal resources, center-only |
| `6p_garrison.level` | 6 | 3v3 symmetric | Hyperspace **disabled**, special: Bentusi-derived dreadnaught + drones |

## Adding a New Map

1. Create `{Np}_{name}.level` in `src/leveldata/multiplayer/slipstream/`
2. Create matching `{Np}_{name}.jpg` and `{Np}_{name}_thumb.tga`
3. The map is automatically picked up by the game mode's `Directories = { Levels = "data:LevelData\\Multiplayer\\slipstream\\" }` setting in `deathmatch.lua`
4. No registration in other files required — the engine discovers maps by directory scan
