# Ship Loadout and Configuration System

One of the central features of **Slipstream: The Price of Freedom** is the ability to configure your capital ships with different weapon subsystems. This allows for a high degree of tactical flexibility within a single ship class.

## How it Works

In vanilla Homeworld 2, most ships have static weapon configurations, with only the Mothership and Shipyards having significant subsystem slots. In this mod, multiple capital ships (like Battlecruisers and Destroyers) have dedicated hardpoints for interchangeable weapon subsystems.

### Hardpoint Configuration
Ship configuration is defined in the ship's `.ship` file using the `StartShipHardPointConfig` function. 

For the **Hiigaran Battlecruiser** (`hgn_battlecruiser.ship`):
```lua
StartShipHardPointConfig(NewShipType, "Weapon Top", "Hardpoint_IonBeam1", "Weapon", "Generic", "Destroyable", "", 
    "hgn_bc_gatlinggunturret_1", 
    "hgn_bc_gatlinggunturret_2", 
    "hgn_bc_ionbeamturret_1", 
    "hgn_bc_ionbeamturret_2", 
    "hgn_bc_minelauncher_1", 
    "hgn_bc_minelauncher_2", 
    "hgn_bc_plasmaburstturret_1", 
    "hgn_bc_plasmaburstturret_2", 
    "", "", "")
```
This configuration allows for several different weapon types to be installed in the "Weapon Top" slot.

### Available Subsystem Types
Players can choose from several weapon types for their capital ships:
- **Gatling Gun Turret:** Rapid-fire projectile weapon, effective against smaller ships.
- **Ion Beam Turret:** High-damage continuous beam weapon, effective against larger targets.
- **Mine Launcher:** Deploys a field of mines to area denial or ambush.
- **Plasma Burst Turret:** High-damage burst projectile weapon for anti-frigate or capital ship duty.

### Strategic Implementation
Because the tech tree is simplified (see `docs/research_tree.md`), players can immediately begin building these subsystems once they have a capital ship. The choice of subsystem changes the role of the ship:
- An Ion Beam-heavy Battlecruiser is a dedicated capital ship killer.
- A Gatling Gun-heavy Battlecruiser can defend itself against swarms of fighters and corvettes.
- A mix of weapon types provides a more versatile all-rounder.

## Custom SRI Units
The SRI Corp units (like the Dreadnaught) often feature massive health pools and unique, high-power weapon systems that can be further enhanced or specialized through this same subsystem loadout logic. 
