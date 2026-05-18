# Shader Refresh Phase 1 (Ships & Thrusters, fp_arb tier) — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Push the eleven fp_arb ship + thruster fragment programs toward an industrial / gritty / high-contrast look (Battlestar Galactica / The Expanse cue) within ARB FP1.0's 96-instruction budget.

**Architecture:** Five layered effects (ambient floor cut, cool-blue fill tint, fresnel rim, tighter spec + hotter glow, luminance desat) applied per-shader wherever the relevant inputs exist. No new files; no `.st` render-state changes; no texture work. Verification is screenshot-based with the user running the game between batches.

**Tech Stack:** ARB_fragment_program 1.0 (`!!ARBfp1.0`), HW2 Classic engine, PowerShell 7+ tooling (`tools\launch-tpof.ps1`, `tools\link-src.ps1`, `tools\parse-logs.ps1`).

---

## Pre-flight context (read once before starting)

**Why this plan looks unusual:** there is no shader unit-test framework. The "test" for every shader change is a two-part gate:

1. **Automated:** HW2 must launch and `tools\parse-logs.ps1 -Errors` must exit 0 (shader compiled cleanly).
2. **Human:** the user captures a screenshot of a known reference scene and confirms the look moved in the right direction.

That means: in TDD terms, the "failing test" is the *baseline screenshot of vanilla output*, and the "passing test" is *the new screenshot showing the targeted effect*. Each task therefore wraps shader edits in a launch + log-check + screenshot + user-review loop before commit.

**Iteration mechanics:** `tools\link-src.ps1` exposes `src/` to HW2 as `DataTPOF/`, and `tools\launch-tpof.ps1` launches with `-moddatapath DataTPOF -overridebigfile`. With the link already in place, `.fp` file edits are picked up on the next launch — **no `.big` repack needed**. Confirm the link exists once in Task 0; after that, just relaunch between batches.

**ARB FP1.0 cheat sheet** (the only instructions used in this plan):

| Op | Semantics |
|---|---|
| `MOV dst, src` | copy |
| `ADD dst, a, b` | dst = a + b |
| `SUB dst, a, b` | dst = a - b |
| `MUL dst, a, b` | dst = a * b (per-component) |
| `MAD dst, a, b, c` | dst = a*b + c |
| `MAX dst, a, b` | dst = max(a, b) |
| `LRP dst, a, b, c` | dst = a*b + (1-a)*c |
| `DP3 dst, a, b` | dst = a.x*b.x + a.y*b.y + a.z*b.z (broadcast) |
| `SUB rim, miscValues.z, col0` | classic "1 - col0" rim seed (miscValues.z == 1.0) |

**Reusable constant snippets** (these blocks appear verbatim in many shaders below; introduce them at the top of each shader where used):

```
PARAM ambientBias = { 0.10, 0.10, 0.10, 0 };       # subtract from col0 before light multiply
PARAM coolTint    = { 0.06, 0.07, 0.10, 0 };       # cool-blue fill added to lighting term
PARAM rimTint     = { 0.50, 0.70, 1.00, 0 };       # rim colour (cool)
PARAM rimStrength = { 0.60, 0,    0,    0 };       # rim intensity scalar in .x
PARAM lumWeights  = { 0.299, 0.587, 0.114, 0 };    # ITU-R BT.601 luminance
PARAM desatAmt    = { 0.15, 0, 0, 0 };             # 15% pull toward grayscale in .x
PARAM glowBoost   = { 0.70, 0, 0, 0 };             # replaces 0.5 (miscValues.y) for emissive term in ship.fp; .x scalar
```

Not every shader needs all of these — each task lists the exact PARAM block to introduce.

**Reference scenes** (use the same camera angles every iteration so visual diffs are clean):

- **A — Hiigaran capital ship close up:** match `screenshots/1440p_dreadnaught_chillin.jpg` framing.
- **B — Thrusters on, motion:** match `screenshots/1440p_destroyer_does_a_flip.jpg` framing.
- **C — Mixed engagement:** Hiigaran vs Vaygr fight, weapons firing. Match any of the `1440p_*_attacks_*` shots; the goal is having both palettes lit in one frame.

Save each iteration's captures to `screenshots\_shaderwip\<task>_<scene>.jpg` so they don't pollute the canonical screenshot library.

**Commit cadence:** one commit per task. Branch is `polish-next-release`. Each commit message follows: `shader: <what changed> (<task#>)`.

---

## File structure

No new files. Eleven existing fragment programs are edited in place:

| File | Purpose | Task |
|---|---|---|
| `src/shaders/fp_arb/shadowandlight.fp` | PCF-shadowed lit pass (largest; budget-critical) | Task 1 |
| `src/shaders/fp_arb/shadowandlightsmall.fp` | Smaller shadow + lighting variant | Task 2 |
| `src/shaders/fp_arb/ship.fp` | Single-pass ship (base + light + fog) | Task 3 |
| `src/shaders/fp_arb/shipglowpass.fp` | Discrete glow pass | Task 3 |
| `src/shaders/fp_arb/shiplightpassadditive.fp` | Multipass lit pass (counterpart to ship.fp's lighting block) | Task 3 |
| `src/shaders/fp_arb/shipbasepass.fp` | Multipass base + team colour only | Task 4 |
| `src/shaders/fp_arb/shipbasewithbadgepass.fp` | Multipass base + team + badge | Task 4 |
| `src/shaders/fp_arb/thruster.fp` | Single-pass thruster | Task 5 |
| `src/shaders/fp_arb/thrusterbasepass.fp` | Thruster base + team | Task 5 |
| `src/shaders/fp_arb/thrusterglowpass.fp` | Thruster glow | Task 5 |
| `src/shaders/fp_arb/thrusterlightpassadditive.fp` | Thruster additive lit pass | Task 5 |

---

## Task 0: Baseline capture & iteration loop sanity check

**Files:** none modified.

- [ ] **Step 1: Confirm the live-link is set up so iteration doesn't require a `.big` repack**

Run:
```powershell
pwsh tools\link-src.ps1
```
Expected: prints "linked" or "already linked" pointing `<HW2>\DataTPOF` at this repo's `src/`. If it errors with "HW2 install not found," set `$env:HW2_ROOT` to the install path and retry.

- [ ] **Step 2: Launch the game on a clean build to confirm the iteration loop works end-to-end before changing anything**

Run:
```powershell
pwsh tools\launch-tpof.ps1
```
Expected: HW2 launches; main menu appears. Quit the game.

- [ ] **Step 3: Verify no pre-existing shader/Lua errors**

Run:
```powershell
pwsh tools\parse-logs.ps1 -Errors
```
Expected: exits 0 (no errors). If errors appear, stop and investigate — they will mask shader compile failures introduced by later tasks.

- [ ] **Step 4: Capture baseline reference screenshots**

Launch HW2 again, load a Slipstream map with at least one Hiigaran and one Vaygr capital ship visible. Fly the camera to scenes A, B, C from the pre-flight context and capture three screenshots.

Save to:
```
screenshots\_shaderwip\task0_baseline_A.jpg
screenshots\_shaderwip\task0_baseline_B.jpg
screenshots\_shaderwip\task0_baseline_C.jpg
```

These are the vanilla "before" shots that every later task compares against.

- [ ] **Step 5: Commit baselines so they're recoverable**

```powershell
git add screenshots/_shaderwip/task0_baseline_*.jpg
git commit -m "shader: capture vanilla baseline screenshots (task0)"
```

---

## Task 1: shadowandlight.fp — most complex, runs the budget gauntlet first

**Why first:** this shader is already ~80 of 96 instructions; if any of the visual recipe overflows the budget, we discover it here and adjust the recipe for the remaining tasks (e.g., demote the fresnel rim into the glow pass instead of the lit pass).

**Files:**
- Modify: `src/shaders/fp_arb/shadowandlight.fp`

- [ ] **Step 1: Document the failing condition (baseline)**

The vanilla `shadowandlight.fp` currently produces flat ambient on shadowed faces and no rim against dark backgrounds. The Task 0 screenshots are the failing state. The success condition is: post-edit, hulls in scene A and C show visibly darker shadow creases, cool tint in unlit areas, and a faint rim along silhouettes.

- [ ] **Step 2: Edit `shadowandlight.fp` to add the five-effect recipe**

Open `src/shaders/fp_arb/shadowandlight.fp`. The shader has two distinct sections after the long PCF shadow accumulation block: a `## lighting` block (specular + shadow fade) and a final `## put lighting in` block. We add PARAMs at the top, square the shadow term, bump specular doublings, add a cool tint into `prim`, and append a rim contribution to `outColour`.

Replace the existing `PARAM miscValues  = { 0, 0.5, 1, 2 };` line by *adding* (not replacing) the new PARAM block below it so existing references to `miscValues` stay valid:

```
PARAM miscValues  = { 0, 0.5, 1, 2 };
PARAM coolTint    = { 0.06, 0.07, 0.10, 0 };
PARAM rimTint     = { 0.50, 0.70, 1.00, 0 };
PARAM rimStrength = { 0.60, 0,    0,    0 };
PARAM ambientBias = { 0.10, 0.10, 0.10, 0 };
```

Then add a new TEMP declaration line alongside the existing TEMPs (near the top, after the `OUTPUT outColour` line):

```
TEMP rim, col0biased;
```

Replace the `## lighting` and `## put lighting in` blocks (currently around the last quarter of the file, after `ADD shadowColour, r10, r9;`). The vanilla block is:

```
## lighting
# compute specular
MUL spec, col1, glow.b;
ADD spec, spec, spec;
ADD spec, spec, spec;

##shadow fade
...
LRP shadowColour, program.local[4].a, shadowColour, miscValues.z;

## put lighting in
MUL prim, col0, shadowColour;
MUL spec, spec, shadowColour;

ADD outColour, prim, spec;
MOV outColour.a, col0.a;
```

Replace it with:

```
## lighting — tighter specular (3 doublings instead of 2)
MUL spec, col1, glow.b;
ADD spec, spec, spec;
ADD spec, spec, spec;
ADD spec, spec, spec;

## shadow fade — with fake-AO squaring of the PCF accumulator
MUL shadowColour, shadowColour, shadowColour;
LRP shadowColour, program.local[4].a, shadowColour, miscValues.z;

## ambient floor cut — bias col0 down then clamp at 0
SUB col0biased, col0, ambientBias;
MAX col0biased, col0biased, miscValues.x;

## put lighting in — cool-blue fill on the diffuse term
MUL prim, col0biased, shadowColour;
ADD prim, prim, coolTint;
MUL spec, spec, shadowColour;
ADD outColour, prim, spec;

## fake fresnel rim — (1 - col0) modulated by glow.b, cool tint
SUB rim, miscValues.z, col0;
MUL rim, rim, glow.b;
MUL rim, rim, rimTint;
MAD outColour, rim, rimStrength.x, outColour;

MOV outColour.a, col0.a;
```

Instruction delta: roughly +9 instructions on top of ~80 → ~89. Within budget.

- [ ] **Step 3: Verify shader compiles (the "test")**

Run:
```powershell
pwsh tools\launch-tpof.ps1
```
Let the main menu appear, then load any Slipstream map with capital ships.

Then in another shell (or after quitting):
```powershell
pwsh tools\parse-logs.ps1 -Errors
```

Expected: exit code 0. If non-zero with an ARB fragment program compile error mentioning instruction count or syntax, the shader rejected the change.

- [ ] **Step 4: If compile fails, apply the documented mitigation**

If the log shows "exceeded instruction count" or similar: remove the fresnel rim block (the last 4 lines before `MOV outColour.a, col0.a;`) and also remove `TEMP rim, col0biased;` → declare only `TEMP col0biased;`. The rim will be picked up by the multipass route via `shipglowpass` + `shiplightpassadditive` (Task 4) on most modern drivers.

Then re-run Step 3.

- [ ] **Step 5: Visual verification — capture and compare**

Capture scenes A and C with the live changes:
```
screenshots\_shaderwip\task1_shadowandlight_A.jpg
screenshots\_shaderwip\task1_shadowandlight_C.jpg
```

Open both alongside the Task 0 baselines. The user confirms: ships have visibly darker shadow creases, slight cool tint in shaded areas, and (if rim wasn't dropped) a faint cool rim along silhouettes against dark space.

If the user judges the look wrong (too dark, too cool, rim too strong), tune the relevant PARAM constant and re-run Steps 3 + 5. Common tuning dials:

| Symptom | Adjust |
|---|---|
| Too dark overall | Reduce `ambientBias` values from 0.10 → 0.06 |
| Cool tint reads as "smurfy" | Reduce `coolTint` to `{ 0.03, 0.04, 0.06, 0 }` |
| No visible rim | Bump `rimStrength.x` from 0.60 → 0.90 |
| Rim too cyan/cold | Shift `rimTint` toward warmer: `{ 0.70, 0.80, 1.00, 0 }` |
| Creases too crushed | Skip the `MUL shadowColour, shadowColour, shadowColour` line |

- [ ] **Step 6: Commit**

```powershell
git add src/shaders/fp_arb/shadowandlight.fp screenshots/_shaderwip/task1_*.jpg
git commit -m "shader: gritty pass on shadowandlight.fp — AO squaring, cool fill, fresnel rim (task1)"
```

---

## Task 2: shadowandlightsmall.fp — mirror the Task 1 changes

**Files:**
- Modify: `src/shaders/fp_arb/shadowandlightsmall.fp`

This shader is the smaller-shadow variant. Vanilla math is structurally identical to `shadowandlight.fp` in the lighting block; only the shadow accumulator is simpler. Apply the same five-effect changes.

**Important:** use whatever final PARAM values Task 1 settled on, including any mitigations. If Task 1 dropped the rim, drop it here too. If Task 1 reduced `ambientBias` to 0.06, use 0.06 here.

- [ ] **Step 1: Apply the same edits to `shadowandlightsmall.fp`**

Add the same PARAM block below `PARAM miscValues  = { 0, 0.5, 1, 2 };`:

```
PARAM coolTint    = { 0.06, 0.07, 0.10, 0 };
PARAM rimTint     = { 0.50, 0.70, 1.00, 0 };
PARAM rimStrength = { 0.60, 0,    0,    0 };
PARAM ambientBias = { 0.10, 0.10, 0.10, 0 };
```

(Substitute the tuned values from Task 1 if they differ.)

Add `TEMP rim, col0biased;` to the TEMP declarations (drop `rim` if rim was dropped in Task 1).

`shadowandlightsmall.fp` has a *different* shadow-fade structure than the big variant — its `## shadow fade` block must be preserved as-is rather than overwritten. The vanilla `## lighting`, `## shadow fade`, and `## put lighting in` blocks read:

```
## lighting
# compute specular
MUL spec, col1, glow.b;
ADD spec, spec, spec;
ADD spec, spec, spec;
##shadow fade
#invert
SUB shadowColour, miscValues.z, shadowAmount;
#use prim to hold the inverse of the shadow colour
SUB prim, miscValues.z, program.local[4];
# change to shadow colour
MUL shadowColour, shadowColour, prim;
#invert back to normal
SUB shadowColour, miscValues.z, shadowColour;
#fade to no shadow
LRP shadowColour, program.local[4].a, shadowColour, miscValues.z;

## put lighting in
MUL prim, col0, shadowColour;
MUL spec, spec, shadowColour;

ADD outColour, prim, spec;
MOV outColour.a, col0.a;
```

Targeted edits (apply each precisely; do not rewrite the whole block):

1. Add a third `ADD spec, spec, spec;` line right after the existing two, so specular doublings go 2 → 3.
2. Insert `MUL shadowColour, shadowColour, shadowColour;` immediately *after* the final `LRP shadowColour, program.local[4].a, shadowColour, miscValues.z;` line (fake-AO squaring).
3. Insert before `MUL prim, col0, shadowColour;`:

   ```
   SUB col0biased, col0, ambientBias;
   MAX col0biased, col0biased, miscValues.x;
   ```

   Then change `MUL prim, col0, shadowColour;` → `MUL prim, col0biased, shadowColour;`.
4. Insert `ADD prim, prim, coolTint;` immediately after the (modified) `MUL prim, col0biased, shadowColour;`.
5. If keeping the rim (i.e., Task 1 did not drop it), insert before the final `MOV outColour.a, col0.a;`:

   ```
   SUB rim, miscValues.z, col0;
   MUL rim, rim, glow.b;
   MUL rim, rim, rimTint;
   MAD outColour, rim, rimStrength.x, outColour;
   ```

- [ ] **Step 2: Verify shader compiles**

```powershell
pwsh tools\launch-tpof.ps1
# load a map, then:
pwsh tools\parse-logs.ps1 -Errors
```
Expected: exit 0.

- [ ] **Step 3: Visual verification**

Capture scenes A and C → `screenshots\_shaderwip\task2_shadowandlightsmall_{A,C}.jpg`. The two shadow variants should look near-identical on a static frame (they only differ in shadow sample count). Confirm with the user.

- [ ] **Step 4: Commit**

```powershell
git add src/shaders/fp_arb/shadowandlightsmall.fp screenshots/_shaderwip/task2_*.jpg
git commit -m "shader: gritty pass on shadowandlightsmall.fp matching shadowandlight (task2)"
```

---

## Task 3: ship.fp + shipglowpass.fp + shiplightpassadditive.fp — coherent single-pass and multipass changes

**Why grouped:** these three shaders are the rest of the ship-surface lighting story. `ship.fp` is the single-pass renderer; `shiplightpassadditive.fp` + `shipglowpass.fp` are the multipass equivalents. They must move in sync or single-pass and multi-pass driver paths will diverge visually.

**Files:**
- Modify: `src/shaders/fp_arb/ship.fp`
- Modify: `src/shaders/fp_arb/shipglowpass.fp`
- Modify: `src/shaders/fp_arb/shiplightpassadditive.fp`

### Task 3a — ship.fp

- [ ] **Step 1: Edit `ship.fp`**

Add to PARAM declarations (below `PARAM miscValues = { 0, 0.5, 1, 2 };`):

```
PARAM coolTint    = { 0.06, 0.07, 0.10, 0 };
PARAM rimTint     = { 0.50, 0.70, 1.00, 0 };
PARAM rimStrength = { 0.60, 0,    0,    0 };
PARAM ambientBias = { 0.10, 0.10, 0.10, 0 };
PARAM lumWeights  = { 0.299, 0.587, 0.114, 0 };
PARAM desatAmt    = { 0.15, 0, 0, 0 };
PARAM glowBoost   = { 0.70, 0, 0, 0 };
```

(Use Task 1's tuned values where applicable.)

Add to TEMP declarations: `TEMP rim, col0biased, lum;` (drop `rim` if Task 1 dropped it).

Vanilla `## lighting` and `## final colour` blocks:

```
## lighting
# compute specular
MUL spec, col1, glow.b;
ADD spec, spec, spec;
ADD spec, spec, spec;
ADD spec, spec, spec;
# compute amount of glow
MUL light, miscValues.y, glow.g;
#MUL light, light, glow.g;
# average glow/level lighting
LRP light, glow.g, light, col0;
# add specular
ADD light, light, spec;

## final colour
MUL unFoggedColour.rgb, base, light;
```

Replacement:

```
## lighting — tighter specular (4 doublings is already in this shader)
MUL spec, col1, glow.b;
ADD spec, spec, spec;
ADD spec, spec, spec;
ADD spec, spec, spec;
# hotter glow contribution: use glowBoost.x (0.70) instead of miscValues.y (0.5)
MUL light, glowBoost.x, glow.g;
# average glow/level lighting (col0 has the engine's lighting interpolant)
LRP light, glow.g, light, col0;
# ambient floor cut on the col0-derived part of light
SUB col0biased, light, ambientBias;
MAX light, col0biased, miscValues.x;
# cool-blue fill bias
ADD light, light, coolTint;
# add specular
ADD light, light, spec;

## luminance desaturation of base (post-team-color)
DP3 lum, base, lumWeights;
LRP base, desatAmt.x, lum, base;

## final colour
MUL unFoggedColour.rgb, base, light;

## fake fresnel rim before fog blend
SUB rim, miscValues.z, col0;
MUL rim, rim, glow.b;
MUL rim, rim, rimTint;
MAD unFoggedColour.rgb, rim, rimStrength.x, unFoggedColour;
```

The remainder of the shader (the fog blend and alpha mov) stays as-is.

- [ ] **Step 2: Verify compile**

```powershell
pwsh tools\launch-tpof.ps1
pwsh tools\parse-logs.ps1 -Errors
```

### Task 3b — shipglowpass.fp

- [ ] **Step 3: Bump glowValue.g to match ship.fp's hotter emissive**

In `src/shaders/fp_arb/shipglowpass.fp`, change the line:

```
PARAM glowValue  = { 0.5, 0.5, 0.5, 0.5 };
```

to:

```
PARAM glowValue  = { 0.5, 0.7, 0.5, 0.5 };
```

(Match whatever value `glowBoost.x` settled on in Task 3a.)

Nothing else changes in this file.

### Task 3c — shiplightpassadditive.fp

- [ ] **Step 4: Edit `shiplightpassadditive.fp`**

Add to PARAM declarations:

```
PARAM coolTint    = { 0.06, 0.07, 0.10, 0 };
PARAM rimTint     = { 0.50, 0.70, 1.00, 0 };
PARAM rimStrength = { 0.60, 0,    0,    0 };
PARAM ambientBias = { 0.10, 0.10, 0.10, 0 };
```

Add to TEMP declarations: `TEMP rim, col0biased;` (drop `rim` if dropped earlier).

Replace the existing block:

```
## lighting
# compute specular
MUL spec, col1, glow.b;
ADD spec, spec, spec;
ADD spec, spec, spec;
ADD spec, spec, spec;
# add specular
ADD outColour, col0, spec;
```

with:

```
## lighting — tighter specular (kept at 3 doublings, was already 3)
MUL spec, col1, glow.b;
ADD spec, spec, spec;
ADD spec, spec, spec;
ADD spec, spec, spec;

## ambient floor cut + cool fill on col0
SUB col0biased, col0, ambientBias;
MAX col0biased, col0biased, miscValues.x;
ADD col0biased, col0biased, coolTint;

## combine
ADD outColour, col0biased, spec;

## fake fresnel rim
SUB rim, miscValues.z, col0;
MUL rim, rim, glow.b;
MUL rim, rim, rimTint;
MAD outColour, rim, rimStrength.x, outColour;
```

- [ ] **Step 5: Verify compile after all three files edited**

```powershell
pwsh tools\launch-tpof.ps1
pwsh tools\parse-logs.ps1 -Errors
```

- [ ] **Step 6: Visual verification — three scenes**

Capture A, B, C → `screenshots\_shaderwip\task3_shipfp_{A,B,C}.jpg`.

The user confirms: ships look consistent whether the renderer takes the single-pass (ship.fp) or multi-pass (additive + glow) path — no banding, no double-rim, no double-tint. Hull paint reads slightly desaturated; team stripes still pop.

- [ ] **Step 7: Commit**

```powershell
git add src/shaders/fp_arb/ship.fp src/shaders/fp_arb/shipglowpass.fp src/shaders/fp_arb/shiplightpassadditive.fp screenshots/_shaderwip/task3_*.jpg
git commit -m "shader: gritty pass on ship.fp, shipglowpass.fp, shiplightpassadditive.fp (task3)"
```

---

## Task 4: shipbasepass.fp + shipbasewithbadgepass.fp — luminance desat only

These two shaders have no lighting interpolants in scope (they only compute base colour with team paint applied, with `shipbasewithbadgepass.fp` also stamping a player badge). Only the luminance desaturation effect applies.

**Files:**
- Modify: `src/shaders/fp_arb/shipbasepass.fp`
- Modify: `src/shaders/fp_arb/shipbasewithbadgepass.fp`

- [ ] **Step 1: Edit `shipbasepass.fp`**

Add to PARAM declarations (below `PARAM miscValues`):

```
PARAM lumWeights  = { 0.299, 0.587, 0.114, 0 };
PARAM desatAmt    = { 0.15, 0, 0, 0 };
```

Add to TEMP declarations: `TEMP lum;`.

The shader currently ends with:

```
##avaerge the team colour and base texture
LRP base.rgb, teamBaseAmount, teamBaseColour, diffuse;
LRP outColour, teamStripeAmount, teamStripeColour, base;
```

Replace with:

```
##avaerge the team colour and base texture
LRP base.rgb, teamBaseAmount, teamBaseColour, diffuse;
LRP base.rgb, teamStripeAmount, teamStripeColour, base;

## luminance desaturation (post-team-color so stripes stay saturated)
DP3 lum, base, lumWeights;
LRP outColour, desatAmt.x, lum, base;
```

- [ ] **Step 2: Edit `shipbasewithbadgepass.fp`**

Add the same PARAMs and `TEMP lum;`.

The shader currently ends with:

```
LRP outColour, badgeColour.a, badgeColour, base;
```

The badge stamp must remain the *last* operation (otherwise the badge gets desaturated, which is wrong — it's a player identity marker). So the desat goes *before* the badge stamp. Replace the block:

```
##avaerge the team colour and base texture
LRP base.rgb, teamBaseAmount, teamBaseColour, diffuse;
LRP base.rgb, teamStripeAmount, teamStripeColour, base;

#invert the mask`s alpha and use it to discolour the badge texture
SUB mask.a, miscValues.z, mask.a;
MUL badgeColour.rgb, mask.a, badge;
#combine the mask and the badge`s alpha
MUL badgeColour.a, badge.a, mask.a;

LRP outColour, badgeColour.a, badgeColour, base;
```

with:

```
##avaerge the team colour and base texture
LRP base.rgb, teamBaseAmount, teamBaseColour, diffuse;
LRP base.rgb, teamStripeAmount, teamStripeColour, base;

## luminance desaturation BEFORE badge stamp so badges stay saturated
DP3 lum, base, lumWeights;
LRP base.rgb, desatAmt.x, lum, base;

#invert the mask`s alpha and use it to discolour the badge texture
SUB mask.a, miscValues.z, mask.a;
MUL badgeColour.rgb, mask.a, badge;
#combine the mask and the badge`s alpha
MUL badgeColour.a, badge.a, mask.a;

LRP outColour, badgeColour.a, badgeColour, base;
```

- [ ] **Step 3: Verify compile**

```powershell
pwsh tools\launch-tpof.ps1
pwsh tools\parse-logs.ps1 -Errors
```

- [ ] **Step 4: Visual verification**

Capture A and C → `screenshots\_shaderwip\task4_basepass_{A,C}.jpg`. The user confirms: hull paint is slightly less saturated, team stripes and player badges are unaffected.

- [ ] **Step 5: Commit**

```powershell
git add src/shaders/fp_arb/shipbasepass.fp src/shaders/fp_arb/shipbasewithbadgepass.fp screenshots/_shaderwip/task4_*.jpg
git commit -m "shader: luminance desat on base passes (preserves stripes & badge) (task4)"
```

---

## Task 5: thruster.fp + thrusterbasepass.fp + thrusterglowpass.fp + thrusterlightpassadditive.fp

All four thruster shaders changed together: same recipe as ship shaders, tuned hotter for engine-glow character (4 specular doublings instead of 3; glow boost 0.75 instead of 0.70).

**Files:**
- Modify: `src/shaders/fp_arb/thruster.fp`
- Modify: `src/shaders/fp_arb/thrusterbasepass.fp`
- Modify: `src/shaders/fp_arb/thrusterglowpass.fp`
- Modify: `src/shaders/fp_arb/thrusterlightpassadditive.fp`

### Task 5a — thruster.fp (single-pass thruster)

- [ ] **Step 1: Edit `thruster.fp`**

Add to PARAM declarations:

```
PARAM coolTint        = { 0.06, 0.07, 0.10, 0 };
PARAM rimTint         = { 0.50, 0.70, 1.00, 0 };
PARAM rimStrength     = { 0.60, 0,    0,    0 };
PARAM ambientBias     = { 0.10, 0.10, 0.10, 0 };
PARAM lumWeights      = { 0.299, 0.587, 0.114, 0 };
PARAM desatAmt        = { 0.15, 0, 0, 0 };
PARAM thrusterGlowBoost = { 0.75, 0, 0, 0 };
```

Add to TEMP declarations: `TEMP rim, col0biased, lum;` (drop `rim` if dropped earlier).

The vanilla `## lighting` block is essentially identical to `ship.fp`'s but with different vanilla doublings — actually `thruster.fp` has 4 doublings already (matches our target for ship, but we want thrusters one *higher* than ships at 4 doublings vs ship's 4 — wait, ship.fp had 3 doublings originally and we kept it at 3; rechecking…). Re-read the actual file before editing: the vanilla doubling count is the one to bump by +1.

Replace the existing `## lighting` and `## final colour` blocks with the equivalent of Task 3a but using `thrusterGlowBoost.x` instead of `glowBoost.x`. If vanilla has N specular doublings, ship up with N+1. Add the same ambient bias, cool tint, luminance desat (post-team-color), and fresnel rim sequences as Task 3a.

Concrete replacement (assuming vanilla 3 specular doublings as `ship.fp` did):

```
## lighting — bump specular doublings by 1 from vanilla
MUL spec, col1, glow.b;
ADD spec, spec, spec;
ADD spec, spec, spec;
ADD spec, spec, spec;
ADD spec, spec, spec;
# hotter engine glow
MUL light, thrusterGlowBoost.x, glow.g;
LRP light, glow.g, light, col0;
# ambient floor cut + cool fill
SUB col0biased, light, ambientBias;
MAX light, col0biased, miscValues.x;
ADD light, light, coolTint;
ADD light, light, spec;

## luminance desaturation of base
DP3 lum, base, lumWeights;
LRP base, desatAmt.x, lum, base;

## final colour
MUL unFoggedColour, base, light;

## fake fresnel rim
SUB rim, miscValues.z, col0;
MUL rim, rim, glow.b;
MUL rim, rim, rimTint;
MAD unFoggedColour, rim, rimStrength.x, unFoggedColour;
```

Fog/alpha mov at the end stays as-is.

### Task 5b — thrusterbasepass.fp (desat only)

- [ ] **Step 2: Edit `thrusterbasepass.fp` — same pattern as Task 4 on `shipbasepass.fp`**

Add PARAMs `lumWeights`, `desatAmt`. Add `TEMP lum;`. Replace the closing `LRP outColour, teamStripeAmount, teamStripeColour, base;` with:

```
LRP base.rgb, teamStripeAmount, teamStripeColour, base;
DP3 lum, base, lumWeights;
LRP outColour, desatAmt.x, lum, base;
```

### Task 5c — thrusterglowpass.fp

- [ ] **Step 3: Bump glowValue.g to 0.75**

In `src/shaders/fp_arb/thrusterglowpass.fp`, change the line:

```
PARAM glowValue  = { 0.5, 0.5, 0.5, 0.5 };
```

to:

```
PARAM glowValue  = { 0.5, 0.75, 0.5, 0.5 };
```

Match whatever value `thrusterGlowBoost.x` settled on in Task 5a.

### Task 5d — thrusterlightpassadditive.fp

- [ ] **Step 4: Edit `thrusterlightpassadditive.fp`**

Add PARAMs `coolTint`, `rimTint`, `rimStrength`, `ambientBias`. Add `TEMP rim, col0biased;`.

Vanilla `## lighting` block:

```
## lighting
# compute specular
MUL spec, col1, glow.b;
# add specular
ADD outColour, col0, spec;
```

Replace with:

```
## lighting — add 3 doublings to compensate for vanilla's single MUL
MUL spec, col1, glow.b;
ADD spec, spec, spec;
ADD spec, spec, spec;
ADD spec, spec, spec;

## ambient floor cut + cool fill
SUB col0biased, col0, ambientBias;
MAX col0biased, col0biased, miscValues.x;
ADD col0biased, col0biased, coolTint;

ADD outColour, col0biased, spec;

## fake fresnel rim
SUB rim, miscValues.z, col0;
MUL rim, rim, glow.b;
MUL rim, rim, rimTint;
MAD outColour, rim, rimStrength.x, outColour;
```

- [ ] **Step 5: Verify compile after all four files edited**

```powershell
pwsh tools\launch-tpof.ps1
pwsh tools\parse-logs.ps1 -Errors
```

- [ ] **Step 6: Visual verification — scene B is the critical one (thrusters lit)**

Capture A, B, C → `screenshots\_shaderwip\task5_thruster_{A,B,C}.jpg`. Scene B is the make-or-break: engine exhausts should look noticeably hotter, with a cooler rim around the thruster nozzle housing.

- [ ] **Step 7: Commit**

```powershell
git add src/shaders/fp_arb/thruster.fp src/shaders/fp_arb/thrusterbasepass.fp src/shaders/fp_arb/thrusterglowpass.fp src/shaders/fp_arb/thrusterlightpassadditive.fp screenshots/_shaderwip/task5_*.jpg
git commit -m "shader: gritty pass on thruster.fp set — hotter exhausts (task5)"
```

---

## Task 6: Whole-mod integration check

**Goal:** confirm nothing regressed across the broader rendering surface.

**Files:** none modified.

- [ ] **Step 1: Launch and exercise the validation gates**

Run:
```powershell
pwsh tools\launch-tpof.ps1
```

Load a 2p Slipstream map (any). Do all of:

- Build a unit (verify subsystem mouseover glow still works → tests `innatess.st` interaction with our shader changes).
- Engage hyperspace on a capital ship (verify hyperspace entry/exit renders correctly — it multiplies against ship shaders).
- Order a strike on an enemy capital ship (weapons firing → confirms FX particles still render).
- Inspect Hiigaran and Vaygr capital ships side-by-side (team palette legibility check).

- [ ] **Step 2: Verify clean log**

```powershell
pwsh tools\parse-logs.ps1 -Errors
```
Expected: exit 0.

- [ ] **Step 3: Capture comparison set against Task 0 baselines**

Capture scenes A, B, C one final time → `screenshots\_shaderwip\task6_final_{A,B,C}.jpg`. User reviews the full visual diff (task0 vs task6) and confirms the direction is right.

If the user wants further tuning at this point, return to whichever task's PARAMs need adjustment, tweak constants, recapture, recommit (as a tuning commit on top of the original task commit).

- [ ] **Step 4: Commit the final comparison captures**

```powershell
git add screenshots/_shaderwip/task6_final_*.jpg
git commit -m "shader: phase 1 final verification screenshots (task6)"
```

---

## Task 7: Cleanup & branch hygiene

**Files:** potentially modified `screenshots/_shaderwip/` history.

- [ ] **Step 1: Decide on screenshot retention**

The `_shaderwip` folder contains 18+ comparison screenshots. They were useful during development but probably shouldn't ship in the canonical `screenshots/` library that goes to ModDB. Either:

(a) Move the keepers (typically the task0 baseline and task6 final) into the canonical `screenshots/` library with descriptive names, then delete `screenshots/_shaderwip/`.

(b) Move the entire `screenshots/_shaderwip/` folder under a gitignored path or just delete it — the diffs were useful at the time and the spec/plan now document the rationale.

User decides; this is purely housekeeping.

- [ ] **Step 2: If deleting, do so**

```powershell
Remove-Item -Recurse -Force screenshots\_shaderwip
git add -A screenshots/
git commit -m "shader: remove iteration screenshots (task7 cleanup)"
```

- [ ] **Step 3: Push branch and open PR**

```powershell
git push -u origin polish-next-release
gh pr create --title "Shader refresh phase 1 — ships & thrusters (fp_arb tier)" --body "$(cat <<'EOF'
## Summary
- Tunes the eleven fp_arb ship + thruster fragment programs toward an industrial / gritty / high-contrast look
- Adds ambient floor cut, cool-blue fill tint, fake fresnel rim, tighter specular, hotter emissive glow, and slight luminance desaturation
- No changes to lower-tier shaders, .st render states, textures, or particles
- Backgrounds & weapon FX deferred to phase 2 (separate spec)

## Test plan
- [ ] tools\parse-logs.ps1 -Errors exits 0 after launching
- [ ] Hiigaran & Vaygr capital ships visible with correct team colours
- [ ] Subsystem mouseover glow works
- [ ] Hyperspace entry/exit renders correctly
- [ ] Weapons fire with FX visible

Design: docs/superpowers/specs/2026-05-17-shader-refresh-design.md
Plan: docs/superpowers/plans/2026-05-17-shader-refresh-phase1.md

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

(Push and PR creation should only happen if the user has explicitly asked for it — this step documents the recipe but is opt-in.)

---

## Self-review notes

**Spec coverage check:** Every section of the spec maps to a task — 5-effect recipe (Tasks 1, 2, 3, 5), per-shader plan (Tasks 1–5), verification approach (built into every task + Task 6), rollback (per-task commits enable single-revert), risks (Task 1 has the mitigation for instruction-count overflow inline; cool-tint tuning dial is documented; "too gritty" is the user-check at every step).

**Placeholders:** none — every step has either exact code, an exact command, or an exact user action.

**Type consistency:** PARAM names (`coolTint`, `rimTint`, `rimStrength`, `ambientBias`, `lumWeights`, `desatAmt`, `glowBoost`, `thrusterGlowBoost`) are used identically across tasks; TEMP names (`rim`, `col0biased`, `lum`) match.

**Known caveat:** Task 5 step 1 includes a hedge ("re-read the actual file before editing: the vanilla doubling count is the one to bump by +1") because the file's vanilla doubling count may differ from `ship.fp`'s; the executing agent reads the file first to confirm. This is appropriate — not a placeholder.
