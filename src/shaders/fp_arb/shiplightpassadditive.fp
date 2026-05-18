!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

ATTRIB tex = fragment.texcoord[0];      #first set of texture coordinates
ATTRIB col0 = fragment.color.primary;	#diffuse interpolated color
ATTRIB col1 = fragment.color.secondary;	#specular interpolated color
PARAM miscValues  = { 0, 0.5, 1, 2 };

# TPOF shader refresh (phase 1): gritty / industrial look constants
PARAM coolTint    = { 0.06, 0.07, 0.10, 0 };
PARAM rimTint     = { 0.50, 0.70, 1.00, 0 };
PARAM rimStrength = { 0.60, 0,    0,    0 };
PARAM ambientBias = { 0.10, 0.10, 0.10, 0 };

OUTPUT outColour = result.color;

TEMP glow, spec;
TEMP rim, col0biased;

TEX glow, tex, texture[0], 2D;       #sample the texture

## lighting — vanilla already has 3 specular doublings
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

## fake fresnel rim — (1 - col0) modulated by glow.b, cool tint
SUB rim, miscValues.z, col0;
MUL rim, rim, glow.b;
MUL rim, rim, rimTint;
MAD outColour, rim, rimStrength.x, outColour;

END
