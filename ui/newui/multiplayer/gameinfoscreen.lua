-- LuaDC version 0.9.20
-- 11/11/2008 7:35:17 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
GameInfoScreen = 
{ 
    size = 
        { 0, 0, 800, 600, }, 
    stylesheet = "HW2StyleSheet", 
    pixelUVCoords = 1, 
    RootElementSettings = 
    { 
        backgroundColor = "FEColorBackground2", }, 
    LocalizedMessages = 
    { 
        LM_GameName = "$3435", 
        LM_Map = "$3436", 
        LM_GameMode = "$3437", 
        LM_MaxPlayers = "$3446", }, 
; 
{ 
    type = "Frame", 
    position = 
        { 273, 100, }, 
    size = 
        { 308, 337, }, 
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
    type = "TextLabel", 
    position = 
        { 10, 2, }, 
    size = 
        { 200, 13, }, 
    Text = 
    { 
        textStyle = "FEHeading3", 
        text = "$3422", }, 
}, 
{ 
    type = "TextLabel", 
    position = 
        { 10, 17, }, 
    size = 
        { 200, 10, }, 
    Text = 
    { 
        textStyle = "FEHeading4", 
        text = "$3447", }, 
}, 
{ 
    type = "Frame", 
    outerBorderWidth = 2, 
    position = 
        { 4, 32, }, 
    size = 
        { 300, 300, }, 
    borderColor = "FEColorOutline", 
; 
{ 
    type = "ListBox", 
    name = "listBoxInfo", 
    borderWidth = 0, 
    borderColor = "FEColorOutline", 
    backgroundColor = 
        { 25, 25, 25, 89, }, 
    position = 
        { 0, 0, }, 
    size = 
        { 300, 275, }, 
}, 
{ 
    type = "ListBoxItem", 
    name = "listBoxTemplate", 
    size = 
        { 360, 13, }, 
; 
{ 
    type = "TextListBoxItem", 
    name = "optionName", 
    visible = 1, 
    enabled = 1, 
    Text = 
    { 
        font = "ListBoxItemFont", 
        color = 
            { 255, 255, 255, 255, }, 
        offset = 
            { 4, 0, }, }, 
    backgroundColor = 
        { 0, 0, 0, 0, }, 
    position = 
        { 0, 0, }, 
    size = 
        { 140, 13, }, 
}, 
{ 
    type = "TextListBoxItem", 
    name = "optionValue", 
    visible = 1, 
    enabled = 1, 
    Text = 
    { 
        font = "ListBoxItemFont", 
        color = 
            { 255, 255, 255, 255, }, 
        offset = 
            { 4, 0, }, }, 
    backgroundColor = 
        { 0, 0, 0, 0, }, 
    position = 
        { 140, 0, }, 
    size = 
        { 180, 13, }, }, 
}, 
{ 
    type = "Line", 
    p1 = 
        { 0, 280, }, 
    p2 = 
        { 300, 280, }, 
    lineWidth = 2, 
    color = "FEColorOutline", 
    above = 1, 
}, 
{ 
    visible = 1, 
    type = "TextButton", 
    position = 
        { 90, 283, }, 
    buttonStyle = "FEButtonStyle1", 
    name = "m_btnBack", 
    Text = 
    { 
        textStyle = "FEButtonTextStyle", 
        text = "$3420", }, }, 
}, 
}, 
}
