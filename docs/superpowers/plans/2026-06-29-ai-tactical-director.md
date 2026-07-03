# AI Tactical Director Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a game-rules "tactical director" that drives each AI player's capital ships in hyperspace jump-strikes and hit-n-run retreats, for an arena-style feel.

**Architecture:** A new rule (`Director_Tick`) runs in the game-rules Lua VM (hooked from `deathmatch.lua`), separate from the per-AI-player "cpu brain" VM. Each tick it forms a strike group from an AI player's Battlecruisers/Destroyers and runs a per-player state machine (FORM → INBOUND → ENGAGE → OUTBOUND → REGROUP) using `SobGroup_*` commands. Jumps are scripted teleports via `SobGroup_EnterHyperSpaceOffMap` + `SobGroup_ExitHyperSpaceSobGroup`. The director and brain never share state; when the director releases a group (REGROUP), the brain reclaims it because explicit SCAR orders override AI orders only while actively issued.

**Tech Stack:** HW2 Classic Lua (a Lua-4.0-style dialect — see Global Constraints), `SobGroup_*`/`Player_*`/`Universe_*` SCAR API, PowerShell 7 dev tooling under `tools/`.

**Companion spec:** `docs/superpowers/specs/2026-06-29-ai-rebuild-design.md`. This plan implements that spec's Layer B (director) including its Phase 0 smoke test. Layer A (cpu brain rewrite) is a separate plan and is not required for this one — the director operates on whatever ships the current AI builds.

## Global Constraints

- **Lua dialect (HW2 Classic):** No `#` length operator, no `pairs`/`ipairs`, no `table.insert`. Iterate tables with `for k, v in t do ... end`. Use `NIL` (engine nil) in comparisons, matching existing AI code. String concat is `..`. These rules are absolute — violating them throws Lua errors at load.
- **Platform:** Windows, PowerShell 7+ (`pwsh`) for all host commands. Repo temp dir is `.tmp\` (never system temp).
- **Paths in Lua:** forward slashes OK; `dofilepath("data:scripts/...")` form for includes.
- **No `Co-Authored-By:` trailers** in any commit in this repo.
- **Locale:** any new player-facing string must be a `$<ID>` ref with ID 8000–8999. (This plan adds no player-facing strings.)
- **Validation is in-game, not unit-tested.** HW2 has no test harness. Every task's "test" = link the source, launch a skirmish on a named map vs. an AI, observe behavior, and assert on `tools\parse-logs.ps1` output (no `ERROR`/`LUA ERROR`, plus expected `DIRECTOR:` trace lines). Exact commands are given per task.
- **Iteration loop (used in every task):**
  - Link source without repacking: `pwsh tools\link-src.ps1`
  - Launch: `pwsh tools\launch-tpof.ps1`
  - In-game: start a **Skirmish**, your seat = **player slot 0**, add **one Computer (AI) opponent** in slot 1, pick the task's map, start.
  - After the observation window, exit, then: `pwsh tools\parse-logs.ps1 -Errors` and `pwsh tools\parse-logs.ps1 -Lua`
  - PASS = no `ERROR`/`LUA ERROR` lines + the task's expected observation/trace.

---

## File Structure

- `src/scripts/director/director.lua` — entry point: init, the `Director_Tick` rule, AI-player set, per-player state table, trace helper.
- `src/scripts/director/tactics.lua` — pure-ish helpers: build strike/home/target SobGroups, pick target player, jumps-allowed check, difficulty knobs.
- `src/scripts/director/strikegroup.lua` — the per-player state machine and its transitions.
- `src/leveldata/multiplayer/deathmatch.lua` — MODIFY: load the director, add the `Director_Tick` interval rule.
- `src/leveldata/multiplayer/slipstream/2p_research_outpost.level`, `3p_assault.level`, `5p_mining_outpost.level`, `6p_garrison.level` — MODIFY: set `g_disableDirectorJumps = 1` so the director uses conventional movement there.

**Shared data model (created in `director.lua`, consumed everywhere):**

```lua
-- g_directorState[playerIndex] = {
--   state       = "FORM",                 -- FORM | INBOUND | ENGAGE | OUTBOUND | REGROUP
--   strikeName  = "Dir_Strike_<p>",       -- SobGroup of this player's strike capitals
--   homeName    = "Dir_Home_<p>",         -- SobGroup of this player's mothership/shipyard
--   targetName  = "Dir_Target_<p>",       -- SobGroup of current enemy target ships
--   targetPlayer= -1,                     -- enemy player index
--   stateTime   = 0,                      -- gameTime() when current state was entered
--   lastJumpTime= -9999,                  -- gameTime() of last strike start (cooldown gate)
--   lastAttackTime = 0,                   -- gameTime() of last AttackPlayer re-issue
-- }
```

**Function signatures (the contract between files):**

- `Director_Init()` → builds `g_directorState`, `g_directorAI` list, sets `g_directorTickInterval`.
- `Director_Tick()` → rule body; loops AI players, calls `StrikeGroup_Update(p)`.
- `Director_IsAIPlayer(p)` → `1`/`0`.
- `Director_Trace(msg)` → logs `"DIRECTOR: "..msg`.
- `Tactics_FillStrikeShips(p, outName)` → count (fills `outName` with p's BC+Destroyer).
- `Tactics_FillHome(p, outName)` → count (fills with p's mothership/shipyard).
- `Tactics_FillTarget(enemyIndex, outName)` → count (enemy capitals, else enemy home structures).
- `Tactics_PickTargetPlayer(p)` → enemy index or `-1`.
- `Tactics_JumpsAllowed()` → `1`/`0`.
- `Tactics_Knobs()` → table of difficulty-scaled thresholds.
- `StrikeGroup_Update(p)` → advances one player's state machine.

---

### Task 1: Phase 0 API smoke test (throwaway)

De-risks the four unverified behaviors from the spec in one shot: AI-player command, explicit-orders-override-AI, `SobGroup_ExitHyperSpaceSobGroup` in Steam HW2 Classic, and reliable return from `SobGroup_EnterHyperSpaceOffMap`. This code is **thrown away** in Task 2 — keep it isolated.

**Files:**
- Modify: `src/leveldata/multiplayer/deathmatch.lua` (add a temporary rule + hook; clearly marked).

**Interfaces:**
- Consumes: nothing.
- Produces: nothing permanent (removed in Task 2).

- [ ] **Step 1: Add the smoke-test rule to `deathmatch.lua`**

Add this block at the end of `deathmatch.lua` (after `findSlipgatesAndStartEvent`). It hardcodes the AI as player slot 1 and the enemy as slot 0 (matches the test setup). `SMOKE_*` names make it greppable for removal.

```lua
-------------------------------------------------------------------------------
-- TEMPORARY Phase-0 API smoke test. REMOVE in director Task 2.
-- Validates: forming an AI player's capital group, jumping it onto the enemy,
-- attacking, and jumping it home (reliable off-map return).
-------------------------------------------------------------------------------
SMOKE_ai = 1          -- AI player slot in the test skirmish
SMOKE_enemy = 0       -- human/enemy slot
SMOKE_phase = 0
SMOKE_t0 = 0

