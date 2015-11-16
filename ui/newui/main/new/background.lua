-- LUA CONFIG FOR THE FE BACKGROUND
Background = {
	size = {0, 0, 800, 600},
	stylesheet = "HW2StyleSheet",

	RootElementSettings = {
		--backgroundColor = {100,100,100,255},
	},

	-- Flags
	pixelUVCoords = 1, -- Enter pixel coords for texture coords

	;

	{
		type = "Frame",
		visible = 1,
		position = {0, 0},
		size = {800, 600},
		BackgroundGraphic = {
			type = "Graphic",
			size = {800, 600},
			textureUV = {0,0,1600,1200},
			texture = "Data:UI\\NewUI\\Background\\menu1600.tga",
		},
	},
}
