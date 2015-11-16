--Copyright Tanner "Emperor" Mckenney
NewMainMenu =
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
        texture = "Data:UI\\NewUI\\Background\\menu1600.tga",
        textureUV =
            { 0, 0, 1600, 1200, }, },
},
{
    type = "Frame",
    autosize = 1,
    outerBorderWidth = 1,
    borderColor = "FEColorHeading1",
    backgroundColor = "FEColorBackground1",
    position =
        { 262.5, 187, },
    autoarrange = 1,
    autoarrangeWidth = 304,
    autoarrangeSpace = 0,
    maxSize =
        { 275, 400, },
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
--{
--    type = "TextLabel",
--    name = "m_lblSubTitle",
--    size =
--        { 304, 10, },
--    Text =
--    {
--        textStyle = "FEHeading4",
--        text = "",
--        offset =
--            { 8, 0, }, },
--},
{
    type = "Frame",
    size =
        { 304, 4, },
},
--{
--    type = "Frame",
--    size =
--        { 4, 50, },
--},
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
    text = "About Slipstream",
    name = "btnTutorial",
	enabled = 1,
    width = 272,
    onMouseClicked = "UI_ShowScreen('UniverseScreen', eTransition);",
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
    name = "btnCampaign",
    enabled = 1,
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
    text = "System Settings",
    name = "btnOptions",
    width = 272,
    onMouseClicked = [[UI_ShowScreen("FEGameOptions", eTransition)]],
},
{
    type = "Frame",
    size =
        { 296, 15, },
},
--{
--    type = "TextButton",
  --  buttonStyle = "FEButtonStyle1",
    --text = "Credits & Contributors",
  --  name = "btnCredits",
  --  width = 272,
  --  onMouseClicked = [[UI_ShowScreen("CreditsScreen", eTransition)]], },
--{
--    type = "Frame",
--    size =
--        { 296, 15, },
--},
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
    type = "TextLabel",
    name = "lblVersion",
    position =
        { 501, 588, },
    size = {300, 20},
    Text =
    {
        font = "Buttonfont",
        text = "Build Version 2.4.5000 - May 4, 2009 ",
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
        font = "Buttonfont",
        text = "Music: Nutritious - Ancient Enemies",
        color =
            { 255, 255, 255, 255, },
        hAlign = "Left",
        vAlign = "Top", },},
}