function SMOKE_fill(out, p, t)
    SobGroup_Create(out)
    SobGroup_Clear(out)
    Player_FillShipsByType(out, p, t)
    return SobGroup_Count(out)
end

function SMOKE_Tick()
    local now = gameTime()
    if SMOKE_phase == 0 then
        -- wait until the AI actually has a battlecruiser to command
        local n = SMOKE_fill("SMOKE_strike", SMOKE_ai, "vgr_battlecruiser")
        if n == 0 then n = SMOKE_fill("SMOKE_strike", SMOKE_ai, "hgn_battlecruiser") end
        if n > 0 then
            print("DIRECTOR-SMOKE: have " .. n .. " BC, entering hyperspace")
            SobGroup_EnterHyperSpaceOffMap("SMOKE_strike")
            SMOKE_t0 = now
            SMOKE_phase = 1
        end
    elseif SMOKE_phase == 1 then
        if SobGroup_AreAllInHyperspace("SMOKE_strike") == 1 then
            SobGroup_Create("SMOKE_target")
            SobGroup_Clear("SMOKE_target")
            Player_FillShipsByType("SMOKE_target", SMOKE_enemy, "hgn_mothership")
            Player_FillShipsByType("SMOKE_target", SMOKE_enemy, "vgr_mothership")
            print("DIRECTOR-SMOKE: exiting near enemy, target count " .. SobGroup_Count("SMOKE_target"))
            SobGroup_ExitHyperSpaceSobGroup("SMOKE_strike", "SMOKE_target", 1000)
            SobGroup_AttackPlayer("SMOKE_strike", SMOKE_enemy)
            SMOKE_t0 = now
            SMOKE_phase = 2
        elseif (now - SMOKE_t0) > 15 then
            print("DIRECTOR-SMOKE: WATCHDOG never reached hyperspace")
            SMOKE_phase = 9
        end
    elseif SMOKE_phase == 2 then
        if (now - SMOKE_t0) > 20 then
            print("DIRECTOR-SMOKE: jumping home")
            SobGroup_EnterHyperSpaceOffMap("SMOKE_strike")
            SMOKE_t0 = now
            SMOKE_phase = 3
        end
    elseif SMOKE_phase == 3 then
        if SobGroup_AreAllInHyperspace("SMOKE_strike") == 1 then
            SobGroup_Create("SMOKE_home")
            SobGroup_Clear("SMOKE_home")
            Player_FillShipsByType("SMOKE_home", SMOKE_ai, "hgn_mothership")
            Player_FillShipsByType("SMOKE_home", SMOKE_ai, "vgr_mothership")
            print("DIRECTOR-SMOKE: exiting home, home count " .. SobGroup_Count("SMOKE_home"))
            SobGroup_ExitHyperSpaceSobGroup("SMOKE_strike", "SMOKE_home", 1000)
            print("DIRECTOR-SMOKE: DONE — ships returned, strike count " .. SobGroup_Count("SMOKE_strike"))
            SMOKE_phase = 9
        elseif (now - SMOKE_t0) > 15 then
            print("DIRECTOR-SMOKE: WATCHDOG never reached hyperspace (home)")
            SMOKE_phase = 9
        end
    end
