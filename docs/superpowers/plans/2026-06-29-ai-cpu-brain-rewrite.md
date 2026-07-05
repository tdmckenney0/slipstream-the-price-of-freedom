# AI CPU Brain Rewrite Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild the per-AI-player "cpu brain" so it builds ships aggressively and re-fits its capitals' weapon loadouts to counter the enemy's fleet composition — a complete, arena-aggressive AI that is fully playable and auditable **without** the tactical director.

**Architecture:** In-place rewrite of the files under `src/ai/`, keeping existing filenames so `dofilepath` includes stay intact and each file produces a clean reviewable git diff. The rewrite preserves the current fork's hard-won crash guards (nil-checks on engine globals, the restrict.lua/free-research interplay, capital arming) and re-tunes economy, build, loadout, and military behavior for aggression. Runs in the AI VM; uses only the proven cpu-layer API. Independent of the director plan (`2026-06-29-ai-tactical-director.md`) — no shared code, no Phase 0 dependency.

**Tech Stack:** HW2 Classic Lua (Lua-4.0-style dialect — see Global Constraints), the HW2 AI `cp*`/`Cpu*`/demand API, PowerShell 7 dev tooling under `tools/`.

**Companion spec:** `docs/superpowers/specs/2026-06-29-ai-rebuild-design.md` (Layer A).

## Global Constraints

