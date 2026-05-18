!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

ATTRIB tex = fragment.texcoord[0];      #first set of texture coordinates
ATTRIB col0 = fragment.color.primary;	#diffuse interpolated color
ATTRIB col1 = fragment.color.secondary;	#specular interpolated color
PARAM miscValues  = { 0, 0.5, 1, 2 };

# TPOF shader refresh (phase 1 v2): gritty / industrial look constants
# v2: cut cool tint, rim, and spec doublings
PARAM coolTint    = { 0.015, 0.018, 0.025, 0 };
PARAM rimTint     = { 0.50, 0.70, 1.00, 0 };
PARAM rimStrength = { 0.15, 0,    0,    0 };
PARAM ambientBias = { 0.10, 0.10, 0.10, 0 };

OUTPUT outColour = result.color;

TEMP glow, spec;
TEMP glowOn, glowOff, weight;
TEMP rim, col0biased;

#sample the textures
TEX glowOn, tex, texture[0], 2D;
TEX glowOff, tex, texture[1], 2D;

#average the textures
MOV weight, program.local[3];
MUL glow, glowOn, weight;
SUB weight, miscValues.z, weight;
MAD glow, glowOff, weight, glow;

## lighting — v2: 1 specular doubling (was 4, vanilla had 0) — gentle boost
MUL spec, col1, glow.b;
ADD spec, spec, spec;

## ambient floor cut + cool fill on col0
SUB col0biased, col0, ambientBias;
MAX col0biased, col0biased, miscValues.x;
ADD col0biased, col0biased, coolTint;

## combine into TEMP — outColour is write-only in ARB FP1.0
ADD col0biased, col0biased, spec;

## fake fresnel rim — (1 - col0) modulated by glow.b, cool tint
SUB rim, miscValues.z, col0;
MUL rim, rim, glow.b;
MUL rim, rim, rimTint;
MAD col0biased, rim, rimStrength.x, col0biased;

MOV outColour, col0biased;

END
