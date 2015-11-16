--Copyright Tanner "Emperor" Mckenney
UniverseScreen =
{
    size =
        { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    RootElementSettings =
    {
        backgroundColor =
            { 0, 0, 0, 255, }, },
    pixelUVCoords = 1,
;
{
    type = "Frame",
    position =
        { 0, 0, },
    size =
        { 800, 600, },
    BackgroundGraphic =
    {
        size =
            { 800, 600, },
        texture = "Data:UI\\NewUI\\Background\\map1600.tga",
        textureUV =
            { 0, 0, 1600, 1200, }, },
},
{
			type = "TextLabel",
			position = {16,-2},
			size = {700,36},
			name = "txtLblTITLETUT",
			Text =
			{
				-- TUTORIAL
				text = "SLIPSTREAM UNIVERSE",
				textStyle = "FEHeading1",
			},
			;
},
{
			type = "TextLabel",
			position = {17,34},
			size = {700,21},
			-- SPECIAL SUBTITLE FOR THE TUTORIAL
			name = "txtLblSUBTITLETUT",
			Text =
			{
				-- LEARN TO PLAY
				text = "Milky Way - Current Year: 2681",
				textStyle = "FEHeading2",
			},
			;
},

--Bottom Navigation Screen
		{
			type = "Frame",
			outerBorderWidth = 1,
			borderColor = "FEColorHeading3",
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
