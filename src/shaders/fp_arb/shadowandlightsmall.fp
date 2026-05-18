!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

ATTRIB coordShadow = fragment.texcoord[0];    #shadow texture coordinates
ATTRIB coordShip = fragment.texcoord[1];      #normal texture coordinates
ATTRIB col0 = fragment.color.primary;	#diffuse interpolated color
ATTRIB col1 = fragment.color.secondary;	#specular interpolated color
#ATTRIB pos = fragment.position;			#screen position
PARAM miscValues  = { 0, 0.5, 1, 2 };

# TPOF shader refresh (phase 1): gritty / industrial look constants
PARAM coolTint    = { 0.06, 0.07, 0.10, 0 };
PARAM rimTint     = { 0.50, 0.70, 1.00, 0 };
PARAM rimStrength = { 0.60, 0,    0,    0 };
PARAM ambientBias = { 0.10, 0.10, 0.10, 0 };

OUTPUT outColour = result.color;

TEMP glow, shadowColour, shadowAmount;
TEMP spec, prim;
TEMP R;
TEMP rim, col0biased;

#sample the textures
TXP shadowAmount, coordShadow, texture[0], 2D;
TEX glow, coordShip, texture[1], 2D;

RCP R, coordShadow.w;
MUL R, coordShadow.z, R;
SGE shadowAmount, shadowAmount, R;
MOV shadowAmount.a, col0.a;

## lighting — tighter specular (3 doublings, vanilla was 2)
MUL spec, col1, glow.b;
ADD spec, spec, spec;
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

# fake-AO crease darkening by squaring the shadow term
MUL shadowColour, shadowColour, shadowColour;

## ambient floor cut on col0
SUB col0biased, col0, ambientBias;
MAX col0biased, col0biased, miscValues.x;

## put lighting in — cool-blue fill on the diffuse term
MUL prim, col0biased, shadowColour;
ADD prim, prim, coolTint;
MUL spec, spec, shadowColour;

## fake fresnel rim — (1 - col0) modulated by glow.b, cool tint
## Accumulate into prim (a TEMP) — outColour is write-only in ARB FP1.0
SUB rim, miscValues.z, col0;
MUL rim, rim, glow.b;
MUL rim, rim, rimTint;
MAD prim, rim, rimStrength.x, prim;

ADD outColour, prim, spec;
MOV outColour.a, col0.a;

END 
