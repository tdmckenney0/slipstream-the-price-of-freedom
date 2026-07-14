# Research Tree and Tech Simplification

TPOF replaces the vanilla HW2 research tree with small custom `research.lua` files per race. The vanilla tech race is gone, but research is **not zero**: each race keeps a compact set of always-available stat upgrades.

The source of truth is [`src/scripts/building and research/{race}/research.lua`](../src/scripts/building%20and%20research/) plus [`startingfleets/<race>00.lua`](../src/scripts/startingfleets/). This document is a summary.

> **Historical note:** earlier TPOF versions kept the vanilla research/build data and disabled most of it at runtime via `Player_RestrictResearchOption`/`Player_RestrictBuildOption` in `restrict.lua`. That mechanism is retired — `MPRestrict()` is now an empty stub, and the custom `build.lua`/`research.lua` files simply define only TPOF content.

## 1. What research exists now

Every entry is a **two-tier `MAXHEALTH` or `MAXSPEED` upgrade**. None has a subsystem prerequisite (`RequiredShipSubSystems` is empty) — no research module exists or is needed, so upgrades are researchable from match start. Tier 2 requires tier 1 (`RequiredResearch` chains); display strings reuse vanilla `$7xxx` locale IDs.

- **Hiigaran** — per ship type: Interceptor (speed only); AssaultCorvette, PulsarCorvette, TorpedoFrigate, IonCannonFrigate, AssaultFrigate, Battlecruiser, Destroyer (health + speed); ResourceCollector, ResourceController (health only).
- **Vaygr** — per class family (`TargetType` = family, so one upgrade covers every ship of that class): SuperCap/Capital (health + speed), Fighter (speed), Corvette (health + speed), Frigate (health + speed), Utility (health).

The AI researches these upgrades too — `src/ai/cpuresearch.lua`; see `docs/ai_brain.md`.

## 2. Pre-granted research

Both [`hiigaran00.lua`](../src/scripts/startingfleets/hiigaran00.lua) and [`vaygr00.lua`](../src/scripts/startingfleets/vaygr00.lua) pre-grant exactly one item: `RepairAbility`.

## 3. Starting fleet contents

Each fleet ships as an immediately usable force, flagship pre-fitted:

- **Hiigaran**: 1 `hgn_heavycruiser` flagship (all 6 weapon hardpoints fitted), 2 `hgn_battlecruiser` (distinct module/sensor/weapon loadouts), 2 `hgn_destroyer`, 6 each of assault/torpedo/ion-cannon frigates, 25 interceptors (5 squadrons of 5), 12 assault + 12 pulsar corvettes (4 squadrons of 3), 6 collectors, 3 controllers.
- **Vaygr**: 1 `vgr_qwaarjetii` flagship (fully fitted), 2 `vgr_battlecruiser`, 2 `vgr_destroyer`, 6 assault + 6 heavy-missile frigates, 35 interceptors (5×7), 30 bombers (5×6), 25 lance fighters (5×5), 16 missile + 16 laser corvettes (4×4), 6 collectors, 3 controllers.

## Gameplay Impact

There's no tech tree to climb — just cheap, flat stat upgrades that are worth queueing when RUs allow. Focus shifts to **loadout choices** in the build menu (see [`loadout_system.md`](loadout_system.md)), **tactical movement/formations**, **resource management**, and protecting the irreplaceable flagship.
