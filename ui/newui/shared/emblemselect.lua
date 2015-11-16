-- LuaDC version 0.9.20
-- 11/11/2008 7:35:18 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
EmblemSelect = 
{ 
    size = 
        { 0, 0, 800, 600, }, 
    stylesheet = "HW2StyleSheet", 
    RootElementSettings = 
    { 
        backgroundColor = "FEColorBackground2", }, 
    pixelUVCoords = 1, 
; 
{ 
    type = "Frame", 
    position = { 209, 196, }, 
    size = { 381, 218, }, 
    outerBorderWidth = 1,
    borderColor = "FEColorHeading3",
    backgroundColor = "FEColorBackground1",
    BackgroundGraphic = 
    {
	 color = { 255, 255, 255, 255, },
	 textureUV = {0,0,600,600},
	 texture = "Data:UI\\NewUI\\Textures\\Gradient.tga",
    },
; 
{ 
    type = "Frame", 
    position = 
        { 4, 4, }, 
    size = 
        { (381 + -8), 70, }, 
    style = "FEPopupBackgroundStyle", 
}, 
{ 
    type = "Frame", 
    position = 
        { 2, 2, }, 
    size = 
        { (381 + -4), 32, }, 
; 
{ 
    type = "Frame", 
    size = 
        { (381 + -4), 34, }, 
    borderWidth = 2, 
    borderColor = "FEColorPopupOutline", }, 
}, 
{ 
    type = "TextLabel", 
    position = 
        { 0, 0, }, 
    size = 
        { 277, 21, }, 
    marginWidth = 6, 
    Text = 
    { 
        text = "$2785", 
        textStyle = "FEHeading3", }, 
}, 
{ 
    type = "TextLabel", 
    position = 
        { 0, 13, }, 
    size = 
        { 281, 19, }, 
    marginWidth = 6, 
    Text = 
    { 
        text = "$2786", 
        textStyle = "FEHeading4", }, 
}, 
{ 
    type = "Frame", 
    position = 
        { 3, 33, }, 
    autosize = 1, 
    autoarrange = 1, 
    outerBorderWidth = 1, 
    borderColor = "FEColorPopupOutline", 
; 
{ 
    type = "ListBox", 
    listBoxStyle = "FEBorderListBoxStyle", 
    size = 
        { 375, (136 + 10), }, 
    name = "emblemList", 
    borderColor = "FEColorPopupOutline", 
    backgroundColor = 
        { 0, 0, 0, 0, }, 
}, 
{ 
    type = "Line", 
    p1 = 
        { 355, 0, }, 
    p2 = 
        { 355, (136 + 10), }, 
    lineWidth = 2, 
    color = "FEColorPopupOutline", 
}, 
{ 
    type = "TextLabel", 
    name = "helpTip", 
    size = 
        { 375, 19, }, 
    borderWidth = 1, 
    borderColor = "FEColorPopupOutline", 
    Text = 
    { 
        textStyle = "FEHelpTipTextStyle", 
        offset = 
            { 4, 0, }, }, 
}, 
{ 
    type = "Frame", 
    size = 
        { 375, 19, }, 
    borderWidth = 1, 
    borderColor = "FEColorPopupOutline", 
; 
{ 
    type = "TextButton", 
    buttonStyle = "FEButtonStyle1", 
    position = 
        { 252, 3, }, 
    width = 120, 
    text = "$2613", 
    name = "cancelbutton", 
    onMouseClicked = "UI_HideScreen( 'EmblemSelect');", 
    helpTipTextLabel = "helpTip", 
    helpTip = "$2613", 
}, 
{ 
    type = "TextButton", 
    buttonStyle = "FEButtonStyle2", 
    position = 
        { ((252 + -120) + -2), 3, }, 
    width = 120, 
    text = "$2612", 
    name = "acceptbutton", 
    helpTipTextLabel = "helpTip", 
    helpTip = "$2612", }, 
}, 
}, 
}, 
{ 
    type = "ListBoxItem", 
    name = "emblemItem", 
    visible = 0, 
    size = 
        { 70, 70, }, 
    backgroundColor = 
        { 118, 174, 207, 255, }, 
    borderWidth = 1, 
    borderColor = 
        { 0, 0, 0, 0, }, 
    overBorderColor = 
        { 0, 0, 0, 0, }, 
    pressedBorderColor = 
        { 255, 255, 255, 255, }, 
    helpTipTextLabel = "helpTip", 
    allowDoubleClicks = 1, 
; 
{ 
    type = "Frame", 
    name = "emblem", 
    position = 
        { 3, 3, }, 
    size = 
        { 64, 64, }, 
    BackgroundGraphic = 
    { 
        size = 
            { 64, 64, }, 
        texture = "DATA:Badges/Hiigaran.tga", 
        textureUV = 
            { 0, 0, 64, 64, }, }, 
    giveParentMouseInput = 1, 
}, 
{ 
    type = "TextLabel", 
    name = "imageError", 
    visible = 0, 
    position = 
        { 0, 0, }, 
    size = 
        { 70, 70, }, 
    wrapping = 1, 
    backgroundColor = 
        { 0, 0, 0, 255, }, 
    borderWidth = 1, 
    borderColor = 
        { 0, 0, 0, 0, }, 
    marginWidth = 2, 
    Text = 
    { 
        font = "ChatFont", 
        text = "$2790", 
        hAlign = "Center", 
        vAlign = "Center", 
        color = 
            { 255, 255, 255, 255, }, }, }, 
}, 
}
