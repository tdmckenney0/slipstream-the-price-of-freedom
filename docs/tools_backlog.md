# Tools Backlog

Suggested tools to build under `tools/`. All must be PowerShell 7+ scripts per project convention.

---

## 1. `validate-mod.ps1` — Cross-reference validator

**Priority: High**

Parses source files and checks that all named references point to things that actually exist. Silent breakage (wrong entity name in `build.lua`, misspelled subsystem in a `.ship` hardpoint) only surfaces at engine load time. This script makes those failures visible at author time.

Checks to implement:

- Every `ThingToBuild` name in `build.lua` has a matching directory under `src/ship/` or `src/subsystem/`
- Every `Player_RestrictBuildOption` / `Player_RestrictResearchOption` name in `restrict.lua` appears in the corresponding `build.lua`
- Every subsystem option listed in `StartShipHardPointConfig(...)` in a `.ship` file has a matching directory under `src/subsystem/`
- Every `WeaponScriptName` in `StartShipWeaponConfig` / `StartSubSystemWeaponConfig` has a matching directory under `src/scripts/weaponfire/`
- Every ship type listed in a starting fleet (`hiigaran00.lua`, `vaygr00.lua`) exists under `src/ship/`
- Each `.ship` file that references a `.events` file (implicitly by its presence) actually has a corresponding `.hod`
- Every ship that declares `CanBuildShips` with a non-subsystem class list also declares `ShipHold` (known crash trigger — see the note in `src/ship/CLAUDE.md`)

Output: pass/fail per check, with file + line context for failures.

---

## 2. `pack.ps1` — Workshop Tool launcher

**Priority: Low**

Launches the HW2 Workshop Tool pre-configured to pack `src/config.txt` into `TPOF.big` and place it in the correct `Data\` directory. If the Workshop Tool supports any CLI arguments, this becomes a single-command build step; if not, it at least opens the tool with the correct working directory.

Also useful as a hook that could run post-pack validation (verify `.big` file size is within expected range, confirm output path).

---

## Notes

- All scripts must target PowerShell 7+ (`pwsh`). No `bash`, no `cmd`.
- Prefer writing results to stdout for CI/agent consumption; file output should be opt-in via a `-OutputPath` parameter.
- Scripts should be idempotent and read-only by default (no side effects without an explicit `-Fix` flag).
