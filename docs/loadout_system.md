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

## System and Sensors Slots

Capitals also carry swappable non-weapon hardpoints (same `StartShipHardPointConfig` mechanism, category `"System"`/`"Sensors"`). The Hiigaran BC, for example, has two Generic module slots (Hyperspace, Cloak Generator, Hyperspace Inhibitor, Fire Control, Manufacturing Controller `hgn_c_module_buildspeed`, Auxiliary Power Unit `Hgn_C_Module_MaxSpeed`) and one Sensors slot (Detect Hyperspace, Advanced Array, Detect Cloaked, Sensors Distortion). Starting fleets spawn capitals with these fitted (see `startingfleets/`); full catalog in `src/subsystem/CLAUDE.md`.

## Strategic Implementation

Because the tech tree is simplified (see `research_tree.md`), players can build these subsystems immediately once they have a capital ship. The choice reshapes the ship's role — Ion Beam-heavy = capital killer; Gatling-heavy = anti-swarm screen; mixed = versatile all-rounder. (SRI Corp scenario units like the Dreadnaught instead carry massive health and fixed high-power weapons — no swappable slots.)
</content>
