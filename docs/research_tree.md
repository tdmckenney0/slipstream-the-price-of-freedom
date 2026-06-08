# Research Tree and Tech Simplification

TPOF heavily simplifies the vanilla HW2 research tree to encourage immediate tactical play over a slow tech race. This is done almost entirely through **restriction** — most vanilla research is disabled via `MPRestrict()` in [`src/scripts/scar/restrict.lua`](../src/scripts/scar/restrict.lua), and starting fleets ship with the units a player would otherwise research.

The source of truth is two files: `restrict.lua` and `startingfleets/<race>00.lua`. This document is a summary.

## 1. Restricted vanilla research

`RestrictOptions(playerid)` calls `Player_RestrictResearchOption(...)` for a long list on both sides:

- **Hiigaran**: `DestroyerTech`, `BattlecruiserIonWeapons`, `PlatformIonWeapons`, elite corvette/bomber weapon upgrades, all sensor/mothership/shipyard/carrier speed-build-health upgrade chains, hyperspace cost upgrades, scout ping/EMP, defense-field shield, ECM/prox probes, torpedo/bomb improvements, Keeper/AttackDroid SPGAME upgrades, and more.
- **Vaygr**: `CorvetteTech`, `FrigateTech`, `LanceBeams`, `PlasmaBombs`, `CorvetteLaser`, `PlatformHeavyMissiles`, `FrigateAssault`, `BattlecruiserIonWeapons`, `DestroyerGuns`, `HyperspaceGateTech`, capture/radiation-immunity hacks, carrier/mothership/shipyard/frigate/corvette upgrade chains, corvette-command, frigate-infiltration, probe variants, and more.

See `restrict.lua` for the full authoritative list.

## 2. Restricted vanilla units

The same file hides vanilla units that would clutter the build menu: carriers, shipyards, scouts, attack bombers, minelayer corvettes, research/mover-production modules, marine/defense-field/infiltrator frigates, command corvettes, hyperspace platforms, probe variants, and the Vaygr planet-killer missile. Summary list: [main CLAUDE.md](../CLAUDE.md#restriction-system-srcscriptsscarrestrictlua).

## 3. Pre-granted research

Both [`hiigaran00.lua`](../src/scripts/startingfleets/hiigaran00.lua) and [`vaygr00.lua`](../src/scripts/startingfleets/vaygr00.lua) pre-grant exactly one item: `RepairAbility`. Everything else either needs no research (the vanilla gate was removed by restriction) or comes from the starting fleet directly.

## 4. Starting fleet contents

Since restriction (not pre-granting) is the mechanism, each fleet ships with multiple squadrons of each class for an immediately usable force. The Hiigaran start, for example, includes a flagship (`hgn_heavybattlecruiser`), two `hgn_battlecruiser`, two `hgn_destroyer`, three frigate types (4 each), interceptors, two corvette types, plus resource collectors and a controller.

## Gameplay Impact

With vanilla research paths gone, there's no research menu to navigate for most of a match. Focus shifts to **loadout choices** in the build menu (see [`loadout_system.md`](loadout_system.md)), **tactical movement/formations**, and **resource management** and protecting the irreplaceable flagship.
</content>
