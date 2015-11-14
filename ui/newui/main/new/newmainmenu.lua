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
        texture = "Data:UI\\NewUI\\Background\\mainmenu1600.tga",
        textureUV =
            { 0, 0, 1600, 1200, }, },
},
{
    type = "Frame",
    autosize = 1,
    backgroundColor = "",
    position =
        { 20, 187, },
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
        { 304, 13, },
    Text =
    {
        textStyle = "FEHeading3",
        text = "",
        offset =
            { 24, 0, }, },
},
{
    type = "Frame",
    size =
        { 304, 2, },
},
{
    type = "TextLabel",
    name = "m_lblSubTitle",
    size =
        { 304, 10, },
    Text =
    {
        textStyle = "FEHeading4",
        text = "",
        offset =
            { 8, 0, }, },
},
{
    type = "Frame",
    size =
        { 304, 4, },
},
{
    type = "Frame",
    size =
        { 4, 50, },
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
    buttonStyle = "FEButtonStyle3",
    text = "",
    name = "btnTutorial",
    enabled = 1,
    width = 260,
    onMouseClicked = "UI_ShowScreen('UniverseScreen', eTransition);",
},
{
    type = "Frame",
    size =
        { 296, 15, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle3",
    text = "",
    name = "btnCampaign",
    enabled = 1,
    width = 260,
},
{
    type = "Frame",
    size =
        { 296, 15, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle3",
    text = "",
    name = "btnPlayerVsCPU",
    width = 260,
},
{
    type = "Frame",
    size =
        { 296, 15, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle3",
    text = "",
    name = "btnMultiplayer",
    width = 260,
    onMouseClicked = "UI_ShowScreen('ConnectionType', eTransition);",
},
{
    type = "Frame",
    size =
        { 296, 15, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle3",
    text = "",
    name = "btnProfile",
    width = 260,
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
    buttonStyle = "FEButtonStyle3",
    text = "",
    name = "btnOptions",
    width = 260,
    onMouseClicked = [[UI_ShowScreen("FEGameOptions", eTransition)]],
},
{
    type = "Frame",
    size =
        { 296, 15, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle3",
    text = "",
    name = "btnCredits",
    width = 260,
    onMouseClicked = [[UI_ShowScreen("CreditsScreen", eTransition)]], },
},
{
    type = "Frame",
    size =
        { 300, 4, }, },
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
    buttonStyle = "FEButtonStyle3",
    text = "",
    name = "btnExit",
    position =
        { 280, 198, },
    width = 15,
    onMouseClicked = "UI_ExitApp();", },
{
    type = "TextLabel",
    name = "lblVersion",
    size =
        { 200, 13, },
    position =
        { 25, 200, },
    Text =
    {
        text = "Slipstream: The Price of Freedom v2.0 Mac",
        font = "ButtonFont",
        hAlign = "Left",
        vAlign = "Top",
        color =
            { 255, 255, 255, 255, },
        offset =
            { 0, 0, }, }, },
}
