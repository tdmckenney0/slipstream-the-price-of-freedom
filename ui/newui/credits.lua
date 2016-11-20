--Copyright Tanner "Emperor" Mckenney
dofilepath("data:libraries/version.lua")
Credits =
{
    size = { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    pixelUVCoords = 1,
    onShow = [[]],
    onUpdate = [[]],
	;
	-- Main Box -- 
	{
		type = "Frame",
		name = "menubox",
		visible = 1,
		position =  { 237, 150},
		size = {325, 290},
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		backgroundColor = "FEColorBackground1",
		BackgroundGraphic = 
		{
			color = { 255, 255, 255, 255, },
			textureUV = {0,0,600,600},
			texture = "Data:UI\\NewUI\\Textures\\Gradient.tga",
		},
		;
		{
			type = "Frame",
			visible = 1,
			position =  { 28, 5},
			size = {270, 68},
			BackgroundGraphic = 
			{
				type = "Graphic",
				size = {270, 68},
				color = { 0, 0, 0, 255, },
				textureUV = {0,0,800,200},
				texture = "Data:UI\\NewUI\\Textures\\logo.tga",
			},
		},
		{ 
			type = "Line", 
			p1 =  { 10, 80, }, 
			p2 =  { 315, 80, }, 
			lineWidth = 1, 
			color = "FEColorHeading3", 
		}, 
	},
	-- SKip Button --
	{
		type = "Frame",
		name = "SkipButton",
		visible = 1,
		position =  { 700, 580},
		size = {75, 12},
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		backgroundColor = "FEColorBackground1",
		BackgroundGraphic = 
		{
			color = { 255, 255, 255, 255, },
			textureUV = {0,0,600,600},
			texture = "Data:UI\\NewUI\\Textures\\Gradient.tga",
		},
		;
		{
			type = "TextButton",
			buttonStyle = "FEButtonStyle1",
			text = "Skip",
			name = "btnSkipToMenu",
			enabled = 1,
			width = 75,
			onMouseClicked = [[UI_ShowScreen("NewMainMenu", eTransition)]],
		},
	},
}