- **Lua dialect (HW2 Classic):** No `#` length operator, no `pairs`/`ipairs`/`table.insert`. Iterate with `for k, v in t do ... end`. Use `NIL` for engine nil (matches existing AI code). Concatenate with `..`. Violations throw Lua errors at load.
- **Preserve crash guards:** Every `(x or 0)` / `if foo == NIL` guard in the current files exists because an engine global was nil in some game state. When rewriting a function, carry its guards forward. Do not "clean up" a guard you cannot prove is unnecessary.
- **Platform:** Windows, PowerShell 7+ (`pwsh`). Repo temp dir is `.tmp\`.
- **No `Co-Authored-By:` trailers** in commits. **Do not commit** unless the user has reviewed — this plan's steps stage but the user controls commits (see each task's final step note).
- **Buildable capital ceiling:** standard Battlecruiser + Destroyer only. Heavy battlecruisers / flagships are starting-fleet units and must never be added to build demand (see `src/ship/CLAUDE.md`).
- **Validation is in-game.** No unit harness. Each task: link source, run a skirmish vs one AI, observe, and assert on `tools\parse-logs.ps1` (no `ERROR`/`LUA ERROR`, plus the AI's expected `aitrace` lines via `-Lua`). `parse-logs.ps1` exits 1 if any error is found.
- **Iteration loop (every task):**
  - `pwsh tools\link-src.ps1`
  - `pwsh tools\launch-tpof.ps1`
  - In-game: Skirmish, your seat = slot 0, **one Computer opponent** = slot 1, the task's map, start. To audit the AI directly, you may also add **two Computer players and spectate** if the build supports it; otherwise play passively and watch the AI's economy/fleet.
  - `pwsh tools\parse-logs.ps1 -Errors` then `pwsh tools\parse-logs.ps1 -Lua`
  - PASS = no errors + expected behavior/trace.

---

## File Structure (in-place rewrite — same filenames)

- `src/ai/default.lua` — controller/oninit/doai tick. Minor: keep aggressive tick/spend tuning; no structural change.
- `src/ai/cpuresource.lua` — economy: lean collectors, fast military pivot (retune).
- `src/ai/cpubuild.lua` — ship build demand: sustained aggression, constant production floor (retune); capital ceiling enforced.
- `src/ai/cpubuildsubsystem.lua` — capital arming **+ new counter-composition loadout selection and refit**.
- `src/ai/cpumilitary.lua` — grouping + aggressive wave timing for the **whole** fleet (stays full-featured; director, when added later, overrides by order-precedence).
- `src/ai/cpuresearch.lua`, `src/ai/classdef.lua` — verify and carry forward; no behavioral change.

**New functions introduced (contract):**
- `CpuLoadout_Mode()` → `"antistrike"` | `"anticap"` | `"balanced"` (in `cpubuildsubsystem.lua`).
- `CpuLoadout_DesiredTurrets(shipType, mode)` → turret-constant list or `NIL`.
- `CpuBuildSS_RefitMismatchedTurret(buildShipId, desiredList)` → `1`/`0`.

These reuse existing globals already set by the brain: `s_race`, `s_enemyIndex`, `kBattleCruiser`, `kDestroyer`, `player_max`, `Race_Hiigaran`, and the turret constants already referenced in the current `CpuBuildSS_NextMissingTurret` (`BCIONBEAMTURRET1`, `BCGATLINGGUNTURRET1`, `BCPLASMABURSTTURRET1`, `DDPLASMABURSTTURRET1`, `DDGATLINGGUNTURRET1`, `BCHEAVYFUSIONMISSILE`, `DDPULSECANNONTURRET1`, `DDSCATTERSHOTTURRET1`).

---

### Task 1: Baseline capture (no code change)

Record current AI behavior so later tasks have a comparison and so we confirm the toolchain works before changing anything.

**Files:** none (observation only).

- [ ] **Step 1: Confirm the current AI loads clean**

Run:
```
pwsh tools\link-src.ps1
pwsh tools\launch-tpof.ps1
```
Skirmish on `2p_as_sirat`, slot 0 you, slot 1 AI. Run ~8 minutes. Then:
```
pwsh tools\parse-logs.ps1 -Errors
pwsh tools\parse-logs.ps1 -Lua
```

- [ ] **Step 2: Write down the baseline**

In a scratch note (not committed), record: how many collectors the AI settles on, roughly when it first fields a Battlecruiser, whether its capitals ever have weapon turrets fitted, and the approximate fleet size at 8 min. This is the before-picture for goals #3 (build volume) and #2 (loadouts). No commit.

---

### Task 2: Aggressive economy (`cpuresource.lua`)

Make the economy pivot to military faster and harder, without starving collection so much that production stalls.

**Files:**
- Modify: `src/ai/cpuresource.lua` (`CpuResource_Init`, `CalcDesiredNumCollectors`).

**Interfaces:**
- Produces: same function names/globals (`sg_desiredNumCollectors`, `sg_militaryToBuildPerCollector`, `sg_minNumCollectors`, `sg_maxNumCollectors`). No signature changes.

- [ ] **Step 1: Raise the military-build ratio and lower the collector ceiling**

In `CpuResource_Init`, change the collector bounds (currently `sg_minNumCollectors = 3`, `sg_maxNumCollectors = 15`) to:

```lua
    sg_minNumCollectors = 3
    sg_maxNumCollectors = 12
```

In `CalcDesiredNumCollectors`, the block that boosts military priority over time currently reads:

```lua
    -- SLIPSTREAM: Increase military priority as game progresses
    if gametime > 240 then
        sg_militaryToBuildPerCollector = sg_militaryToBuildPerCollector + 2
    end
```

Replace with a stronger, earlier ramp:

```lua
    -- SLIPSTREAM: Increase military priority as game progresses (arena: earlier+steeper)
    if gametime > 150 then
        sg_militaryToBuildPerCollector = sg_militaryToBuildPerCollector + 2
    end
    if gametime > 360 then
        sg_militaryToBuildPerCollector = sg_militaryToBuildPerCollector + 2
    end
```

- [ ] **Step 2: Keep the hard collector cap honest**

Confirm the existing hard cap block remains (do not remove):

```lua
    -- SLIPSTREAM: Hard cap at 10 collectors - focus on military
    if sg_desiredNumCollectors > 10 then
        sg_desiredNumCollectors = 10
    end
