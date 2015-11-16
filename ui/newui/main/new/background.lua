-- LUA CONFIG FOR THE FE BACKGROUND
Background =
{
	size = {0, 0, 800, 600},
	stylesheet = "HW2StyleSheet",
	RootElementSettings = {
	},
	pixelUVCoords = 1,
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

	{
    type = "TextLabel",
    name = "lblVersion",
    position =
        { 250, 0, },
    size = {300, 20},
    Text =
    {
        font = "Buttonfont",
        text = " ",
        color =
            { 255, 255, 255, 255, },
        hAlign = "Center",
        vAlign = "Top", },
	},
}
