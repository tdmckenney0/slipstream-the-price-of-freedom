# Ship Loadout and Configuration System

A central TPOF feature: capital ships can be fitted with interchangeable weapon subsystems, giving tactical flexibility within a single ship class. Where vanilla HW2 reserves significant subsystem slots for the Mothership/Shipyard only, TPOF gives multiple capital ships (Battlecruisers, Destroyers) dedicated swappable hardpoints.

## Hardpoint Configuration

Defined per-ship in the `.ship` file via `StartShipHardPointConfig`. Example — Hiigaran Battlecruiser (`hgn_battlecruiser.ship`), "Weapon Top" slot:

```lua
StartShipHardPointConfig(NewShipType, "Weapon Top", "Hardpoint_IonBeam1", "Weapon", "Generic", "Destroyable", "",
    "hgn_bc_gatlinggunturret_1", "hgn_bc_gatlinggunturret_2",
    "hgn_bc_ionbeamturret_1",    "hgn_bc_ionbeamturret_2",
    "hgn_bc_minelauncher_1",     "hgn_bc_minelauncher_2",
    "hgn_bc_plasmaburstturret_1","hgn_bc_plasmaburstturret_2",
    "", "", "")
```

## Available Weapon Types

- **Gatling Gun Turret** — rapid-fire, effective vs. smaller ships.
- **Ion Beam Turret** — high-damage continuous beam, effective vs. larger targets.
- **Mine Launcher** — deploys a mine field for area denial/ambush.
- **Plasma Burst Turret** — high-damage burst, anti-frigate/capital.

## Strategic Implementation

Because the tech tree is simplified (see `research_tree.md`), players can build these subsystems immediately once they have a capital ship. The choice reshapes the ship's role — Ion Beam-heavy = capital killer; Gatling-heavy = anti-swarm screen; mixed = versatile all-rounder. SRI Corp units (e.g. the Dreadnaught) carry massive health and high-power systems that use this same loadout logic.
</content>