```

- [ ] **Step 3: Link, launch, verify economy pivots**

Run the iteration loop on `2p_as_sirat`, ~6 min. Expected via `parse-logs.ps1 -Lua`: collector count plateaus ≤10 and `Build collector` lines taper off after ~2.5 min while military builds continue. No `LUA ERROR`.

- [ ] **Step 4: Stage (do not commit)**

```
git add src/ai/cpuresource.lua
```
Leave for user review. Do not run `git commit`.

---

### Task 3: Aggressive ship building (`cpubuild.lua`) — goal #4

Increase sustained ship demand and keep build channels busy, while respecting the capital ceiling.

**Files:**
- Modify: `src/ai/cpubuild.lua` (`CpuBuild_Init`, `DetermineSpecialDemand`).

**Interfaces:**
- Produces: unchanged signatures. `sg_shipDemand`, `sg_militaryToBuildPerCollector`, ship-demand calls.

- [ ] **Step 1: Raise the baseline ship demand**

In `CpuBuild_Init`, the current values are `sg_shipDemand = 8` and `sg_militaryToBuildPerCollector = 2`. Keep `sg_militaryToBuildPerCollector = 2` (resource code tunes it) and raise sustained ship demand:

```lua
    sg_subSystemOverflowDemand = 0
    sg_subSystemDemand = 0
    sg_shipDemand = 12                 -- arena: keep ship queues saturated
    sg_militaryToBuildPerCollector = 2 -- Always prioritize military
```

- [ ] **Step 2: Strengthen the capital-build pulse (ceiling-safe)**

In `DetermineSpecialDemand`, the current capital block adds `kBattleCruiser` 3.0 and `kDestroyer` 1.5 once economy is up, with a +2.0/+1.0 bonus past 2000 RU. Keep `kBattleCruiser`/`kDestroyer` only (never heavy caps) and make the floor kick in slightly earlier and stronger:

```lua
    -- Always try to build capitals once basic economy is up
    if numCollecting >= 3 or numRUs > 400 then
        if kBattleCruiser then
            ShipDemandAdd(kBattleCruiser, 3.5)
        end
        if kDestroyer then
            ShipDemandAdd(kDestroyer, 2.0)
        end

        -- Even higher priority when we have RUs
        if numRUs > 1800 then
            if kBattleCruiser then
                ShipDemandAdd(kBattleCruiser, 2.0)
            end
            if kDestroyer then
                ShipDemandAdd(kDestroyer, 1.0)
            end
        end
    end
```

- [ ] **Step 3: Confirm no heavy-capital demand exists anywhere**

Search to prove the ceiling is respected:
```
pwsh -Command "Select-String -Path src/ai/cpubuild.lua -Pattern 'kHeavyBattleCruiser','HEAVYCRUISER','QWAARJETII','Dreadnaught'"
```
Expected: no `ShipDemandAdd`/`Build` call targets a heavy capital. (`kHeavyBattleCruiser` may appear only in counting/recognition, not in build demand.) If any build demand on a heavy capital exists, remove it.

- [ ] **Step 4: Link, launch, verify build volume**

Iteration loop on `2p_as_sirat`, ~8 min. Expected: visibly more ships than the Task 1 baseline; steady `**DoMilitaryBuild` and `Build` lines; Battlecruisers appear earlier. `parse-logs.ps1 -Errors` clean.

- [ ] **Step 5: Stage (do not commit)**

```
git add src/ai/cpubuild.lua
```
Leave for user review.

---

### Task 4: Counter-composition loadouts (`cpubuildsubsystem.lua`) — goal #2

Make capital arming choose the turret mix based on the enemy's fleet, and re-fit when the enemy composition decisively shifts.

**Files:**
- Modify: `src/ai/cpubuildsubsystem.lua` (`CpuBuildSS_Init`, replace `CpuBuildSS_NextMissingTurret`, add `CpuLoadout_Mode`, `CpuLoadout_DesiredTurrets`, `CpuBuildSS_RefitMismatchedTurret`, hook into `CpuBuildSS_ArmCapitalShips`).

**Interfaces:**
- Consumes: `s_race`, `s_enemyIndex`, `kBattleCruiser`, `kDestroyer`, `player_max`, `Race_Hiigaran`, `eBattleCruiser`, `eHeavyBattleCruiser`, turret constants, and `BuildShipType`/`BuildShipHasSubSystem`/`BuildShipCanBuild`/`BuildSubSystemOnShip`/`RetireSubSystem` (all already used in this file).
- Produces: `CpuLoadout_Mode`, `CpuLoadout_DesiredTurrets`, `CpuBuildSS_RefitMismatchedTurret`; revised `CpuBuildSS_NextMissingTurret`.

- [ ] **Step 1: Add the enemy-composition mode selector**

Add near the top of `cpubuildsubsystem.lua` (after `CpuBuildSS_Init`):

```lua
-- Decide which turret bias to fit on capitals based on the chosen enemy's fleet.
-- "antistrike" when the enemy leans fighters/corvettes; "anticap" when it leans
-- frigates/capitals; "balanced" when mixed or the enemy is unknown.
function CpuLoadout_Mode()
    local e = s_enemyIndex
    if e == -1 then
        return "balanced"
    end
    local strike = PlayersMilitary_Fighter(e, player_max) + PlayersMilitary_Corvette(e, player_max)
    local heavy = PlayersMilitary_Frigate(e, player_max)
        + (PlayersUnitTypeCount(e, player_max, eBattleCruiser) or 0) * 80
        + (PlayersUnitTypeCount(e, player_max, eHeavyBattleCruiser) or 0) * 120
    if strike > (heavy * 1.6) and strike > 20 then
        return "antistrike"
    end
    if heavy > (strike * 1.6) and heavy > 20 then
        return "anticap"
    end
    return "balanced"
