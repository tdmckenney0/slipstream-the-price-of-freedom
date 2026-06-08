# Locale System — custom display strings

TPOF's player-facing text lives in the HW2 Classic locale system, not as hardcoded English literals. Strings are referenced as `"$<ID>"` and resolved at runtime against a TPOF-owned dictionary.

> **The one rule that matters most:** TPOF locale IDs **must** be in **8000–8999**. The engine only resolves mod strings in that reserved range; an ID outside it (e.g. `$9000`) silently renders as the raw literal `"$9000"` in-game. This cost three failed debugging passes before it was nailed down.

## How HW2 Classic locale works

Despite the `.dat` extension, dictionary files are **plain ASCII text**, not binary:

```
filerange 8000 8999
rangestart 8000 8999

// comments with // are allowed
8000	Concussion Missile Launcher
8001	Anti-frigate explosive missile battery

rangeend
```

- `filerange`/`rangestart` declare the ID window the file owns.
- Each data row is `<ID><TAB><text>` — a **real tab**, not spaces.
- The file **must** end with `rangeend` (omitting it breaks loading).
- Encoding is **ASCII + CRLF**. No UTF-8, no BOM, no em-dashes (use `--`).
- The engine loads the dictionary list from `Locale/localedat.lua`.
- Source references a string by ID as `"$<ID>"` (e.g. `displayedName = "$8000"`).

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

**Files**
- `src/locale/english/slipstream.dat` — the TPOF dictionary; one `<ID><TAB><text>` row per string, IDs 8000–8999, terminated with `rangeend`.
- `src/locale/localedat.lua` — overrides vanilla's dictionary list: the 8 vanilla entries plus `{ name = "slipstream.dat" }`.

**Packing** — no build-script changes. Both files are packed by `tools\build-tpof.ps1` through the **normal `Data` TOC**, landing at `Locale\english\slipstream.dat` and `Locale\localedat.lua` in `TPOF.big`, overriding vanilla by path. No separate `alias="Locale"` TOC is needed.

> The RDN `ResourceRace` sample instead packs its `.dat` in a separate `alias="Locale"` TOC and ships no `localedat.lua`. Both approaches work; TPOF uses the simpler Data-TOC + override deliberately — don't "fix" ours to match the sample.

Lowercase paths work fine; big-file path casing is not the deciding factor (an earlier theory that proved false).

## Current ID allocation

| Range | Use |
|---|---|
| 8000–8099 | Weapon subsystems + matching build-menu entries (shared IDs) + planet-killer |
| 8100–8199 | Ship names (`displayedName`/`sobDescription`) |
| 8300–8399 | MP game-rules: `GameRulesName`, setup `Description`, Music `locName`/`tooltip` + the 34 music-choice labels |
| 8400–8499 | Hiigaran research-menu strings |
| 8500–8599 | Vaygr research-menu strings |
| 8600–8999 | Reserve |

Each user-visible string gets **one** ID. If the same literal appears in both a `.subs` and its `build.lua` entry, both reference the same ID (keeps the build menu and in-fleet selection UI in sync); identical strings repeated within one file also share one ID.

## Adding or changing a string

1. Pick the next free ID in the appropriate 8xxx sub-range.
2. Add a `<ID><TAB><text>` row to `slipstream.dat` (inside the `filerange`/`rangeend` block; comments and blank lines are fine).
3. Reference it as `"$<ID>"` — works in `displayedName`/`sobDescription` (`.ship`/`.subs`), `DisplayedName`/`Description` (`build.lua`/`research.lua`), and `GameRulesName`/`Description`/`locName`/`tooltip`/`choices` (`deathmatch.lua`).
4. Rebuild: `pwsh tools\build-tpof.ps1 -Install`.
5. Launch, confirm the text renders (not a raw `"$<ID>"`), and run `pwsh tools\parse-logs.ps1 -Errors` for a clean load.

### Editing `slipstream.dat` safely

Editors that convert tabs to spaces, change line endings to LF, or save UTF-8 will silently break the file. Regenerate it with a PowerShell script that writes `<ID>` + `[char]9` + text, joins with `` `r`n ``, and writes via `System.Text.ASCIIEncoding`. Verify:

```powershell
$b = [System.IO.File]::ReadAllBytes('src\locale\english\slipstream.dat')
"Non-ASCII bytes: $(($b | Where-Object { $_ -gt 127 }).Count)"   # must be 0
```

To find dangling refs, compare `$8xxx` IDs grepped from `src/` against those defined in `slipstream.dat` — a dangling reference renders as a raw `"$<ID>"`; an orphan entry is harmless dead weight.

## Scope notes (current pass)

- **Converted**: ship + subsystem `displayedName`/`sobDescription`, the Vaygr `build.lua` weapon + planet-killer entries, `deathmatch.lua` game-rules + music labels, and the Hiigaran/Vaygr `research.lua` menu strings — all moved verbatim.
- **Out of scope**: hardpoint slot labels (`StartShipHardPointConfig` args), fixing mismatched reused-vanilla `$<ID>` refs, rewording strings, and additional languages (the structure leaves room for parallel dictionaries later).

## References

- `docs/rdn_modding_reference.md` §3.4 — the documented 8000–8999 range and game-rule-mod localization mechanism.
- `refs/rdn/ResourceRace/ResourceRace.zip` — Relic-authored working sample.
- Design doc: `docs/superpowers/specs/2026-05-25-locale-display-strings-design.md`.
</content>
