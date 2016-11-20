--Copyright Tanner "Osiris" Mckenney

dofilepath("data:engine/")

CreditsScreen =
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
		text = "Tanner Mckenney",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},

--HDS
{
	type = "TextLabel",
	position = {150,190},
	size = {510,200},
	Text =
	{
		text = "Testing, Concepting, Advisor, Director",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},
{
	type = "TextLabel",
	position = {150,205},
	size = {510,200},
	Text =
	{
		text = "Erik Mann",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},

--Matt
{
	type = "TextLabel",
	position = {150,230},
	size = {510,200},
	Text =
	{
		text = "Concept Ships, Weapon Concept, Trailers",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},
{
	type = "TextLabel",
	position = {150,245},
	size = {510,200},
	Text =
	{
		text = "Matthew Collins",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},

--DoubleForte
{
	type = "TextLabel",
	position = {150,270},
	size = {510,200},
	Text =
	{
		text = "Art Advisor, Testing, Design Advisor",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},
{
	type = "TextLabel",
	position = {150,285},
	size = {510,200},
	Text =
	{
		text = "DoubleForte",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},

--Nick
{
	type = "TextLabel",
	position = {150,305},
	size = {510,200},
	Text =
	{
		text = "Maps, Environment Advisor, Testing",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},
{
	type = "TextLabel",
	position = {150,320},
	size = {510,200},
	Text =
	{
		text = "NSWMaps",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},

--Testers
{
	type = "TextLabel",
	position = {150,345},
	size = {510,200},
	Text =
	{
		text = "Beta Testers & Debuggers",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},
{
	type = "TextLabel",
	position = {150,360},
	size = {510,200},
	Text =
	{
		text = "Fierwizard, Nathanius, and the Entire TPOF Community!",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},

--Contributors
{
	type = "TextLabel",
	position = {150,385},
	size = {510,200},
	Text =
	{
		text = "Community Contributors",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},
{
	type = "TextLabel",
	position = {150,400},
	size = {510,200},
	Text =
	{
		text = "Mikail, The Modernization Team, EvilJedi, Axel, TFSv2.6 Dev Team",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},

--DJZ4K
{
	type = "TextLabel",
	position = {150,425},
	size = {510,200},
	Text =
	{
		text = "For the Kick-Ass Music",
		font = "Heading2Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
	},
},
{
	type = "TextLabel",
	position = {150,440},
	size = {510,25},
	Text =
	{
		text = "DJZ4K - Look This guy up on iTunes!",
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

--Xi Logo
{
	type = "Frame",
	name = "XiLogo",
	visible = 1,
	position =  { 384, 565},
	size = {32, 32},
	BackgroundGraphic = 
	{
		type = "Graphic",
		size = {32, 32},
		color = { 255, 255, 255, 255, },
		textureUV = {0,0,64,64},
		texture = "Data:UI\\newui\\textures\\xi_logo.tga",
	},
	onMouseClicked = [[UI_ShowScreen("NewMainMenu", eTransition)]],
},
}