end
```

- [ ] **Step 2: Add the desired-turret table (constants resolved at call time)**

```lua
-- Desired turret list for a capital, given its type and the loadout mode.
-- Turret constants are the same ones the prior fixed loadout used; they resolve
-- at call time (the .subs are loaded by then). Returns NIL for non-capitals.
function CpuLoadout_DesiredTurrets(shipType, mode)
    if s_race == Race_Hiigaran then
        if shipType == kBattleCruiser then
            if mode == "anticap" then
                return { BCIONBEAMTURRET1, BCPLASMABURSTTURRET1 }
            elseif mode == "antistrike" then
                return { BCGATLINGGUNTURRET1, BCPLASMABURSTTURRET1 }
            else
                return { BCIONBEAMTURRET1, BCGATLINGGUNTURRET1 }
            end
        elseif shipType == kDestroyer then
            if mode == "anticap" then
                return { DDPLASMABURSTTURRET1 }
            elseif mode == "antistrike" then
                return { DDGATLINGGUNTURRET1, DDPLASMABURSTTURRET1 }
            else
                return { DDPLASMABURSTTURRET1, DDGATLINGGUNTURRET1 }
            end
        end
    else
        if shipType == kBattleCruiser then
            -- Single missile-battery slot; one anti-capital option.
            return { BCHEAVYFUSIONMISSILE }
        elseif shipType == kDestroyer then
            if mode == "anticap" then
                return { DDPULSECANNONTURRET1 }
            elseif mode == "antistrike" then
                return { DDSCATTERSHOTTURRET1, DDPULSECANNONTURRET1 }
            else
                return { DDPULSECANNONTURRET1, DDSCATTERSHOTTURRET1 }
            end
        end
    end
    return NIL
end
```

- [ ] **Step 3: Replace `CpuBuildSS_NextMissingTurret` to use the desired list**

Replace the entire existing `CpuBuildSS_NextMissingTurret` function with:

```lua
-- Pick the next desired turret missing from a capital's slots, chosen by the
-- current loadout mode. Returns a subsystem constant or 0 if nothing to fit.
function CpuBuildSS_NextMissingTurret(buildShipId)
    local shipType = BuildShipType(buildShipId)
    local turrets = CpuLoadout_DesiredTurrets(shipType, CpuLoadout_Mode())
    if turrets == NIL then
        return 0
    end
    local i, t
    for i, t in turrets do
        if t and BuildShipHasSubSystem(buildShipId, t) == 0 and BuildShipCanBuild(buildShipId, t) == 1 then
            return t
        end
    end
    return 0
