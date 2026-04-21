# RDN Modding Reference — Extracted Content

This document distills the substantive technical content from the Relic Developer's Network (RDN) PDFs and toolkit in [refs/rdn/](../refs/rdn/). Where [relic_developers_network.md](relic_developers_network.md) is an *inventory* of the toolkit, this file is a *reference* — a single place to look up the APIs, formats, and workflows the RDN documents actually describe.

Everything here is sourced from PDFs and HTML files inside [refs/rdn/Documents/](../refs/rdn/Documents/) (which we cannot write to) and the doxygen Lua API reference in [refs/rdn/Documents/Scar/](../refs/rdn/Documents/Scar/).

Conventions used by Relic's docs (kept below for clarity):
- Paths are written Relic-style (`Homeworld2/Data/...`) in quoted blocks so they match the PDFs; elsewhere we use the repo convention (backslashes, `src\...`).
- "SCAR" = Relic's Lua dialect ("SCripting At Relic"). All `.lua` files in HW2 are SCAR scripts.

---

## 1. Archive Tool (`Archive.exe`) — `.big` / `.sga` packaging

Source: `HW2_ArchiveTool.pdf` v1.01.

### 1.1 CLI arguments

| Argument | Description |
|---|---|
| `-a <archive file>` | Target archive file (path + filename). Required for every operation. |
| `-c <buildfile> -r <rootpath>` | Create archive. `<buildfile>` is the build script; `<rootpath>` is the folder containing files referenced in the script. |
| `-l` | List archive contents (folder, file name, original + compressed sizes, storage method). Redirect output with `> <destfile>` for Excel examination. |
| `-e <extract location>` | Extract all files (rebuilding folder tree) to the given location. |
| `-t` | Test archive — recomputes per-file CRCs and compares against stored values. |
| `-hash` | Emit a unique hash identifying the archive. |
| `-v` | Verbose output (combinable with any above). |

### 1.2 Four standard operations

| Operation | Example |
|---|---|
| Create | `Archive -a c:\archives\archive.sga -c c:\archives\build.txt -r c:\IC\Data` |
| Extract | `Archive -a c:\archives\archive.sga -e c:\archives\archivecontents` |
| List | `Archive -a c:\archives\archive.sga -l` |
| Test | `Archive -a c:\archives\archive.sga -t` |

### 1.3 Build script syntax

A build script has four parts: `Archive` header → `TOCStart` → `FileSettingsStart…FileSettingsEnd` → file list → `TOCEnd`. Lines starting with `//` are comments; blank lines are ignored.

```
Archive name="<archive name>"
TOCStart name="<toc name>" alias="<alias>" relativeroot="<relative folder>"
FileSettingsStart defcompression="<default storage>"
    Override wildcard="<wildcard>" minsize="<min>" maxsize="<max>" ct="<storage>"
    SkipFile  wildcard="<wildcard>" minsize="<min>" maxsize="<max>"
FileSettingsEnd
    <file listing ...>
TOCEnd
```

**Storage methods** (`ct=` / `defcompression=`):

| Ordinal | Meaning |
|---|---|
| `0` | Store raw (no compression). |
| `1` | Compressed; decompressed on-the-fly as the file is read (use for large files). |
| `2` | Compressed; decompressed once into memory then reread (use for small files, **especially `.lua`**). |

**Override / SkipFile semantics**: the *first* matching `Override` wins, so order matters. `minsize`/`maxsize` of `-1` means "no limit". `SkipFile` drops matching files from the archive entirely. Wildcards support `*` and `?`.

**File listing**: each line is either relative to `-r <rootpath> + relativeroot` or a fully qualified path matching that root. The tool does **not** support wildcards in the file list — generate a list with `dir /s /a-d /b *.*` and paste it in.

**Alias convention**: game data should use `alias="data"`. Localization TOCs use `alias="locale"`; see §4.

### 1.4 Sample build script (from the PDF)

