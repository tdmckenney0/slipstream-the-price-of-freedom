# AI Tactical Director

A game-rules-VM system (`src/scripts/director/`) that drives each AI player's
expendable capitals in hyperspace jump-strikes and hit-n-run, overlaid on the
per-player cpu brain (`src/ai/`). Hooked from `deathmatch.lua` `OnInit`:

```lua
dofilepath("data:scripts/director/director.lua")
...
Director_Init()
Rule_AddInterval("Director_Tick", g_directorTickInterval)
```

## Files
- `director.lua` — init, the per-AI-player tick loop, the AI-player set, on-screen
  debug trace.
- `tactics.lua` — strike/home/target SobGroup builders, target selection,
  `Tactics_JumpsAllowed`, and `Tactics_Knobs` (difficulty-scaled thresholds).
- `strikegroup.lua` — the per-player state machine.

## State machine (`strikegroup.lua`)
```
FORM -> OUT -> ENGAGE -> BACK -> REGROUP -> FORM
```
- **FORM** — gather the strike capitals; when strong enough and off cooldown,
  pick a target and `SobGroup_Despawn` the group (or attack conventionally if
  jumps are disabled).
- **OUT** — once `SobGroup_AreAllInHyperspace` is true, `ExitHyperSpaceSobGroup`
  next to the enemy and attack. Watchdog prevents stranding.
- **ENGAGE** — attack; break off when hurt (`HealthPercentage` < threshold),
  timed out, or the target is gone.
- **BACK** — once in hyperspace, `ExitHyperSpaceSobGroup` next to home.
- **REGROUP** — stop issuing orders so the cpu brain reclaims the ships, until
  the cooldown elapses and the cycle repeats.

## The jump mechanism (validated by the Phase-0 smoke test)
The engine specifics that make this work — each one was a failed attempt first:

| Use | Not |
|-----|-----|
| `Universe_GameTime()` | `gameTime()` (does not exist in the rules VM) |
| `SobGroup_Despawn` then `ExitHyperSpaceSobGroup` | `SobGroup_EnterHyperSpaceOffMap` (off-map state can't be recalled) |
| Exit only when `SobGroup_AreAllInHyperspace == 1` | a fixed timer (exit fires before all ships are in hyperspace) |
| Anchor on **real ships** (capitals/flagship/resourcer) | mothership/shipyard (don't exist — restricted) |
| **Non-empty** anchor (else ships dump at origin) | unchecked anchor |
| Union types via temp + `SobGroup_SobGroupAdd` | repeated `Player_FillShipsByType` (it clears-and-fills) |

The flagship (heavycruiser / Qwaar-Jet II) is intentionally **kept home as an
anchor**, never thrown into hit-n-run (it's irreplaceable).

## Coordination with the cpu brain
Separate Lua VMs, no shared state. Explicit SCAR orders override AI orders while
actively issued; in REGROUP the director stops ordering, so the brain reclaims
the ships. The strike SobGroup is refreshed only in real-space states
(FORM/ENGAGE/REGROUP) so off-map ships are never dropped mid-jump.

## Hyperspace-disabled maps
Some maps place a **`meg_asteroid_inhibitor`** — an in-world field that blocks
hyperspace (`3p_assault`, `5p_mining_outpost`, `6p_garrison`). A scripted jump
there would strand a despawned strike group (it can never enter hyperspace), so
on the **first tick** `Director_ResolveJumps()` calls `Tactics_MapHasInhibitor()`
(`Player_FillShipsByType(..., -1, "meg_asteroid_inhibitor")`, exactly how
`deathmatch.lua` detects `meg_slipgate`). If any inhibitor exists it sets
`g_disableDirectorJumps = 1` **in the rules VM**, so `Tactics_JumpsAllowed()`
returns 0 and the director uses conventional attack-move / retreat-move.

A `g_disableDirectorJumps` global set in the `.level` file does **not** work — the
`.level` runs in a separate VM and never reaches the director (confirmed in
testing). The inhibitor object is the reliable cross-VM signal, and it's tied to
the actual hazard, so the director can never strand ships. `2p_research_outpost`
has no inhibitor (its "no hyperspace" status is inherited HW1 lore, not engine-
enforced), so jumps are correctly *allowed* there — the same as for a human.

## Knobs & toggles
- All tactical thresholds live in `Tactics_Knobs` in `tactics.lua`, scaled by
  `getLevelOfDifficulty()` (guarded — it may be absent in the rules VM).
- `g_directorDebug` (in `director.lua`) — `1` shows per-player state transitions
  on-screen via `Subtitle_Message`. `print`/`trace` do NOT reach `Hw2.log` in
  this VM, so Subtitle is the observability channel. Set `0` for release.
- `g_directorHumanPlayers` — player slots the director must not command. AI-vs-
  human detection isn't exposed by the engine, so this exclusion list is the
  interim (the human is slot 0 in the test matrix).
