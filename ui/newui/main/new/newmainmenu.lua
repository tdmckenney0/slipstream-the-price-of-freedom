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

			 ]],
	onUpdate = [[


			   ]],
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
        vAlign = "Top", },},
}

