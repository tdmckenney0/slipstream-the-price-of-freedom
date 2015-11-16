dofilepath("data:libraries/version.lua")

NewMainMenu =
{
    size = { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    pixelUVCoords = 1,
    RootElementSettings =
    {
		backgroundColor = { 0, 0, 0, 0, }, 
    },
	;
    
	{
		type = "Frame",
		name = "menubox",
		visible = 1,
		position =  { 237, 170},
		size = {325, 260}, --325, 290
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		backgroundColor = "FEColorBackground1",
		BackgroundGraphic = {

			color = { 255, 255, 255, 255, },
			textureUV = {0,0,600,600},
			texture = "Data:UI\\NewUI\\Textures\\Gradient.tga",
		},
	;
	
	{
		type = "TextLabel",
		name = "lblTitle",
		position = { 28, 5},
		size = {270, 68},
		Text = {
		
			text = "The Price of Freedom",
			font = "Heading1Font",
			color = "FEColorHeading3",
			vAlign = "Top",
			hAlign = "Center",
		},
	},
	
	{ 
		type = "Line", 
		p1 =  { 10, 50, }, 
		p2 =  { 315, 50, }, 
		lineWidth = 1, 
		color = "FEColorHeading3", 
	}, 
		{
			type = "Frame",
			autosize = 1,
			position = { 25, 55, },  --25, 85
			autoarrange = 1,
			autoarrangeWidth = 304, 
			autoarrangeSpace = 0,
			maxSize = { 276, 400, },
		;
			{
				type = "Frame",
				size = { 304, 10, },
			},
			{
				type = "Frame",
				outerBorderWidth = 0,
				borderColor = "FEColorOutline",
				autosize = 1,
				autoarrange = 1,
				autoarrangeSpace = 2,
				autoarrangeWidth = 200,
			;
				{
				  type = "TextButton",
				  buttonStyle = "FEButtonStyle1",
				  enabled = 1,
				  text = "Single Player Campaign",
				  name = "btnTutorial",
				  width = 272,
				},
				{
					type = "Frame",
					size = { 296, 10, },
				},
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					text = "Navigation Data",
					name = "btnUniverse",
					enabled = 1,
					width = 272,
					onMouseClicked = "UI_ShowScreen('GalaxyMap', eTransition);",
				},
				{
					type = "Frame",
					size = { 296, 10, },
				}, 
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					text = "Skirmish Games",
					name = "btnPlayerVsCPU",
					width = 272,
				}, 
				{
					type = "Frame",
					size = { 296, 10, },
				},
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					text = "Multiplayer",
					name = "btnMultiplayer",
					width = 272,
					onMouseClicked = "UI_ShowScreen('ConnectionType', eTransition)",
				},
				{
					type = "Frame",
					size = { 296, 10, },
				},
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					text = "Profile Management",
					name = "btnProfile",
					width = 272,
					onMouseClicked = [[
					
						UI_SetNextScreen("UserProfile", "NewMainMenu");
						UI_SetPreviousScreen("UserProfile", "NewMainMenu");
						UI_ShowScreen("UserProfile", eTransition);
					]],
				},
				{
					type = "Frame",
					size = { 296, 10, },
				},
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					text = "Game Settings",
					name = "btnOptions",
					width = 272,
					onMouseClicked = "UI_ShowScreen('FEGameOptions', eTransition)",
				},
				{
					type = "Frame",
					size = { 296, 10, },
				},
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					text = "Quit to Desktop",
					name = "btnExit",
					width = 272,
					onMouseClicked = "UI_ExitApp();", 
				},
			},
			
			{
				type = "Frame",
				size = { 296, 10, }, 
			},
			
		},
		{
			type = "TextLabel",
			name = "lblVersion",
			position = { 12, 243, },
			size = {300, 20},
			Text =
			{
				textStyle = "FEHeading3",
				text = "v".. TPOFVERSION .."",
				color = { 0, 0, 0, 255, },
				hAlign = "Center",
			},
		},
	},
	
	{
		type = "Frame",
		name = "Logo",
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
		onMouseClicked = [[UI_ShowScreen("Credits", eTransition)]],
	},
	
	

	-- Homeworld 2 Will Crash if the tutorial and campaign buttons are not somewhere on the main menu --

	{
		type = "TextButton",
		buttonStyle = "FEButtonStyle1",
		name = "btnCampaign",
		position = { 2000, 0, }, -- <-- This hides them outside the viewing area and disables them. 
		enabled = 0,
		width = 0,
	},
}

