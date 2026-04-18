# TPOF Sim-Tick Crash Investigation

Ongoing investigation of the deterministic access-violation crash observed
when running Slipstream: The Price of Freedom on Homeworld 2 Classic.
Reproduces since at least **TPOF v3.2** (current v4.x). Does **not**
reproduce in vanilla HW2.

## Crash Signature

| Field | Value |
|-------|-------|
| Exception | `c0000005` (Access violation — read) |
| EIP | `0023:004ae549` in `Homeworld2.exe` |
| Fault address | `0x00000010` (NULL + 16) |
| EBP | `0x00000000` |
| ECX (`this`) | `0x00000000` |
| Stack tell | Repeating `0x3dcccccd` = `0.1f` (per-tick sim, dt = 0.1s) |

Three captured dumps in `refs/bin/Release/`:

- `4-17-2026_21_28_22_MiniDump.dmp`
- `4-17-2026_21_38_12_MiniDump.dmp`
- `4-18-2026_00_26_18_MiniDump.dmp`

All three show identical EIP, identical caller return address, and
identical further-up stack frames — the call chain is **fully
deterministic**. The "random-feeling" repro is purely due to when a
triggering entity enters a type-0 branch of the tick, not variation in
the code path.

## Instruction-Level Analysis

### Crashing function (`0x004ae53c`)

```asm
004ae53c  sub   esp, 10h
004ae53f  push  ebx
004ae540  push  ebp
004ae541  mov   ebp, ecx          ; ebp = this   (ecx = NULL — bug origin)
004ae543  push  esi
004ae544  push  edi
004ae545  push  [esp+28h]         ; re-push arg2
004ae549  mov   eax, [ebp+10h]    ; CRASH — deref NULL+0x10
```

Calling convention is `__thiscall`. The method was invoked with `ecx =
NULL`, which is then copied to `ebp` (frame-pointer-omitted use of `ebp`
as a general register) and dereferenced at offset `0x10`.

### Call site (`0x0059490d`, return address `0x00594912`)

```asm
005948f6  lea   ecx, [edi+10h]             ; std::string at edi+0x10
005948f9  cmp   [ecx+14h], 10h             ; SSO capacity check
005948fd  jb    short +2                   ; skip deref if short-string
005948ff  mov   ecx, [ecx]                 ; else deref to heap buffer
00594901  mov   eax, [ebx+28h]             ; eax = container manager
00594904  push  0                          ; arg2
00594906  push  ecx                        ; arg1 = entity name (std::string)
00594907  mov   ecx, [eax+304h]            ; this = sub-manager at +0x304
0059490d  call  004ae53c                   ; <-- NULL this, crash
```

**What this tells us:** the container at `[ebx+0x28]` holds several
sub-managers at fixed offsets. The caller _successfully_ uses the
sub-manager at `+0x294` just a few instructions earlier (calling
`0x004e5ec5`), so the container itself is valid. Only the specific slot
at `+0x304` is never populated — it remains NULL.

The outer code loops over entities (`edi`), branching on
`[[edi+0x38]+0x68]` (a type enum). The `type == 0` branch pushes the
entity's name string and a `0` sentinel into our crashing call. The
crashing method's signature appears to be:

```c
void SubManager::report(const std::string& entityName, int kind);
```

— the shape of a per-entity reporting/event hook invoked on every
simulation tick.

### String data near the function

The function pushes the offset `0x006ea970` and calls a lazy-init helper
at `0x005eb2d2`. Nearby string literals include:

```
"lowColour"
"ls/badtrail.tga"
"noname"
"EngineNozzle1" ... "EngineNozzle6"
"setEngineGlow: Invalid type for fifth arguement - blurStartDistance"
```

These look like engine-effect / engine-glow validator strings. This may
just be data-segment proximity (unrelated strings packed adjacent),
**or** it may indicate that the sub-manager at `+0x304` is part of the
engine-effects or per-ship-visual subsystem. Treat as a weak hint, not
evidence.

## Plain-English Interpretation

