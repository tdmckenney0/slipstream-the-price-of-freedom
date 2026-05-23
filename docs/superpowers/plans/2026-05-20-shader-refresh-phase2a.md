# Shader Refresh Phase 2A (Megaliths, fp_arb tier) — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Apply the Phase 1 v2 gritty/industrial recipe to the two megalith fp_arb fragment programs, pushed further toward "ancient/weathered derelict" — stronger desat, deeper shadows, dampened glow, dampened additive overlay.

**Architecture:** Same five-effect recipe as Phase 1 (ambient floor cut, cool-blue fill tint, fake fresnel rim via TEMP, luminance desat, glow-boost tweak) transposed onto vanilla `megalith.fp` (which is structurally identical to vanilla `ship.fp`), plus a single-instruction dampener on `megalithglowpass.fp`. No new files, no `.st` changes, no texture work.

**Tech Stack:** ARB_fragment_program 1.0 (`!!ARBfp1.0`), HW2 Classic engine, PowerShell 7+ tooling (`tools\launch-tpof.ps1`, `tools\link-src.ps1`, `tools\parse-logs.ps1`).

---

## Pre-flight context (read once before starting)

**What's different from Phase 1:** the recipe is the same shape but the **constants are pushed further** for the "dead derelict" look (see spec for full diff table). Two files only. Both already-existing — no new files in this phase.

**Critical FP1.0 constraint (Phase 1 lesson — commit `8a964b4`):** `outColour` is **write-only** in ARB_fragment_program 1.0. Using it as a source operand (e.g. `MAD outColour, rim, rimStrength.x, outColour;`) causes the program to fail to link at runtime with "Could not load !!ARBfp1.0 / invalid source register type." The rim block in this plan routes the accumulator through the existing `unFoggedColour` TEMP, then the existing fog `LRP` writes `outColour`. Do not deviate from this pattern.

**Iteration mechanics (same as Phase 1):** `tools\link-src.ps1` exposes `src/` as `<HW2>\DataTPOF` so `.fp` edits are picked up on the next launch — no `.big` repack needed. `tools\launch-tpof.ps1` runs the game with the live link.

**ARB FP1.0 cheat sheet** (same ops used as Phase 1):

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

**Constants block (verbatim into `megalith.fp`):**

```
PARAM coolTint     = { 0.020, 0.025, 0.035, 0 };   # ~1.3× Phase 1 (was 0.015/0.018/0.025)
PARAM rimTint      = { 0.50, 0.70, 1.00, 0 };      # cool rim, same as Phase 1
PARAM rimStrength  = { 0.18, 0,    0,    0 };      # slightly stronger silhouette (was 0.15)
PARAM ambientBias  = { 0.12, 0.12, 0.12, 0 };      # deeper shadow pockets (was 0.10)
PARAM lumWeights   = { 0.299, 0.587, 0.114, 0 };   # ITU-R BT.601 luminance, same
PARAM desatAmt     = { 0.25, 0, 0, 0 };            # stronger chroma loss (was 0.15)
PARAM megGlowBoost = { 0.40, 0, 0, 0 };            # less hot (Phase 1 ship was 0.55)
```

**Reference scenes** (maps with megaliths visible):

- **A — Bentusi ruin close-up:** any map that places a `meg_bentus_ruins_core_*` object near a starting position. Frame so the ruin fills the right half of the screen with deep space behind it (silhouettes the rim).
- **B — Slipgate structure:** any Slipstream map where the gate is visible without active gate FX (gate inactive). The gate structure uses `megalith.fp`; the gate effect itself is rendered separately and is 2C scope.
- **C — Mixed scene:** a megalith next to a player ship for direct comparison — verifies megaliths now read distinctly more weathered than fresh hulls.

Save iteration captures to `screenshots\_shaderwip\<task>_<scene>.jpg`.

**Commit cadence:** one commit per task. Branch is `shader-refresh` (already current). Commit message pattern: `shader: <what changed> (phase 2a task<n>)`.

---

## File structure

No new files. Two existing fragment programs are edited in place:

| File | Purpose | Task |
|---|---|---|
| `src/shaders/fp_arb/megalith.fp` | Single-pass megalith renderer (analog of `ship.fp`) | Task 1 |
| `src/shaders/fp_arb/megalithglowpass.fp` | Megalith additive glow overlay | Task 2 |

---

## Task 0: Baseline capture & iteration loop sanity check

**Files:** none modified.

