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
        texture = "Data:UI\\NewUI\\Background\\menu.anim",
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
				text = "SLIPSTREAM",
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
				text = "The Price of Freedom",
				textStyle = "FEHeading2",
			},
			;
},
{
    type = "Frame",
    autosize = 0,
    outerBorderWidth = 1,
    borderColor = "FEColorHeading3",
    backgroundColor = "FEColorBackground1",
	position = {28,112},
	size = {742,338},
    --position =
      --  { 262.5, 187, },
    autoarrange = 1,
 --   autoarrangeWidth = 304,
    autoarrangeSpace = 0,
    --maxSize =
      --  { 275, 400, },
;
{
    type = "Frame",
    size =
        { 304, 2, },
},
{
    type = "TextLabel",
    size =
        { 375, 13, },
    Text =
    {
        textStyle = "FEHeading3",
        text = "Slipstream, ERA II, Current Year: 2681",
        offset =
            { 24, 0, }, },
},
{
    type = "Frame",
    size =
        { 304, 13, },
},
{
    type = "TextLabel",
	autosize = 0,
    size =
        { 718, 330, },
	wrapping = 1,
	marginWidth = 0,
	marginHeight = 0,
    Text =
    {
        textStyle = "Buttonfont",
        --text = "The UNCG has been in control of most of humanity since Earth's Destruction in 2130. On the other side of the galaxy was the DSCG, a rival to the UNCG, and has been since the year 2145. The Two factions never had contact since. The Year is now 2300, and Emperor Alexander of the American Empire, has been elected chairman of the UNCG. His Plan is to take over the UNCG and erect the Empire of Humanity. Meanwhile, The DCSG, had found Ancient Tablets referring to massive kingdom made entirely of light. However, more secrets lie buried behind a region where the current UNCG resides. With the DOL and the UNCG Enemies, a war is imminent.",
		text = "Place holder for the new universe screen..",
		hAlign = "left",
		vAlign = "Top",
		offset =
            { 24, 0, }, },
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
