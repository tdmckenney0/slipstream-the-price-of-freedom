# Design: Move custom display strings into the HW2 locale system

**Date:** 2026-05-25
**Branch:** polish-next-release
**Status:** ✅ Implemented (2026-06-06).

> **Implementation corrections — read `docs/locale_system.md` for the authoritative, as-built
> reference.** Three details in the original design below turned out to be wrong and were
> changed during implementation:
> 1. **ID range is 8000–8999, not 9000–9999.** The engine only resolves mod strings in the
>    reserved 8000–8999 range; `9xxx` IDs render as raw `"$<ID>"` literals in-game.
> 2. **No separate `locale`-alias TOC, and no `build-tpof.ps1` change.** `slipstream.dat` and
>    `localedat.lua` pack through the normal `Data` TOC and override vanilla by path.
> 3. Path **casing is irrelevant** (lowercase `locale/english/` works).
>
> The inventory, scope, conversion rules, and non-goals below are still accurate; only the
> mechanism (range + packing) changed.

## Problem

TPOF's player-facing display strings are inconsistent. Two patterns coexist:

1. **Reused vanilla `$<ID>` references** (most `.ship`/`.subs` files) — resolve against
   the vanilla dictionaries, so custom content sometimes shows mismatched names. *Out of
   scope for this pass.*
2. **Literal hardcoded English strings** — written directly into source
   (`displayedName = "Concussion Missile Launcher"`, `GameRulesName = "Slipstream"`, …).

This pass converts the **literal** strings into a proper TPOF-owned locale dictionary so
they live in the locale system like every other HW2 string: referenced via `$<ID>`,
served from a dictionary file, registered in `localedat.lua`.

## How HW2 Classic locale works (confirmed from `refs/`)

- Dictionary files (e.g. `refs/english-big/ships.dat`) are **plain text**: a header of
  `filerange <min> <max>` + one or more `rangestart <min> <max>` lines, then
  `<ID>⇥<text>` rows. They are **not** binary despite the `.dat` extension.
- The list of dictionaries loaded by the engine lives in `locale/localedat.lua`
  (`Dictionaries = { { name = "ships.dat" }, … }`), shipped in the main data archive.
- The dictionary files themselves are served through the **`locale:` alias** (vanilla
  ships these in `english.big`, whose root holds `ships.dat`, `ui.dat`, etc.).
- Source code references a string as `"$<ID>"`.

### Vanilla ID ranges (do not collide)

| Dictionary | Range |
|---|---|
| engine.dat | 1–1499 |
| ships.dat | 1500–2499 |
| resource.dat | 2500–2549 |
| ui.dat | 2550–5599 |
| events.dat | 5600–5999 |
| ati.dat | 6000–6299 |
| leveldesc.dat | 6300–6499 |
| buildresearch.dat | 7000–7999 |
| *(reserved for game-rule mods)* | 8000–8999 |

**TPOF uses 9000–9999** — above everything vanilla and above the reserved game-rule range.

## Scope

Convert the literal display strings in these four categories (hardpoint slot labels are
**excluded** this pass — see Non-goals):

1. **Ship / subsystem `displayedName` + `sobDescription`** (`.ship` / `.subs`)
2. **Build-menu `DisplayedName` + `Description`** (`vaygr/build.lua`)
3. **MP game-rules strings** (`deathmatch.lua`)
4. **Research-menu `DisplayedName` + `Description`** (`hiigaran/`+`vaygr/research.lua`, 31 literals)

### Concrete inventory (categories 1–3)

**Ships (`.ship`):**
- `meg_slipgate` — `displayedName` + `sobDescription`, both `"Slipgate"`
- `sri_sajuuk` — `displayedName = "SRI-Sajuuk"` (its `sobDescription` is already `$1627`)

**Subsystems (`.subs`) — IDs shared with the matching `build.lua` entry:**
- `vgr_bc_concussionmissile` — `"Concussion Missile Launcher"` / `"Anti-frigate explosive missile battery"`
- `vgr_bc_sunshattermissile` — `"Sun-Shatter Missile Launcher"` / `"Long-range siege missile battery"`
- `vgr_bc_heavyfusionmissile` — `"Heavy Fusion Missile Launcher"` / `"Heavy-yield anti-capital missile battery"`
- `vgr_bc_swarmmissile` — `"Swarm Missile Burst"` / `"Rapid-fire anti-strikecraft missile battery"`

**Build menu (`vaygr/build.lua`):**
- The four missile launchers above (reuse the subsystem IDs — keeps build menu + selection UI in sync)
- Planet-killer entry `DisplayedName = "Honking big planet killing missile"` (own ID)