end
```

- [ ] **Step 2: Hook the smoke rule in `OnInit`**

In `deathmatch.lua`'s `OnInit()`, add after `Rule_Add("MainRule")`:

```lua
    Rule_AddInterval("SMOKE_Tick", 2)
```

- [ ] **Step 3: Link and launch**

Run:
```
pwsh tools\link-src.ps1
pwsh tools\launch-tpof.ps1
```
Start a Skirmish: your seat = slot 0, add one Computer opponent = slot 1, map `2p_as_sirat` (hyperspace ON). Let it run ~3–4 minutes so the AI builds a Battlecruiser, then watch for the AI's BC to vanish (hyperspace), reappear next to your mothership and attack, then vanish and reappear at its own base.

- [ ] **Step 4: Verify via logs**

Run:
```
pwsh tools\parse-logs.ps1 -Lua
pwsh tools\parse-logs.ps1 -Errors
```
Expected: `DIRECTOR-SMOKE:` lines progressing `have N BC` → `exiting near enemy` → `jumping home` → `DONE — ships returned, strike count > 0`, and **no** `LUA ERROR`. The final `strike count > 0` proves ships reliably return from off-map (the critical risk).

**If any call errors** (e.g. `SobGroup_ExitHyperSpaceSobGroup` not found, or ships never return): record the exact log line and stop. The director design's jump mechanism must be revised before Task 5 (fallback: pre-placed exit volumes via `SobGroup_ExitHyperSpace`, or conventional-movement-only director). Tasks 2–4 (which use no jumps) are still valid and can proceed.

- [ ] **Step 5: Commit**

```
git add src/leveldata/multiplayer/deathmatch.lua
git commit -m "Add throwaway Phase-0 director API smoke test"
```

---

### Task 2: Director scaffold, hook, AI-player set, and jump-disable flags

Stand up the director loop that ticks per AI player and does nothing tactical yet (just traces). Wire the jump-disable flag into the four no-hyperspace maps. Remove the Task 1 smoke test.

**Files:**
- Create: `src/scripts/director/director.lua`
- Modify: `src/leveldata/multiplayer/deathmatch.lua` (remove smoke test; load director; add real rule)
- Modify: `src/leveldata/multiplayer/slipstream/2p_research_outpost.level`, `3p_assault.level`, `5p_mining_outpost.level`, `6p_garrison.level`

**Interfaces:**
- Produces: `Director_Init`, `Director_Tick`, `Director_IsAIPlayer`, `Director_Trace`, `g_directorState`, `g_directorAI`.
- Consumes (forward refs, stubbed this task): `StrikeGroup_Update` — define a temporary stub here, replaced in Task 4.

- [ ] **Step 1: Create `src/scripts/director/director.lua`**

```lua
-- Slipstream: The Price of Freedom - Tactical Director (game-rules VM)
-- Drives AI players' capital ships in hyperspace strikes and hit-n-run.
-- Runs separately from the per-AI-player cpu brain; coordinates only by the
-- rule that explicit SCAR orders override AI orders while actively issued.

dofilepath("data:scripts/director/tactics.lua")
dofilepath("data:scripts/director/strikegroup.lua")

g_directorTickInterval = 2

-- Player indices the director must NOT command (humans). Auto-population is the
-- Step-4 discovery item; this list is the reliable interim for the test matrix
-- (your seat = slot 0). Real multi-human MP refines this in Step 4.
g_directorHumanPlayers = { 0 }

function Director_Trace(msg)
    -- Surfaces in Hw2.log; safe no-op if print is unavailable.
    if print then print("DIRECTOR: " .. msg) end
end

function Director_IsAIPlayer(p)
    local h
    for k, h in g_directorHumanPlayers do
        if h == p then return 0 end
    end
    return 1
end

function Director_Init()
    g_directorState = {}
    g_directorAI = {}
    local p
    for p = 0, Universe_PlayerCount() - 1 do
        if Director_IsAIPlayer(p) == 1 then
            g_directorAI[p] = 1
            g_directorState[p] = {
                state = "FORM",
                strikeName = "Dir_Strike_" .. p,
                homeName = "Dir_Home_" .. p,
                targetName = "Dir_Target_" .. p,
                targetPlayer = -1,
                stateTime = 0,
                lastJumpTime = -9999,
                lastAttackTime = 0,
            }
            Director_Trace("init AI player " .. p)
        end
    end
end

function Director_Tick()
    local p, v
    for p, v in g_directorAI do
        if Player_IsAlive(p) == 1 then
            StrikeGroup_Update(p)
        end
    end
end
```

- [ ] **Step 2: Create a temporary `strikegroup.lua` stub and a real `tactics.lua` stub**

The director `dofilepath`s both; they must exist and define the referenced names or load fails. Create `src/scripts/director/strikegroup.lua`:

```lua
-- Slipstream: Tactical Director - strike-group state machine (stub; Task 4)
function StrikeGroup_Update(p)
    local st = g_directorState[p]
    Director_Trace("tick p" .. p .. " state " .. st.state)
