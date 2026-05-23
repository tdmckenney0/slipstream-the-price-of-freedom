# Shader Refresh Phase 2B (Backgrounds & Space FX, render-state tier) — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Cut the wet/shiny highlight on nebula geometry so backgrounds read as gritty deep space rather than glossy painted-on plates.

**Architecture:** A single render-state `.st` file changes — `nebula.st`'s `material specular` and `material shininess` are tuned down. No fragment program changes, no texture changes, no `.lua` background script changes.

**Tech Stack:** HW2 Classic engine `.st` fixed-function render-state DSL, PowerShell 7+ tooling (`tools\launch-tpof.ps1`, `tools\link-src.ps1`, `tools\parse-logs.ps1`).

---

## Honest scope statement (read this before doubting the plan's length)

Phase 2B was originally framed as "backgrounds & space FX." A 30-minute reconnaissance pass over the HW2 render-state surface area revealed that:

1. **`background.st` (skybox)** is a trivial texture-modulate pipeline with no tunable lighting. Skybox character is 100% baked into the `.tga` texture content, not the shader.
2. **`dustcloud.st`, `dustcloudnebula.st`, `mattealpha.st`, `mattealphafullbright.st`, `matte.st`, `matteadditivelight.st`, `mattealphalight.st`, `mattealphaadditivelight.st`** — all already have `material specular 0 0 0 0`. There is no shiny gloss to remove.
3. **`asteroid.st` / `asteroidtest.st`** are empty `simple { }` blocks — the engine renders asteroids via a built-in path. No shader-tier lever.
4. **`nebula.st`** is the lone outlier with `material specular 1 1 0.4 1` and `shininess 97` — a yellow-tinted wet highlight that gives nebulae a glossy painted-on look. **This is the one render-state change in 2B's scope.**

The dominant lever for "grittier backgrounds" is the actual `.tga` content in `src/background/` (post-processing toward darker / desaturated / higher-contrast). That is **image-editing work, not shader work**, and is deferred to a future Phase 2D ("background texture pass"). 2B does what shader files can do; 2D, if pursued, does what only texture editing can do.

If after running 2B the visual impact feels too small, that confirms the above and the conversation should pivot to 2D or to Phase 2C (FX scripts).

---

## File structure

One file modified:

| File | Purpose | Task |
|---|---|---|
| `src/shaders/nebula.st` | Material setup for nebula HOD models (specular highlight on backlit nebula geometry) | Task 1 |

---

## Pre-flight context (read once before starting)

**Iteration mechanics:** same as Phase 1 / 2A. `tools\link-src.ps1` exposes `src/` as `<HW2>\DataTPOF`. `.st` file edits are picked up on the next launch — **no `.big` repack needed**.

**Reference scenes:** the change is only visible on maps that use nebula backgrounds. From `src/background/`, the nebula-heavy backgrounds are:

- `tpof_nebula` — primary test target. Find a Slipstream map that uses this background.
- `tpof_supernova` — has nebulous halos around the supernova; secondary test target.
- `hwc_kadiir_nebula` — Cataclysm-era nebula; if any TPOF map uses it.

Save iteration captures to `screenshots\_shaderwip\phase2b_<task>_<scene>.jpg`. Iteration scenes:

- **A — Nebula filling most of screen:** wide camera, no ships in frame. Tests the bare nebula look.
- **B — Ship vs nebula backdrop:** medium camera, capital ship in foreground against the nebula. Tests whether the nebula sits properly behind ships now that the specular is dialed down.

**`.st` DSL reference** (the only directives this plan touches):

| Directive | Meaning |
|---|---|
| `material specular  r g b a` | Phong specular reflection colour (per channel) |
| `material shininess s s s s` | Specular exponent (higher = tighter highlight). HW2 broadcasts the same value to all four slots. |

**Commit cadence:** one commit. Branch is `shader-refresh` (already current).

---

## Task 0: Baseline capture & iteration loop sanity check

**Files:** none modified.

- [ ] **Step 1: Confirm the live-link is set up**

```powershell
pwsh tools\link-src.ps1
```
Expected: prints "linked" or "already linked".

- [ ] **Step 2: Verify no pre-existing shader/Lua errors**

