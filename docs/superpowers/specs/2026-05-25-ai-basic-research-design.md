# Design: AI uses always-available "basic research"

**Date:** 2026-05-25
**Branch:** polish-next-release
**Status:** Approved (design), pending implementation plan

## Problem

The TPOF AI was reworked under the assumption that "TPOF disables the tech race
entirely." That rework deleted `src/ai/cpuresearch.lua`,
`src/ai/hiigaran_upgrades.lua`, and `src/ai/vaygr_upgrades.lua`, removed the
research call from `src/ai/default.lua`, and annotated the code with comments
like "research/upgrades are disabled in TPOF."

That assumption is only partly true. `src/scripts/scar/restrict.lua` disables a
*specific subset* of research per race. Many upgrades remain **always
available**: they are defined in `src/scripts/building and research/<race>/research.lua`
with `RequiredResearch = ""` (or chained from an available item) and
`RequiredSubSystems = ""` (no research module needed), and they are **not** in
the restrict list. A human player can research these from game start with no
research module. The AI currently never does.

Two separate bugs would have kept the old code inert even if it had been
retained:

1. `CpuResearch_Process()` bailed out with `if NumResearchSubSystems() == 0 then
   return 0 end`. In TPOF the research modules are restricted, so this is always
   true and research never ran.
2. The old upgrade tables referenced vanilla HW2 research constants (e.g.
   `INTERCEPTORHEALTHUPGRADE1`) that do not exist in TPOF's `research.lua`
   (TPOF replaced several with speed-only upgrades, e.g.
   `InterceptorMAXSPEEDUpgrade1`). Those demands resolved to undefined globals
   and were no-ops.

This needs a fresh, TPOF-aligned implementation, not a straight restore.

## Goal

Make the AI research the always-available upgrades for its race, spending only
spare economy so it never starves ship production. Active on all difficulties,
scaled by difficulty.

## Decisions (confirmed with user)

- **Scope:** research/upgrades, plus light build tuning (keep build thresholds
  aligned with research thresholds; fix stale comments). No new build behavior.
- **Difficulty:** all difficulties research, with difficulty-scaled
  thresholds/cadence/demand.
- **RU policy:** spare economy only — research only when the economy is healthy
  and the AI is not under heavy attack; never divert RU needed for ships.
- **Selection logic:** demand-based and fleet-scaled — upgrade demand is
  proportional to how many of each ship class the AI actually fields.
- **Asymmetry:** the AI researches whatever its race actually has available.
  Vaygr capital (`SuperCap`) upgrades are available; Hiigaran capital upgrades
  are gated behind the restricted `BattlecruiserIonWeapons`/`DestroyerTech` and
  are therefore not available. This is intentional per the current `restrict.lua`
  data and is left as-is.

## Constant naming convention

The HW2 AI environment auto-generates a global constant for each research item,
equal to the uppercased research `Name`. Example: `BattlecruiserIonWeapons` →
`BATTLECRUISERIONWEAPONS`. The previous author already relied on this for weapon
techs, confirming the convention. All upgrade references below use
`UPPERCASE(Name)`.

## Available upgrades (the target set)

### Hiigaran (per-ship-type; counts via `NumSquadrons(<type>)`)

| Upgrade chain | Constants | Prerequisite |
|---|---|---|
| Interceptor speed | `INTERCEPTORMAXSPEEDUPGRADE1/2` | — |
| Attack bomber speed | `ATTACKBOMBERMAXSPEEDUPGRADE1/2` | only if AI fields bombers (`NumSquadrons(kBomber) > 0`) |
| Assault corvette health | `ASSAULTCORVETTEHEALTHUPGRADE1/2` | — |
| Assault corvette speed | `ASSAULTCORVETTEMAXSPEEDUPGRADE1/2` | — |
| Pulsar corvette health | `PULSARCORVETTEHEALTHUPGRADE1/2` | — |
| Pulsar corvette speed | `PULSARCORVETTEMAXSPEEDUPGRADE1/2` | — |
| Torpedo frigate health | `TORPEDOFRIGATEHEALTHUPGRADE1/2` | — |
| Torpedo frigate speed | `TORPEDOFRIGATEMAXSPEEDUPGRADE1/2` | — |
| Ion cannon frigate health | `IONCANNONFRIGATEHEALTHUPGRADE1/2` | `INSTAADVANCEDFRIGATETECH` |
| Ion cannon frigate speed | `IONCANNONFRIGATEMAXSPEEDUPGRADE1/2` | `INSTAADVANCEDFRIGATETECH` |
| Assault frigate health | `ASSAULTFRIGATEHEALTHUPGRADE1/2` | `INSTAADVANCEDFRIGATETECH` |
| Assault frigate speed | `ASSAULTFRIGATEMAXSPEEDUPGRADE1/2` | `INSTAADVANCEDFRIGATETECH` |
| Resource collector health | `RESOURCECOLLECTORHEALTHUPGRADE1/2` | — |
| Resource controller health | `RESOURCECONTROLLERHEALTHUPGRADE1/2` | — |

`INSTAADVANCEDFRIGATETECH` (`InstaAdvancedFrigateTech`) is free (Cost 0, Time 0)
and must be researched before the ion cannon / assault frigate upgrades become
available. The AI should grab it when it fields any assault or ion cannon
frigate.

### Vaygr (family-wide; counts via `numActiveOfClass(s_playerIndex, e<Class>)`)

