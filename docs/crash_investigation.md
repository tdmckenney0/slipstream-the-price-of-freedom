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

## Full Call Chain (captured 2026-04-18 via unattended cdb session)

Walked via saved-ebp chain out of the unattended dump
`tpof-cdb-2026-04-18_203726_*.dmp`:

| # | Site / Ret-addr | What it is |
|---|-----------------|------------|
| 0 | CRASH `0x004ae549` | `mov eax, [ebp+10h]`, `ebp = 0`, fault reading `0x10` |
| 1 | ret `0x00594912` | **Sub-manager A's update** (`0x00594756`). Iterates entities, type-0 branch does the crashing call |
| 2 | ret `0x00496445` | **Dispatcher** (`0x00496420`) calling `[this+2E4h]->update(dt)`. Null-checks each sub-manager cleanly before calling |
| 3 | ret `0x00496135` | **Outer updater** — flat sequence of `update(this, dt)` calls (`00494164`, `00496516`, `004965dc`, `004962ab`, `004961c0`, `00496420`) |
| 4 | ret `0x00605ddd` | **Virtual-call iterator** (`0x00605d7b+`) — for each elem in a list, check flag bit `0x100` at `+0x138h`, if clear call `vtable[16](dt)` |
| 5 | ret `0x00605965` | **Top of tick** (`0x0060592f`) — iterates units at `[this+37Ch]` (count `[this+380h]`) |

## Sub-manager A (`0x00594756`) dissected

```asm
00594756  [SEH prologue, install handler at 006dad2b]
00594763  push ebx; mov ebx, ecx; mov [ebp-28h], ebx   ; ebx = this
00594769  mov ecx, [ebx+28h]; call 00490ee4             ; container->check()
00594771  test al, al; je bail                          ; — if false, bail
00594779  mov ecx, [ebx+28h]; push 0Bh; call 004935eb   ; container->is_enabled(0x0B)
00594783  test al, al; je bail                          ; — TPOF passes this
0059478b  push esi; mov ecx, ebx; call 0059352c         ; this->prep()
00594793  mov ecx, [ebx+20h]                            ; entity list sentinel
00594796  mov ax, [ebx+2Dh]; mov [ebp-10h], ax          ; type-enable bitmap (16 byte-flags)
0059479e  mov esi, [ecx]                                ; first entity
...
005947b5  mov eax, [entity+38h]; mov eax, [eax+68h]     ; type enum
005947b8  cmp byte [ebp+eax-10h], 0; jne process        ; indexed byte-flag per type
...
005948a8  mov ecx, [ebx+28h]; push [edi+0Ch]            ; entity ID
005948ae  add ecx, 294h                                 ; ecx = &container->field_294 (INLINE sub-object)
005948b4  call 004e5ec5                                 ; works — the by-ID reporter
...
00594907  mov ecx, [eax+304h]                           ; ecx = *(container + 0x304) (POINTER)
0059490d  call 004ae53c                                 ; CRASHES — pointer is NULL
```

**Crucial distinction**: `+0x294` is an **inline sub-object** (`add ecx, 294h` — address computation). `+0x304` is a **stored pointer** (`mov ecx, [eax+304h]` — dereference). The inline one is always present (statically allocated inside the container); the pointer is conditionally allocated at construction time.

## The init site — gated allocation

Scanning Homeworld2.exe for stores to `[reg+304h]` yielded **exactly one**
write site across the entire binary: `0x004901e8`, inside a constructor
at ~`0x00490174+`.

```asm
00490182  mov ecx, [edi+134h]         ; ecx = this->config
00490188  mov byte [ebp-4], 6
0049018c  mov [edi+2E4h], eax         ; ALWAYS: sub-manager A assigned
00490192  cmp [ecx+5A8h], 0           ; ← GATE 1: config->vector_5A8 non-null?
00490199  je  004901ee                ;     if NULL, skip — +0x304 stays 0
0049019b  cmp byte [ecx+570h], 0      ; ← GATE 2: config->flag_570 non-zero?
004901a2  je  004901ee                ;     if 0, skip — +0x304 stays 0
004901a4  push 0B8h; call operator_new ; alloc 184-byte reporter
004901bc  mov ecx, [edi+134h]
004901c2  mov ecx, [ecx+5A8h]          ; deref vector
004901c8  mov eax, [ecx+0Ch]; sub eax, [ecx+8]; sar eax, 2  ; vector element count
004901d3  push eax; push edi           ; args: count, owner
004901d5  call 004ad192                 ; reporter->construct(owner, count)
004901e8  mov [edi+304h], eax           ; store reporter (or NULL/ebx)
```

