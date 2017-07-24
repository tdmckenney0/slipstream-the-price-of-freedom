-- Cold Fusion LUA Decompiler v1.0.0
-- By 4E534B
-- Date: 07-23-2017 Time: 20:31:12
-- On error(s), send source (compiled) file to 4E534B@gmail.com

-- Background={size={0,
-- 	0,
-- 	800,
-- 	600},
-- stylesheet="HW2StyleSheet",
-- RootElementSettings={},
-- pixelUVCoords=1,; {type="Frame",
-- visible=1,
-- position={0,
-- 	0},
-- size={800,
-- 	600},
-- BackgroundGraphic={type="Graphic",
-- size={800,
-- 	600},
-- textureUV={0,
-- 	0,
-- 	800,
-- 	600},
-- texture="Data:UI\\NewUI\\Background\\background.mres"}}};

Background =
{
   size = {0, 0, 800, 600},
   stylesheet = "HW2StyleSheet",
   RootElementSettings = { },
   pixelUVCoords = 1,
;
{
   type = "Frame",
   name = "bgimage",
   visible = 1,
   position = {0, 0},
   size = {800, 600},
   BackgroundGraphic = 
   {
	type = "Graphic",
	size = {800, 600},
	color = { 255, 255, 255, 255, },
	textureUV = {0,0,1600,1200},
	texture = "Data:UI\\NewUI\\Textures\\background.tga",
   },
},
}
