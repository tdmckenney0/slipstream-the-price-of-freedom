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
