# ShipHold Sim-Tick Crash — Post-Mortem

A deterministic access-violation crash in `Homeworld2.exe` that reproduced on every Slipstream match since at least TPOF v3.2. **Resolved 2026-04-20** by adding a zero-capacity `ShipHold` to both flagship `.ship` files.

The durable rule extracted from this lives in [`src/ship/CLAUDE.md`](../src/ship/CLAUDE.md). This document is the forensic record of how it was diagnosed, kept in case a similar "engine-side sub-manager is NULL on sim tick" pattern appears again.

## Crash signature

| Field | Value |
|-------|-------|
| Exception | `c0000005` (Access violation — read) |
| EIP | `0023:004ae549` in `Homeworld2.exe` (`mov eax, [ebp+10h]`) |
| Fault address | `0x00000010` (NULL + 16) |
| `ebp` / `ecx` | `0x00000000` (NULL `this`) |
| Stack tell | Repeating `0x3dcccccd` = `0.1f` → per-tick sim at dt=0.1s |

Three captured minidumps (2026-04-17 / 2026-04-18) show identical EIP and stack frames. The "random-feeling" repro was driven by *when* a triggering entity entered the type-0 branch of the sim tick, not by randomness in the code path.

## Root cause

An engine-owned "per-entity reporter" sub-manager lives at offset `+0x304` of
a container built by the `CanBuildShips`-adjacent ability handlers. The
pointer is only populated when a ship also has `ShipHold`, because the
allocation is gated by two config fields:

- `config + 0x5A8` — `std::vector` pointer for the ship-hold contents
- `config + 0x570` — "ship-hold is valid" flag byte

Both are set in exactly one place: the `ShipHold` ability handler at
`0x004ccb57`, via a setter at `0x0049be42`.

The per-tick update at `0x00594756` runs over every entity in the container.
For entities whose type enum is `0`, it dispatches into the `+0x304`
sub-manager unconditionally — no NULL check. So any ship whose config has
`CanBuildShips` (or `CanDock` / `CanLaunch` / `ParadeCommand`) but no
`ShipHold` will trigger a NULL read on the first sim tick after construction.

## Why the flagship

Both `hgn_heavybattlecruiser` and `vgr_heavybattlecruiser` declared `CanBuildShips` with ship-class scope (`Battlecruiser_Hgn`, `SuperCap_Hgn`, `Capital`) but no `ShipHold` — effectively mini-carriers without the carrier container the engine assumes exists.

Vanilla enforces this empirically: the only three vanilla ships declaring `CanBuildShips` without `ShipHold` (`meg_asteroid`, `meg_asteroid_nosubs`, `meg_asteroidmp`) build `SubSystemModule`/`SubSystemSensors` only. Every vanilla carrier, mothership, shipyard, battlecruiser, and destroyer that builds ships has `ShipHold`.

## Fix

Added to both flagship `.ship` files:

```lua
addAbility(NewShipType, "ShipHold", 1, 0, 0, "rallypoint", "", 0)
```

The zero-capacity form allocates the engine's internal hold structures (satisfying the `+0x5A8`/`+0x570` invariants the sim tick relies on) while accepting no ship classes and reserving zero capacity. Gameplay-neutral. After the fix, the `0x004ae549` crash is gone.

## Investigation technique

```powershell
# cdb path (x86 debugger — HW2 is a 32-bit binary)
$cdb = "%LOCALAPPDATA%\Microsoft\WindowsApps\cdbX86.exe"

# Open a dump and switch to exception context
& $cdb -z "refs\bin\Release\<MiniDump>.dmp" -c ".ecxr; r; q"

# Disassemble the crashing function and its caller
& $cdb -z "<dump>" -c ".ecxr; ub 004ae549 L10; u 004ae549 L10; q"
& $cdb -z "<dump>" -c ".ecxr; ub 00594912 L30; u 00594912 L10; q"

# Walk the stack at the caller frame (prologue math: sub esp,10h + five pushes = 0x24)
& $cdb -z "<dump>" -c ".ecxr; dds 001afbb0 L20; q"
```

The workflow that converged: capture a dump with `tools\debug-tpof.ps1`, disassemble the crashing function and its immediate caller, read the stack to find which sub-manager was NULL, then scan `.text` for the single *writer* to the implicated offset and backwalk to its call site to identify the ability-handler string dispatch that reaches it.

The "writer in the engine binary" pass is the key move — engine-owned fields almost always have exactly one init site, and finding it names the ability keyword whose handler sets the field.

## Outstanding follow-ups

- **Mid-game crash at `0x0047fe80`** (`mov edi, [ecx+0xAC]` with
  `ecx = 0xfeeefeee` — use-after-free) surfaces ~30+ minutes into
  gameplay. Different code path, different bug. Not yet investigated.
- **Validator**: the "`CanBuildShips` without `ShipHold`" rule is a good
  candidate for the planned `tools\validate-mod.ps1` (see
  [`tools_backlog.md`](tools_backlog.md)) so this class of issue fails
  loudly at author time rather than silently at sim tick.
