--Copyright Tanner "Emperor" Mckenney
dofilepath("data:engine/version.lua")
NewMainMenu =
{
    size =
        { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    RootElementSettings =
    {
        backgroundColor =
            { 0, 0, 0, 0, }, },
    pixelUVCoords = 1,
	onShow = [[
				introTimer = 0
				creditsRoleGo = 0
			 ]],
	onUpdate = [[
					introTimer = introTimer + 1

					if(introTimer > 200) then
						creditsRoleGo = creditsRoleGo - 0.25
					end

					UI_SetElementPosition("NewMainMenu","CreditsRole",0, creditsRoleGo);

					UI_SetTextLabelText("NewMainMenu", "lblTimer", " Timer Count = "..introTimer);
			   ]],
;


{
    type = "Frame",
	name = "Introduction",
	visible = 1,
	backgroundColor =
            { 0, 0, 0, 255, },
	size =
        { 800, 600, },
    position =
        { 0, 0, },
;

{
    type = "Frame",
	name = "CreditsRole",
	visible = 1,
	backgroundColor =
            { 0, 0, 0, 255, },
	size =
        { 800, 5000, },
    position =
        { 0, 0, },
;
{
		type = "Frame",
		name = "SRILogo",
		visible = 1,
		position = {350, 200},
		size = {800, 400},
		BackgroundGraphic = {
			type = "Graphic",
			size = {100, 100},
			color =
            { 255, 255, 255, 255, },
			textureUV = {0,0,800,800},
			texture = "data:/ui/newui/intro/logo.tga",
		},
},
{
			type = "TextLabel",
			position = {150,300},
			size = {510,200},
			name = "SRIPRESENTS",
			Text =
			{
				-- TUTORIAL
				text = "SUB-REAL INDUSTRIES PRESENTS",
				font = "Heading3Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
		type = "Frame",
		name = "SSLogo",
		position = {200, 700},
		size = {400, 134},
		BackgroundGraphic = {
			type = "Graphic",
			size = {400, 134},
			textureUV = {0,0,800,267},
			texture = "data:/ui/newui/intro/sslogo.tga",
		},
},
{
			type = "TextLabel",
			position = {150,1000},
			size = {510,200},
			Text =
			{
				text = "The Year is 2681.",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1050},
			size = {510,200},
			Text =
			{
				text = "Mankind is on the eve of",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1100},
			size = {510,200},
			Text =
			{
				text = "Its Destruction.",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1200},
			size = {510,200},
			Text =
			{
				text = "The DSCG and UNCG Factions",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1250},
			size = {510,200},
			Text =
			{
				text = "Have been gridlocked in a",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1300},
			size = {510,200},
			Text =
			{
				text = "320-Year-Long War.",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1400},
			size = {510,200},
			Text =
			{
				text = "The DSCG's Thirst for the",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1450},
			size = {510,200},
			Text =
			{
				text = "Tsaraii Hammer of Light,",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1500},
			size = {510,200},
			Text =
			{
				text = "and the UNCG's drive for Power,",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1550},
			size = {510,200},
			Text =
			{
				text = "have worn humanity down",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1600},
			size = {510,200},
			Text =
			{
				text = "to only a handful of worlds.",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
		type = "Frame",
		name = "Fade1",
		visible = 1,
		position = {0, 0},
		size = {800, 600},
		BackgroundGraphic = {
			type = "Graphic",
			size = {800, 600},
			color =
            { 255, 255, 255, 255, },
			textureUV = {0,0,64,48},
			texture = "data:/art/fx/fade/fade_in.anim",
		},
},
},
},

--actual main menu
{
    type = "Frame",
	name = "MainMenu",
	visible = 0,
	size =
        { 800, 600, },
    position =
        { 0, 0, },
;
{
    type = "Frame",
	name = "menubox_shadow",
	backgroundColor =
            { 0, 0, 0, 0, },
	size =
        { 276, 213, },
    position =
        { 267, 192, }, --270 195
},
{
    type = "Frame",
	name = "menubox",
    autosize = 1,
    outerBorderWidth = 1,
    borderColor = "FEColorHeading3",
    backgroundColor = "FEColorBackground1",
	BackgroundGraphic =
    {
		color =
            { 255, 255, 255, 255, },
        texture = "DATA:UI\\NewUI\\background\\gradient.tga",
        textureUV =
            { 0, 0, 600, 600, },
	},
    position =
        { 262, 187, }, --262, 187
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
        text = "Slipstream: The Price of Freedom",
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
        { 304, 4, },
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
    text = "Slipstream Universe Map",
    name = "btnUniverse",
	enabled = 1,
    width = 272,
    onMouseClicked = "UI_ShowScreen('UniverseScreen', eTransition);",
},
{
    type = "Frame",
    size =
        { 296, 15, },
},
--{
  --  type = "TextButton",
  --  buttonStyle = "FEButtonStyle1",
  --  text = "Single Player Campaigns",
  --  name = "btnScenarios",
  --  enabled = 1,
  --  width = 272,
	--onMouseClicked = "UI_ShowScreen('CampaignScreen', eTransition);",
--},
--{
--    type = "Frame",
--    size =
  --      { 296, 15, },
--},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "Skirmish Battles",
    name = "btnPlayerVsCPU",
    width = 272,
},
{
    type = "Frame",
    size =
        { 296, 15, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "Local & Online Multiplayer",
    name = "btnMultiplayer",
    width = 272,
    onMouseClicked = "UI_ShowScreen('ConnectionType', eTransition);",
},
{
    type = "Frame",
    size =
        { 296, 15, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "Player Profile Management",
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
    size =
        { 296, 15, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "Game Settings",
    name = "btnOptions",
    width = 272,
    onMouseClicked = [[UI_ShowScreen("FEGameOptions", eTransition)]],
},
{
    type = "Frame",
    size =
        { 296, 15, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "Quit to Desktop",
    name = "btnExit",
    width = 272,
    onMouseClicked = "UI_ExitApp();", },
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
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "",
    name = "btnTutorial",
	position =
        { 2000, 0, },
	enabled = 0,
    width = 0,
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "",
    name = "btnCampaign",
	position =
        { 2000, 0, },
	enabled = 0,
    width = 0,
},
{
    type = "TextLabel",
    name = "lblVersion",
    position =
        { 501, 588, },
    size = {300, 20},
    Text =
    {
        font = "ChatFont",
        text = "Build Version ".. TPOFVERSION .." - ".. TPOFDATE .." ",
        color =
            { 255, 255, 255, 255, },
        hAlign = "Right",
        vAlign = "Top", },
},
{
    type = "TextLabel",
    name = "lblmusic",
    position =
        { 2, 588, },
    size = {300, 20},
    Text =
    {
        font = "ChatFont",
        text = " Music: Slipstream Suite - SRI-Emperor",
        color =
            {  255, 255, 255, 255, },
        hAlign = "Left",
        vAlign = "Top", },}, },
{
    type = "TextLabel",
    name = "lblTimer",
    position =
        { 2, 588, },
    size = {300, 20},
    Text =
    {
        font = "ChatFont",
        color =
            {  255, 255, 255, 255, },
        hAlign = "Left",
        vAlign = "Top", },},
{
    type = "TextButton",
    backgroundColor = "FEColorBackground1",
    buttonStyle = "FEButtonStyle1",
    text = "Skip Intro",
    name = "btnSkip",
	position =
        { 680, 580, },
   enabled = 1,
   onMouseClicked = [[
				UI_SetElementVisible("NewMainMenu", "MainMenu", 1)
				UI_SetElementVisible("NewMainMenu", "Introduction", 0) 
				UI_SetElementVisible("NewMainMenu", "btnSkip", 0) 
				UI_SetElementVisible("NewMainMenu", "lblTimer", 0)
			    ]],
},
}

