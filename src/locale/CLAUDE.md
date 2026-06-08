# Locale — custom display strings

TPOF's player-facing text lives here as a locale dictionary, not as hardcoded literals in
source. Strings are referenced by ID as `"$<ID>"` and resolved at runtime.

## Files

| File | Purpose |
|------|---------|
| `english/slipstream.dat` | The TPOF dictionary — plain-text `<ID>⇥<text>` rows (despite the `.dat` extension). |
| `localedat.lua` | Dictionary list the engine loads: the 8 vanilla entries + `slipstream.dat`. |

## `slipstream.dat` format

```
filerange 8000 8999
rangestart 8000 8999

// comments allowed
8000	Concussion Missile Launcher

rangeend
```

- **IDs must be 8000–8999.** The engine only resolves mod strings in this reserved range; an
  out-of-range `$<ID>` renders as the raw literal in-game.
- Rows are `<ID><TAB><text>` — a **real tab**, not spaces.
- Must end with `rangeend`.
- **ASCII + CRLF** only. No UTF-8/BOM/em-dashes. Editors that retab, convert line endings, or
  save UTF-8 will silently break it — regenerate via PowerShell with `[char]9` tabs and
  `System.Text.ASCIIEncoding` when in doubt.

## Packing

Packed by `tools\build-tpof.ps1` through the normal `Data` TOC (no build-script changes) —
lands at `Locale\english\slipstream.dat` / `Locale\localedat.lua` in `TPOF.big`, overriding
vanilla by path.

## Adding a string

1. Pick the next free ID in the right 8xxx sub-range (see allocation table in the full doc).
2. Add a `<ID><TAB><text>` row here, inside the `filerange`/`rangeend` block.
3. Reference it from source as `"$<ID>"`.
4. `pwsh tools\build-tpof.ps1 -Install`, launch, confirm it renders.

Full reference (ID allocation, conversion rules, gotchas, verification): **`docs/locale_system.md`**.
