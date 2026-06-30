# AI Rebuild — Design Spec

**Date:** 2026-06-29
**Status:** Approved (pending spec review) → implementation planning
**Goal source:** `docs/todo.md` "Fix AI" — five behavioral goals (below)

## 1. Objective

Rebuild the Slipstream AI so it plays a fast, aggressive, arena-style game. Five goals:

1. **More aggressive hyperspacing** strategy.
2. **More hit-n-run** tactics.
3. **Builds and reconfigures ship loadouts** depending on attack strategy.
4. **Aggressively builds more ships.**
5. **More arena-style** overall feel (relentless pressure, no turtling).

## 2. Feasibility findings (verified in spike)

Evidence: RDN doxygen API docs under `refs/rdn/Documents/Scar/` + decompiled campaign scripts under `refs/homeworld2-big/leveldata/campaign/`. **Not yet a live in-game test** — see the Phase 0 smoke test.

HW2 has **two scripting contexts in separate Lua VMs**:

- **AI "cpu" sandbox** (`src/ai/*.lua`, per-AI-player): demand-based API (`ShipDemand*`, `AttackNow`, threat tuning, `BuildSubSystemOnShip`, `RetireSubSystem`). **No direct movement or hyperspace control** — the current `Logic_military_hyperspace` only logs and admits this.
- **Game-rules / SCAR VM** (`deathmatch.lua`, global): full `SobGroup_*` and `Player_*` control. Used to script AI-owned fleets in the campaign.

Key API verbs confirmed available in the game-rules VM:

| Need | Function | Notes |
|------|----------|-------|
| Jump a fleet in | `SobGroup_EnterHyperSpaceOffMap(group)` then `SobGroup_ExitHyperSpaceSobGroup(toExit, exitCloseTo, proximity)` | **No pre-placed volume needed** — exits relative to another group (e.g. the enemy fleet). This is the load-bearing discovery. |
| Jump a fleet out / home | same pair, `exitCloseTo` = home anchor | Hit-n-run retreat. |
| Move / attack-move | `SobGroup_Move(playerIndex, group, ptName)`, `SobGroup_MoveToSobGroup(mover, target)` | Conventional movement & no-hyperspace fallback. |
| Attack | `SobGroup_Attack`, `SobGroup_AttackPlayer`, `SobGroup_AttackSobGroupHardPoint` | Cross-player command works (campaign orders AI waves). |
| Build dynamic groups | `SobGroup_Create` + `Player_FillShipsByType` / `SobGroup_FillShipsByType` + `SobGroup_FillUnion` | Per player + type. |
| Loadout fit (build layer) | `BuildSubSystemOnShip`, `RetireSubSystem` (cpu VM) | Already used in `cpubuildsubsystem.lua`. |
| Health / state queries | `SobGroup_GetHardPointHealth`, `SobGroup_AreAllInHyperspace`, `SobGroup_GetActualSpeed`, tactics | For refit detection, jump watchdog, posture. |
| Hyperspace enable state | `Hyperspace_SetStateForPlayer`, `Hyperspace_SetStateForVolume` | The mechanic behind hyperspace-disabled maps; director must check/respect it. |

**Verdict:** all five goals are achievable. Two layers, cooperating across the VM boundary.

## 3. Decisions (locked)

- **Architecture:** full rewrite of `src/ai` **plus** a new tactical director in the game-rules VM.
- **Jump model:** **free scripted teleport**, cooldown-gated — no hyperspace-module or RU requirement (max arena aggression). *Exception:* respect hyperspace-disabled maps and fall back to conventional movement there.
- **Loadout reconfiguration:** **counter enemy composition** (turret mix adapts to what the enemy fields). Lives entirely in the cpu loadout layer on the existing `RetireSubSystem`+`BuildSubSystemOnShip` path — no cross-VM refit.
- **Coordination model:** the two VMs **cannot share Lua tables**, so there is no lease registry. Instead, rely on the HW2 rule that **explicit SCAR orders override AI orders while active.** The director issues orders to its strike force every tick; when it releases a group (REGROUP/idle), the cpu brain reclaims it. Clean hand-off by who's actively ordering.