end
```

Create `src/scripts/director/tactics.lua`:

```lua
-- Slipstream: Tactical Director - tactics helpers (stub; Task 3)
```

- [ ] **Step 3: Edit `deathmatch.lua` — remove smoke test, load director, add rule**

Delete the entire `TEMPORARY Phase-0 API smoke test` block from Task 1 and the `Rule_AddInterval("SMOKE_Tick", 2)` line. Then, near the other `dofilepath` lines at the top (after `dofilepath("data:scripts/music.lua")`), add:

```lua
dofilepath("data:scripts/director/director.lua")
```

In `OnInit()`, after `Rule_Add("MainRule")`, add:

```lua
    Director_Init()
    Rule_AddInterval("Director_Tick", g_directorTickInterval)
```

- [ ] **Step 4: Resolve AI-player detection (discovery)**

The interim (exclude `g_directorHumanPlayers = {0}`) is correct for the test matrix. To generalize, attempt — during a running skirmish — to confirm an engine query exists. In a scratch rule, log probes and check `parse-logs.ps1 -Lua` for which resolve without `LUA ERROR`:

```lua
-- scratch probe (remove after): does any player-type query exist?
if Player_IsCpuPlayer then print("DIRECTOR-PROBE IsCpuPlayer p1=" .. Player_IsCpuPlayer(1)) end
if Player_IsHuman then print("DIRECTOR-PROBE IsHuman p1=" .. Player_IsHuman(1)) end
```
If a query resolves, replace `Director_IsAIPlayer`'s body with it. If none resolves (expected, per spec §9), keep the human-exclusion list and document that real MP must set `g_directorHumanPlayers` to the human slots at match start. Either outcome closes this item — no placeholder remains.

- [ ] **Step 5: Wire jump-disable flag into the four no-hyperspace maps**

In each of `2p_research_outpost.level`, `3p_assault.level`, `5p_mining_outpost.level`, `6p_garrison.level`, add this line at the **top of the file** (before `levelDesc`), so the global is set when the level loads (the level and game-rules share the VM):

```lua
g_disableDirectorJumps = 1
```

- [ ] **Step 6: Link, launch, verify the loop runs**

Run:
```
pwsh tools\link-src.ps1
pwsh tools\launch-tpof.ps1
```
Start a skirmish (slot 0 you, slot 1 AI) on `2p_as_sirat`. Run ~1 minute. Then:
```
pwsh tools\parse-logs.ps1 -Lua
pwsh tools\parse-logs.ps1 -Errors
```
Expected: `DIRECTOR: init AI player 1` once, then repeating `DIRECTOR: tick p1 state FORM`. No `LUA ERROR`. (No ship behavior yet.)

- [ ] **Step 7: Commit**

```
git add src/scripts/director src/leveldata/multiplayer/deathmatch.lua src/leveldata/multiplayer/slipstream/2p_research_outpost.level src/leveldata/multiplayer/slipstream/3p_assault.level src/leveldata/multiplayer/slipstream/5p_mining_outpost.level src/leveldata/multiplayer/slipstream/6p_garrison.level
git commit -m "Add tactical director scaffold, tick loop, and jump-disable map flags"
```

---

### Task 3: Tactics helpers

Implement the SobGroup-building and target-selection helpers. No behavior change yet — verified by logging counts.

**Files:**
- Modify: `src/scripts/director/tactics.lua` (replace the stub).

**Interfaces:**
- Produces: `Tactics_FillByTypes`, `Tactics_FillStrikeShips`, `Tactics_FillHome`, `Tactics_FillTarget`, `Tactics_PickTargetPlayer`, `Tactics_JumpsAllowed`, `Tactics_Knobs` (exact signatures in the File Structure contract).
- Consumes: `Director_Trace`.

- [ ] **Step 1: Replace `src/scripts/director/tactics.lua` with the full implementation**

```lua
-- Slipstream: Tactical Director - tactics helpers

-- Per-race capital strike ships, keyed by Player_GetRace() (0=Hiigaran,1=Vaygr).
g_dirStrikeTypes = {}
g_dirStrikeTypes[0] = { "hgn_battlecruiser", "hgn_destroyer" }
g_dirStrikeTypes[1] = { "vgr_battlecruiser", "vgr_destroyer" }

-- Per-race home anchor structures (used as jump-home destination + regroup point).
g_dirHomeTypes = {}
g_dirHomeTypes[0] = { "hgn_mothership", "hgn_shipyard" }
g_dirHomeTypes[1] = { "vgr_mothership", "vgr_mothership_makaan", "vgr_shipyard" }

-- Fill outName with all of playerIndex's ships whose type is in typeList.
-- Accumulates via SobGroup_SobGroupAdd (no aliasing of union operands).
function Tactics_FillByTypes(playerIndex, outName, typeList)
    SobGroup_Create(outName)
    SobGroup_Clear(outName)
    local tmp = outName .. "_tmp"
    SobGroup_Create(tmp)
    local i, t
    for i, t in typeList do
        SobGroup_Clear(tmp)
        Player_FillShipsByType(tmp, playerIndex, t)
        SobGroup_SobGroupAdd(outName, tmp)
    end
    return SobGroup_Count(outName)
end

function Tactics_FillStrikeShips(p, outName)
    local types = g_dirStrikeTypes[Player_GetRace(p)]
    if types == NIL then types = g_dirStrikeTypes[0] end
    return Tactics_FillByTypes(p, outName, types)
end

function Tactics_FillHome(p, outName)
    local types = g_dirHomeTypes[Player_GetRace(p)]
    if types == NIL then types = g_dirHomeTypes[0] end
    return Tactics_FillByTypes(p, outName, types)
