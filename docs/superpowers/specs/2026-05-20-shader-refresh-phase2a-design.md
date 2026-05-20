# Shader Refresh — Phase 2A: Megaliths

**Date:** 2026-05-20
**Branch:** `shader-refresh`
**Builds on:** [Phase 1 design](2026-05-17-shader-refresh-design.md) (committed at `bb11810`)
**Status:** Spec — awaiting user review before plan + implementation

## Context

Phase 1 refreshed the `fp_arb/` fragment programs that render ships and thrusters with an industrial / gritty / high-contrast look. After two tuning rounds (v1 too hot, v2 dialed back), Phase 1 shipped on the `shader-refresh` branch with the following recipe:

- Ambient floor cut (`ambientBias = 0.10`)
- Cool fill tint (`coolTint = { 0.015, 0.018, 0.025 }`)
- Fake fresnel rim using `(1 - col0) * glow.b * rimTint` with `rimStrength = 0.15`
- Luminance desaturation (`DP3` + `LRP`, `desatAmt = 0.15`)
- Mild glow boost on the engine/stripe contribution (`glowBoost = 0.55`)
- Specular doublings preserved at vanilla levels

Phase 2 was originally scoped as "backgrounds & space FX," but on inspection the surface area splits across three distinct levers (fragment programs, fixed-function `.st` files, Lua FX scripts). Phase 2 has been decomposed into three sub-phases — **2A (megaliths)**, **2B (backgrounds)**, **2C (FX)** — each with its own spec → plan → implementation cycle. This document covers 2A only.

## Phase 2A Goal

Apply the Phase 1 v2 recipe to the megalith fragment programs, **pushed further toward "ancient / weathered derelict"** — stronger chroma loss, deeper shadows, dampened glow, dampened additive overlay. Megaliths are neutral scenario objects (Bentusi ruin cores, Tanis structures, Leviathan, Chimera, slipgate, asteroid inhibitor) that should read as dead matter, not active military hardware.

## Files Touched

| File | Change |
|---|---|
| `src/shaders/fp_arb/megalith.fp` | Add v2 recipe with weathered constants |
| `src/shaders/fp_arb/megalithglowpass.fp` | Dampen additive-overlay output by 15% |

No other shaders or render-state files are in 2A scope.

## Constants — `megalith.fp` PARAM block

Diff vs Phase 1 v2 (ships):

| Param | Phase 1 v2 (ships) | 2A (megaliths) | Rationale |
|---|---|---|---|
| `coolTint` | `0.015 / 0.018 / 0.025` | **`0.020 / 0.025 / 0.035`** | ~1.3× — dead matter reads cooler |
| `rimStrength` | `0.15, 0, 0, 0` | **`0.18, 0, 0, 0`** | Slightly stronger silhouette on derelicts |
| `ambientBias` | `0.10, 0.10, 0.10, 0` | **`0.12, 0.12, 0.12, 0`** | Deeper shadow pockets |
| `desatAmt` | `0.15, 0, 0, 0` | **`0.25, 0, 0, 0`** | Stronger chroma loss — weathered |
| `megGlowBoost` | `0.55, 0, 0, 0` (named `glowBoost`) | **`0.40, 0, 0, 0`** | Less hot — derelicts aren't powered |
| `rimTint` | `0.50 / 0.70 / 1.00 / 0` | same | Cool rim still works |
| `lumWeights` | `0.299 / 0.587 / 0.114 / 0` | same | Standard ITU-R BT.601 luminance |
| Specular doublings | 3 (vanilla ship was 3) | **0** (vanilla megalith.fp has 0 with no `/2` divide either — already hot relative to ship base) | Megaliths need *less* spec, not more |

## `megalith.fp` Recipe (mirrors `ship.fp` Phase 1 v2)

The structure of vanilla `megalith.fp` is identical to vanilla `ship.fp` (sample diffuse + glow, team-color via `LRP base.rgb`, lighting LRP, fog blend). The Phase 1 v2 recipe transposes one-to-one. Required edits in order:

1. **Add PARAM block** with the constants above (after the existing `miscValues` PARAM line).
2. **Add TEMP declarations** for `rim`, `col0biased`, `lum`. (`unFoggedColour` and `spec` are already present in vanilla.)
3. **Replace** the existing `LRP light, glow.g, glow.g, col0;` with a pair that introduces the `megGlowBoost` multiplier on the glow contribution:
   ```
   MUL light, megGlowBoost.x, glow.g;
   LRP light, glow.g, light, col0;
   ```
   The second `LRP` argument changes from `glow.g` (vanilla) to `light` (now containing `megGlowBoost * glow.g`).
