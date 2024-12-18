-- LuaDC version 0.9.20
-- 11/11/2008 7:35:17 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
IPConnect = 
{ 
    size = 
        { 0, 0, 800, 600, }, 
    stylesheet = "HW2StyleSheet", 
    pixelUVCoords = 1, 
    RootElementSettings = 
    { 
        backgroundColor = "FEColorBackground2", }, 
    onShow = [[UI_GiveFocus("m_txtInput","IPConnect")]], 
; 
{ 
    type = "Frame", 
    position = 
        { 273, 250, }, 
    size = 
        { 254, 100, }, 
    outerBorderWidth = 1,
    borderColor = "FEColorHeading3",
    backgroundColor = "FEColorDialog", 
    BackgroundGraphic =
    {
	color = { 255, 255, 255, 255, },
        texture = "DATA:UI\\NewUI\\Textures\\gradient.tga",
        textureUV = { 0, 0, 600, 600, },
    }, 
; 
{ 
    type = "Frame", 
    outerBorderWidth = 2, 
    position = 
        { 4, 4, }, 
    size = 
        { 246, 92, }, 
    borderColor = "FEColorPopupOutline", 
    style = "FEPopupBackgroundStyle", 
; 
{ 
    type = "Line", 
    p1 = 
        { 0, 28, }, 
    p2 = 
        { 254, 28, }, 
    lineWidth = 2, 
    color = "FEColorPopupOutline", 
    above = 0, 
}, 
{ 
    type = "TextInput", 
    textInputStyle = "FETextInputStyle", 
    name = "m_txtInput", 
    maxTextLength = 16, 
    position = 
        { 4, 35, }, 
    width = 238, 
    helpTipTextLabel = "m_lblHelpText", 
    helpTip = "$3552", 
    onAccept = "UI_DialogAcceptID(UI_GetScreenID('IPConnect'));", 
}, 
{ 
    type = "Line", 
    p1 = 
        { 0, 54, }, 
    p2 = 
        { 254, 54, }, 
    lineWidth = 2, 
    color = "FEColorPopupOutline", 
    above = 0, 
}, 
{ 
    type = "TextLabel", 
    position = 
        { 10, 58, }, 
    size = 
        { 230, 13, }, 
    name = "m_lblHelpText", 
    Text = 
    { 
        textStyle = "FEHelpTipTextStyle", }, 
}, 
{ 
    type = "Line", 
    p1 = 
        { 0, 75, }, 
    p2 = 
        { 254, 75, }, 
    lineWidth = 2, 
    color = "FEColorPopupOutline", 
    above = 1, 
}, 
{ 
    type = "TextButton", 
    position = 
        { 124, 77, }, 
    buttonStyle = "FEButtonStyle1", 
    name = "m_btnCancel", 
    Text = 
    { 
        textStyle = "FEButtonTextStyle", 
        text = "$2613", }, 
    helpTipTextLabel = "m_lblHelpText", 
    helpTip = "$2613", 
    onMouseClicked = "UI_DialogCancel();", 
}, 
{ 
    type = "TextButton", 
    position = 
        { 2, 77, }, 
    name = "m_btnCreateNew", 
    buttonStyle = "FEButtonStyle2", 
    Text = 
    { 
        textStyle = "FEButtonTextStyle", 
        text = "$2612", }, 
    helpTipTextLabel = "m_lblHelpText", 
    helpTip = "$2612", 
    onMouseClicked = "UI_DialogAccept();", }, 
}, 
{ 
    type = "TextLabel", 
    position = 
        { 10, 2, }, 
    size = 
        { 230, 13, }, 
    Text = 
    { 
        textStyle = "FEHeading3", 
        text = "$3550", }, 
}, 
{ 
    type = "TextLabel", 
    position = 
        { 10, 17, }, 
    size = 
        { 230, 10, }, 
    Text = 
    { 
        textStyle = "FEHeading4", 
        text = "$3551", }, }, 
}, 
}