end

-- Enemy target: prefer capitals; if none, fall back to home structures so we
-- always have an exit anchor while the enemy is alive.
function Tactics_FillTarget(enemyIndex, outName)
    SobGroup_Create(outName)
    SobGroup_Clear(outName)
    if enemyIndex < 0 then return 0 end
    local capTypes = g_dirStrikeTypes[Player_GetRace(enemyIndex)]
    if capTypes == NIL then capTypes = g_dirStrikeTypes[0] end
    local n = Tactics_FillByTypes(enemyIndex, outName, capTypes)
    if n == 0 then
        local homeTypes = g_dirHomeTypes[Player_GetRace(enemyIndex)]
        if homeTypes == NIL then homeTypes = g_dirHomeTypes[0] end
        n = Tactics_FillByTypes(enemyIndex, outName, homeTypes)
    end
    return n
end

-- First alive, non-allied player relative to p.
function Tactics_PickTargetPlayer(p)
    local q
    for q = 0, Universe_PlayerCount() - 1 do
        if q ~= p and Player_IsAlive(q) == 1 and AreAllied(p, q) == 0 then
            return q
        end
    end
    return -1
end

function Tactics_JumpsAllowed()
    if g_disableDirectorJumps == 1 then return 0 end
    return 1
end

-- Difficulty-scaled thresholds. getLevelOfDifficulty() may be absent in the
-- rules VM; default to the most aggressive (arena) profile if so.
function Tactics_Knobs()
    local lod = 2
    if getLevelOfDifficulty then lod = getLevelOfDifficulty() end
    local k = {
        minStrikeShips = 2,   -- capitals required before committing a strike
        jumpCooldown   = 25,  -- seconds between strikes (gate measured from regroup end)
        engageMaxTime  = 30,  -- seconds before a strike breaks off regardless
        breakHealth    = 0.45,-- group HealthPercentage that triggers hit-n-run
        regroupTime    = 20,  -- seconds parked at home before re-forming
        regroupHealth  = 0.75,-- group HealthPercentage required to re-form
        exitProximity  = 900, -- distance to exit hyperspace from the anchor group
        hyperMaxTime   = 12,  -- watchdog: max seconds allowed in transit
        reissueAttack  = 4,   -- seconds between AttackPlayer re-issues
    }
    if lod == 0 then            -- Easy
        k.minStrikeShips = 3; k.jumpCooldown = 70; k.engageMaxTime = 22
        k.breakHealth = 0.60; k.regroupTime = 40
    elseif lod == 1 then        -- Medium
        k.jumpCooldown = 45; k.breakHealth = 0.50; k.regroupTime = 28
    end
    return k
end
```

- [ ] **Step 2: Temporarily log counts from the stub**

Replace `strikegroup.lua`'s stub body with a count probe (this is replaced wholesale in Task 4):

```lua
function StrikeGroup_Update(p)
    local st = g_directorState[p]
    local n = Tactics_FillStrikeShips(p, st.strikeName)
    local tp = Tactics_PickTargetPlayer(p)
    Director_Trace("p" .. p .. " strike=" .. n .. " targetPlayer=" .. tp .. " jumps=" .. Tactics_JumpsAllowed())
end
```

- [ ] **Step 3: Link, launch, verify counts**

Run `pwsh tools\link-src.ps1` then `pwsh tools\launch-tpof.ps1`. Skirmish on `2p_as_sirat`, run ~4 min (until the AI has capitals). Then `pwsh tools\parse-logs.ps1 -Lua`.
Expected: `DIRECTOR: p1 strike=0 ...` early, rising to `strike=1`+ once the AI builds a Battlecruiser; `targetPlayer=0`; `jumps=1`. No `LUA ERROR`.

- [ ] **Step 4: Verify the jump-disable flag**

Repeat on `2p_research_outpost`. Expected identical lines but `jumps=0`.

- [ ] **Step 5: Commit**

```
git add src/scripts/director/tactics.lua src/scripts/director/strikegroup.lua
git commit -m "Implement director tactics helpers (strike/home/target groups, knobs)"
```

---

### Task 4: State machine with conventional movement (no jumps)

Implement the full FORM → ENGAGE → REGROUP loop using conventional orders only (`SobGroup_AttackPlayer`, `SobGroup_MoveToSobGroup`). This validates the loop and the order-precedence hand-off before adding hyperspace. INBOUND/OUTBOUND states exist but are skipped (jumps off).

**Files:**
- Modify: `src/scripts/director/strikegroup.lua` (replace probe with the machine).

**Interfaces:**
- Produces: `StrikeGroup_Update`, `StrikeGroup_Enter`, `StrikeGroup_BeginStrike`, `StrikeGroup_BeginBreak`.
- Consumes: all `Tactics_*`, `Director_Trace`, `g_directorState`.

- [ ] **Step 1: Replace `src/scripts/director/strikegroup.lua` with the state machine**

Note: the strike group is **refreshed only in real-space states** (FORM/ENGAGE/REGROUP). During INBOUND/OUTBOUND the group holds ships that are off-map; re-filling would drop them. (Jumps are wired in Task 5; the INBOUND/OUTBOUND branches are present but only reached when `Tactics_JumpsAllowed()==1`.)

```lua
-- Slipstream: Tactical Director - strike-group state machine