**So the pluggable reporter at `+0x304` is only created if BOTH:**
1. `config->field_5A8` is a non-null `std::vector` (of 4-byte elements)
2. `config->field_570` is a non-zero byte

Sub-manager A's runtime gate (`container->is_enabled(0x0B)`) does **not**
check the pluggable reporter's presence. So it's entirely possible to
have feature 0x0B enabled but the paired `+0x304` pointer NULL — which
is exactly TPOF's state.

The constructor at `~0x00490174+` is clearly a large aggregate init (the
same function continues setting up `+0x320h`, `+0x324h`, etc. through
similar gated branches). Identifying *what object this constructor
creates* and *what `config->field_5A8` / `config->field_570` represent*
is the next concrete step.

## Candidate identities for config fields 5A8h / 570h

Working hypotheses — the pair "non-null vector of 4-byte elements + a
boolean enable flag" is a common shape for:

- **Recording / replay**: `field_570` = "record replays", `field_5A8` = vector of tracked player/team ids. Replay recorders match the by-ID + by-name pair pattern.
- **Match stats / scoreboard**: `field_570` = "collect stats", `field_5A8` = vector of scoreboard columns or stat ids.
- **Campaign/mission tracking**: `field_570` = "track objectives", `field_5A8` = vector of objective ids. Less likely for multiplayer-only repro.
- **Debug telemetry**: `field_570` = "emit telemetry", `field_5A8` = list of taps. Possible but Relic typically strips these in Release.

The "**name**-keyed reporter at `+0x304` complementing an **ID**-keyed reporter at `+0x294`" strongly suggests a system that logs/reports per-entity events to two indexes simultaneously — replay or stats most likely.

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

## Update 2026-04-19 — Empirical Confirmation

Live-dump inspection of the second mini-dump confirmed the gate-field
hypothesis and narrowed the failing code path to a single ability
keyword.

### Concrete state at crash time

From the crashing thread's register snapshot and `dd` on the live
pointers:

- **Dispatcher object** (the one whose `+304h` vtable slot is read in
  the crashing function): `0x435b3a50`, vtable `0x007188b4`.
- **Config object** being walked by the dispatcher: `0x433992e8`,
  vtable `0x00718b08`. This is the sim-container config for the
  ship/subsystem under construction.
- `[config + 0x5A8] = 0x00000000` — the NULL pointer that gets
  dereferenced.
- `[config + 0x570] = 0x00` — the "hold is valid" flag byte is also
  zero.
- `[config + 0x4B0] = 0x4339d4a0` — populated (not zero). This is a
  different field set by a *different* ability handler (see below),
  and proves the dispatcher infrastructure is working on this config.

`+5A8h` is the pointer the crashing instruction dereferences; `+570h`
is the "this hold/launcher is configured" gate byte that guards it.
Both are zero at crash time.

### ShipHold is the keyword that sets the gate

Scanning `.text` for writers to `config + 0x5A8` found a single
setter at `0x0049be42`:

```
mov eax, [esp+4]
mov [ecx+5A8h], eax           ; write pointer
mov byte [ecx+570h], 1        ; flip gate byte
ret 4
```

That setter is only called from **one** site in the binary: inside
the ability handler at `0x004ccb57` (call at `0x004ccd3d`), gated by
a local flag that is only set when the handler takes the
"first-time, allocate new vector" branch.

The string-dispatch table that routes ability keywords to handlers
lists `"ShipHold"` (string at `0x0071b18c`) as the first entry and
dispatches it to `0x004ccb57`. Handler-local disassembly confirms it
reads `[ebx+5A8h]` (where `ebx` is the config arg) and, on the
allocate path, walks down to `call 0x0049be42` at `0x004ccd3d`.

Therefore: **`+5A8h` is the ShipHold / "ships this object can hold"
container pointer, and the only path that populates it is the
`ShipHold` ability handler.**

### CanBuildShips writes `+4B0h` — proves dispatch works under TPOF

The same scan located a writer at `0x004cbc8a` that stores into
`[config + 0x4B0]`. Backwalking places it inside the
`"CanBuildShips"` handler (string at `0x00721c00`). Since
`+4B0h` *is* populated on the crashing config (see above), this
config was built from a ship that declared `CanBuildShips` and the
dispatcher *did* route that keyword to its handler. The dispatcher
and handler tables are functional under TPOF for at least this
sibling keyword.