end
```

- [ ] **Step 4: Add a conservative refit that swaps a wrong-role turret**

When the mode is decisive (`antistrike`/`anticap`) and a ship carries a turret that is not in the desired list, retire it so the next pass fits the right one. Gate by a cooldown so it cannot thrash. Add:

```lua
-- If a capital carries a turret that isn't in the desired list for a decisive
-- mode, retire one such turret (next pass re-arms correctly). Cooldown-gated to
-- prevent churn. Returns 1 if a turret was retired.
function CpuBuildSS_RefitMismatchedTurret(buildShipId, desiredList)
    if desiredList == NIL then
        return 0
    end
    local now = gameTime()
    if (now - (sg_lastRefitTime or -9999)) < (sg_refitCooldown or 60) then
        return 0
    end

    -- All turret constants this ship class could carry (both races, both types).
    local allTurrets = {
        BCIONBEAMTURRET1, BCGATLINGGUNTURRET1, BCPLASMABURSTTURRET1, BCHEAVYFUSIONMISSILE,
        DDPLASMABURSTTURRET1, DDGATLINGGUNTURRET1, DDPULSECANNONTURRET1, DDSCATTERSHOTTURRET1,
    }
    local i, t, j, d
    for i, t in allTurrets do
        if t and BuildShipHasSubSystem(buildShipId, t) == 1 then
            local wanted = 0
            for j, d in desiredList do
                if d == t then
                    wanted = 1
                end
            end
            if wanted == 0 then
                aitrace("Loadout refit: retire mismatched turret")
                RetireSubSystem(buildShipId, t)
                sg_lastRefitTime = now
                return 1
            end
        end
    end
    return 0
end
```

- [ ] **Step 5: Initialize the refit cooldown and hook refit into arming**

In `CpuBuildSS_Init`, add:

```lua
    sg_lastRefitTime = -9999
    sg_refitCooldown = 60
```

Then replace `CpuBuildSS_ArmCapitalShips` with a version that fits missing desired turrets first, then refits one mismatch:

```lua
function CpuBuildSS_ArmCapitalShips()
    local bcount = BuildShipCount()
    if bcount == 0 then
        return 0
    end

    local mode = CpuLoadout_Mode()
    local i
    for i = 0, (bcount - 1), 1 do
        local buildShipId = BuildShipAt(i)
        local armTurret = CpuBuildSS_NextMissingTurret(buildShipId)
        if armTurret ~= 0 then
            aitrace("Arm capital: build turret (mode " .. mode .. ")")
            BuildSubSystemOnShip(buildShipId, armTurret)
            return 1
        end
    end

    -- Nothing missing to add: consider one mismatch refit (cooldown-gated).
    for i = 0, (bcount - 1), 1 do
        local buildShipId = BuildShipAt(i)
        local shipType = BuildShipType(buildShipId)
        local desired = CpuLoadout_DesiredTurrets(shipType, mode)
        if (mode == "antistrike" or mode == "anticap") and desired ~= NIL then
            if CpuBuildSS_RefitMismatchedTurret(buildShipId, desired) == 1 then
                return 1
            end
        end
    end

    return 0
