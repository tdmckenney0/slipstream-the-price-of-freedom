--Copyright Tanner "Emperor" Mckenney
CampaignScreen =
{
    size =
        { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    RootElementSettings =
    {
        backgroundColor =
            { 0, 0, 0, 0, }, },
    pixelUVCoords = 1,
;
{
    type = "Frame",
    autosize = 1,
    outerBorderWidth = 1,
    borderColor = "FEColorHeading3",
    backgroundColor = "FEColorBackground1",
	BackgroundGraphic =
    {
        texture = "DATA:UI\\NewUI\\background\\gradient.tga",
        textureUV =
            { 0, 0, 600, 600, }, },
    position =
        { 262, 187, },
    autoarrange = 1,
    autoarrangeWidth = 304,
    autoarrangeSpace = 0,
    maxSize =
        { 276, 400, },
;
{
    type = "Frame",
    size =
        { 304, 2, },
},
{
    type = "TextLabel",
    size =
        { 275, 13, },
    Text =
    {
        textStyle = "FEHeading3",
        text = "Single Player Game",
		hAlign = "Center",
        offset =
            { 0, 0, }, },
},
{
    type = "Frame",
    size =
        { 304, 2, },
},
{
    type = "Frame",
    size =
        { 304, 6, },
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
    text = "Scenarios",
    name = "btnScenarios",
	enabled = 1,
    width = 272,
    --onMouseClicked = "UI_ShowScreen('UniverseScreen', eTransition);",
},
{
    type = "Frame",
    size =
        { 296, 15, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "The Price of Freedom Campaign",
    name = "btnTPOFCamp",
    enabled = 1,
    width = 272,
	--onMouseClicked = "UI_ShowScreen('CampaignScreen', eTransition);",
},
{
    type = "Frame",
    size =
        { 296, 15, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "Homeworld 2 Campaign",
    name = "btnCampaign",
    width = 272,
},
},
{
    type = "Frame",
    size =
        { 296, 15, }, },
},
{
    type = "TextListBoxItem",
    buttonStyle = "FEListBoxItemButtonStyle",
    name = "m_levelListBoxItem",
    visible = 0,
    enabled = 0,
    Text =
    {
        textStyle = "FEListBoxItemTextStyle", },
},
--Bottom Navigation Screen
		{
			type = "Frame",
			outerBorderWidth = 1,
			borderColor = "FEColorHeading3",
			BackgroundGraphic =
			{
			texture = "DATA:UI\\NewUI\\background\\gradient.tga",
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

