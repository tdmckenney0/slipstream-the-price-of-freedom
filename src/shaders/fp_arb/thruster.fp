!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

ATTRIB tex = fragment.texcoord[0];      #first set of texture coordinates
ATTRIB col0 = fragment.color.primary;	#diffuse interpolated color
ATTRIB col1 = fragment.color.secondary;	#specular interpolated color
PARAM miscValues  = { 0, 0.5, 1, 2 };

# TPOF shader refresh (phase 1 v2): gritty / industrial look constants
# v2: cut cool tint, rim, glow boost, and spec doublings — v1 was much too hot
PARAM coolTint           = { 0.015, 0.018, 0.025, 0 };
PARAM rimTint            = { 0.50, 0.70, 1.00, 0 };
PARAM rimStrength        = { 0.15, 0,    0,    0 };
PARAM ambientBias        = { 0.10, 0.10, 0.10, 0 };
PARAM lumWeights         = { 0.299, 0.587, 0.114, 0 };
PARAM desatAmt           = { 0.15, 0, 0, 0 };
PARAM thrusterGlowBoost  = { 0.55, 0, 0, 0 };

OUTPUT outColour = result.color;

TEMP diffuseOn, glowOn, diffuseOff, glowOff;
TEMP diffuse, glow, base, teamBaseColour, teamStripeColour;
TEMP teamBaseAmount, teamStripeAmount, light, spec;
TEMP unFoggedColour, fogColour, weight;
TEMP rim, col0biased, lum;

#sample the textures
TEX diffuseOn, tex, texture[0], 2D;
TEX diffuseOff, tex, texture[1], 2D;
TEX glowOn, tex, texture[2], 2D;
TEX glowOff, tex, texture[3], 2D;

#average the textures
MOV weight, program.local[3];
MUL diffuse, diffuseOn, weight;
MUL glow, glowOn, weight;
SUB weight, miscValues.z, weight;
MAD diffuse, diffuseOff, weight, diffuse;
MAD glow, glowOff, weight, glow;

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

## lighting — v2: 1 specular doubling (was 4, vanilla had 0) — gentle boost
MUL spec, col1, glow.b;
ADD spec, spec, spec;
# hotter engine glow contribution: thrusterGlowBoost.x (0.75)
MUL light, thrusterGlowBoost.x, glow.g;
# average glow/level lighting
LRP light, glow.g, light, col0;
# ambient floor cut + cool fill
SUB col0biased, light, ambientBias;
MAX light, col0biased, miscValues.x;
ADD light, light, coolTint;
# add specular
ADD light, light, spec;

## luminance desaturation of base
DP3 lum, base, lumWeights;
LRP base, desatAmt.x, lum, base;

## final colour
MUL unFoggedColour, base, light;

## fake fresnel rim before fog blend
SUB rim, miscValues.z, col0;
MUL rim, rim, glow.b;
MUL rim, rim, rimTint;
MAD unFoggedColour, rim, rimStrength.x, unFoggedColour;

## fog
MOV fogColour, program.local[2];
MUL fogColour.a, fogColour, col0;
LRP outColour, fogColour.a, fogColour, unFoggedColour;

##fade away as needed
MOV outColour.a, col0;

END 