function StrikeGroup_Enter(st, newState, now)
    st.state = newState
    st.stateTime = now
end

-- Commit a formed strike group toward the chosen target.
function StrikeGroup_BeginStrike(p, st, k, now)
    if Tactics_JumpsAllowed() == 1 then
        Director_Trace("p" .. p .. " STRIKE jump-in")
        SobGroup_EnterHyperSpaceOffMap(st.strikeName)
        StrikeGroup_Enter(st, "INBOUND", now)
    else
        Director_Trace("p" .. p .. " STRIKE conventional")
        SobGroup_AttackPlayer(st.strikeName, st.targetPlayer)
        st.lastAttackTime = now
        StrikeGroup_Enter(st, "ENGAGE", now)
    end
end

-- Break off (hit-n-run): jump home if allowed, else retreat-move home.
function StrikeGroup_BeginBreak(p, st, k, now)
    if Tactics_JumpsAllowed() == 1 then
        Director_Trace("p" .. p .. " BREAK jump-out")
        SobGroup_EnterHyperSpaceOffMap(st.strikeName)
        StrikeGroup_Enter(st, "OUTBOUND", now)
    else
        Director_Trace("p" .. p .. " BREAK retreat")
        Tactics_FillHome(p, st.homeName)
        if SobGroup_Count(st.homeName) > 0 then
            SobGroup_MoveToSobGroup(st.strikeName, st.homeName)
        end
        StrikeGroup_Enter(st, "REGROUP", now)
    end
end

function StrikeGroup_Update(p)
    local st = g_directorState[p]
    local k = Tactics_Knobs()
    local now = gameTime()

    -- Refresh strike membership only in real-space states.
    local strikeCount
    if st.state == "FORM" or st.state == "ENGAGE" or st.state == "REGROUP" then
        strikeCount = Tactics_FillStrikeShips(p, st.strikeName)
    else
        strikeCount = SobGroup_Count(st.strikeName)
    end

    if st.state == "FORM" then
        if strikeCount >= k.minStrikeShips and (now - st.lastJumpTime) >= k.jumpCooldown then
            st.targetPlayer = Tactics_PickTargetPlayer(p)
            if st.targetPlayer >= 0 and Tactics_FillTarget(st.targetPlayer, st.targetName) > 0 then
                st.lastJumpTime = now
                StrikeGroup_BeginStrike(p, st, k, now)
            end
        end
        return
    end

    if st.state == "INBOUND" then
        if SobGroup_AreAllInHyperspace(st.strikeName) == 1 then
            if Tactics_FillTarget(st.targetPlayer, st.targetName) > 0 then
                SobGroup_ExitHyperSpaceSobGroup(st.strikeName, st.targetName, k.exitProximity)
            else
                Tactics_FillHome(p, st.homeName)
                SobGroup_ExitHyperSpaceSobGroup(st.strikeName, st.homeName, k.exitProximity)
            end
            SobGroup_AttackPlayer(st.strikeName, st.targetPlayer)
            st.lastAttackTime = now
            StrikeGroup_Enter(st, "ENGAGE", now)
        elseif (now - st.stateTime) > k.hyperMaxTime then
            Tactics_FillHome(p, st.homeName)
            SobGroup_ExitHyperSpaceSobGroup(st.strikeName, st.homeName, k.exitProximity)
            Director_Trace("p" .. p .. " INBOUND watchdog -> home")
            StrikeGroup_Enter(st, "REGROUP", now)
        end
        return
    end

    if st.state == "ENGAGE" then
        if strikeCount == 0 then
            StrikeGroup_Enter(st, "FORM", now)
            return
        end
        if (now - st.lastAttackTime) >= k.reissueAttack then
            if Player_IsAlive(st.targetPlayer) == 1 then
                SobGroup_AttackPlayer(st.strikeName, st.targetPlayer)
            end
            st.lastAttackTime = now
        end
        local hp = SobGroup_HealthPercentage(st.strikeName)
        local targetGone = (Player_IsAlive(st.targetPlayer) == 0) or (Tactics_FillTarget(st.targetPlayer, st.targetName) == 0)
        if hp < k.breakHealth or (now - st.stateTime) > k.engageMaxTime or targetGone then
            StrikeGroup_BeginBreak(p, st, k, now)
        end
        return
    end

    if st.state == "OUTBOUND" then
        if SobGroup_AreAllInHyperspace(st.strikeName) == 1 or (now - st.stateTime) > k.hyperMaxTime then
            Tactics_FillHome(p, st.homeName)
            if SobGroup_Count(st.homeName) > 0 then
                SobGroup_ExitHyperSpaceSobGroup(st.strikeName, st.homeName, k.exitProximity)
            end
            StrikeGroup_Enter(st, "REGROUP", now)
        end
        return
    end

    if st.state == "REGROUP" then
        -- Stop issuing orders; the cpu brain reclaims these ships. Re-form once
        -- parked long enough and healthy enough, gated by the jump cooldown.
        local hp = SobGroup_HealthPercentage(st.strikeName)
        if (now - st.stateTime) >= k.regroupTime and hp >= k.regroupHealth then
            st.lastJumpTime = now
            StrikeGroup_Enter(st, "FORM", now)
        end
        return
    end