```powershell
pwsh tools\parse-logs.ps1 -Errors
```
Expected: exits 0.

- [ ] **Step 3: Capture baseline reference screenshots**

Launch HW2 with `pwsh tools\launch-tpof.ps1` and load a Slipstream map that uses a nebula background (most likely `tpof_nebula` — pick from `src/leveldata/multiplayer/slipstream/` whichever map references it via its background-set call). Fly the camera to scenes A and B from the pre-flight context and capture two screenshots.

Save to:
```
screenshots\_shaderwip\phase2b_task0_baseline_A.jpg
screenshots\_shaderwip\phase2b_task0_baseline_B.jpg
```

These are the "before" shots that Task 1 compares against.

- [ ] **Step 4: Commit baselines so they're recoverable**

```powershell
git add screenshots/_shaderwip/phase2b_task0_baseline_*.jpg
git commit -m "shader: capture phase 2b baseline screenshots (phase 2b task0)"
```

---

## Task 1: nebula.st — cut specular and soften the highlight

**Files:**
- Modify: `src/shaders/nebula.st`

**Vanilla file** (full content for reference):

```
static Texture $diffuse

simple defaultPass(Texture $diffuse)
{
    setCap depthBufferCap true
    setCap gouraudCap true
    setCap cullCap false
    setCap texture0Cap true    
    setCap blendCap true
    setCap rescaleNormalCap true
-- setCap fogCap true    
    depthWrite false
    
	
	srcBlend oneBlend
    destBlend oneBlend

    material specular  1 1 0.4 1
    material shininess 97 97 97 97

    textureMode	modulateMode
    
    activeTexture 0
    texture $diffuse     
}

compound nebula()
{
    addPass defaultPass
}
```

The line of interest is:
```
    material specular  1 1 0.4 1
    material shininess 97 97 97 97
```

`specular  1 1 0.4 1` is a near-yellow at full intensity — it's what gives nebulae a wet/painted highlight when they catch the global light direction. `shininess 97` is a sharp Phong exponent — concentrated hot spot. Together they produce the glossy look.

For "gritty deep space" we want:
- Less intense highlight (drop magnitude from 1.0 toward ~0.35).
- Slight cool shift (drop yellow from 0.4 to ~0.25 on blue channel, lift blue slightly to ~0.4) — matches Phase 1 / 2A's cool-fill aesthetic.
- Softer exponent (drop shininess from 97 to ~40) — broader, dimmer highlight so the eye reads "diffuse cloud" rather than "polished surface."

- [ ] **Step 1: Read `src/shaders/nebula.st` to confirm structure**

Open the file and verify the two lines of interest match the vanilla content above.

- [ ] **Step 2: Replace the material specular line**

Find the line:
```
    material specular  1 1 0.4 1
```

Replace with:
```
    # TPOF shader refresh (phase 2b): cooler, dimmer specular for gritty deep-space nebulae
    material specular  0.35 0.35 0.40 1
```

The triple `0.35 0.35 0.40` is a near-neutral with a faint cool lean (blue slightly higher than red/green). Alpha stays at 1.

- [ ] **Step 3: Replace the material shininess line**

Find the line:
```
    material shininess 97 97 97 97
```

Replace with:
```
    material shininess 40 40 40 40
```

Shininess 40 is a broad, softer Phong exponent — the highlight blurs out instead of being a concentrated hot spot.

- [ ] **Step 4: Verify the file still parses cleanly**

The `.st` DSL has no compile step we can run headlessly; the verification is to launch the game and check `parse-logs.ps1`. Defer to Step 5.

- [ ] **Step 5: Visual verification — capture and compare**

```powershell
pwsh tools\launch-tpof.ps1
```

Load the same nebula-background map as Task 0. Capture scenes A and B:

```
screenshots\_shaderwip\phase2b_task1_nebula_A.jpg
screenshots\_shaderwip\phase2b_task1_nebula_B.jpg
```

Then:
```powershell
pwsh tools\parse-logs.ps1 -Errors
```
Expected: exit 0.

Open the new captures alongside the Task 0 baselines. The user confirms: nebulae look distinctly less glossy / wet / painted. Highlight should be broader and dimmer, with a faint cool lean rather than yellow.