In other words: the failure is specifically that `ShipHold` is not
being reached / not taking the allocate branch for whichever ship's
config is being constructed when the crash fires. It is not a
wholesale dispatcher breakage.

### TPOF ShipHold declarations are syntactically clean

Grep of `src/` for `ShipHold` returned eight declarations. All match
vanilla syntax:

| File | Form |
|------|------|
| `hgn_battlecruiser.ship:143` | `ShipHold, 1, 0, 5, "rallypoint", "Fighter, Corvette", 25, {Fighter="12"}, {Corvette="75"}` |
| `vgr_battlecruiser.ship:145` | same form |
| `hgn_resourcecontroller.ship:137` | `ShipHold, 1, 40, 0, "rallypoint", "", 35` |
| `vgr_resourcecontroller.ship:142` | same form |
| `meg_chimera.ship:122` | `ShipHold, 1, 0, 0, "rallypoint", "", 0` |
| `sri_dreadnaught.ship:148` | `ShipHold, 1, 0, 0, "rallypoint", "", 1` |
| `sri_commandbase.ship:120` | full form with squadron tables |
| `vgr_prisonstation.ship:124` | full form with squadron tables |

`pwsh tools\parse-logs.ps1 -Errors` returns 0 errors — the handler
is not throwing a visible Lua error. If it's bailing, it's bailing
silently.

### TPOF's flagship lacks ShipHold — and so does most of the roster

The starting-fleet flagships are `hgn_heavybattlecruiser` and
`vgr_heavybattlecruiser`. Neither `.ship` file declares `ShipHold`,
though both declare `CanDock`, `CanLaunch`, `CanBuildShips`, and
`ParadeCommand`. They expect to act like mini-carriers without the
container that the engine's carrier-path code assumes exists.

TPOF also has no `Carrier`, `Mothership`, or `Shipyard` ship types
at all — the vanilla ships that always carry `ShipHold` and get
spawned early in standard games are simply absent. The population
of objects that *do* have `ShipHold` under TPOF
(`hgn_battlecruiser`, `vgr_battlecruiser`, the resource controllers,
the dreadnaught, the Keeper/scenario ships) is a much narrower set,
and — for a standard deathmatch start — the first `CanDock`/`CanLaunch`-capable
object to hit sim-init is the heavybattlecruiser flagship, which
has no ShipHold at all.

### Working hypothesis, refined

The crash happens when engine code on a per-tick sim path
(`0.1f` delta parameter observed repeatedly in stack frames) walks
`[config + 0x5A8]` on a ship-config whose `ShipHold` handler never
ran. The most-likely candidates, from most to least plausible
given current evidence:

1. **Heavybattlecruiser flagship + carrier-path sim code.** The
   flagship has `CanDock` / `CanLaunch` / `CanBuildShips` /
   `ParadeCommand` but no `ShipHold`. If the sim-tick code path
   reached by any of those abilities assumes the `ShipHold`
   container exists, it will deref NULL on this config.
2. **Parse-order / timing.** ShipHold ships do exist in TPOF, but
   if the sim-container constructor for the first-built ship
   (flagship) runs before the `.ship` file's `addAbility(...,
   "ShipHold", ...)` call has been applied, the config is
   un-gated at tick time.
3. **Silent handler bail.** The handler branches on its args —
   if one of TPOF's trimmed `ShipHold, 1, 0, 0, ...` forms
   (resourcecontroller, chimera, dreadnaught) hits a code path
   that returns before the allocate branch, the setter never
   fires and `+5A8h` stays NULL even for the ship that declared
   it.

Hypothesis (1) dominates because `+4B0h` *is* set on the crashing
config (so `CanBuildShips` fired on it), which points directly at
the flagship or another builder-capable object that lacks
`ShipHold`.

## Revised Next Steps

The user has ruled out the simplest experimental fix — adding
`ShipHold` to the heavybattlecruisers — on gameplay grounds:
heavybattlecruisers are not meant to dock, launch, or hold ships.
So the first experiment must be diagnostic rather than
gameplay-altering.

### Step A — Confirm which ship's config is on the dispatcher

Instrument `.ship` files with `print()` calls keyed to the
constructor entry so the log records the order in which
sim-configs are built vs. the order in which `ShipHold` handlers
fire. Suggested shape, added at the top of each suspect `.ship`
file:

```lua
print("TPOF-TRACE: loading <filename>")
```

…and at the end, after the last `addAbility`:

```lua
print("TPOF-TRACE: finished <filename>")
```

Rebuild `TPOF.big`, reproduce, and capture `Hw2.log` from the
crashing run (previous logs were from a later non-crashing
session). The last `TPOF-TRACE` line before the engine cuts will
name the ship whose sim-config is on the dispatcher at crash time.

### Step B — If the flagship is implicated, remove the carrier-path abilities

If Step A confirms the heavybattlecruiser is the culprit, the
constraint "no ship hold" is compatible with also removing
`CanDock` / `CanLaunch` / `CanBuildShips` / `ParadeCommand` from
the flagship. Losing `CanBuildShips` on the flagship is a gameplay
change, so this should be scoped and confirmed with the user
before applying. An interim compromise — keep `CanBuildShips`,
drop only `CanDock` / `CanLaunch` — may satisfy the engine
without costing the "build from flagship" flow.

### Step C — Audit every `CanDock` / `CanLaunch` / `CanBuildShips` declarer for missing `ShipHold`

```powershell
# Ships declaring dock/launch/build capability
Select-String -Path 'src\ship' -Pattern 'CanDock|CanLaunch|CanBuildShips' -Recurse

