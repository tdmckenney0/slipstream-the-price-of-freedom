-- LuaDC version 0.9.20
-- 11/11/2008 7:35:17 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
WIDTH = 300
HEIGHT = 121
DirectConnection = 
{ 
    size = 
        { (400 - WIDTH / 2), (300 - HEIGHT / 2), WIDTH, HEIGHT, }, 
    stylesheet = "HW2StyleSheet", 
    pixelUVCoords = 1, 
    RootElementSettings = 
    { 
        outerBorderWidth = 1,
	borderColor = "FEColorHeading3",
	backgroundColor = "FEColorBackground1",
	BackgroundGraphic =
	{
		color = { 255, 255, 255, 255, },
		texture = "DATA:UI\\NewUI\\Textures\\gradient.tga",
		textureUV = { 0, 0, 600, 600, },
	}, 
    }, 
    LocalizedMessages = 
    { 
        LM_GameName = "$3035", }, 
    previousScreen = "NewMainMenu", 
; 
{ 
    type = "TextLabel", 
    position = 
        { 10, 2, }, 
    size = 
        { 280, 13, }, 
    Text = 
    { 
        textStyle = "FEHeading3", 
        text = "$3036", }, 
}, 
{ 
    type = "TextLabel", 
    position = 
        { 10, 17, }, 
    size = 
        { 280, 10, }, 
    Text = 
    { 
        textStyle = "FEHeading4", 
        text = "$3037", }, 
}, 
{ 
    type = "Frame", 
    outerBorderWidth = 2, 
    position = 
        { 4, 32, }, 
    size = 
        { (WIDTH + -8), (HEIGHT + -36), }, 
    borderColor = "FEColorOutline", 
; 
{ 
    type = "Frame", 
    autosize = 1, 
    autoarrange = 1, 
    autoarrangeSpace = 2, 
; 
{ 
    type = "TextButton", 
    buttonStyle = "FEButtonStyle1", 
    width = (WIDTH + -12), 
    name = "m_btnHost", 
    position = 
        { 2, 2, }, 
    helpTipTextLabel = "m_lblHelpText", 
    helpTip = "$3038", 
    Text = 
    { 
        text = "$3039", 
        textStyle = "FEButtonTextStyle", }, 
}, 
{ 
    type = "TextButton", 
    buttonStyle = "FEButtonStyle1", 
    width = (WIDTH + -12), 
    name = "m_btnJoin", 
    position = 
        { 2, 17, }, 
    helpTipTextLabel = "m_lblHelpText", 
    helpTip = "$3040", 
    Text = 
    { 
        text = "$3041", 
        textStyle = "FEButtonTextStyle", }, 
    onMouseClicked = [[UI_ShowScreen("IPConnect", ePopup)]], }, 
}, 
{ 
    type = "Line", 
    p1 = 
        { 0, (HEIGHT + -72), }, 
    p2 = 
        { (WIDTH + -6), (HEIGHT + -72), }, 
    lineWidth = 2, 
    color = "FEColorOutline", 
    above = 1, 
}, 
{ 
    type = "TextLabel", 
    position = 
        { 4, (HEIGHT + -70), }, 
    size = 
        { (WIDTH + -6), 13, }, 
    name = "m_lblHelpText", 
    Text = 
    { 
        textStyle = "FEHelpTipTextStyle", }, 
}, 
{ 
    type = "Line", 
    p1 = 
        { 0, (HEIGHT + -53), }, 
    p2 = 
        { (WIDTH + -6), (HEIGHT + -53), }, 
    lineWidth = 2, 
    color = "FEColorOutline", 
    above = 1, 
}, 
{ 
    type = "TextButton", 
    buttonStyle = "FEButtonStyle1", 
    width = (WIDTH + -12), 
    name = "m_btnBack", 
    position = 
        { 2, (HEIGHT + -51), }, 
    helpTipTextLabel = "m_lblHelpText", 
    helpTip = "$3042", 
    Text = 
    { 
        text = "$2610", 
        textStyle = "FEButtonTextStyle", }, 
    onMouseClicked = [[UI_ShowScreen("NewMainMenu", eTransition)]], }, 
}, 
}