- [ ] **Step 1: Confirm the live-link is set up so iteration doesn't require a `.big` repack**

Run:
```powershell
pwsh tools\link-src.ps1
```
Expected: prints "linked" or "already linked" pointing `<HW2>\DataTPOF` at this repo's `src/`. If it errors with "HW2 install not found," set `$env:HW2_ROOT` to the install path and retry.

- [ ] **Step 2: Launch the game on a clean tree to confirm the iteration loop works end-to-end**

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

Launch HW2 again, load a Slipstream map that places at least one megalith and one player ship in view. Fly the camera to scenes A, B, C from the pre-flight context and capture three screenshots.

Save to:
```
screenshots\_shaderwip\phase2a_task0_baseline_A.jpg
screenshots\_shaderwip\phase2a_task0_baseline_B.jpg
screenshots\_shaderwip\phase2a_task0_baseline_C.jpg
```

These are the "before" shots that Task 1 and Task 2 compare against.

- [ ] **Step 5: Commit baselines so they're recoverable**

```powershell
git add screenshots/_shaderwip/phase2a_task0_baseline_*.jpg
git commit -m "shader: capture phase 2a baseline screenshots (phase 2a task0)"
```

---

## Task 1: megalith.fp — full v2 recipe with weathered constants

**Files:**
- Modify: `src/shaders/fp_arb/megalith.fp`

**Vanilla file structure for reference** (read the file first to confirm it hasn't drifted from this — these are the lines you'll be editing):

```
!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

ATTRIB tex = fragment.texcoord[0];
ATTRIB col0 = fragment.color.primary;
ATTRIB col1 = fragment.color.secondary;
PARAM miscValues  = { 0, 0.5, 1, 2 };

OUTPUT outColour = result.color;

TEMP diffuse, glow, base, teamBaseColour, teamStripeColour;
TEMP teamBaseAmount, teamStripeAmount, light, spec;
TEMP unFoggedColour, fogColour;
...
## lighting
# compute specular
MUL spec, col1, glow.b;
### compute amount of glow
##MUL light, miscValues.y, glow.g;
##don't divide by 2 like the ship shader
# average glow/level lighting
LRP light, glow.g, glow.g, col0;
# add specular
ADD light, light, spec;

## final colour
MUL unFoggedColour, base, light;

## fog
MOV fogColour, program.local[2];
MUL fogColour.a, fogColour, col0;
LRP outColour, fogColour.a, fogColour, unFoggedColour;

##fade away as needed
MOV outColour.a, col0;

END
```

- [ ] **Step 1: Read the file to confirm structure**

Open `src/shaders/fp_arb/megalith.fp` and verify it matches the structure above (the `## lighting`, `## final colour`, `## fog` blocks specifically). If anything has drifted, adapt step numbers below to the actual file.

- [ ] **Step 2: Add the new PARAM block**

Find the existing line:
```
PARAM miscValues  = { 0, 0.5, 1, 2 };
```

*Add* the following block immediately after it (do not remove the `miscValues` line — it is still referenced elsewhere):

```
# TPOF shader refresh (phase 2a): weathered/derelict variant of Phase 1 v2 recipe
PARAM coolTint     = { 0.020, 0.025, 0.035, 0 };
PARAM rimTint      = { 0.50, 0.70, 1.00, 0 };
PARAM rimStrength  = { 0.18, 0,    0,    0 };
PARAM ambientBias  = { 0.12, 0.12, 0.12, 0 };
PARAM lumWeights   = { 0.299, 0.587, 0.114, 0 };
PARAM desatAmt     = { 0.25, 0, 0, 0 };
PARAM megGlowBoost = { 0.40, 0, 0, 0 };
```

- [ ] **Step 3: Add new TEMP declarations**

Find the existing TEMP block (three lines ending with `TEMP unFoggedColour, fogColour;`). *Add* a new line immediately below the last existing TEMP line:

```
TEMP rim, col0biased, lum;
```

- [ ] **Step 4: Replace the glow-LRP with the boosted variant**

Find the line:
```
LRP light, glow.g, glow.g, col0;
```

Replace it with **two** lines that introduce the `megGlowBoost` scalar:

```
MUL light, megGlowBoost.x, glow.g;
LRP light, glow.g, light, col0;
```

The second LRP's second argument changes from `glow.g` (vanilla) to `light` (now containing `megGlowBoost * glow.g`). The first and third arguments are unchanged.

- [ ] **Step 5: Insert ambient floor cut + cool fill**

