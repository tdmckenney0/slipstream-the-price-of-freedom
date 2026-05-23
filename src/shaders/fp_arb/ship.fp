!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

ATTRIB tex = fragment.texcoord[0];      #first set of texture coordinates
ATTRIB col0 = fragment.color.primary;	#diffuse interpolated color
ATTRIB col1 = fragment.color.secondary;	#specular interpolated color
PARAM miscValues  = { 0, 0.5, 1, 2 };

# TPOF shader refresh (phase 1 v2): gritty / industrial look constants
# v2: cut cool tint to ~25%, rim to 25%, glow boost back near vanilla
PARAM coolTint    = { 0.015, 0.018, 0.025, 0 };
PARAM rimTint     = { 0.50, 0.70, 1.00, 0 };
PARAM rimStrength = { 0.15, 0,    0,    0 };
PARAM ambientBias = { 0.10, 0.10, 0.10, 0 };
PARAM lumWeights  = { 0.299, 0.587, 0.114, 0 };
PARAM desatAmt    = { 0.15, 0, 0, 0 };
PARAM glowBoost   = { 0.55, 0, 0, 0 };

OUTPUT outColour = result.color;

TEMP diffuse, glow, base, teamBaseColour, teamStripeColour;
TEMP teamBaseAmount, teamStripeAmount, light, spec;
TEMP unFoggedColour, fogColour;
TEMP rim, col0biased, lum;

TEX diffuse, tex, texture[0], 2D;       #sample the texture
TEX glow, tex, texture[1], 2D;        	#sample the texture

##adjust colour underlying base
# make darker
ADD base, diffuse, miscValues.y;
MUL teamBaseColour, base, program.local[0];
MUL teamStripeColour, base, program.local[1];
# make lighter
SUB base, diffuse, miscValues.y;
ADD teamBaseColour, base, teamBaseColour;
ADD teamStripeColour, base, teamStripeColour;

## compute amount of team colour needed
SUB teamBaseAmount, miscValues.z, diffuse.a;
SUB teamStripeAmount, miscValues.z, glow.a;

##avaerge the team colour and base texture
LRP base.rgb, teamBaseAmount, teamBaseColour, diffuse;
LRP base.rgb, teamStripeAmount, teamStripeColour, base;

## lighting — keep vanilla 3 specular doublings, but bump glow contribution
MUL spec, col1, glow.b;
ADD spec, spec, spec;
ADD spec, spec, spec;
ADD spec, spec, spec;
# hotter glow contribution: use glowBoost.x (0.70) instead of miscValues.y (0.5)
MUL light, glowBoost.x, glow.g;
# average glow/level lighting
LRP light, glow.g, light, col0;
# ambient floor cut on the col0-derived lighting
SUB col0biased, light, ambientBias;
MAX light, col0biased, miscValues.x;
# cool-blue fill bias
ADD light, light, coolTint;
# add specular
ADD light, light, spec;

## luminance desaturation of base (post-team-color so stripes stay saturated)
DP3 lum, base, lumWeights;
LRP base, desatAmt.x, lum, base;

## final colour
MUL unFoggedColour.rgb, base, light;

## fake fresnel rim before fog blend
SUB rim, miscValues.z, col0;
MUL rim, rim, glow.b;
MUL rim, rim, rimTint;
MAD unFoggedColour.rgb, rim, rimStrength.x, unFoggedColour;

## fog
MOV fogColour, program.local[2];
MUL fogColour.a, fogColour, col0;
LRP outColour.rgb, fogColour.a, fogColour, unFoggedColour;

##fade away as needed
MOV outColour.a, col0;

END 