```
Archive name="ICTestArchive"
TOCStart name="ICTestData" alias="Data" relativeroot=""
FileSettingsStart defcompression="1"
    // Anything less than 100 bytes, just store
    Override wildcard="*.*"  minsize="-1" maxsize="100" ct="0"
    // Media gets stored uncompressed
    Override wildcard="*.mp3" minsize="-1" maxsize="-1" ct="0"
    Override wildcard="*.wav" minsize="-1" maxsize="-1" ct="0"
    Override wildcard="*.jpg" minsize="-1" maxsize="-1" ct="0"
    // Lua always compressed + decompressed in one shot
    Override wildcard="*.lua" minsize="-1" maxsize="-1" ct="2"
    SkipFile wildcard="*emptyfile.txt" minsize="-1" maxsize="-1"
FileSettingsEnd
TextFiles\TestFile.txt
C:\Temp\test\SampleData.test
TOCEnd
```

### 1.5 Loading mods at runtime

From appendix B of `HW2_ArchiveTool.pdf`:

- **Game Rules mods**: auto-loaded from `bin\GAMERULES\`. No flag needed.
- **Total conversion**: use `-mod nameofyourmod.big ,;nameofyoursecondmod.big` (note the `,;` separator). Or list them line-by-line in a text file and pass `-mod @mylistofmod.txt`.
- Neither format is subject to auto-download — all players must install the mod before joining.

---

## 2. SCAR — Relic's Lua scripting

Source: `HW2_SCAR.pdf`.

### 2.1 Rules (the frame loop)

A *Rule* is a user-defined function registered with the engine so it is evaluated on an interval.

```lua
Rule_Add( "Rule_HelloWorld" )              -- evaluate every frame
Rule_AddInterval( "Rule_Name", seconds )   -- evaluate every N seconds
Rule_Remove( "Rule_Name" )                 -- removed on the NEXT interval, not mid-rule
```

**Idiom — single-shot rule**: check condition → do work → `Rule_Remove` self.

```lua
Rule_Add("Rule_HelloWorld")
function Rule_HelloWorld()
    for i = 1, Universe_PlayerCount() do
        if Player_GetRace(i) == Race_Hiigaran then
            print("Hello world!")
        end
        if i == Universe_PlayerCount() then
            Rule_Remove("Rule_HelloWorld")
        end
    end
