# Locale System — custom display strings

How TPOF's player-facing text lives in the HW2 Classic locale system instead of as
hardcoded English literals in source. Player-visible strings are referenced as `"$<ID>"`
and resolved at runtime against a TPOF-owned dictionary file.

> **The one rule that matters most:** TPOF locale IDs **must** be in the range
> **8000–8999**. The engine only resolves mod strings in that reserved range. An ID
> outside it (e.g. `$9000`) silently renders as the raw literal `"$9000"` in-game. This
> single fact cost three failed debugging passes before it was nailed down — don't relearn
> it the hard way.

## How HW2 Classic locale works

Despite the `.dat` extension, dictionary files are **plain text** (ASCII), not binary:

```
filerange 8000 8999
rangestart 8000 8999

// comments with // are allowed
8000	Concussion Missile Launcher
8001	Anti-frigate explosive missile battery

rangeend
```

- `filerange` / `rangestart` declare the ID window the file owns.
- Each data row is `<ID><TAB><text>` — a **real tab** character, not spaces.
- The file ends with a `rangeend` line. **Omitting `rangeend` breaks loading.**
- Encoding is **ASCII + CRLF**. No UTF-8, no BOM, no em-dashes (use `--`).
- The engine loads the list of dictionaries from `Locale/localedat.lua`
  (`Dictionaries = { { name = "ships.dat" }, … }`).
- Source code references a string by ID as `"$<ID>"` (e.g. `displayedName = "$8000"`).

### Vanilla ID ranges (do not collide)

| Dictionary | Range |
|---|---|
| engine.dat | 1–1499 |
| ships.dat | 1500–2499 |
| resource.dat | 2500–2549 |
| ui.dat | 2550–5599 |
| events.dat | 5600–5999 |
| ATI.dat | 6000–6299 |
| levelDesc.dat | 6300–6499 |
| buildresearch.dat | 7000–7999 |
| **TPOF (`slipstream.dat`)** | **8000–8999** (the reserved game-rule-mod range) |

## TPOF's implementation

### Files

- **`src/locale/english/slipstream.dat`** — the TPOF dictionary. One `<ID><TAB><text>` row
  per custom string, IDs in 8000–8999, terminated with `rangeend`.
- **`src/locale/localedat.lua`** — overrides vanilla's dictionary list. It replicates the
  8 vanilla entries (`engine.dat` … `buildresearch.dat`) and appends
  `{ name = "slipstream.dat" }` so the engine loads our dictionary alongside the stock ones.

### Packing — no build-script changes needed

`slipstream.dat` and `localedat.lua` are packed by `tools\build-tpof.ps1` like any other
source file, through the **normal `Data` TOC** (alias `Data`, relative to `src/`). They land
at `Locale\english\slipstream.dat` and `Locale\localedat.lua` inside `TPOF.big`, overriding
vanilla by path. **No separate `alias="Locale"` TOC is required.**

> **Note vs. the RDN `ResourceRace` sample:** the official sample
> (`refs/rdn/ResourceRace/ResourceRace.zip`) packs its `.dat` in a *separate*
> `TOCStart … alias="Locale"` TOC and ships **no** `localedat.lua`. That also works, but
> TPOF deliberately uses the simpler Data-TOC + `localedat.lua` override instead — it needs
> zero changes to `build-tpof.ps1`. Both approaches are valid; don't "fix" ours to match the
> sample.

### Case

Lowercase paths (`src/locale/english/slipstream.dat`, `localedat.lua`) work fine. Big-file
path casing is **not** the deciding factor (an earlier theory that proved false).

## Current ID allocation

| Range | Use |
|---|---|
| 8000–8099 | Weapon subsystems + matching build-menu entries (shared IDs) + planet-killer |
| 8100–8199 | Ship names (`displayedName` / `sobDescription`) |
| 8300–8399 | MP game-rules: `GameRulesName`, setup `Description`, Music `locName`/`tooltip` + the 34 music-choice labels |
| 8400–8499 | Hiigaran research-menu strings |
| 8500–8599 | Vaygr research-menu strings |
| 8600–8999 | Reserve |

A given user-visible string gets **one** ID. If the same literal appears in both a subsystem
`.subs` and its `build.lua` entry (e.g. a weapon name), both reference the same ID — that
keeps the build menu and the in-fleet selection UI in sync. Likewise, an identical string
appearing twice in one file (e.g. two research rows with the same label) shares one ID.

## Adding or changing a string

1. Pick the next free ID in the appropriate 8xxx sub-range.
2. Add a `<ID><TAB><text>` row to `src/locale/english/slipstream.dat` (keep it inside the
   `filerange`/`rangeend` block; comments and blank lines are fine).
3. Reference it from source as `"$<ID>"` — works in `displayedName`/`sobDescription`
   (`.ship`/`.subs`), `DisplayedName`/`Description` (`build.lua`/`research.lua`), and
   `GameRulesName`/`Description`/`locName`/`tooltip`/`choices` labels (`deathmatch.lua`).
4. Rebuild: `pwsh tools\build-tpof.ps1 -Install`.
5. Launch and confirm the text renders (not a raw `"$<ID>"`). Run
   `pwsh tools\parse-logs.ps1 -Errors` to confirm a clean load.

### Editing `slipstream.dat` safely

Editors that convert tabs to spaces, line endings to LF, or save as UTF-8 will silently
break the file. The reliable way to regenerate it is a small PowerShell script that writes
`<ID>` + `[char]9` + text, joins with `` `r`n ``, and writes with `System.Text.ASCIIEncoding`.
Verify afterward:

```powershell
$b = [System.IO.File]::ReadAllBytes('src\locale\english\slipstream.dat')
"Non-ASCII bytes: $(($b | Where-Object { $_ -gt 127 }).Count)"   # must be 0
```

To cross-check that every `$8xxx` reference in source has a dictionary entry (and vice
versa), compare the IDs grepped from `src/` against those defined in `slipstream.dat` — a
dangling reference renders as a raw `"$<ID>"`; an orphan entry is harmless dead weight.

## Scope notes (current pass)

- **In scope / converted:** ship + subsystem `displayedName`/`sobDescription`, the Vaygr
  `build.lua` weapon + planet-killer entries, `deathmatch.lua` game-rules + music labels, and
  the Hiigaran/Vaygr `research.lua` menu strings — all literal English, moved verbatim.
- **Out of scope:** hardpoint slot labels (`StartShipHardPointConfig` arguments), fixing
  mismatched *reused-vanilla* `$<ID>` references, rewording any string, and additional
  languages (the structure leaves room to add parallel dictionaries later).

## References

- `docs/rdn_modding_reference.md` §3.4 — the documented 8000–8999 reserved range and the
  general game-rule-mod localization mechanism.
- `refs/rdn/ResourceRace/ResourceRace.zip` — Relic-authored working sample (extract to see a
  real `.dat` and its build script).
- Design doc: `docs/superpowers/specs/2026-05-25-locale-display-strings-design.md`.