# Cross-reference: which of those also declare ShipHold?
Select-String -Path 'src\ship' -Pattern 'ShipHold' -Recurse
```

Any ship on the first list not on the second is a latent crash
candidate on the same code path. The flagship is the obvious one,
but there may be others.

### Step D — (Deferred) Decompile `0x004ccb57` branch conditions

If Steps A–C don't resolve it, go back to the handler and fully
map the conditions under which it *doesn't* take the allocate
branch (i.e. doesn't set `+570h`). That tells us which
`ShipHold, ...` arg form would cause a silent bail — which would
move hypothesis (3) to the front of the queue. This is the
slowest path and should only be taken if the faster
instrumentation loop doesn't converge.

### Supersedes

The earlier "UI overhaul / sensors manager / pieplate" candidate
hypotheses above remain technically possible but are now
lower-probability: the dispatcher + config are on the
ship-ability path, not the UI or sensors path, and the
crashing config has a populated `CanBuildShips` field
(`+4B0h`), which ties it specifically to a ship-type sim-config.
Prioritize the ShipHold trail first.

## Resolution 2026-04-20 — Flagship ShipHold

**Root cause:** both `hgn_heavybattlecruiser` and `vgr_heavybattlecruiser`
declared `CanBuildShips` with ship-class scope (`Battlecruiser_Hgn`,
`SuperCap_Hgn`, and type `Capital`) but did not declare `ShipHold`. The
engine's sim-tick code for `CanBuildShips`/`CanDock`/`CanLaunch`
unconditionally reads `[config + 0x5A8]` (the ship-hold vector pointer),
which is only populated by the `ShipHold` ability handler. With no
handler having run, that pointer stayed NULL and the tick crashed on
the dereference at `0x004ae549` (`mov eax, [ebp+0x10]` with
`ebp = 0`).

**Vanilla-HW2 confirms the rule empirically:** of all vanilla
`.ship` files under `refs/homeworld2-big/ship/`, the only three that
declare `CanBuildShips` without `ShipHold` are `meg_asteroid`,
`meg_asteroid_nosubs`, and `meg_asteroidmp` — and all three build
`SubSystemModule`/`SubSystemSensors` only, no ship classes. Every
vanilla carrier/mothership/shipyard/battlecruiser/destroyer that
builds actual ships has `ShipHold`.

**Fix applied:** added a zero-capacity `ShipHold` to both flagship
`.ship` files:

```lua
addAbility(NewShipType, "ShipHold", 1, 0, 0, "rallypoint", "", 0)
```

Form copied from `meg_chimera` — allocates the engine's internal
hold structures but accepts no ship classes and reserves zero
capacity, so nothing can actually dock or launch. Purely
crash-avoidance, gameplay-neutral.

**Verified:** after the fix, the startup crash at `0x004ae549` is
gone. A new, unrelated crash now surfaces roughly 30+ minutes
into gameplay at `0x0047fe80` (`mov edi, [ecx+0xAC]` with
`ecx = 0xfeeefeee` — use-after-free), which is a different code
path and a different bug. See future investigation notes.

**Durable rule** (also captured in `src/ship/CLAUDE.md`): any
`.ship` that declares `CanBuildShips` with any non-subsystem type
in its class list (`Fighter`, `Corvette`, `Frigate`, `Capital`,
`Platform`, `Utility`) MUST also declare `ShipHold`. Use the
zero-capacity form above if the ship isn't supposed to
function as a carrier.
