# Shader Refresh — Phase 1: Ships & Thrusters (fp_arb tier)

**Status:** Approved design — ready for implementation plan
**Date:** 2026-05-17
**Branch context:** `polish-next-release`
**Scope:** `src/shaders/fp_arb/` only. Ship + thruster fragment programs. Visual direction: industrial / gritty / high-contrast (Battlestar Galactica / The Expanse cue).

## Background

The TPOF shader stack was authored for HW2 Classic, whose renderer is fixed-pipeline-plus-`ARB_fragment_program 1.0` (circa 2002, ~96-instruction budget, no flow control, no GLSL, no shader-model 3+). The engine selects from tiered subdirectories based on detected GPU caps:

- `fp_arb/` — top tier, ARB FP1.0 (what virtually every modern Windows GPU hits)
- `fragment_program/`, `env_combine{2,3,4}`, `ati_combine3`, `nv_reg_combiners` — older fallbacks
- root `.st` — fixed-function fallback

We cannot add PBR, SSAO, screen-space bloom, real normal mapping, or modern post-processing without replacing the engine. We *can* push richer per-pixel lighting (fake fresnel, tighter specular, better team-color blending, fake AO via biased shadow attenuation, cooler shadow tint) within the FP1.0 budget. That is the realistic ceiling and the target of this work.

## Goals

Deliver a coordinated visual upgrade across ship surface and thruster rendering that reads as **gritty industrial military hardware** rather than vanilla HW2's bright, flat lighting. The work should:

1. Be entirely contained in `src/shaders/fp_arb/`. No changes to lower tiers, no changes to `.st` render-state files, no changes to textures or `.rot` particles.
2. Preserve faction palette legibility (Hiigaran teal/blue, Vaygr red) at silhouette distance.
3. Stay within ARB FP1.0's 96-instruction-per-shader budget on every shader touched.
4. Be screenshot-verifiable in a tight iteration loop with the user running the game.

## Non-goals

- **Backgrounds and space FX** (background, nebula, dustcloud, starfield, planet, hyperspace, asteroid, shadow self/depth shaders). Deferred to a separate spec — Phase 2.
- **Weapon visuals.** Weapon FX (muzzle flashes, beam trails, missile exhausts, hit FX) are `.rot` particle systems plus `.st` render-state files — they don't live in fp_arb fragment programs and are not in this scope. They belong to Phase 2.
- **Lower GPU tiers** (`fragment_program/`, `env_combine*`, `ati_combine*`, `nv_reg_combiners/`, root `.st`). These exist for genuinely ancient hardware that was designed for the original look; nobody runs HW2 on a 2003 GPU in 2026.
- **Megalith shaders** (`megalith.fp`, `megalithglowpass.fp`). Sajuuk-class megaliths are visually distinct in vanilla; deferred to an optional pass after Phase 1 lands and we can see whether they read as out-of-place.
- **Textures / glow-map repaints.** Optional follow-up; revisit only if shaders alone underdeliver.
- **Per-faction shader divergence.** Same shader for Hiigaran and Vaygr. Tune for Vaygr first since gritty/contrast is the harder case on already-dark hulls.

## Files in scope

Eleven fragment programs in `src/shaders/fp_arb/`:

**Ship surface (7):**