end
```

A Rule is just a regular Lua function by convention prefixed `Rule_`. Plain helper functions are fine and preferable to cloning Rules.

### 2.2 Event tables (linear scripted sequences)

Events are linear timelines of segments. Each segment executes its calls simultaneously; the segment advances when its *Controller* returns true.

```lua
Events = {}   -- must be named exactly "Events"; the engine looks for this
Events.intelevent_constructinterceptors = {
    {   -- segment 1: many calls, HW2_Wait(2) is the controller
        { "Universe_EnableSkip(1)", "" },
        { "Sound_EnterIntelEvent()", "" },
        { "Sound_SetMuteActor('Fleet')", "" },
        HW2_Letterbox(1),
        HW2_Wait(2),
    },
    {   -- segment 2: ...
        { "Sensors_Toggle(0)", "" },
        { "Camera_Interpolate('here','camera_focus',2)", "" },
        HW2_SubTitleEvent(Actor_FleetCommand, "$40550", 5),
    },
    -- ...
}
Event_Start("intelevent_constructinterceptors")
```

**Call forms inside a segment**:
- `{ "<lua expr>", "" }` — executes once, not a controller.
- `{ "<start expr>", "<end predicate>" }` — the segment advances when `<end predicate>` returns true. Controllers.
- Helper functions like `HW2_Wait(n)` expand to `{ "wID = Wait_Start(n)", "Wait_End(wID)" }` — a controller that waits `n` seconds.

**Restrictions**: no `if`, no `for`, no conditionals inside an Event segment — use a Rule for branching.

### 2.3 Entry points

Unique functions the engine looks for:

| Function | Behavior |
|---|---|
| `OnInit()` | Called when the mission is first loaded. **Not called on save-game load.** Typical body: `Rule_Add("Rule_Init")`. |
| `OnStartOrLoad()` | Called both on fresh start *and* save-game reload. Use for anything that must be re-initialized when resuming (e.g. looping effects). |

### 2.4 Minimum mission file structure

| File | Location (HW2 root) | Role |
|---|---|---|
| `<Mission>.level` | `data\LevelData\Campaign\<Campaign>\<Mission>\` | Mission layout, exported from Maya LevelEd. |
| `<Mission>.lua` | same dir as `.level`; same base name | Mission script (Rules, Events). |
| `<Mission>.tga` | same dir as `.level`; same base name | Loading screen. |
| `Teamcolour.lua` | same dir | Per-player base/stripe colors, badges, trail textures. |
| `AI<n>.lua` | same dir | Override AI behavior for player index `<n>`. |
| `ReferenceFleet.lua` | same dir | AI difficulty / reactive fleet slots. |
| `datfiles.lua` | same dir | `Dictionaries = { { name = "locale:leveldata/campaign/.../mission_01.dat" } }`. |
| `<Campaign>.campaign` | `data\LevelData\Campaign\` | Mission list + animatic hooks. |
| Localized `.dat` | `data\Locale\English\LevelData\Campaign\...` | `<ID> <text>` lines referenced via `"$<ID>"`. |
| Voice audio | `Data\Sound\english\Speech\MISSIONS\<ID>.fda` | Audio file with numeric name matching the localization ID. |

### 2.5 Campaign file shape

```lua
displayName = "Postmortem"
Mission = {}
Mission[1] = {
    postload  = function() playAnimatic("data:animatics/A00.lua", 1, 1) end,
    directory = "Mission_01",
    level     = "Mission_01.level",
    postlevel = function(bWin)
        if bWin == 1 then playAnimatic("data:animatics/A01.lua", 1, 0)
        else postLevelComplete() end
    end,
    displayName = "Mission 1",
    description = "Mission 1",
}
```

### 2.6 Team colour shape

```lua
-- [player index] = { {base R,G,B}, {stripe R,G,B}, "badge.tga", {trail R,G,B}, "trail.tga" }
teamcolours = {
    [0] = {{.365,.553,.667},{.8,.8,.8},"DATA:Badges/Hiigaran.tga",{.365,.553,.667},"data:/effect/trails/hgn_trail_clr.tga"},
    [1] = {{.9,.9,.9},{.1,.1,.1},"DATA:Badges/Vaygr.tga",{.921,.75,.419},"data:/effect/trails/vgr_trail_clr.tga"},
}
```

### 2.7 Localized subtitle call

```lua
HW2_SubTitleEvent( Actor_FleetCommand, "$42999", 5 )
--                 ^ actor             ^ loc id  ^ seconds on screen
```

The engine looks up `42999` in the current-language `.dat` and plays `Data\Sound\english\Speech\MISSIONS\42999.fda` if present. Subtitle ID and audio filename must match.

---

## 3. Game Rule Mods — multiplayer game types

Source: `HW2_GameRuleMods.pdf` (companion: the `ResourceRace` sample at [refs/rdn/ResourceRace/](../refs/rdn/ResourceRace/)).

This is the mechanism that ships TPOF's `Slipstream` mode. The same mechanism defines the vanilla `Deathmatch`.

### 3.1 Delivery & discovery

- Packaged as a `.big` archive in `bin\GAMERULES\`.
- On launch, HW2 scans that directory and loads basic description info.
- `Deathmatch` is always present; any `.big` in `bin\GAMERULES\` adds another selectable rule.
- Multiplayer lobby lists the rule by its `GameRulesName`. Clients missing the `.big` cannot join.
- On game start the `.big` is loaded; any of its data files override the main `Homeworld2.big`.
- An MD5 of `<GameRules>.lua` is computed at startup — only byte-identical copies can play against each other.

### 3.2 Required bigfile structure

Minimum: one `data`-alias TOC containing `LevelData\Multiplayer\<GameRules>.lua` where `<GameRules>` matches the filename used to identify the rule.

### 3.3 `<GameRules>.lua` top-level fields

| Name | Type | Purpose |
|---|---|---|
| `GameRulesName` | string or `"$loc"` | Localized name shown in lobbies. |
| `Description` | string or `"$loc"` | Setup-screen blurb (256-char cap). |
| `Directories` | `{ Levels = "path" }` | Only `Levels` is supported — a directory of rule-specific maps. |
| `GameSetupOptions` | table of tables | Per-option config rows (see below). |
| `OnInit` | function | Script entry point; add at least one watch Rule here. |

**GameSetupOptions row**:

| Field | Type | Purpose |
|---|---|---|
| `Name` | string | Internal name used by code/scripts. |
| `locName` | string or `"$loc"` | Display label. |
| `Tooltip` | string or `"$loc"` | Hover text. |
| `default` | int | Index into `choices`. |
| `Visible` | 0/1 | `0` hides from UI but keeps the default — useful for locking options. |
| `choices` | table of locID/string pairs | `[1] = "$8001", [2] = "HardMode"` etc. |

### 3.4 Localization for game rule mods

Add a TOC with `alias="locale"` to the same `.big`. Pack multiple languages as multiple `locale`-alias TOCs in the same archive — only the one matching the running language (or English fallback) is mapped. This is why **different-language players can multiplayer without desync** on text.

**Reserved locID range**: `8000–8999`. Stay within that range in mod `.dat` files.

### 3.5 Displaying HUD widgets

Call `ATI_xxx()` functions from inside a watch Rule. "ATI" = Advanced Tactical Interface. Load a template file describing items to display, then render templates at 2D screen positions with optional params. See `refs/rdn/Documents/Scar/_lua_a_t_i_8cpp.html` and the `ResourceRace` sample.

---

## 4. Build / Research scripts

Source: `HW2_BuildandResearchScripting.pdf`. The files live at:

```
Data\Scripts\Building and Research\<race>\build.lua
Data\Scripts\Building and Research\<race>\research.lua
```

Each file is one big flat table of entries.

### 4.1 Research entry fields

| Field | Req. | Meaning |
|---|---|---|
| `Name` | ✓ | Identifier referenced by dependency lists. |
| `RequiredResearch` | ✓ | Boolean expression over research names. Operators: `&` (and), `\|` (or), `!` (not), parentheses allowed. |
| `RequiredSubSystems` | ✓ | Subsystems that must exist **anywhere in the player's fleet**. Use the subsystem's `typeString` (e.g. `"AdvancedFighterProduction"`), **not** the Lua name. Booleans as above. |
| `Cost` | ✓ | RU cost. |
| `Time` | ✓ | Seconds at 1× research subsystem; more modules speed this up. |
| `DisplayedName` | ✓ | UI header (can be `"$<id>"`). |
| `DisplayPriority` | ✓ | Lower goes higher in the list. Ties: only one shows. |
| `Description` | ✓ | UI body (can be `"$<id>"`; supports `<b>…</b>` and `\n`). |
| `UpgradeType` | | `Modifier` or `Ability` — see §5. |
| `TargetType` | | `AllShips`, `Family`, or `Ship`. |
| `TargetName` | | Attack family name or ship name depending on `TargetType`. |
| `UpgradeName` | | Specific modifier/ability key. |
| `UpgradeValue` | | Modifier: new value (replaces). Ability: `0` disable, `>0` enable. |
| `Icon` / `ShortDisplayedName` | | UI icon (`.mres`) and ≤14-char label for the research manager. |

### 4.2 Build entry fields

| Field | Meaning |
|---|---|
| `Type` | `Ship` or `SubSystem`. |
| `ThingToBuild` | Lua name (`Hgn_Scout`, `Hgn_AdvancedFighterProduction`, etc.). |
| `RequiredResearch` | Boolean expression over research names. |
| `RequiredShipSubSystems` | Subsystems required **on the building ship** (typeStrings + booleans). |
| `RequiredFleetSubSystems` | Subsystems required **anywhere in the player's fleet**. |
| `DisplayedName` / `DisplayPriority` / `Description` | UI fields; same semantics as research. |

**Key distinction** (trips people up): research uses `RequiredSubSystems` (fleet-wide); build entries use `RequiredShipSubSystems` (building ship) and/or `RequiredFleetSubSystems` (fleet-wide).

**TPOF context**: TPOF uses the build table for hardpoint/weapon swaps as well as ships — weapon swaps appear at `DisplayPriority = 1000+` (see [src/scripts/building and research/hiigaran/build.lua](../src/scripts/building%20and%20research/hiigaran/build.lua)).

---

## 5. Multipliers & Abilities

Source: `HW2_MultipliersAndAbilitiesHowTo.pdf`. These are edited in the tuning spreadsheets:

```
Data\Ship\ShipTuning.xls
Data\SubSystem\SubSystemTuning.xls
Data\Nebula\NebulaTuning.xls
```

Two internal kinds of multiplier: **permanent** (set by research to the specified value) and **temporary** (cleared and recomputed every sim frame by active subsystems/ships/nebulas). Many temporary multipliers can stack per frame — each multiplies the running value. A cap limit in `data\scripts\tuning.lua` prevents runaway stacking.

### 5.1 Multiplier row shape

| Field | Values |
|---|---|
| `MultiplierType` | One of the types listed below. |
| `InfluenceType` | Where the multiplier applies (see §5.3). Nebulas always use `ThisShipOnly`. |
| `ActivityRelation` | `None` (fixed) or `Linear` (scales with subsystem health). |
| `MultiplierHigh` | Value at activity 100%, or the value when `ActivityRelation=None`. |
| `MultiplierLow` | Value at activity 0%. Ignored when `None`. |
| `Radius` | Sphere radius used by most `InfluenceType`s. |

Multipliers are **multiplicative** — "no effect" = `1.0`.

### 5.2 Full `MultiplierType` list

| Type | Effect |
|---|---|
| `MaxHealth` | Max health multiplier. |
| `Speed` | Max speed *and* acceleration (slower speed → slower braking too). |
| `MaxSpeed` | Max speed only; acceleration unchanged (ship can still stop). |
| `BuildSpeed` | Ship construction rate. |
| `ShipHoldRepairSpeed` | Docked-ship repair rate. |
| `HealthRegenerationRate` | Self-heal rate. |
| `WeaponAccuracy` | Miss chance. |
| `WeaponDamage` | Bullet/missile damage output. |
| `ShieldRegenerationRate` | Shield regen rate. |
| `MaxShield` | Shield capacity. |
| `HyperSpaceRecoveryTime` | Disabled duration after exit. |
| `HyperSpaceTime` | Jump duration. |
| `HyperSpaceCost` | RU cost per jump. |
| `HyperSpaceAbortDamage` | Damage when aborting a jump. |
| `Capture` | Capture attempt progress rate. |
| `CloakingStrength` | Stealth vs. detection compare — bigger is harder to spot. |
| `CloakDetection` | Detection vs. cloaking compare. |
| `CloakingTime` | Cloak capacity use: `<0` longer/faster recharge, `>1` shorter/slower. |
| `SensorDistortion` | Applied to *detectors'* sensor ranges. `<1` makes this ship harder to detect. |
| `VisualRange` | Visual range. |
| `PrimarySensorsRange` | Primary sensors range. |
| `SecondarySensorsRange` | Secondary sensors range. |
| `DustCloudSensitivity` | Damage taken inside dustclouds (`0`=immune, `1`=full). |
| `NebulaSensitivity` | Damage taken inside nebulas. |
| `ResourceCollectionRate` | Collector harvest rate. |
| `ResourceDropOffRate` | Drop-off rate when docked. |
| `ResourceCapacity` | RU storage. |
| `DefenseFieldTime` | Defense field capacity (same `<0` / `>1` convention as `CloakingTime`). |

### 5.3 `InfluenceType` values (shared by multipliers and abilities)

| Type | Acts on |
|---|---|
| `ThisShipOnly` | Just the ship the subsystem is deployed on. |
| `AllShipsWithinRadius` | Every ship in radius (including self). |
| `OwnShipsWithinRadius` | Player-owned ships in radius (including self). |
| `EnemyShipsWithinRadius` | Enemy ships in radius. |
| `AllShipsWithinRadiusExcludingThisShip` | Every ship in radius, excluding self. |
| `OwnShipsWithinRadiusExcludingThisShip` | Player-owned ships in radius, excluding self. |
| `EnemyShipsWithinRadiusIncludingSleeping` | Enemy ships in radius, including hyperspacing/sleeping ships. |

### 5.4 Ability row shape

| Field | Values |
|---|---|
| `AbilityType` | One of the types below. |
| `enable` | `0` disable, `1` enable. |
| `InfluenceType` | Same table as §5.3. |
| `Radius` | Sphere radius. |

### 5.5 `AbilityType` list

Command-level toggles (require the ability to be in `ShipTuning.xls` to be available): `Move`, `Attack`, `Guard`, `Repair`, `Cloak`, `Harvest`, `Mine`, `Capture`, `Dock`, `AcceptDocking`, `Builder`, `Hyperspace`, `Parade`, `FormHyperspaceGate`, `HyperspaceViaGate`, `SensorPing`, `Retire`.

Always-available toggles: `Stop`, `Steering` (disable → ship tumbles), `Targeting` (disable → cannot fire), `Sensors` (disable → no sensors), `Lights` (disable → engine glow off), `DefenseField`, `DefenseFieldShield`, `HyperspaceInhibitor`, `Scuttle` (enabled by default), `UseSpecialWeaponsInNormalAttack` (disabled by default — granting it makes a ship auto-pick special-attack weapons during regular combat; used for torpedo frigates and bombers).

---

## 6. Innate subsystems

Source: `HW2_InnateSubsystem.pdf`.

**Definition**: a subsystem that uses part of the *parent ship's hull mesh* to represent itself visually — e.g. battlecruiser missile batteries, destroyer-and-larger engines, MS/carrier resource drop-off pads. Contrast with regular subsystems, which are distinct meshes (cloak generator, ion turret, etc.).

Because the visible representation is the hull itself, an innate subsystem needs:
1. A **glow mesh** — invisible until moused over, at which point it glows like a normal subsystem. Uses shader `innateSS.st` and a 1×1 white `.tga` as its texture.
2. A **weapons-effect collision mesh** (often just a simplified duplicate of the glow mesh). This is what damage and FX actually collide against; it is never rendered.
3. A **joint trio** on the parent ship: `Hardpoint_<Name>_Position`, `Hardpoint_<Name>_Direction`, `Hardpoint_<Name>_Rest`.

### 6.1 ShipTuning hardpoint row for an innate subsystem

| Field | Value |
|---|---|
| `Name` | `Engine` (or similar label) |
| `jointName` | `Hardpoint_Engine` |
| `type` | `System` |
| `family` | `Innate` |
| `healthType` | `Damageable` |
| `defaultSubSystem` | `Hgn_Des_Engine` (or whatever the `.subs` TypeString is) |

### 6.2 Workflow summary

1. Duplicate the parent ship `.ma`; extract the relevant faces.
2. Rename the extracted mesh `select_<Name>`; reparent to root; delete unused shaders.
3. Apply an HW2 material with a 1×1 white `.tga` and the `innateSS.st` shader.
4. Center pivot; snap to root; freeze transforms; simplify polys while keeping the silhouette.
5. Place the glow mesh over the target location on a duplicate hull; copy its XYZ coordinates.
6. Create the `Hardpoint_<Name>_Position/Direction/Rest` joints on the real hull at those coords; export the hull `.hod`.
7. In the glow mesh, `Rotate X = 90` to match the joint orientation; duplicate as the collision mesh (`CM_<Name>`); export the subsystem `.hod`.
8. Add a column in `SubsystemTuning.xls` (duplicate an engine-type as a baseline); export `.subs`.
9. Add the hardpoint row above to `ShipTuning.xls`; export `.ship`.

Export options for all `.hod` exports: File Type `hod`, Export Type `Ship`, Texture `DXT5(rgba)`, Optimization `Triangle List + Merge`.

---

## 7. Lua API — exposed `.cpp` modules

All HTML lives under [refs/rdn/Documents/Scar/](../refs/rdn/Documents/Scar/) (doxygen 1.3-rc3, generated 2003-10-31).

| File | Purpose | Symbol count |
|---|---|---|
| `LuaATI.cpp` | HUD template display (ATI widgets) | 9 |
| `LuaCamera.cpp` | Camera control / interpolation | 27 |
| `LuaCampaign.cpp` | Campaign state | 1 |
| `LuaFX.cpp` | Particle-FX spawning | 12 |
| `LuaFog.cpp` | Fog of war | 7 |
| `LuaHyperspace.cpp` | Hyperspace jumps | 2 |
| `LuaLight.cpp` | Dynamic/static lighting | 7 |
| `LuaObjectives.cpp` | Mission objectives | 5 |
| `LuaPing.cpp` | Ping / waypoint helpers | 5 |
| `LuaPlayer.cpp` | Player state | 33 |
| `LuaSensor.cpp` | Sensor queries / visibility | 7 |
| `LuaShadow.cpp` | Shadow settings | 0 (header only) |
| `LuaSobGroupActions.cpp` | Ship-group commands | 58 |
| `LuaSobGroupQuery.cpp` | Ship-group status queries | 51 |
| `LuaSound.cpp` | Sound / music | 11 |
| `LuaSubtitle.cpp` | Subtitle display | 6 |
| `LuaUniverse.cpp` | Universe / environment | 30 |

**Notable Player functions** (from doxytags in `_lua_player_8cpp.html`):

`Player_GetRace`, `Player_GetRU`, `Player_SetRU`, `Player_GetName`, `Player_SetPlayerName`, `Player_SetTeamColours`, `Player_SetBadgeTexture`, `Player_IsAlive`, `Player_Kill`, `Player_HasResearch`, `Player_CanResearch`, `Player_Research`, `Player_CancelResearch`, `Player_HasQueuedResearch`, `Player_HasQueuedBuild`, `Player_GrantResearchOption`, `Player_GrantAllResearch`, `Player_RestrictBuildOption`, `Player_RestrictResearchOption`, `Player_UnrestrictResearchOption`, `Player_ShareVision`, `Player_FillShipsByType`, `Player_GetShipsByType`, `Player_FillSobGroupInVolume`, `Player_FillProximitySobGroup`, `Player_IsShipInVolume`, `Player_NumberOfAwakeShips`, `Player_GetNumberOfSquadronsOfTypeAwakeOrSleeping`, `Player_InstantDockAndParade`, `Player_InstantlyGatherAllResources`, `Player_SetDefaultShipTactic`, `Player_AllowDockFromUIOverride`.

**Notable SobGroup action functions** (from `_lua_sob_group_actions_8cpp.html`):

`SobGroup_Create`, `SobGroup_Clear`, `SobGroup_CreateShip`, `SobGroup_CreateSubSystem`, `SobGroup_Despawn`, `SobGroup_Move`, `SobGroup_MoveToSobGroup`, `SobGroup_AttackSobGroupHardPoint`, `SobGroup_GuardSobGroup`, `SobGroup_RepairSobGroup`, `SobGroup_ParadeSobGroup`, `SobGroup_DockSobGroup`, `SobGroup_DockSobGroupAndStayDocked`, `SobGroup_DockSobGroupInstant`, `SobGroup_CaptureSobGroup`, `SobGroup_SalvageSobGroup`, `SobGroup_Kamikaze`, `SobGroup_Launch`, `SobGroup_DeployMines`, `SobGroup_ExitHyperSpace`, `SobGroup_ExitHyperSpaceSobGroup`, `SobGroup_FollowPath`, `SobGroup_FillBattleScar`, `SobGroup_FillShipsByType`, `SobGroup_FillUnion`, `SobGroup_FillSubstract`, `SobGroup_FillCompare`, `SobGroup_AbilityActivate`, `SobGroup_ChangePower`, `SobGroup_SwitchOwner`, `SobGroup_OwnedBy`, `SobGroup_AutoEngineGlow`, `SobGroup_ManualEngineGlow`, `SobGroup_SetAutoLaunch`, `SobGroup_SetAsDeployed`, `SobGroup_SetBuildSpeedMultiplier`, `SobGroup_SetCaptureState`, `SobGroup_SetCaptureAlwaysDisables`, `SobGroup_SetHardPointHealth`, `SobGroup_GetHardPointHealth`, `SobGroup_SetDisplayedRestrictedHardpoint`, `SobGroup_ForceStayDockedIfDocking`, `SobGroup_RestrictBuildOption`, `SobGroup_AllowPassiveActionsAlways`, `SobGroup_DoDamageProximitySobGroup`, `SobGroup_LoadPersistantData`, `SobGroup_DeSelectAll`.

(51 more `SobGroup_*` query functions live in `_lua_sob_group_query_8cpp.html`; 30 in `_lua_universe_8cpp.html`. Refer to the HTML for signatures.)

---

## 8. Sample mod — ResourceRace

Located at [refs/rdn/ResourceRace/](../refs/rdn/ResourceRace/):

- `ResourceRace.big` (22 KB) — loadable compiled mod.
- `ResourceRace.zip` (23 KB) — the source files *and* the build script used to package it. This is the reference for the multi-TOC layout described in §3.4 (multiple `locale`-alias TOCs per language + one `data`-alias TOC).

Use this as a starting template for building custom Game Rule Mods.

---

## 9. Further reading (RDN PDFs we haven't mirrored above)

The following documents contain material that overlaps with other specialized guides in this repo or is more useful as primary source than extracted:

| PDF | What it covers |
|---|---|
| `HW2_ArtPipeline.pdf` (2.4 MB) | Full Maya → Photoshop → export workflow. Best kept as primary source — too figure-heavy to usefully transcribe. |
| `HW2_Attack Styles.pdf` | Attack-style catalog. Overlaps with [src/scripts/attack/CLAUDE.md](../src/scripts/attack/CLAUDE.md) once written; see the `Data\Scripts\Attack\*.lua` files directly. |
| `HW2_DockLaunchLatchPathsRDNHelp.pdf` | Docking/launch/latch path construction in Maya. |
| `HW2_FlightManeuversHowTo.pdf` | Flight maneuver authoring. |
| `HW2_LevelEd.pdf` / `HW2_LevelEdCurveTool.pdf` | Maya-based level editor; relevant when authoring new `.level` files (see [src/leveldata/CLAUDE.md](../src/leveldata/CLAUDE.md)). |
| `HW2_MayaPluginPackage.pdf` / `HW2_Maya_Install_Doc.pdf` | Maya 3.0 plugin list and install steps. |
| `HW2_PhotoshopActionInstallation.pdf` | Photoshop action/plug-in install. |
| `HW2_FX_Tool_Documentation1.pdf` | Effects authoring; see [src/art/fx/](../src/art/fx/). |
| `HW2_MadState.pdf` | Ship state machine ("MAD"). Small PDF, largely superseded by what's in `.ship` files. |
| `HW2_Sensors Manager.pdf` | In-game sensors manager UI hooks. |
| `HW2_ATI.pdf` | Deeper dive on the ATI widget system referenced in §3.5. |

---

## Document provenance

All quoted syntax, field tables, and workflow steps in §§1–6 are transcribed from the PDFs listed. Copyright on the original documents: Relic Entertainment, 2003. They are mirrored in [refs/rdn/Documents/](../refs/rdn/Documents/) for reference; that directory is read-only from this repo's perspective.