## 4. Architecture

```
deathmatch.lua (game-rules VM)
  └─ Rule_AddInterval("DirectorTick", 2)
       └─ src/scripts/director/
            director.lua     -- per-AI-player loop; AI-only gate; hyperspace-state gate
            strikegroup.lua  -- per-strike-force state machine
            tactics.lua      -- target selection, jump helpers, difficulty knobs

src/ai/ (per-player AI VM) — FULL REWRITE
  default.lua      -- controller + doai tick
  classdef.lua     -- class membership (carried forward; data)
  cpueconomy.lua   -- collectors/refineries (lean, fast military pivot)
  cpubuild.lua     -- aggressive ship demand
  cpuloadout.lua   -- arm + counter-comp refit capitals; production modules
  cpuresearch.lua  -- free-upgrade pursuit (carried forward; proven)
  cpumilitary.lua  -- grouping/attack timing for the NON-strike fleet
```

Two gates the director always respects: (1) act only on AI/computer players, never humans; (2) skip jump tactics where hyperspace is disabled (`2p_research_outpost`, `3p_assault`, `5p_mining_outpost`, `6p_garrison`) and use conventional attack-move there.

## 5. Layer A — cpu brain rewrite (`src/ai/`)

The rewrite **preserves the proven survival fixes** from the current fork: nil-guards on engine-provided globals, the `restrict.lua` / free-research interplay (`cpuresearch.lua` deliberately does not bail on `NumResearchSubSystems()==0`), capital arming, and the build-channel math. It re-organizes around clear module responsibilities.

Behavioral changes by module:

- **`cpueconomy.lua`** (was `cpuresource.lua`): lean economy, fast military pivot. Keep the aggressive collector curve (cap ~10, ramp down over time); simplify the tangled `CalcDesiredNumCollectors`.
- **`cpubuild.lua`**: goal #4. Higher sustained ship demand, more open build channels, a constant production floor so the economy never idles. Keep simplified counter-composition chassis demand. Respect the buildable ceiling: **standard Battlecruiser + Destroyer only** (heavy caps / flagships are starting-fleet units, never buildable — see `src/ship/CLAUDE.md` and the build-list rules in `src/scripts/CLAUDE.md`).
- **`cpuloadout.lua`** (was `cpubuildsubsystem.lua`): goal #2. Arm new capitals, refit turrets shot off in combat, fit production/hyperspace modules. **Counter-comp logic:** count enemy strike value (fighters+corvettes) vs. enemy cap value (frigates+capitals); strike-heavy → prefer Gatling/Scattershot (anti-strike); cap-heavy → prefer Ion/Plasma/Missile/Pulse (anti-cap). Per-ship turret options already enumerated in the current `CpuBuildSS_NextMissingTurret`.
- **`cpumilitary.lua`**: now smaller — grouping + aggressive short-wave attack timing for the **non-strike** fleet (strikecraft, spare frigates) while the director owns capital jump-strikes. Keep the short wave timers.
- **`cpuresearch.lua`**, **`classdef.lua`**: carried forward nearly as-is.

## 6. Layer B — tactical director (`src/scripts/director/`)

Game-rules VM, hooked from `deathmatch.lua` `OnInit` via `Rule_AddInterval("DirectorTick", 2)`. Each tick loops AI players; each AI player runs one strike-force state machine (one strike force per player to start; expandable).

State machine:

```
FORM ──► STRIKE ──► ENGAGE ──► BREAK ──► REGROUP ──┐
  ▲                                                 │
  └─────────────────────────────────────────────────┘
```