end
```

- [ ] **Step 6: Link, launch, verify counter-comp arming**

Iteration loop on `2p_as_sirat`, ~10 min. To exercise both modes, build mostly strikecraft yourself for one run (expect AI to fit Gatling/Scattershot — `mode antistrike`), and mostly capitals for another (expect Ion/Plasma/Pulse — `mode anticap`). Via `parse-logs.ps1 -Lua`, expect `Arm capital: build turret (mode ...)` lines whose mode matches your fleet, and occasional `Loadout refit: retire mismatched turret` after you switch composition. `parse-logs.ps1 -Errors` clean.

- [ ] **Step 7: Stage (do not commit)**

```
git add src/ai/cpubuildsubsystem.lua
```
Leave for user review.

---

### Task 5: Combat aggression (`cpumilitary.lua`)

Tighten attack cadence and group thresholds so the full fleet presses constantly. This stays full-featured (no director assumed).

**Files:**
- Modify: `src/ai/cpumilitary.lua` (`Logic_military_setattacktimer`, `Logic_military_groupvars`). Remove the dead `Logic_military_hyperspace` no-op.

**Interfaces:** unchanged.

- [ ] **Step 1: Remove the dead hyperspace no-op**

Delete the entire `Logic_military_hyperspace` function (it only logs) and its call inside `CpuMilitary_Process` (the line `Logic_military_hyperspace()`), and the call inside `attack_now_timer`. The director plan owns real hyperspace; leaving a no-op here is misleading.

- [ ] **Step 2: Shorten wave timers**

In `Logic_military_setattacktimer`, the current Hard branch is `timedelay = 0`, `wavedelay = (20 + sg_militaryRand * 0.2)`. Tighten medium and hard:

```lua
    if g_LOD == 0 then
        timedelay = 240
        wavedelay = (90 + sg_militaryRand * 0.3)
    elseif g_LOD == 1 then
        timedelay = 90
        wavedelay = (45 + sg_militaryRand * 0.3)
    else -- Hard
        timedelay = 0
        wavedelay = (15 + sg_militaryRand * 0.2)
    end
```

- [ ] **Step 3: Lower commit thresholds when ahead**

In `Logic_military_groupvars`, the current "we're strong" branch triggers at `s_militaryStrength > 120`. Make the AI commit smaller groups sooner:

```lua
    elseif s_militaryStrength > 90 then
        -- We're strong, attack with smaller groups
        cp_minSquadGroupSize = 2
        cp_minSquadGroupValue = 75
    end
```

- [ ] **Step 4: Link, launch, verify pressure**

Iteration loop on `2p_as_sirat` at Hard, ~8 min. Expected: more frequent attack waves than baseline; `Attacktimer added` lines at the shorter cadence. `parse-logs.ps1 -Errors` clean.

- [ ] **Step 5: Stage (do not commit)**

```
git add src/ai/cpumilitary.lua
```
Leave for user review.

---

### Task 6: Verify carried-forward modules + docs

Confirm research and class definitions still load and behave, remove the now-dead hyperspace references elsewhere, and document the brain.

**Files:**
- Verify (no change expected): `src/ai/cpuresearch.lua`, `src/ai/classdef.lua`, `src/ai/default.lua`.
- Create: `docs/ai_brain.md`.

- [ ] **Step 1: Grep for any remaining dead hyperspace references in the AI**

```
pwsh -Command "Select-String -Path src/ai/*.lua -Pattern 'Logic_military_hyperspace','sg_lastHyperspaceTime','sg_hyperspaceDelay'"
```
Expected after Task 5: matches only in `cpumilitary.lua` Init if the init vars remain. Remove `sg_lastHyperspaceTime`/`sg_hyperspaceDelay` initialization from `CpuMilitary_Init` since the function that used them is gone.

- [ ] **Step 2: Confirm research + classdef untouched and loading**

Iteration loop on `2p_as_sirat`, ~8 min (long enough for the AI to have spare economy and research a free upgrade). Expected via `parse-logs.ps1 -Lua`: `Research:` lines appear; no `LUA ERROR`. No code change unless an error surfaces.

- [ ] **Step 3: Write `docs/ai_brain.md`**

```markdown
# AI CPU Brain

Per-AI-player AI (`src/ai/`), loaded by `default.lua`. Demand-based; runs in
the AI VM. Independent of the tactical director.

## Modules
- `default.lua` — oninit, the `doai` tick, build-channel math.
- `cpuresource.lua` — lean economy; collectors cap ~10, fast military pivot.
- `cpubuild.lua` — aggressive sustained ship demand; capital ceiling is the
  standard Battlecruiser + Destroyer (no heavy caps).
