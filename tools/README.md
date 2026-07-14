# Tools

PowerShell 7+ scripts for working with TPOF. Run with `pwsh ./tools/<script>.ps1`. Each script has a `.SYNOPSIS` / `.PARAMETER` header — use `Get-Help ./tools/<script>.ps1 -Full` for the full reference.

## Scripts

| Script | Purpose |
|--------|---------|
| `build-tpof.ps1` | Pack `src/` into `TPOF.big` headlessly via the RDN `Archive.exe`. `-Install` copies the result into `<HW2>\Data\`. |
| `launch-tpof.ps1` | Launch HW2 Classic with TPOF active (uses `-moddatapath DataTPOF -overridebigfile`). |
| `debug-tpof.ps1` | Launch HW2 under the x86 `cdb` console debugger. `-Unattended` auto-captures a minidump on first-chance exception. |
| `parse-logs.ps1` | Read / filter / live-tail `Hw2.log`. Surfaces ERROR + LUA ERROR lines. Exits 1 when any are found, suitable for CI/agent checks. |
| `ship-stats.ps1` | Extract key balance fields from every `.ship` file. `-GitRef` diffs against a git revision. |
| `weapon-dps.ps1` | Estimate sustained DPS for every `.wepn` (damage / inter-shot interval); flags burst and beam weapons whose real DPS the naive formula misstates. |
| `find-empty-weapon-effects.ps1` | Find `StartShipWeaponConfig`/`StartSubSystemWeaponConfig` calls whose fire-animation arg is `""`. |
| `export-weapon-events.ps1` | Export weapon configs joined to their fire-animation `.events` entries as CSV. |
| `import-weapon-events.ps1` | Rewrite `.events` files from an edited copy of that CSV. |
| `link-src.ps1` | Symlink/junction this repo's `src/` into the HW2 install as `DataTPOF/` (iterate without repacking the `.big`). |
| `link-bin.ps1` | Link the HW2 `Bin/` directory into `refs/bin/` for log and minidump access from inside the repo. |
| `link-rdn.ps1` | Link the RDN installation into `refs/rdn/` for in-repo reference access. |

## Conventions

- All scripts target **PowerShell 7+** (`pwsh`); they will not run on Windows PowerShell 5.x.
- Paths to the HW2 install resolve in this order: explicit parameter → `HW2_ROOT` env var → Steam registry → common install paths.
- Read-only by default; any side-effecting flag is opt-in (e.g. `-Install` on `build-tpof.ps1`).
- Temporary outputs (`.tmp\TPOF.big`, generated build scripts) are written under the repo's `.tmp\` directory, which is gitignored.