- **FORM** — Gather the player's capitals (Battlecruiser/Destroyer) into a strike SobGroup (`Player_FillShipsByType` + `SobGroup_FillUnion`). Wait for a minimum group value before committing (difficulty-scaled).
- **STRIKE** — Pick a target (§6.1). If hyperspace enabled and jump cooldown ready: `EnterHyperSpaceOffMap(strike)` → `ExitHyperSpaceSobGroup(strike, target, proximity)`. If disabled: conventional `SobGroup_Move` attack-move.
- **ENGAGE** — `SobGroup_AttackPlayer`/`SobGroup_Attack` on the target; aggressive tactics. Watch group health + an engage timer.
- **BREAK (hit-n-run)** — When group health < threshold, or engage timer expires, or target dies → jump out: `EnterHyperSpaceOffMap(strike)` → `ExitHyperSpaceSobGroup(strike, homeAnchor, proximity)`. No-hyperspace maps: retreat-move home + evasive tactics.
- **REGROUP** — Sit at the home anchor (mothership/shipyard) to repair/regather. Director stops ordering → cpu brain reclaims the ships until the next FORM cycle (cooldown + health gate).

### 6.1 Target selection (`tactics.lua`)

Arena-aggressive priority: isolated enemy capital → enemy mothership/production → collectors (raid) → main fleet. Start simple (main fleet / mothership); expand later. Home anchor for jump-back = the AI player's mothership/shipyard group.

### 6.2 Difficulty scaling

- **Hard:** short cooldowns, low commit threshold, frequent jumps.
- **Med:** longer cooldowns, larger required group.
- **Easy:** rare or no director jumps (mostly conventional combat).

### 6.3 Robustness (off-map ships are invisible/untargetable — must never be lost)

- **Watchdog:** `SobGroup_AreAllInHyperspace` + a max-time guard force-exits any group stuck in hyperspace, at home, so ships can't be stranded off-map.
- **Re-fill** the strike SobGroup every tick (ships die; groups go stale).
- The director reads only **engine queries** (counts, health, proximity), never cpu-brain state — the two-VM split is a non-issue.

## 7. Testing & rollout

**Phase 0 — API smoke test (throwaway).** Minimal rule in `deathmatch.lua`: for one AI player, form a capital group, jump it next to the enemy, fight briefly, jump home. Validates the four unverified behaviors at once (AI-player detection call, explicit-orders-override-AI, `ExitHyperSpaceSobGroup` in Steam HW2 Classic, reliable return from `EnterHyperSpaceOffMap`). Verify via `parse-logs.ps1` + in-game observation on `2p_as_sirat`. Adjust the director approach if anything fails.

**Phases 1–4 — incremental, each independently playable:**

1. **cpu brain rewrite** — economy/build/loadout/research/military. Ship alone first: aggressive building + counter-comp loadouts, no director. Confirm no crashes / Lua errors; builds relentlessly.
2. **Director skeleton** — full state machine, **conventional movement only** (no jumps). Validates the loop and the order-precedence hand-off.
3. **Add hyperspace** — jump-strike, jump-out, off-map watchdog.
4. **Tune** — difficulty scaling + target selection.

**Test matrix:** both races (Hiigaran/Vaygr) × hyperspace-on (`2p_as_sirat`) and hyperspace-off (`2p_research_outpost`). Tools: `link-src.ps1` (repackless iteration), `launch-tpof.ps1`, `parse-logs.ps1`, `debug-tpof.ps1`.

**Rollback safety:** the director is purely additive — new files + one `Rule_Add` line in `deathmatch.lua`; comment out the hook to disable. The cpu rewrite replaces `src/ai/`, but the current version stays recoverable via git history.

## 8. Done-criteria (mapped to goals)

| Goal | Observable result |
|------|-------------------|
| 1. Aggressive hyperspacing + 2. hit-n-run | Strike force jumps onto enemies and jumps out when damaged/timed-out; repeats. Degrades to attack-move on no-hyperspace maps. |
| 3. Loadout reconfiguration | Capitals arm on build and re-fit their turret mix to counter the enemy's current composition. |
| 4. Aggressive building | Economy pivots hard to constant ship production; build channels rarely idle. |
| 5. Arena-style | Felt result is relentless pressure rather than turtling. |

## 9. Open items to confirm during implementation (not blockers)

- Exact AI/computer-player detection call in HW2 Classic.
- That explicit SCAR orders override AI orders the same way in Steam HW2 Classic as in the campaign.
- `ExitHyperSpaceSobGroup` proximity behavior / units.
- Whether `EnterHyperSpaceOffMap` on a group requires anything beyond ownership.

All four are covered by the Phase 0 smoke test.