**MP game-rules (`deathmatch.lua`):** the resource/unitcaps/lockteams/etc. options already
use vanilla `$32xx` IDs and are left alone. Literals to convert:
- `GameRulesName = "Slipstream"`
- `Description = "Game Options for Slipstream: The Price of Freedom"`
- Music option: `locName = "Music"`, `tooltip = "Select the background music"`, and every
  display label in its `choices` list (~25 labels such as `"Shuffle: Slipstream"`,
  `"Slipstream: Suite 1"`, `"Ambient: No.1"`, …). The paired values (`"slipstream"`,
  `"ambient\\amb_01"`, etc.) are **not** display strings and stay literal.

### Research (`research.lua`, 31 literals)

Converted **verbatim**, including dev/placeholder text (`"Instant Tech!!!!"`,
`"Sensors Downgrade1"`, `"… SP GAME ONLY"`). No rewording in this pass — that keeps the
change mechanical and reviewable. (13 in `hiigaran/research.lua`, 18 in `vaygr/research.lua`.)

## Design

### New / changed files

- **`src/locale/english/slipstream.dat`** *(new)* — the TPOF dictionary. Header
  `filerange 9000 9999` + `rangestart 9000 9999`, then `<ID>⇥<text>` rows. Tab-separated,
  matching vanilla `.dat` formatting. Packed via the **`locale`-alias TOC** (lands at the
  locale root next to where vanilla serves `ships.dat`).
- **`src/locale/localedat.lua`** *(new)* — overrides the vanilla dictionary list. Replicates
  the existing 8 vanilla entries and appends `{ name = "slipstream.dat" }`. Packed in the
  normal **`Data` TOC** at path `locale/localedat.lua` (overrides vanilla by path).
- **`tools/build-tpof.ps1`** *(changed)* — emit a second TOC
  `TOCStart name="TPOFLocale" alias="locale" relativeroot=""` rooted at `src/locale/english`
  so `slipstream.dat` resolves via `locale:`; and `SkipFile`/exclude `slipstream.dat` from
  the `Data` TOC so it isn't packed twice. `localedat.lua` stays in the `Data` TOC.
- **Source files** — each listed literal replaced with its `$<ID>` reference.

### ID allocation (within 9000–9999)

| Range | Use |
|---|---|
| 9000–9099 | Ship names + descriptions |
| 9100–9299 | Subsystem names + descriptions (reused by `build.lua`) + the planet-killer build entry |
| 9300–9399 | MP game-rules strings (`GameRulesName`, setup `Description`, Music `locName`/`tooltip`/`choices`) |
| 9400–9799 | Research-menu strings |
| 9800–9999 | Reserve |

### Conversion rules

- Strings copied **verbatim** — no rewording, including research placeholders.
- A given user-visible string gets **one** ID; if the same literal appears in both a
  subsystem and its build entry, both reference the shared ID.
- Music `choices` display labels become `$<ID>`; their paired values stay literal.

## Verification-first (de-risks the unknown)

The one thing not fully confirmable from the repo is whether overriding `localedat.lua` +
adding a `locale` TOC makes the engine load a mod dictionary. So implementation begins with
a **spike** before any bulk conversion:

1. Create `slipstream.dat` with a single test entry (e.g. `9000⇥Slipgate`) and the
   overriding `localedat.lua`.
2. Wire `meg_slipgate.displayedName = "$9000"`.
3. Update `build-tpof.ps1`, then `pwsh tools/build-tpof.ps1 -Install`.
4. Launch; confirm the slipgate shows **"Slipgate"**, not a raw `"$9000"`.
5. `pwsh tools/parse-logs.ps1 -Errors` is clean.

Only after the spike renders correctly do we bulk-convert the remaining categories.

**Final verification:** full build + launch, spot-check a converted unit name and a build-menu
entry, and `parse-logs.ps1 -Errors` clean.

## Non-goals

- **Hardpoint slot labels** (~50 `StartShipHardPointConfig` labels like `"Weapon Top"`,
  `"Engine"`, `"Generic 1"`). Excluded: many are generic/positional, it's unconfirmed whether
  the engine localizes that argument via `$<ID>`, and they'd roughly double the work for low
  polish value. Candidate for a later pass once the dictionary infra is proven.
- **Fixing mismatched reused-vanilla `$<ID>` references** (e.g. heavy battlecruiser showing a
  vanilla name). Separate effort.
- **Rewording** any string. This pass is a 1:1 move into the locale system.
- **Steam Workshop Tool GUI packing** of the locale TOC — `build-tpof.ps1` is the documented
  iteration path and the target here. If the Workshop Tool needs equivalent locale-folder
  handling, that's a follow-up note, not part of this pass.
- **Additional languages.** English only; the structure leaves room to add languages later
  as parallel `locale`-alias dictionaries.