After the LRP line you just modified, and *before* the existing line `ADD light, light, spec;`, insert:

```
# ambient floor cut + cool fill on the col0-derived part of light
SUB col0biased, light, ambientBias;
MAX light, col0biased, miscValues.x;
ADD light, light, coolTint;
```

The block now reads:
```
MUL light, megGlowBoost.x, glow.g;
LRP light, glow.g, light, col0;
SUB col0biased, light, ambientBias;
MAX light, col0biased, miscValues.x;
ADD light, light, coolTint;
# add specular
ADD light, light, spec;
```

- [ ] **Step 6: Insert luminance desaturation on base**

Find the two team-color lines:
```
LRP base.rgb, teamBaseAmount, teamBaseColour, diffuse;
LRP base.rgb, teamStripeAmount, teamStripeColour, base;
```

After the second LRP and *before* the `## lighting` comment, insert:

```
## luminance desaturation of base (post-team-color so stripes stay saturated)
DP3 lum, base, lumWeights;
LRP base, desatAmt.x, lum, base;
```

- [ ] **Step 7: Insert fake fresnel rim before fog blend**

Find the line:
```
MUL unFoggedColour, base, light;
```

After it, and *before* the `## fog` comment line, insert:

```
## fake fresnel rim — (1 - col0) modulated by glow.b, cool tint
## NOTE: writes to unFoggedColour TEMP, not outColour (FP1.0 OUTPUT-read crash avoidance)
SUB rim, miscValues.z, col0;
MUL rim, rim, glow.b;
MUL rim, rim, rimTint;
MAD unFoggedColour, rim, rimStrength.x, unFoggedColour;
```

- [ ] **Step 8: Verify shader compiles**

Run:
```powershell
pwsh tools\launch-tpof.ps1
```

Let the main menu appear, then load any Slipstream map with at least one megalith visible.

Then in another shell (or after quitting):
```powershell
pwsh tools\parse-logs.ps1 -Errors
```

Expected: exit code 0. If non-zero with an ARB fragment program compile error mentioning "invalid source register type," the rim accumulator likely reads `outColour` — re-check Step 7. If the error mentions "exceeded instruction count," the file has more instructions than expected and we need to drop the rim block (Step 7 lines) and re-test.

- [ ] **Step 9: Visual verification — capture and compare**

Capture scenes A, B, C with the live changes:

```
screenshots\_shaderwip\phase2a_task1_megalith_A.jpg
screenshots\_shaderwip\phase2a_task1_megalith_B.jpg
screenshots\_shaderwip\phase2a_task1_megalith_C.jpg
```

Open both alongside the Task 0 baselines. The user confirms: megaliths now read distinctly cooler, less saturated, with deeper shadow pockets and a faint cool rim along silhouettes. The slipgate structure reads dimmer.

If the user judges the look wrong, tune the relevant PARAM constant and re-run Steps 8 + 9. Common tuning dials:

| Symptom | Adjust |
|---|---|
| Too dark / too crushed | Reduce `ambientBias` from 0.12 → 0.08 |
| Too gray (lost all chroma) | Reduce `desatAmt` from 0.25 → 0.20 |
| Too cool (smurfy) | Reduce `coolTint` to `{ 0.012, 0.015, 0.020, 0 }` |
| Rim too strong | Reduce `rimStrength` from 0.18 → 0.12 |
| Spec still pops too much | Add `MUL spec, spec, 0.85;` right after `MUL spec, col1, glow.b;` (documented as optional v2 dial-down in spec) |
| Bentusi ruins look broken / invisible | Reduce `desatAmt` to 0.15 (matches Phase 1 ship value — they were already low-saturation) |

- [ ] **Step 10: Commit**

```powershell
git add src/shaders/fp_arb/megalith.fp screenshots/_shaderwip/phase2a_task1_*.jpg
git commit -m "shader: gritty/weathered pass on megalith.fp (phase 2a task1)"
```

---

## Task 2: megalithglowpass.fp — dampen additive overlay by 15%

**Files:**
- Modify: `src/shaders/fp_arb/megalithglowpass.fp`

**Vanilla file** (very short, full content):

```
!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

ATTRIB tex = fragment.texcoord[0];

OUTPUT outColour = result.color;

TEMP glow;

TEX glow, tex, texture[0], 2D;

MOV outColour, glow.g;

END
```

- [ ] **Step 1: Read the file to confirm structure**

Open `src/shaders/fp_arb/megalithglowpass.fp` and verify it matches the structure above.

