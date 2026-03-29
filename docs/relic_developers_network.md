# Relic Developer's Network (RDN) — Reference Guide

The Relic Developer's Network (RDN) is Relic Entertainment's official toolkit for modding Homeworld 2. It ships as a single installer (`homeworld2_rdn.exe`) and installs to `C:\Program Files (x86)\Relic Developer's Network\`. This document covers the toolkit's structure, tools, documentation, and Lua API coverage. All file paths are relative to the RDN root, prefixed `RDN/`.

---

## Directory Structure

```
RDN/
├── readme.txt               # Setup instructions
├── license.txt              # End-User License Agreement
├── Archive.exe              # Standalone archive tool
├── Data/                    # Compiled game data (466 files)
├── DataSrc/                 # Editable source assets (113 files, ~66 MB)
├── Documents/               # PDF documentation + Lua API HTML reference
├── Maya/3.0/                # Maya 3.0 plugins and MEL scripts
├── tools/                   # Utilities and pipeline tools
│   ├── bin/Archive/         # Archive tool binary
│   ├── bin/FXToolGL/        # Effects editor
│   ├── bin/ModPackager/     # Mod packaging tool
│   └── Photoshop/           # Photoshop plugins and action sets
└── ResourceRace/            # Sample mod (.big + .zip source)
```

---

## Tools

### Archive Tool

**Location**: `RDN/tools/bin/Archive/Archive.exe` (also `RDN/Archive.exe`)

Creates and extracts `.big` archive files — the format used to package all HW2 game data. Required as a first step to extract the base game data for modding.

**Typical usage** (from `readme.txt`):
```
archive -a Homeworld2.big -e %HW2_ROOT%\Data
```

**Documentation**: `RDN/Documents/HW2_ArchiveTool.pdf`

The file `RDN/Data/` is produced by extracting `Homeworld2.big` with this tool. The file `RDN/tools/bin/Archive/Homeworld2.big.listing` (873 KB) provides a full index of the base game archive's contents.

---

### FX Tool

**Location**: `RDN/tools/bin/FXToolGL/FxTool.exe`

An OpenGL-based visual effects editor. Used to author and preview particle effects, trails, and other visual FX. Requires the `-wkdir` parameter pointing to the HW2 installation directory (a shortcut in the same folder configures this).

**Key dependencies** (same folder):
- `lua.dll`, `LuaConfig.dll` — Lua scripting engine
- `GL.dll`, `Platform.dll`, `Memory.dll`, `Objects.dll`, etc.

**Working directory**: `RDN/Data/Art/FX/` contains compiled effects (`.hod` files) for reference.

**Documentation**: `RDN/Documents/HW2_FX_Tool_Documentation1.pdf`

---

### Mod Packager

**Location**: `RDN/tools/bin/ModPackager/ModPackager.exe` (v1.0.1.1)

Packages modified source data into a distributable `.big` mod file. Configured via `RDN/tools/bin/ModPackager/pipeline.ini`, which specifies `DataSource`, `DataIntermediate`, `DataFinal`, and `Locale` folder paths.

---

### Photoshop Integration

**Location**: `RDN/tools/Photoshop/`

| File | Purpose |
|------|---------|
| `dds.8bi` | DDS (DirectDraw Surface) format read/write |
| `FakeOverlay.8bf` | Overlay compositing filter |
| `Opaque.8bf` | Opacity manipulation |
| `Raise Zero.8bf` | Altitude/channel adjustment |
| `Safe Transparency.8bf` | Alpha channel handling |
| `Relic.atn` | General Relic action set |
| `Ship Texturing.atn` | Automated ship texture workflow |

Requires Photoshop 5.5 or above. Installation: see `RDN/Documents/HW2_PhotoshopActionInstallation.pdf`.

---

### Maya 3.0 Plugins

**Location**: `RDN/Maya/3.0/`

15 plugins (`.mll`/`.dll`) for Maya 3.0 that enable HW2-native export/import:

| Plugin | Purpose |
|--------|---------|
| `Homeworld2Export.mll` | Primary ship model/animation exporter |
| `AnimExport.mll` | Animation data export |
| `LevelExport.mll` | Mission/level export |
| `FlightManeuversExport.mll` | Ship movement behavior export |
| `BTGImport.mll` | Background geometry import |
| `ShipMayaObj.mll` | HW2-specific object properties |
| `HW2GetBB.mll` | Automatic bounding box calculation |
| `FreezeShipScale.mll` | Scale-freezing utility |
| `Pathfind.mll` | Pathfinding data |
| `MELUtil.mll` | MEL script utilities |
| `annotation.mll` | Annotation/markup tool |
| `motionTraceCmd.mll` | Motion tracing |
| `shizoom.mll` | Zoom utility |
| `IMFPSD.dll` | PSD texture import |

`RDN/Maya/3.0/Maya.env` configures plugin and script paths. Installation: see `RDN/Documents/HW2_Maya_Install_Doc.pdf`.

**MEL Scripts**: 134 `.mel` scripts covering ship setup, docking paths, shader attachment, subsystem attributes, level data, formations, and animation export. Key scripts:

- `hw2exportall.mel` — Batch export tool
- `hw2AttachShader.mel` / `hw2CreateShader.mel` — Shader workflow
- `hw2dockingPath.mel` — Docking path creation/editing
- `hw2setShipAttribute.mel` — Assign ship properties
- `hw2levelData.mel` — Level/mission data editing
- `hw2formation.mel` — Formation definition
- `hw2flightManeuver.mel` — Flight behavior

---

## Documentation

All PDFs are in `RDN/Documents/`. The Lua API HTML reference is in `RDN/Documents/Scar/`.

### PDF Reference

| Document | Size | Contents |
|----------|------|---------|
| `HW2_ArtPipeline.pdf` | 2.4 MB | End-to-end model creation (Maya → Photoshop → export) |
| `HW2_SCAR.pdf` | 256 KB | SCAR scripting language (Lua dialect) for missions/campaigns |
| `HW2_LevelEd.pdf` | 182 KB | Level Editor user guide |
| `HW2_FX_Tool_Documentation1.pdf` | 457 KB | Effects tool usage |
| `HW2_MayaPluginPackage.pdf` | 171 KB | Maya plugin reference |
| `HW2_ArchiveTool.pdf` | 43 KB | Archive tool CLI reference |
| `HW2_DockLaunchLatchPathsRDNHelp.pdf` | 474 KB | Docking, launching, and latching path mechanics |
| `HW2_FlightManeuversHowTo.pdf` | 169 KB | Ship flight behavior setup |
| `HW2_GameRuleMods.pdf` | 122 KB | Game rules modification |
| `HW2_Attack Styles.pdf` | 100 KB | Combat AI behavior and attack styles |
| `HW2_BuildandResearchScripting.pdf` | 265 KB | Build/research system scripting |
| `HW2_InnateSubsystem.pdf` | 376 KB | Built-in subsystem types and configuration |
| `HW2_MultipliersAndAbilitiesHowTo.pdf` | 168 KB | Ship abilities and stat multipliers |
| `HW2_MadState.pdf` | 38 KB | State machine (MAD) documentation |
| `HW2_LevelEdCurveTool.pdf` | 218 KB | Curve tool for level paths |
| `HW2_ATI.pdf` | 421 KB | ATI/AMD graphics-specific settings |
| `HW2_Sensors Manager.pdf` | 246 KB | Sensor system documentation |
| `HW2_Maya_Install_Doc.pdf` | 24 KB | Maya plugin installation guide |
| `HW2_PhotoshopActionInstallation.pdf` | 73 KB | Photoshop plugin/action installation |

### Lua API HTML Reference (`RDN/Documents/Scar/`)

Doxygen-generated HTML covering the full scripting API exposed to SCAR (Lua) scripts:

| File | Module |
|------|--------|
| `_lua_a_t_i_8cpp.html` | ATI/AMD graphics settings |
| `_lua_camera_8cpp.html` | Camera control |
| `_lua_campaign_8cpp.html` | Campaign state and progression |
| `_lua_f_x_8cpp.html` / `_lua_f_x_8h.html` | Particle effects |
| `_lua_fog_8cpp.html` | Fog of war |
| `_lua_hyperspace_8cpp.html` | Hyperspace jump mechanics |
| `_lua_light_8cpp.html` | Dynamic and static lighting |
| `_lua_objectives_8cpp.html` | Mission objective tracking |
| `_lua_ping_8cpp.html` | Ping/waypoint system |
| `_lua_player_8cpp.html` | Player state management |
| `_lua_sensor_8cpp.html` | Sensor queries and visibility |
| `_lua_shadow_8cpp.html` | Shadow rendering settings |
| `_lua_sob_group_actions_8cpp.html` | Ship/object group commands |
| `_lua_sob_group_query_8cpp.html` | Ship/object group status queries |
| `_lua_sound_8cpp.html` | Audio and music playback |
| `_lua_subtitle_8cpp.html` | Subtitle/dialog display |
| `_lua_universe_8cpp.html` | Universe/environment management |

---

## Compiled Game Data (`RDN/Data/`)

Contains 466 files extracted from `Homeworld2.big` — the full vanilla HW2 data as a reference and starting point for mods. Key subdirectories:

| Path | Contents |
|------|---------|
| `RDN/Data/Scripts/AI/` | AI behavior scripts (classdef, CPU build/military/research) |
| `RDN/Data/Scripts/Attack/` | 30+ attack style scripts (dogfight, flyby, broadside, etc.) |
| `RDN/Data/Scripts/WeaponFire/` | 60+ weapon fire scripts (kinetics, missiles, beams, torpedoes) |
| `RDN/Data/Scripts/Formations/` | Formation definitions (wall, claw, broad, etc.) |
| `RDN/Data/Scripts/Building and Research/` | Build/research lists for Hiigaran, Vaygr, Keeper |
| `RDN/Data/Scripts/GameRules/` | Game rule files (killMothership, doNothing, etc.) |
| `RDN/Data/Scripts/StartingFleets/` | Starting fleet definitions |
| `RDN/Data/Scripts/Scar/` | Campaign mission scripts |
| `RDN/Data/Scripts/Unitcaps/` | Unit population cap scripts |
| `RDN/Data/Scripts/NavLightStyles/` | Navigation light definitions |
| `RDN/Data/Art/FX/` | Compiled visual effects (`.hod` files) |

Notable individual files:
- `RDN/Data/Scripts/ArmourAndShields.lua` — Armor penetration multiplier tables (with comments)
- `RDN/Data/Scripts/AI/classdef.lua` — Ship class taxonomy used by AI

---

## Source Assets (`RDN/DataSrc/`)

113 files (~66.5 MB) of editable source content for learning the art pipeline:

### Example Ships

| Ship | Files | Notes |
|------|-------|-------|
| `RDN/DataSrc/Ship/Hgn_Interceptor/` | 12 | Fighter class; Maya model + 10 texture PSDs |
| `RDN/DataSrc/Ship/Hgn_PulsarCorvette/` | ~12 | Corvette class |
| `RDN/DataSrc/Ship/Hgn_Carrier/` | ~13 | Capital ship; full texture variants |

### Example Subsystems

Located in `RDN/DataSrc/Subsystem/`:

| Subsystem | Type |
|-----------|------|
| `Hgn_C_Engine` | Propulsion |
| `Hgn_C_Production_Fighter/Corvette/Frigate` | Shipyard modules |
| `Hgn_C_Sensors_AdvancedArray` | Detection |
| `Hgn_C_Module_Research` / `ResearchAdvanced` | Tech tree |
| `Hgn_C_Module_Hyperspace` / `HyperspaceInhibitor` | Jump mechanics |
| `Hgn_C_Module_CloakGenerator` | Stealth |
| `Hgn_C_Module_PlatformControl` | Platform command |
| `Hgn_C_Module_BuildSpeed` | Construction rate |
| `Hgn_C_Module_FireControl` | Weapons systems |

### Other Source Assets

- `RDN/DataSrc/Background/` — Mission environment backgrounds
- `RDN/DataSrc/Nebula/` — Space environment nebula effects
- `RDN/DataSrc/ResourcePatch/` — Asteroid/resource cluster definitions
- `RDN/DataSrc/FlightManeuvers/` — Flight maneuver source

---

## Sample Mod (`RDN/ResourceRace/`)

A minimal example mod demonstrating how to package modified content:

- `ResourceRace.big` (22 KB) — Compiled archive, loadable by HW2
- `ResourceRace.zip` (23 KB) — Source files showing the folder structure

Useful as a template for creating a new `.big` mod archive.

---

## Setup Summary

From `RDN/readme.txt`:

1. Set the `HW2_ROOT` environment variable to your Homeworld 2 installation directory.
2. Extract vanilla data: `Archive.exe -a Homeworld2.big -e %HW2_ROOT%\Data`
3. Install Maya plugins per `RDN/Documents/HW2_Maya_Install_Doc.pdf`.
4. Install Photoshop plugins and actions per `RDN/Documents/HW2_PhotoshopActionInstallation.pdf`.
5. Launch `RDN/tools/bin/FXToolGL/FxToolShortcut.exe.lnk` for the effects editor (the shortcut supplies the required `-wkdir` argument).

**System requirements**: Photoshop 5.5+, Maya 3.0+, Microsoft Excel (for some data sheets), Visual C++ 7.0 runtime (MSVC70 DLLs included).

---

## File Format Quick Reference

| Extension | Format | Tool |
|-----------|--------|------|
| `.big` | HW2 archive (binary) | Archive.exe |
| `.hod` | Homeworld Object Data — compiled 3D model/effect | Maya exporter |
| `.ma` | Maya ASCII model source | Maya 3.0 |
| `.psd` | Photoshop texture source | Photoshop 5.5+ |
| `.dds` | DirectDraw Surface texture | Photoshop DDS plugin |
| `.tga` | Targa texture | Standard |
| `.lua` | SCAR scripting (Lua dialect) | Text editor |
| `.mel` | Maya Embedded Language | Maya 3.0 |
| `.ini` | Pipeline configuration | Text editor |

---

## Toolkit Version

- **RDN Version**: 1.0
- **Maya target**: 3.0
- **ModPackager**: v1.0.1.1
- **Runtime**: Visual C++ 7.0 (MSVC70)
- **Installer date**: July 12, 2007 (originally released 2003–2004 alongside HW2)
