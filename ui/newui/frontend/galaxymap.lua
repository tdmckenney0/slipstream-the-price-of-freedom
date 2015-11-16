GalaxyMap =
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
		name = "Map1",
		visible = 1,
		position = {0, 0},
		size = {800, 600},
		BackgroundGraphic = {
	
			type = "Graphic",
			size = {800, 600},
			color = { 255, 255, 255, 255, },
			textureUV = {0,0,2048,2048},
			texture = "Data:UI\\NewUI\\Textures\\galaxymap.tga",
	
		},
	},

	{
		type = "Frame",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		BackgroundGraphic =
		{
		texture = "Data:UI\\NewUI\\Textures\\Gradient.tga",
		textureUV =
        { 0, 0, 600, 600, }, },
		backgroundColor = "FEColorBackground1",
		position = {12,544},
		size = {776,44},
		name = "frmRootbottombigfrm",
		;
		-- OUTLINE FRAME
		{
			type = "Frame",
			borderWidth = 2,
			borderColor = "FEColorOutline",
			position = {2,2},
			size = {772,40},
			name = "frmbottomframe",
			;

			-- HELP TEXT
			{
				type = "TextLabel",
				position = {4,4},
				size = {764,13},
				name = "txtLblHELPTEXT",
				Text =
				{
					textStyle = "FEHelpTipTextStyle",
				},
				;
			},

			-- LINE
			{
				type = "Line",
				above = 0,
				lineWidth = 2,
				color = "FEColorOutline",
				p1 = {2, 19},
				p2 = {770, 19},

			},

			-- BUTTONS

			--DEFINITION FOR: (txtBtn) BACK
			{
				type = "TextButton",
				buttonStyle = "FEButtonStyle1",
				position = {4,23},
				name = "txtBtnBACK",
				helpTip = "$3468",
				helpTipTextLabel = "txtLblHELPTEXT",
				Text =
				{
					-- BACK
					text = "$2610",
					textStyle = "FEButtonTextStyle",
				},
				onMouseClicked = [[UI_ShowScreen("NewMainMenu", eTransition)]],
				;
			},
			
	},
	
},
}
