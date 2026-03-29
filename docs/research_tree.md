# Research Tree and Tech Simplification

In **Slipstream: The Price of Freedom**, the traditional Homeworld 2 research tree is heavily simplified to encourage immediate tactical engagement and ship configuration rather than a slow tech race.

## Implementation Details

The tech tree is handled through a combination of two methods:

### 1. Pre-granted Research
Most essential technologies (like Destroyer production, advanced weapon tech, and abilities) are granted to players immediately at the start of a match. This is defined in the starting fleet files located in `src/scripts/startingfleets/`. 

For example, in `hiigaran00.lua`:
- `DestroyerTech` (progress = 1)
- `BattlecruiserIonWeapons` (progress = 1)
- `PlatformIonWeapons` (progress = 1)
- `RepairAbility` (progress = 1)

This means players don't have to spend resources or time researching these core technologies; they are available from the moment they have the necessary production facilities.

### 2. Restriction of Vanilla Options
To refine the gameplay and maintain the "tactical arena" feel, many vanilla HW2 units and research items are explicitly disabled. This is handled by the `MPRestrict()` function in `src/scripts/scar/restrict.lua`.

**Examples of Restricted Items (Hiigaran):**
- **Units:** Scouts, Attack Bombers, Marine Frigates, Defense Field Frigates, Proximity Sensors, ECM Probes, Minelayer Corvettes, and even the standard Shipyard.
- **Research:** Upgrades to health and build speeds for Motherships and Shipyards, ability upgrades for Scouts, and elite weapon upgrades for fighters.

**Examples of Restricted Items (Vaygr):**
- **Units:** Scouts, Minelayer Corvettes, Infiltrator Frigates, Command Corvettes, and the standard Vaygr Shipyard.
- **Abilities:** Capture hacks, radiation immunity, and various sensor/hyperspace upgrades.

## Gameplay Impact
By removing these options, the mod directs the player's focus toward the core combat units and their specific loadouts. Players spend less time in the research menu and more time in the build menu, deciding which weapon configuration best suits the current battlefield situation.