end
```

- [ ] **Step 2: Link, launch, verify the conventional loop on a no-jump map**

Run `pwsh tools\link-src.ps1`, `pwsh tools\launch-tpof.ps1`. Skirmish on `2p_research_outpost` (jumps OFF). Run ~6 min. Watch the AI's Battlecruisers/Destroyers group up and attack-move at you, then retreat home when damaged, then return. Then `pwsh tools\parse-logs.ps1 -Lua`.
Expected trace cycle: `STRIKE conventional` → (engage) → `BREAK retreat`, repeating. No `LUA ERROR`.

- [ ] **Step 3: Verify hand-off — brain reclaims ships in REGROUP**

During a REGROUP window, confirm the retreated capitals resume normal AI behavior (they don't sit frozen — the cpu brain re-tasks them) until the next `STRIKE`. If they freeze, the order-precedence assumption needs revisiting; note it but it does not block (the director re-commands on next FORM).

- [ ] **Step 4: Commit**

```
git add src/scripts/director/strikegroup.lua
git commit -m "Implement director state machine with conventional hit-n-run"
```

---

### Task 5: Hyperspace jump-strikes + watchdog

Enable the jump path (already coded in Task 4's INBOUND/OUTBOUND branches). This task is verification + tuning of the live jump behavior on a hyperspace-enabled map, plus confirming the off-map watchdog never strands ships.

**Files:**
- Modify: `src/scripts/director/tactics.lua` (tune `exitProximity`/`hyperMaxTime` only if needed).

**Interfaces:** unchanged.

- [ ] **Step 1: Link, launch, observe live jumps**

Run `pwsh tools\link-src.ps1`, `pwsh tools\launch-tpof.ps1`. Skirmish on `2p_as_sirat` (jumps ON). Run ~6 min. Watch for: AI capitals vanish (`STRIKE jump-in`), reappear next to your fleet/mothership and attack, then vanish (`BREAK jump-out`) and reappear at their base. Then `pwsh tools\parse-logs.ps1 -Lua` / `-Errors`.
Expected cycle: `STRIKE jump-in` → `ENGAGE` → `BREAK jump-out` → REGROUP → repeat. No `LUA ERROR`.

- [ ] **Step 2: Verify the watchdog never strands ships**

Confirm no `INBOUND watchdog -> home` storms (occasional is fine). Critically, after every jump cycle the strike capitals must be present in real space (not lost off-map). If ships ever disappear permanently, reduce risk by lowering `hyperMaxTime` to `8` in `Tactics_Knobs` and ensure the watchdog exit uses the home anchor (it does). Re-test.

- [ ] **Step 3: Tune exit proximity**

If ships exit too far from / on top of the target, adjust `exitProximity` in `Tactics_Knobs` (try `500`–`1500`) and re-test until strikes land at a sensible engagement range. Commit the chosen value.

- [ ] **Step 4: Commit**

```
git add src/scripts/director/tactics.lua
git commit -m "Tune director hyperspace jump-strike proximity and watchdog"
```

---

### Task 6: Target selection priority

Upgrade target picking from "first enemy / their capitals" to arena priority: isolated enemy capital → enemy mothership/production → main fleet. Keep it simple and robust.

**Files:**
- Modify: `src/scripts/director/tactics.lua` (`Tactics_FillTarget` and add `Tactics_PickTargetPlayer` weakest-enemy preference).

**Interfaces:**
- `Tactics_FillTarget` and `Tactics_PickTargetPlayer` keep their signatures (behavior changes only).

- [ ] **Step 1: Prefer the weakest alive enemy as target player**

Replace `Tactics_PickTargetPlayer` in `tactics.lua` with a version that picks the alive non-ally with the fewest awake ships (easiest to crack — arena aggression):

```lua
function Tactics_PickTargetPlayer(p)
    local best = -1
    local bestShips = 999999
    local q
    for q = 0, Universe_PlayerCount() - 1 do
        if q ~= p and Player_IsAlive(q) == 1 and AreAllied(p, q) == 0 then
            local n = Player_NumberOfAwakeShips(q)
            if n < bestShips then
                bestShips = n
                best = q
            end
        end
    end
    return best
end
```

- [ ] **Step 2: Target the enemy's home/production when they have no fielded capitals**

`Tactics_FillTarget` already falls back to home structures when the enemy has no capitals — that is the raid/decap behavior. No code change needed; confirm by reading it. (If you want capitals-first only when the enemy capital count ≥ 2, that is a future refinement, not in scope.)

- [ ] **Step 3: Link, launch, verify targeting in a 3-player game**

Run `pwsh tools\link-src.ps1`, `pwsh tools\launch-tpof.ps1`. Skirmish on `3p_standoff` (FFA): you = slot 0, two AIs. Run ~7 min. Expected: each AI's strikes focus the weaker opponent; no `LUA ERROR` in `parse-logs.ps1 -Errors`.

- [ ] **Step 4: Commit**

```
git add src/scripts/director/tactics.lua
git commit -m "Add weakest-enemy target priority to director"
```

---

### Task 7: Difficulty tuning pass + docs

Final tuning of the knobs across difficulties and a short doc so the system is maintainable.

**Files:**
- Modify: `src/scripts/director/tactics.lua` (final knob values).
- Create: `docs/ai_director.md`.

**Interfaces:** unchanged.

- [ ] **Step 1: Playtest each difficulty and finalize knobs**

Run skirmishes on `2p_as_sirat` at AI difficulty Easy, Medium, Hard (set in the lobby). For each, confirm the intended cadence: Hard = relentless frequent jumps; Medium = periodic; Easy = occasional. Adjust `Tactics_Knobs` per-`lod` values to taste; the structure is already in place from Task 3. Keep edits to the numeric fields only.

- [ ] **Step 2: Write `docs/ai_director.md`**

```markdown
# AI Tactical Director

