!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

ATTRIB tex = fragment.texcoord[0];      #first set of texture coordinates

# TPOF shader refresh (phase 2a): dampen additive overlay to match weathered megalith.fp
PARAM glowDampen = { 0.85, 0, 0, 0 };

OUTPUT outColour = result.color;

TEMP glow;

TEX glow, tex, texture[0], 2D;       #sample the texture

MUL outColour, glow.g, glowDampen.x;

END