4. **Insert ambient floor cut + cool fill** after the lighting LRP, before the spec add:
   ```
   SUB col0biased, light, ambientBias;
   MAX light, col0biased, miscValues.x;
   ADD light, light, coolTint;
   ```
5. **Insert luminance desat** on `base` after team-color LRPs, before `MUL unFoggedColour, base, light;`:
   ```
   DP3 lum, base, lumWeights;
   LRP base, desatAmt.x, lum, base;
   ```
6. **Insert fake fresnel rim** after the `MUL unFoggedColour, base, light;`, before fog blend:
   ```
   SUB rim, miscValues.z, col0;
   MUL rim, rim, glow.b;
   MUL rim, rim, rimTint;
   MAD unFoggedColour, rim, rimStrength.x, unFoggedColour;
   ```

**Critical FP1.0 constraint (Phase 1 lesson — commit `8a964b4`):** the rim accumulator must write to a TEMP, never to `outColour`. `outColour` is write-only in ARB_fragment_program 1.0 — using it as a source operand in `MAD` causes "Could not load !!ARBfp1.0" at program-link time. The recipe above routes through `unFoggedColour` (already a TEMP in vanilla), then the existing fog `LRP outColour, fogColour.a, fogColour, unFoggedColour;` writes the final result to `outColour` correctly.

Optional dial-in pass (defer to v2 if first pass too bright): pre-multiply `spec` by `megSpecScale = 0.85` after the existing `MUL spec, col1, glow.b;`. Not in initial recipe — gather screenshots first.

## `megalithglowpass.fp` Recipe

Vanilla is two non-trivial lines:
```
TEX glow, tex, texture[0], 2D;
MOV outColour, glow.g;
```

Edit:
1. **Add PARAM** `glowDampen = { 0.85, 0, 0, 0 };` after the existing fragment.color attribs.
2. **Replace** `MOV outColour, glow.g;` with `MUL outColour, glow.g, glowDampen.x;`

Preserves the green-channel-splat semantics (the engine still gets the same channel layout); just attenuated by 15%.

## Instruction Budget

`megalith.fp` grows from ~17 instructions to ~28. Well under the FP1.0 hard limit of 96 instructions.
`megalithglowpass.fp` stays at 2 instructions.

## Megaliths That Will Be Affected

| Ship file | Notes |
|---|---|
| `meg_asteroid_inhibitor` | Anti-hyperspace asteroid prop |
| `meg_bentus_ruins_core_1/2/3` | Bentusi ruin pieces — primary aesthetic beneficiary |
| `meg_chimera` | Special scenario object |
| `meg_leviathan` | Large derelict |
| `meg_slipgate` | Slipstream gate **structure** (the active gate FX is 2C scope) |
| `meg_starjumper` | Special scenario object |
| `meg_tanisstructure_medium/medium2` | HW1-era station fragments |

## Risk / Known Traps

- **OUTPUT-read crash (FP1.0):** addressed above — accumulator goes through `unFoggedColour` TEMP, not `outColour`.
- **meg_slipgate read:** the gate *structure* will go dimmer/cooler; the *active gate effect* (slipstream beams, edge animation) is rendered separately via `src/art/fx/slipstreamgate.lua` and is 2C scope.
- **Bentusi ruins already low-saturation:** strong `desatAmt = 0.25` may push them past "weathered" to "actively gray." If so, dial to 0.20 in a v2 tune pass.
- **Spec already hotter than vanilla ship base** because vanilla `megalith.fp` skips the `/2` divide that `ship.fp` applies. We do NOT add doublings here — we keep at 0. If first launch shows specular pop, add `MUL spec, spec, 0.85;` as a v2 dial-down.

## Verification

User launches HW2 with `tools\launch-tpof.ps1`, captures screenshots on maps featuring megaliths (any Bentusi-ruin map, slipgate maps). User reports back; tune constants in a v2 commit if needed (Phase 1 pattern).

`tools\parse-logs.ps1 -Errors` should be checked after launch for any "Could not load !!ARBfp1.0" lines — those would indicate a recipe bug.

## Out of Scope (Deferred to 2B / 2C)

- Skybox, nebula, dust render-state `.st` files (2B)
- Hyperspace plane `.st` files (2C)
- Slipstream gate active-FX Lua scripts (2C)
- Weapon FX, booster, explosion Lua scripts (2C)
- Background `.tga` texture post-processing (2B if chosen)

## Done When

- Both shader files modified per recipe.
- `tools\build-tpof.ps1 -Install` builds without errors.
- User launches and confirms megaliths read as weathered/dead, not broken or invisible.
- Commit on `shader-refresh` branch with message following the Phase 1 naming pattern (`shader: phase 2a — gritty pass on megalith fp_arb (weathered variant)`).
