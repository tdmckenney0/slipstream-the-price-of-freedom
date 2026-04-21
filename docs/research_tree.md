# Research Tree and Tech Simplification

In **Slipstream: The Price of Freedom**, the traditional Homeworld 2 research tree is heavily simplified to encourage immediate tactical engagement and ship configuration rather than a slow tech race.

## Implementation

The tech tree is simplified almost entirely through **restriction** — most vanilla research is disabled outright via `MPRestrict()` in [`src/scripts/scar/restrict.lua`](../src/scripts/scar/restrict.lua), and starting fleets ship with the units a player would otherwise need to research.

### 1. Restriction of vanilla research

`RestrictOptions(playerid)` calls `Player_RestrictResearchOption(...)` for a long list of vanilla research entries on both sides. Highlights:

**Hiigaran research disabled** includes: `DestroyerTech`, `BattlecruiserIonWeapons`, `PlatformIonWeapons`, `AssaultCorvetteEliteWeaponUpgrade`, `AttackBomberEliteWeaponUpgrade`, all sensor/mothership/shipyard/carrier speed/build/health upgrade chains, hyperspace cost upgrades, scout ping/EMP abilities, defense-field shield, ECM/prox-sensor probes, torpedo/bomb improvements, Keeper/AttackDroid SPGAME upgrades, and more.

**Vaygr research disabled** includes: `CorvetteTech`, `FrigateTech`, `LanceBeams`, `PlasmaBombs`, `CorvetteLaser`, `PlatformHeavyMissiles`, `FrigateAssault`, `BattlecruiserIonWeapons`, `DestroyerGuns`, `HyperspaceGateTech`, capture-hack variants, radiation-immunity hack, carrier/mothership/shipyard/frigate/corvette upgrade chains, corvette-command, frigate-infiltration, probe variants, and more.

See `restrict.lua` for the full authoritative list.

### 2. Restriction of vanilla units

The same file also restricts vanilla units that would otherwise clutter the build menu: standard carriers, shipyards, scouts, attack bombers, minelayer corvettes, research modules, mover-production modules, marine/defense-field/infiltrator frigates, command corvettes, hyperspace platforms, probe variants, and the Vaygr planet-killer missile. See the main [CLAUDE.md](../CLAUDE.md#restriction-system-srcscriptsscarrestrictlua) for the summary list.

### 3. Pre-granted research

Both [`hiigaran00.lua`](../src/scripts/startingfleets/hiigaran00.lua) and [`vaygr00.lua`](../src/scripts/startingfleets/vaygr00.lua) pre-grant exactly one research item:

- `RepairAbility` (progress = 1)

Everything else either doesn't need research (because the vanilla gate has been removed by restriction) or is provided directly by the starting fleet's squadron list.

### 4. Starting fleet contents

Because restriction — not pre-granting — is the main mechanism, each starting fleet ships with multiple squadrons of each ship class so the player has a usable force immediately. Hiigaran start, for example, includes a flagship (`hgn_heavybattlecruiser`), two `hgn_battlecruiser`, two `hgn_destroyer`, three types of frigate (4 each), interceptors, and two types of corvette — all with resource collectors and a controller.

## Gameplay Impact

With vanilla research paths gone, there is no research menu to navigate for most of a match. Player focus shifts entirely to:

- **Loadout choices** in the build menu (see [`loadout_system.md`](loadout_system.md))
- **Tactical movement** and formation use
- **Resource management** and positioning of the irreplaceable flagship

The `.lua` data that actually drives this is in two files — `restrict.lua` and `startingfleets/<race>00.lua`. That pair is the source of truth; this document is a summary.