An engine-owned sub-manager — something the HW2 engine expects to
exist as a pointer at offset `+0x304` of a per-game container — is
never initialized when TPOF is the active mod. For each entity on each
tick, vanilla would call a method on that sub-manager (passing the
entity's name). In TPOF, the pointer is NULL, so the method call
dereferences NULL and crashes.

The crash is **not** on TPOF Lua code. It is in C++ engine code,
triggered by an init-time gap: whichever data file or scripted setup
would normally cause the engine to construct the `+0x304` sub-manager
is missing, renamed, or short-circuited by a TPOF override.

## Constraints & Ruled-Out Hypotheses

Anchored to v3.2 as the regression boundary (per maintainer recall).

### Ruled out (do not re-investigate without new evidence)

- **Missing ship types in level files.** `kpr_attackdroid`,
  `meg_asteroid_nosubs`, etc. exist in `refs/homeworld2-big/ship/` and
  load via `-overridebigfile`.
- **`addSquadron ... Name()` warnings.** Squadron-count clamping noise,
  not a crash signal.
- **`hgn_destroyer` `CanBeCaptured` / `CanBeRepaired` ability
  mismatch.** Abilities were removed on 2026-04-18; crash persisted.
- **Recent SRI weapon changes** (commits `604be39`, `3d83ee1`,
  `7f5d083`, `1be5942`). Crash predates these.
- **Zero-cost `HyperSpaceCommand`.** TPOF has used cost-0 hyperspace on
  all ships since original release; not new, not the bug.
- **Hardpoint default subsystem names.** All verified to resolve in
  `src/` or vanilla.
- **Weapon names referenced by ships / subsystems.** All resolve.

### Known unrelated content issues (worth fixing, not the crash)

- `src/ship/meg_leviathan/meg_leviathan.ship` references six
  nonexistent subsystem types in its hardpoint `OPTIONS` list:
  `test_bc_turret`, `hgn_battlecruiserkineticflakcannon`,
  `HGN_SCC_2xPulsar_Turret`, `HGN_SCC_6xAC_Turret`,
  `Hgn_StrikeBattlecruiserRailBeamTBack`,
  `Hgn_StrikeBattlecruiserRailBeamTurret`. They are options, not
  defaults — benign at spawn.

## Candidate Root Causes (not yet confirmed)

Anything that matches the shape "engine registers a per-entity
sub-manager when a particular data file loads, and TPOF omits or
displaces that file" is in scope. Current best guesses:

- **UI overhaul under `src/ui/newui/`.** HW2's engine wires several
  per-entity hooks through UI config — health-bar updates, build-info
  panels, tactical overlay, selection info. A missing file or a
  renamed global in the UI init path could prevent an engine-side
  sub-manager from being constructed. TPOF ships ~40 files under
  `src/ui/newui/` that override vanilla; any one of them dropping a
  global that the engine expects would fit.
- **Stats / replay / event-bus subsystem.** Per-tick, per-entity,
  takes an entity name — classic shape of an analytics hook. Vanilla
  ships a stats schema file; TPOF may not.
- **Sensors manager** (`src/ui/sensorsmanager/sensorsmanager.lua`).
  Handles per-entity sensor visibility; drops a per-entity hook if
  init fails silently.
- **Pieplate / in-game HUD** (`src/ui/pieplate.lua`).
  Per-entity HUD widget registration.

## Next Productive Steps

1. **Diff TPOF's `src/ui/newui/` against vanilla HW2's `ui/newui/`.**
   Look specifically for globals the vanilla file defines but the TPOF
   replacement does not. Any missing global that the engine binds to
   by name is a candidate.
2. **Check for empty / stub files** in `src/ui/`. An earlier refactor
   that replaced a vanilla file with a no-op would match.
3. **Reproduce with a minimal subset of TPOF** — swap TPOF's
   `src/ui/` out for vanilla, rebuild `TPOF.big`, run. If the crash
   disappears, confirmed UI. If it persists, move on to
   `src/scripts/` and `src/ai/`.
4. **Capture a `Hw2.log` from a crashing run** (the existing log is
   from a later, non-crashing 21:54 session). The last lines before
   truncation often name the last-loaded script file or entity —
   strong signal for the "what was being reported at crash time"
   question.

## Debugger Commands Used

```powershell
# cdb path
$cdb = "%LOCALAPPDATA%\Microsoft\WindowsApps\cdbX86.exe"

# Open a dump and switch to exception context
& $cdb -z "refs\bin\Release\4-18-2026_00_26_18_MiniDump.dmp" -c ".ecxr; r; q"

# Disassemble the crashing function
& $cdb -z "<dump>" -c ".ecxr; ub 004ae549 L10; u 004ae549 L10; q"

# Disassemble the caller around the return address
& $cdb -z "<dump>" -c ".ecxr; ub 00594912 L30; u 00594912 L10; q"

# Walk the stack at the caller frame
& $cdb -z "<dump>" -c ".ecxr; dds 001afbb0 L20; q"
```

Offset math: after the crashing function's prologue (`sub esp,10h` +
five 4-byte pushes = `0x24` bytes), the caller's return address is at
`crash_esp + 0x24`. The first two dwords after the return address are
`arg1` (std::string pointer) and `arg2` (`0`).