- `cpubuildsubsystem.lua` — arms capitals and refits their turret mix to
  counter the enemy: `CpuLoadout_Mode()` picks antistrike/anticap/balanced
  from the enemy's fleet; `CpuLoadout_DesiredTurrets` maps mode→turrets;
  refit is cooldown-gated to avoid churn.
- `cpumilitary.lua` — grouping + aggressive wave timing for the whole fleet.
- `cpuresearch.lua` — pursues the always-available free upgrades from spare
  economy (unchanged from the prior design).
- `classdef.lua` — ship→class membership data.

## Tuning
Economy/build/military knobs are inline constants in their modules, scaled by
`g_LOD` (difficulty). Loadout thresholds live in `CpuLoadout_Mode`.

## Relationship to the director
None required. When the tactical director is present it commands capitals via
explicit SCAR orders that override AI orders while active; the brain needs no
awareness of it.
```

- [ ] **Step 4: Stage (do not commit)**

```
git add src/ai/cpumilitary.lua docs/ai_brain.md
```
Leave for user review.

---

### Task 7: Full regression + audit pass

Confirm the rebuilt brain is stable across races and maps, including a hyperspace-disabled map, with no director present.

**Files:** none (validation only).

- [ ] **Step 1: Race + map matrix**

Run the iteration loop for each combination, ~8 min each, `parse-logs.ps1 -Errors` clean for all:
- Hiigaran AI on `2p_as_sirat`
- Vaygr AI on `2p_as_sirat`
- Hiigaran AI on `2p_research_outpost` (hyperspace-disabled map; brain must be unaffected)
- Any AI on `5p_the_final_battle` (SRI flagship present; confirm no loadout/build crash around special units)

- [ ] **Step 2: Compare against baseline**

Against the Task 1 note, confirm: more ships fielded, capitals consistently carry turrets matching your composition, and attack waves are more frequent. If any goal is unmet, record which and revisit the owning task.

- [ ] **Step 3: Hand to user for review**

Report the matrix results. Do not commit — the user reviews the staged diffs and commits.

---

## Self-Review

**Spec coverage (Layer A of `2026-06-29-ai-rebuild-design.md`):**
- §5 lean economy / fast pivot → Task 2. ✅
- §5 aggressive building, capital ceiling → Task 3 (incl. ceiling grep, Step 3). ✅
- §5 + goal #2 counter-composition loadouts + refit → Task 4. ✅
- §5 military aggression (full-featured, not gutted — corrected per coordination model) → Task 5. ✅
- §5 research + classdef carried forward → Task 6. ✅
- Crash-guard preservation (§5) → Global Constraints + per-task "carry guards forward". ✅
- Independence from director / no Phase 0 dependency → stated in header; validated in Task 7 Step 1 (hyperspace-disabled map runs clean with no director). ✅

**Placeholder scan:** No `TBD`/`TODO`/"handle edge cases". Every code step shows complete functions. Turret constants reuse the known-good set from the current file. The one approximation (the `*80`/`*120` capital value weights and `1.6` ratio in `CpuLoadout_Mode`) is explicit, working code with a tuning note in Task 4 Step 6, not a placeholder.

**Type/name consistency:** `CpuLoadout_Mode`, `CpuLoadout_DesiredTurrets`, `CpuBuildSS_RefitMismatchedTurret`, `CpuBuildSS_NextMissingTurret`, `CpuBuildSS_ArmCapitalShips` are defined and called consistently. `sg_lastRefitTime`/`sg_refitCooldown` are initialized in Task 4 Step 5 and read in Step 4. Mode strings `"antistrike"`/`"anticap"`/`"balanced"` are produced by `CpuLoadout_Mode` and consumed identically in `CpuLoadout_DesiredTurrets` and `CpuBuildSS_ArmCapitalShips`. ✅

**Commit discipline:** every task stages but does not commit, per the user's review-first instruction.
```