| Upgrade chain | Constants | Family |
|---|---|---|
| Capital health | `SUPERCAPHEALTHUPGRADE1/2` | Capital |
| Capital speed | `SUPERCAPSPEEDUPGRADE1/2` | Capital |
| Fighter speed | `FIGHTERSPEEDUPGRADE1/2` | Fighter |
| Corvette health | `CORVETTEHEALTHUPGRADE1/2` | Corvette |
| Corvette speed | `CORVETTESPEEDUPGRADE1/2` | Corvette |
| Frigate health | `FRIGATEHEALTHUPGRADE1/2` | Frigate |
| Frigate speed | `FRIGATESPEEDUPGRADE1`, then `SPEEDUPGRADE2` | Frigate |
| Utility health | `UTILITYHEALTHUPGRADE1/2` | Utility |

**Naming gotcha:** the Vaygr second frigate-speed upgrade has `Name =
"SpeedUpgrade2"` (not "FrigateSpeedUpgrade2"), so its constant is `SPEEDUPGRADE2`.
The implementation must use that exact name in the chain.

## Architecture

### New file: `src/ai/cpuresearch.lua`

A slimmed version of the deleted file, TPOF-aligned. Provides:

- `CpuResearch_Init()` — loads the race-appropriate upgrade table
  (`hiigaran_upgrades.lua` / `vaygr_upgrades.lua`), wires
  `DoUpgradeDemand` to the race handler, sets `sg_lastUpgradeTime` and a
  difficulty-scaled `sg_upgradeDelayTime`.
- `Util_CheckResearch(researchId)` — returns truthy when an item is available
  and not yet done (`IsResearchAvailable` && not `IsResearchDone`).
- `inc_research_demand(researchtype, val)` — recurses into tables/chains and
  calls `ResearchDemandAdd` for each available item (reused from old code).
- `DoUpgradeDemand_Hiigaran()` / `DoUpgradeDemand_Vaygr()` — add fleet-scaled
  demand for each available upgrade chain; Hiigaran first ensures
  `INSTAADVANCEDFRIGATETECH` is demanded when it fields advanced frigates.
- `CpuResearch_Process()` — the spare-economy-gated loop. **Key change from the
  deleted version: the `NumResearchSubSystems() == 0` bailout is removed.** Keeps
  `IsResearchBusy()` (one research at a time), clears demand, calls the demand
  rules, then `FindHighDemandResearch()` → `Research(best)`.

### New files: `src/ai/hiigaran_upgrades.lua`, `src/ai/vaygr_upgrades.lua`

Upgrade tables listing **only** the available upgrades above, using correct TPOF
constants. Structured so `inc_research_demand` can recurse (chains as ordered
arrays; grouped by ship/family).

### Modified: `src/ai/default.lua`

- Add `dofilepath("data:ai/cpuresearch.lua")` to the module loads.
- In `oninit()`: set `sg_doupgrades = 1`, set `sg_minNumCollectors` (used by the
  research economy gate), call `CpuResearch_Init()`.
- In `doai()`: call `CpuResearch_Process()` on its own slower cadence, gated to
  spare economy. Research does not consume build channels, so it runs alongside
  `SpendMoney()`/ship-building.
- Replace the inaccurate comments ("research/upgrades are disabled in TPOF, see
  SpendMoney") with accurate descriptions.

### Light build tuning: `src/ai/cpubuild.lua` / `cpubuildsubsystem.lua`

- Align the research spare-economy thresholds (RU / collector counts) with the
  existing build `economicValue` thresholds so the two systems agree on what
  "spare economy" means.
- Correct any remaining stale "research is disabled" comments.
- No new build behavior.

## Spare-economy gate and difficulty scaling

`CpuResearch_Process()` performs research only when **all** hold:

- `IsResearchBusy() == 0` (nothing already researching),
- `UnderAttackThreat()` indicates not under heavy attack (e.g. `< -20`),
- military population above a small minimum,
- `economicValue > 0`, where `economicValue` is derived from `GetRU()` and
  `GetNumCollecting()`,
- time since last upgrade exceeds `sg_upgradeDelayTime`, **or** `economicValue`
  is high (rich economy → upgrade immediately).

Difficulty scaling (`g_LOD`: 0 = Easy, 1 = Medium, 2 = Hard):

| | Easy (0) | Medium (1) | Hard (2) |
|---|---|---|---|
| RU threshold for `economicValue > 0` | high | moderate | low |
| `sg_upgradeDelayTime` | long | moderate | short |
| Demand magnitude | low | moderate | high |

## Behavior summary

Each research tick: if not busy and economy is healthy and not under heavy
attack → score available upgrades by fleet composition × difficulty → research
the highest-demand one. Otherwise spend nothing on research; ship-building
proceeds normally.

## Verification

- Static: confirm every constant used corresponds to a non-restricted research
  `Name` in the race's `research.lua`. Confirm no reference to a restricted item.
- In-game: launch a skirmish vs. AI, watch `tools\parse-logs.ps1 -Lua` /
  `-Errors`. Confirm:
  1. No Lua errors loading `cpuresearch.lua` or the upgrade tables.
  2. The AI actually queues and completes upgrades (the key assumption: the
     engine permits `Research()` of a `RequiredSubSystems = ""` item with no
     research module present, exactly as a human can).
  3. Ship output is not visibly starved relative to before.

## Out of scope

- Changing `restrict.lua` or `research.lua` data (including the Hiigaran capital
  upgrade asymmetry).
- Pre-granting upgrades in starting fleets.
- Any new military/build strategy beyond the threshold alignment above.

## Follow-up

- Update the `heavy-caps-not-buildable` memory, which currently states the
  research AI is inert. After this change the research AI is active for
  always-available upgrades.