Game-rules-VM system (`src/scripts/director/`) that drives each AI player's
capital ships in hyperspace jump-strikes and hit-n-run, hooked from
`deathmatch.lua` as `Rule_AddInterval("Director_Tick", 2)`.

## Files
- `director.lua` — init, tick loop, AI-player set (`g_directorHumanPlayers`
  lists human slots to exclude), `Director_Trace`.
- `tactics.lua` — strike/home/target SobGroup builders, target selection,
  `Tactics_JumpsAllowed` (reads `g_disableDirectorJumps`), `Tactics_Knobs`
  (difficulty-scaled thresholds).
- `strikegroup.lua` — per-player state machine:
  FORM → INBOUND → ENGAGE → OUTBOUND → REGROUP.

## Jumps
Scripted teleport: `SobGroup_EnterHyperSpaceOffMap` then
`SobGroup_ExitHyperSpaceSobGroup(strike, anchor, proximity)`. Free and
cooldown-gated (no module/RU). Disabled on maps that set
`g_disableDirectorJumps = 1` (research_outpost, assault, mining_outpost,
garrison) — those fall back to conventional attack-move + retreat.

## Coordination with the cpu brain
Separate Lua VMs, no shared state. Explicit SCAR orders override AI orders
while issued; in REGROUP the director stops ordering so the brain reclaims
the ships. The strike SobGroup is refreshed only in real-space states so
off-map ships are never dropped; the `hyperMaxTime` watchdog force-exits any
group stuck in transit at its home anchor.

## Tuning
All thresholds live in `Tactics_Knobs` in `tactics.lua`, scaled by
`getLevelOfDifficulty()`.
```

- [ ] **Step 3: Update `docs/todo.md`**

Strike the completed AI sub-items for hyperspacing and hit-n-run (leave loadout/build items for the brain-rewrite plan). Edit the `Fix AI` block to reflect director completion.

- [ ] **Step 4: Final regression pass**

Run one skirmish each on `2p_as_sirat` (jumps on) and `5p_mining_outpost` (jumps off), both races for the AI (force via the lobby race pick). `parse-logs.ps1 -Errors` must be clean on both.

- [ ] **Step 5: Commit**

```
git add src/scripts/director/tactics.lua docs/ai_director.md docs/todo.md
git commit -m "Finalize director difficulty tuning and add director docs"
```

---

## Self-Review

**Spec coverage (Layer B / director scope of `2026-06-29-ai-rebuild-design.md`):**
- Phase 0 smoke test → Task 1. ✅
- Director scaffold, AI-only gate, hyperspace-disabled gate → Task 2. ✅
- Strike-group formation + helpers (§6, §6.1) → Task 3. ✅
- State machine FORM→…→REGROUP with conventional movement (§6) → Task 4. ✅
- Hyperspace jump-strike/out + off-map watchdog (§6.3) → Task 5. ✅
- Target selection priority (§6.1) → Task 6. ✅
- Difficulty scaling (§6.2) → Task 3 structure + Task 7 tuning. ✅
- Coordination via order-precedence (§3) → exercised/verified in Task 4 Step 3. ✅
- *Out of scope here (Layer A, separate plan):* economy/build/counter-comp loadouts/research/grouping. Noted in the plan header.

**Placeholder scan:** No `TBD`/`TODO`/"handle edge cases" left. The AI-detection item is implemented with a working interim and an explicit discovery step (Task 2 Step 4), not deferred. The Task 1 code is intentionally throwaway and is removed in Task 2 Step 3.

**Type/name consistency:** `g_directorState` fields (`state`, `strikeName`, `homeName`, `targetName`, `targetPlayer`, `stateTime`, `lastJumpTime`, `lastAttackTime`) are defined in Task 2 and used identically in Tasks 3–6. `Tactics_*` and `StrikeGroup_*` signatures match the File Structure contract throughout. State names (`FORM`/`INBOUND`/`ENGAGE`/`OUTBOUND`/`REGROUP`) are consistent across `BeginStrike`/`BeginBreak`/`Update`. Knob field names (`minStrikeShips`, `jumpCooldown`, `engageMaxTime`, `breakHealth`, `regroupTime`, `regroupHealth`, `exitProximity`, `hyperMaxTime`, `reissueAttack`) defined in Task 3 and used in Task 4. ✅

**Known risks flagged inline:** jump-mechanism viability (Task 1 gates Task 5); AI detection (Task 2 Step 4); order-precedence hand-off (Task 4 Step 3). All have stated fallbacks.
