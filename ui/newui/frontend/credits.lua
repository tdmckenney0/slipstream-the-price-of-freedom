--Copyright T-Mckenney

dofilepath("data:libraries/version.lua")

Credits =
{
	size = { 0, 0, 800, 600, },
	stylesheet = "HW2StyleSheet",
	pixelUVCoords = 1,
	RootElementSettings =
	{
		backgroundColor = { 0, 0, 0, 200, }, 
	},
;
{
	type = "TextLabel",
	position = {150,100},
	size = {510,200},
	Text =
	{
		text = "Thank you for playing!",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},

--Tanner
{
	type = "TextLabel",
	position = {150,150},
	size = {510,200},
	Text =
	{
		text = "Producer, Programmer, Writer",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},
{
	type = "TextLabel",
	position = {150,165},
	size = {510,200},
	Text =
	{
		text = "T-Mckenney",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},



--Thanks
{
	type = "TextLabel",
	position = {150,465},
	size = {510,25},
	Text =
	{
		text = "An entire kick ass community we didn't have room to Thank.",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},

--Mckenney Logo 
{
	type = "Frame",
	name = "Mckenney",
	visible = 1,
	position =  { 384, 565},
	size = {32, 32},
	BackgroundGraphic = 
	{
		type = "Graphic",
		size = {32, 32},
		color = { 255, 255, 255, 255, },
		textureUV = {0,0,64,64},
		texture = "Data:UI\\logo.tga",
	},
	onMouseClicked = [[UI_ShowScreen("NewMainMenu", eTransition)]],
},
}
