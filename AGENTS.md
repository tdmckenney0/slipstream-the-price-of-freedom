# Slipstream: The Price of Freedom - Agent Guide

This repository contains the source code for the **Slipstream: The Price of Freedom** mod for Homeworld 2 Classic. This mod transforms the game into a fast-paced tactical arena with a focus on ship loadouts and cooperative/competitive multiplayer.

## Core Concepts

- **Fast-Paced Gameplay:** Ships have significantly higher speeds and rotation rates compared to vanilla HW2. For example, the Hiigaran Battlecruiser has a speed of 110 (up from 69).
- **Loadout System:** Instead of a complex tech tree, the focus is on configuring individual ships. Capital ships feature multiple weapon hardpoints where players can choose from various subsystems (Gatling, Ion, Mine, Plasma).
- **Simplified Tech Tree:** Many vanilla research and build options are disabled via `src/scripts/restrict.lua`. Key technologies are often granted at the start via `src/scripts/startingfleets/`.
- **SRI Corp:** A prominent lore faction featuring high-tier units like the `sri_dreadnaught` (500k health) and `sri_sajuuk`.
- **Slipstream Hyperspace:** A custom hyperspace method used by all main races, featuring unique effects and faster transitions.

## Key Files & Directories

- `src/ship/`: Definitions for all ships, including custom SRI units.
- `src/subsystem/`: Contains the various loadout options for ship weapon slots.
- `src/scripts/building and research/`: Defines the buildable units for each race. Note that research is heavily simplified and mostly pre-granted.
- `src/scripts/scar/restrict.lua`: Crucial file that disables many vanilla HW2 units and techs.
- `src/leveldata/multiplayer/deathmatch.lua`: Contains the custom game rules and logic for the "Slipstream" game mode.
- `src/scripts/music.lua`: Implements a custom music shuffle system for in-game soundtracks.

## AI Engineering Notes

- **Modding Style:** The mod follows standard HW2 modding conventions but uses SCAR (Scripting Command and Resource) and custom game rules to drastically alter the core gameplay loop.
- **Ship Configuration:** When adding or modifying ships, look at the `StartShipHardPointConfig` in `.ship` files to understand available subsystem slots.
- **Balance:** Health and speed values are much higher than vanilla. Keep this in mind when designing new units or balancing existing ones.
- **Lore:** The theme is dark sci-fi, drawing inspiration from *Homeworld: Cataclysm*, *Halo*, and *Earth 2150*.

For deeper details, see the documentation in `docs/`.