- `ship.fp` — single-pass ship (base + light + fog)
- `shipbasepass.fp` — multipass: base + team colour only
- `shipbasewithbadgepass.fp` — base + team + badge
- `shipglowpass.fp` — glow contribution as a discrete pass
- `shiplightpassadditive.fp` — additive lit pass (multipass counterpart to `ship.fp`'s lighting block)
- `shadowandlight.fp` — PCF-shadowed lit pass (largest shader; ~80 instructions today)
- `shadowandlightsmall.fp` — small shadow + lighting variant

**Thrusters (4):**

- `thruster.fp` — single-pass thruster
- `thrusterbasepass.fp` — thruster base + team
- `thrusterglowpass.fp` — thruster glow
- `thrusterlightpassadditive.fp` — thruster additive lit pass

**Explicitly untouched:** `badge.fp` (player badge UI), `additive.fp` (generic — affects unrelated FX particles), `megalith.fp` / `megalithglowpass.fp` (deferred).

## Visual recipe

Five layered effects, applied wherever the relevant inputs exist in each shader. All FP1.0-budget-safe. Constants are starting values — expect iteration via the screenshot loop.

### 1. Darker ambient floor + crease AO fake

The vanilla pipeline multiplies the base colour by `col0` (engine-baked diffuse interpolant). `col0` ranges roughly `[0.15, 1.0]` depending on scene ambient — too bright on shadowed faces, giving the flat vanilla wash.

- Subtract a small ambient bias (≈0.10) from `col0` before the light multiply, clamped to 0 with `MAX`.
- In `shadowandlight.fp` and `shadowandlightsmall.fp`: square the accumulated shadow attenuation (`MUL shadow, shadow, shadow`) so creases under PCF shadows get visibly darker — fake AO.

### 2. Cool-blue shadow tint

Add a low-intensity cool-blue bias (≈ `RGB 0.65, 0.80, 1.0` × 0.05–0.10) to the unlit half of the lighting term before the diffuse multiply. Implements the warm-key / cool-fill cue (classic BSG / Expanse signature) without requiring per-scene lighting changes.

In `ship.fp` this rides the existing fog-colour mix; in the multipass `shiplightpassadditive.fp` it's a direct bias before the col0 multiply. In `shadowandlight.fp` it applies inside the post-shadow lighting block.

### 3. Fake fresnel rim light

Approximate `(1 − col0)` and modulate by `glow.b` (already serving as the spec mask in the existing shaders). Add the result, slightly cool-tinted, to the final colour.

```
SUB rim, 1, col0;
MUL rim, rim, glow.b;
MAD outColour, rim, rimTint, outColour;
```

~3 instructions. Produces silhouette-edge highlights against dark backgrounds — *the* signature "ship cutout against the dark" look.

### 4. Tighter, hotter specular

Each `MUL spec, spec, spec` doubling raises the perceived specular exponent. Today most lit shaders do 2 doublings (×4 effective). Bump to 3 (×8) in ship lighting; bump thrusters to 4 (×16) so engines read as actual hot exhausts rather than flat lit panels. Also bump the emissive glow multiplier from 0.5 → 0.7 in ship shaders and 0.5 → 0.75 in `thrusterglowpass.fp` so team-stripe lights and engine nozzles pop harder.

### 5. Slight luminance desaturation of base diffuse

```
LRP base, 0.15, dot(base, lumWeights), base
```

Pulls hull paint ~15% toward grayscale (military feel) *after* team-color blending so faction stripes stay saturated. ~3 instructions.

**Total added per shader:** ~6–10 instructions. All affected shaders currently sit at 20–60 instructions out of 96. `shadowandlight.fp` is the squeeze (see Risks).

## Per-shader change plan

Order matches expected work order (largest / riskiest first so we discover budget issues early).

### `shadowandlight.fp` — the most complex; do first

- Square accumulated `shadowColour` term → fake crease AO.
- Bias `col0` down ≈0.10 with `MAX 0` clamp.
- Add cool-blue tint to post-shadow diffuse term before specular add.
- Bump specular doublings 2 → 3.
- Add fresnel rim and tint it cool.

**Budget check:** ~80 → ~90 instructions. Within 96-cap but tight. Mitigation if overflow: drop rim from this shader and rely on the multipass `shipglowpass`/`shiplightpassadditive` route, which most modern drivers prefer anyway.

### `shadowandlightsmall.fp`

Same edits as the full version. Comfortable budget headroom.

### `ship.fp` — single-pass fallback

- Same ambient bias on `col0`.
- Cool-blue tint via the existing fog-colour mix (bias fog toward blue when scene fog is neutral).
- Specular doublings 2 → 3.
- Bump `glow.g` multiplier 0.5 → 0.7 in the `LRP light, glow.g, light, col0` step.
- Luminance desaturation on `base` before final multiply (post-team-color).
- Fresnel rim as a final ADD before fog blend.

### `shipbasepass.fp` / `shipbasewithbadgepass.fp` — no lighting in these passes

Only luminance desaturation on `base` after team-color blending. Lighting/rim/spec changes do not apply — these passes don't see lighting interpolants.

### `shipglowpass.fp`

Bump constant `glowValue.g` from 0.5 → 0.7. Matches `ship.fp` so single-pass and multi-pass renderers stay in sync.

### `shiplightpassadditive.fp` — the multipass lighting counterpart

Same ambient bias on `col0`, same 2 → 3 specular doublings, same cool-blue tint, same fresnel rim. This is where gritty lighting actually lands in the multipass renderer.

### Thruster shaders

Mirror the ship pattern but tuned for engine-glow character:

- `thruster.fp`, `thrusterlightpassadditive.fp`: more aggressive spec boost (3 → 4 doublings); same ambient bias.
- `thrusterbasepass.fp`: luminance desat on `base`.
- `thrusterglowpass.fp`: `glowValue.g` 0.5 → 0.75 (exhaust nozzle interior reads hotter than hull stripes).

### `.st` render-state files

**No functional changes.** The `.st` files reference fragment programs by name (`shipFragmentProgram`, etc.). Bindings stay correct as long as we edit `.fp` files in place rather than splitting into new programs. The only scenario requiring `.st` edits is if a shader overflows the FP1.0 budget and we must split a pass — plan of record assumes no splits needed; rim-drop in `shadowandlight.fp` is the fallback if it does.

## Verification approach

### Iteration loop (per change batch)

1. Edit a small batch of related shaders together (e.g. all three thrusters, or `shadowandlight` + `shadowandlightsmall`).
2. Write a one-line summary of what the batch is supposed to change visually.
3. User has `tools\link-src.ps1` linked once already — edits to `.fp` files are picked up directly by HW2 on next launch; no `.big` repack needed per change because `launch-tpof.ps1` uses `-moddatapath DataTPOF -overridebigfile`.
4. User launches via `tools\launch-tpof.ps1`, flies to a known reference shot, captures screenshots.

   Suggested reference shots (chosen to cover the lighting cases that matter):
   - `1440p_dreadnaught_chillin.jpg` scene → big hull, ambient + specular character
   - `1440p_destroyer_does_a_flip.jpg` scene → thrusters on, motion lighting
   - A Hiigaran-vs-Vaygr engagement → both team palettes lit, weapons firing
5. User drops screenshots in chat (or saves under `screenshots/` with a `_shaderwip_<batch>` suffix).
6. Compare against existing reference shots; propose next adjustment.
7. Repeat until user calls it done.

### Validation gates (must not regress)

- HW2 launches without Lua/render errors. Pre-check: `pwsh tools\parse-logs.ps1 -Errors` after first launch each batch (exits 1 on shader compile failure).
- All ships visible (no black-bodied ships from broken texture sampling).
- Team colours read correctly for both Hiigaran (blue/teal) and Vaygr (red).
- Subsystem mouseover glow (`innatess.st`) still works — not touching it, but it shares the lighting math context.
- Hyperspace entry/exit visuals still render — they multiply against ship shaders. Untouched, but verify in at least one screenshot.

### Rollback

Each change batch is its own commit on `polish-next-release`. Single-commit revert per batch if a regression appears. Final landing strategy (squash vs. preserve batches) is the user's call at PR time.

## Risks

1. **Instruction-count overflow on `shadowandlight.fp`.** ~80 instructions today; adding rim + cool tint + AO squaring could push past 96. *Mitigation:* drop rim from this shader specifically — it'll still apply via the multipass `shipglowpass` + `shiplightpassadditive` route on most modern drivers.
2. **Cool-blue tint reads wrong on already-cool-lit scenes** (nebula maps with blue fog, slipstream-themed levels). *Mitigation:* keep the cool tint as a low-intensity bias (0.05–0.10), not a full LRP. Phase 2 (backgrounds) may re-tune scene fog anyway.
3. **Vaygr ships looking *too* gritty.** Vaygr hulls are already dark/red; high contrast + AO crease could make them muddy. *Mitigation:* tune to a Vaygr screenshot first; Hiigaran benefits more from the same dial.
4. **Subjectivity of "gritty."** Build in a check-in after the first complete shader pass before committing further iteration time.

## Open questions (resolved during iteration; not blockers)

- Final value of the cool-tint constant.
- Whether to gate the fresnel rim behind a separate program-local constant for easy per-scene disable.
- Whether to add megalith shaders to Phase 1 if the Sajuuk scenes look visually out-of-place against newly gritty regular hulls.

## Out-of-scope (re-stated to anchor scope)

- Lower-tier shader directories.
- Background / nebula / dustcloud / starfield / planet shaders.
- Hyperspace, shadow self/depth, asteroid shaders.
- Megalith shaders.
- Weapon FX (`.rot` particles, `fx.st`, weapon textures).
- New textures or glow-map repaints.
- Per-faction shader divergence.

## Next step

Hand off to `superpowers:writing-plans` to produce a step-by-step implementation plan covering: shader edit order, screenshot-verification checkpoints between batches, fallback handling for the `shadowandlight.fp` budget squeeze, and the commit/revert cadence.