- [ ] **Step 2: Add the glowDampen PARAM**

After the existing `ATTRIB tex = fragment.texcoord[0];` line and before the `OUTPUT outColour = result.color;` line, insert:

```
# TPOF shader refresh (phase 2a): dampen additive overlay to match weathered megalith.fp
PARAM glowDampen = { 0.85, 0, 0, 0 };
```

- [ ] **Step 3: Replace the MOV with a MUL**

Change the line:
```
MOV outColour, glow.g;
```

To:
```
MUL outColour, glow.g, glowDampen.x;
```

This preserves the green-channel-splat semantics (a scalar broadcast to all four output channels) but attenuates by 15%.

- [ ] **Step 4: Verify shader compiles**

```powershell
pwsh tools\launch-tpof.ps1
# load a map with a megalith, then:
pwsh tools\parse-logs.ps1 -Errors
```

Expected: exit 0.

- [ ] **Step 5: Visual verification**

Capture scenes A and B → `screenshots\_shaderwip\phase2a_task2_glowpass_{A,B}.jpg`. Compared to Task 1, megaliths' additive glow overlay (visible on emissive-marked panels, lit windows, etc.) should read slightly dimmer. Confirm with the user. If the user wants more dampening, drop `glowDampen.x` from 0.85 → 0.70 and recapture.

- [ ] **Step 6: Commit**

```powershell
git add src/shaders/fp_arb/megalithglowpass.fp screenshots/_shaderwip/phase2a_task2_*.jpg
git commit -m "shader: dampen megalithglowpass.fp additive overlay (phase 2a task2)"
```

---

## Task 3: Integration check & final comparison

**Goal:** confirm Phase 2A coheres with the existing Phase 1 ship look and nothing regressed in the broader rendering surface.

**Files:** none modified.

- [ ] **Step 1: Launch and exercise the validation gates**

Run:
```powershell
pwsh tools\launch-tpof.ps1
```

Load a 2p Slipstream map that has megaliths. Do all of:

- Inspect a megalith next to a player ship (verifies the megalith reads distinctly more weathered than the ship, not just "broken").
- Engage hyperspace next to a megalith (verifies hyperspace interaction with the new megalith shader has not regressed).
- Capture screenshots framing both a Bentusi ruin and a slipgate structure.

- [ ] **Step 2: Verify clean log**

```powershell
pwsh tools\parse-logs.ps1 -Errors
```
Expected: exit 0.

- [ ] **Step 3: Capture final comparison set against Task 0 baselines**

Capture scenes A, B, C one final time → `screenshots\_shaderwip\phase2a_task3_final_{A,B,C}.jpg`. The user reviews the full visual diff (phase2a_task0 vs phase2a_task3) and confirms the direction is right.

If the user wants further tuning at this point, return to whichever task's PARAMs need adjustment, tweak constants, recapture, recommit (as a tuning commit on top of the original task commit, mirroring the Phase 1 v2 tune-down pattern at commit `bb11810`).

- [ ] **Step 4: Commit the final comparison captures**

```powershell
git add screenshots/_shaderwip/phase2a_task3_final_*.jpg
git commit -m "shader: phase 2a final verification screenshots (phase 2a task3)"
```

---

## Self-review notes

**Spec coverage check:** Every section of the Phase 2A spec maps to a task — constants table (Task 1 Step 2), megalith.fp recipe steps 1–6 (Task 1 Steps 3–7), megalithglowpass.fp recipe (Task 2 Steps 2–3), verification approach (built into Tasks 1, 2, 3), tuning dials for `desatAmt` / `ambientBias` / `coolTint` / `rimStrength` / spec dial-down (Task 1 Step 9 tuning table), OUTPUT-read FP1.0 trap (Task 1 Step 7 + Step 8 error-recovery note).

**Placeholders:** none — every step has either exact code, an exact command, or an exact user action.

**Type consistency:** PARAM names (`coolTint`, `rimTint`, `rimStrength`, `ambientBias`, `lumWeights`, `desatAmt`, `megGlowBoost`, `glowDampen`) are used identically across tasks and match the spec. TEMP names (`rim`, `col0biased`, `lum`) match Phase 1 conventions. `megGlowBoost` (not `glowBoost`) avoids name collision if anyone later writes a multi-shader header.

**Branch:** all commits on `shader-refresh`. No PR step in this plan — the user said earlier "Leave it on the branch" for Phase 1; same disposition by default for Phase 2A.
