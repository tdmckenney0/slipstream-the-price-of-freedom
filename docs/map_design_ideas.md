# Map Design Ideas

Per-map ideas for making the multiplayer maps under `src/leveldata/multiplayer/slipstream/` more interesting to play. Each suggestion leans into the map's existing identity rather than reinventing it.

Most of these need scripted rules added to either `deathmatch.lua` or a new per-map hook. The current engine uses `Rule_Add` / `Rule_AddInterval`; see `findSlipgatesAndStartEvent` and `MainRule` in `src/leveldata/multiplayer/deathmatch.lua` for the pattern.

---

## 2-player

### `2p_as_sirat` — open, resource-rich, no cover

**Lane definers.** Scatter 4–6 mid-sized debris clusters along the bisecting line so there is terrain to fight *around* rather than just resources to grab. Keeps the open feel but creates positional decisions for capital ships.

### `2p_research_outpost` — asymmetric, hyperspace disabled

**Activatable defenses.** The "outpost" side starts with one neutral platform that activates and joins them only after their first frigate dies. Rewards aggressive opening from the attacker; gives the defender a comeback beat.

### `2p_the_graveyard` — symmetric

**Salvageable wrecks.** Place 2–3 derelict cruisers per side as `addNonCombatObject`. They award a small RU bounty when destroyed, or (more ambitious) can be captured by a marine frigate to spawn as a damaged ally.

---

## 3-player

### `3p_assault` — 1v2, no hyperspace, Thaddis Sabbah

**Defender reinforcements.** The solo player gets a scripted Keeper/SRI dropship every 5 minutes from a fixed edge of the map. Reinforces the "they're in trouble but holding out" vibe of Thaddis Sabbah.

### `3p_kadiir_nebula` — 1v2, slipgate route

**Toggle the slipgate.** Trigger the slipgate FX off for the first 3 minutes of the match, then on. Forces opening builds that do not depend on it, then changes the map shape mid-game.

### `3p_standoff` — 3p FFA

**Neutral arbiter.** Spawn a neutral SRI patrol that wanders the center and attacks whoever has the largest fleet (tracked via `Player_NumberOfShips`). Punishes turtling/snowballing without scripting a hard objective.

### `3p_trigs_bones` — 3p FFA, high verticality

**Vertical chokepoints.** Add two horizontal nebula slabs at differing Y altitudes that block hyperspace and force ships to commit to a layer. Doubles down on the verticality gimmick.

---

## 4-player

### `4p_high_dive` — 4p FFA

**Resource pulse.** One big asteroid field at the center that only becomes harvestable after T+4 minutes (spawn it via a delayed rule). Creates a known mid-game flashpoint.

### `4p_the_battlefield` — 2v2 symmetric

**Capturable command platform.** Drop a neutral derelict carrier at the geographic center. The first team to hyperspace a marine frigate to it gets it as a controllable (slow) flagship. One-shot per match.

### `4p_the_unbound` — 4p FFA CQB, Mission 11

**Bentusi debris field hazard.** Lean into the Mission 11 Bentusi-fleet visuals — make some of the wrecks `addNonCombatObject` Bentusi husks that deal AoE damage on death to nearby ships. Discourages clumping in CQB.

---

## 5-player

### `5p_gulf_sector` — 1v4, special `vgr_vanaarjet`

**Vanaarjet escalation.** The lone player's Vanaarjet is initially damaged/offline. After 6 minutes (or after the lone player loses their first capital), it spawns/repairs as a usable unit. Telegraphed comeback.

### `5p_mining_outpost` — 2v3, no hyperspace

**Resource collapse.** The largest asteroid field at the center crumbles into smaller, scattered chunks after T+5 minutes. Shifts mid-game economy from "hold the field" to "hold the lanes."

### `5p_the_final_battle` — 2v3, `sri_sajuuk`

**Sajuuk awakens.** Sajuuk starts inert. After both teams have lost a capital ship, Sajuuk activates and is targetable. Whoever destroys it gets a one-shot superweapon ability granted to their flagship. Big swing, fits the "final battle" framing.

---

## 6-player

### `6p_badlands` — 3v3 or FFA, center-only resources

**Hostile center.** Add a small wandering neutral force (2–3 SRI fighters) that patrols the center asteroid cluster. Resources are still there, but contested by something. Reinforces "minimal econ, fight for it."

### `6p_garrison` — 3v3 symmetric, no hyperspace, Bentusi dreadnaught

**Dreadnaught alignment.** The Bentusi dreadnaught starts neutral. Once any team destroys a player's mothership, it aligns to the losing team as a defensive reinforcement. Anti-snowball mechanic baked into the gimmick.

*Implemented* — see `garrisonAlignmentInit` / `garrisonAlignmentCheck` in `src/leveldata/multiplayer/deathmatch.lua`. The rule gates on `vgr_prisonstation` (unique to this map). Each player's starting `sri_dreadnaught` is tracked; the first player to lose theirs has the neutral `meg_leviathan` transferred to them via `SobGroup_SwitchOwner`.

---

## Implementation notes

- All scripted events should use the existing `Rule_Add` / `Rule_AddInterval` / `Rule_Remove` pattern from `deathmatch.lua`.
- A generic "delayed reinforcement" rule and a "neutral patrol" rule would cover several of these ideas; building those two reusable hooks first would let multiple maps pull in the same primitives.
- The more a map relies on scripted events, the more invisible its rules become to a new player. Maps with one clearly telegraphed gimmick (Sajuuk awakening, slipgate toggling) will land better than maps with three subtle ones.
- Neutral / scripted ships use `addNonCombatObject` in `DetermChunk()`; see `5p_the_final_battle.level` for the Sajuuk precedent and `6p_garrison.level` for the Bentusi dreadnaught precedent.