**Tuning dials** if first pass is off:

| Symptom | Adjust |
|---|---|
| Nebulae lost all highlight, look flat | Bump `material specular` back to `0.55 0.55 0.60 1`; raise `shininess` to 60. |
| Still too glossy | Drop `material specular` further to `0.20 0.20 0.25 1`; drop `shininess` to 25. |
| Cool lean too strong (smurfy) | Reduce blue channel: `0.35 0.35 0.35 1`. |
| Cool lean too weak | Bump blue: `0.30 0.30 0.45 1`. |
| Highlight too soft, looks muddy | Raise `shininess` to 60 — keeps the cool tint but tightens the spot. |

- [ ] **Step 6: Commit**

```powershell
git add src/shaders/nebula.st screenshots/_shaderwip/phase2b_task1_*.jpg
git commit -m "shader: gritty deep-space tune on nebula.st (phase 2b task1)"
```

---

## Task 2: Integration check & final comparison

**Files:** none modified.

**Goal:** confirm the nebula tune doesn't regress on other rendering surfaces and the look reads correctly on at least one ship-vs-nebula composition.

- [ ] **Step 1: Launch and exercise the validation gates**

```powershell
pwsh tools\launch-tpof.ps1
```

Load a 2p Slipstream map that uses one of the nebula backgrounds. Do all of:

- Bring a capital ship close enough that the nebula fills the background. Confirm the ship-vs-backdrop composition reads correctly (ship still pops, nebula sits behind without competing for the eye).
- Fire some weapons (verify nebula doesn't visually interact with weapon FX in any new way).
- Rotate the camera so the nebula is offscreen, then back on. Confirm no popping / flicker / depth issues.

- [ ] **Step 2: Verify clean log**

```powershell
pwsh tools\parse-logs.ps1 -Errors
```
Expected: exit 0.

- [ ] **Step 3: Capture final comparison set**

Capture scenes A and B one final time:

```
screenshots\_shaderwip\phase2b_task2_final_A.jpg
screenshots\_shaderwip\phase2b_task2_final_B.jpg
```

User reviews the visual diff (phase2b_task0 vs phase2b_task2) and decides:

- ✅ Direction is right → commit and 2B is done.
- ⚠️ Direction is right but needs further tuning → return to Task 1 Step 5 tuning table, dial, recapture, recommit as a v2 tune commit.
- ❌ Impact is too small to matter → Phase 2B as render-state-tuning is done; pivot the conversation to Phase 2D (texture post-processing) or Phase 2C (FX scripts) instead.

- [ ] **Step 4: Commit the final comparison captures**

```powershell
git add screenshots/_shaderwip/phase2b_task2_final_*.jpg
git commit -m "shader: phase 2b final verification screenshots (phase 2b task2)"
```

---

## Out of Scope (explicitly deferred)

- **Background `.tga` texture post-processing** (skybox darken/desat/contrast). Defer to Phase 2D if pursued. This is the dominant lever for "gritty backgrounds" but it's image-editing, not shader work.
- **Lens flare scripts** (`tpof_supernova.lua` etc.). Defer to Phase 2C (FX) scope.
- **Asteroid rendering.** Engine-internal; no shader-tier lever.
- **Dust cloud `.st` files.** Already have `material specular 0 0 0 0`; nothing to dial down.
- **HOD model changes.** Out of scope for all shader-refresh phases.

---

## Self-review notes

**Coverage:** the goal sentence maps directly to Task 1. The honest-scope statement explicitly enumerates what was considered and rejected, so reviewers can sanity-check the narrow surface area.

**Placeholders:** none — Task 1 has exact line-replacements; Task 0 / Task 2 have exact commands and exact filenames.

**Type/name consistency:** the `.st` DSL terms (`material specular`, `material shininess`) match the vanilla file verbatim. The 4-component vec on each line preserves the file's existing convention.

**Branch:** all commits on `shader-refresh`. No PR step in this plan — mirror Phase 1 / 2A disposition (leave on branch).

**No `Co-Authored-By` trailers** in any commit message. (User has explicitly forbidden these in this repo; see `memory/feedback_no_cosign.md`.)
