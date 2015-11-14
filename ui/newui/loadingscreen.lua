-- LuaDC version 1.0.1
-- 2/14/2005 3:21:40 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
LoadingScreen = 
{ 
    size = 
        { 0, 0, 800, 600, }, 
    stylesheet = "HW2StyleSheet", 
    pixelUVCoords = 1, 
    RootElementSettings = 
    { 
        backgroundColor = 
            { 0, 0, 0, 255, }, }, 
; 
{ 
    type = "Frame", 
    position = 
        { 0, 0, }, 
    size = 
        { 800, 600, }, 
    name = "bgImage", 
    BackgroundGraphic = 
    { 
        size = 
            { 800, 600, }, 
        texture = "DATA:UI/NewUI/Background/load_background.mres", 
        textureUV = 
            { 0, 0, 800, 600, }, }, 
; 
{ 
    type = "ProgressBar", 
    progressColor = 
        { 255, 255, 255, 190, }, 
    position = 
        { 43, 300, }, 
    size = 
        { 717, 15, }, 
    name = "loadingProgress", }, 
}, 
{ 
    type = "TextLabel", 
    name = "moduleLabel", 
    position = 
        { 0, 300, }, 
    size = 
        { 800, 50, }, 
    Text = 
    { 
        textStyle = "FEButtonTextStyle", 
        color = 
            { 0, 0, 0, 255, }, 
        vAlign = "Middle", 
        hAlign = "Center", }, 
}, 
{ 
    type = "TextLabel", 
    name = "titleLabel1", 
    visible = 0, 
    size = 
        { 800, 50, }, 
    Text = 
    { 
        textStyle = "FEButtonTextStyle", 
        color = 
            { 255, 255, 255, 255, }, 
        vAlign = "Middle", 
        hAlign = "Left", }, 
}, 
{ 
    type = "TextLabel", 
    name = "titleLabel2", 
    position = 
        { 0, 50, }, 
    size = 
        { 800, 50, }, 
    visible = 0, 
    Text = 
    { 
        textStyle = "FEButtonTextStyle", 
        color = 
            { 255, 255, 255, 255, }, 
        vAlign = "Middle", 
        hAlign = "Left", }, }, 
}
