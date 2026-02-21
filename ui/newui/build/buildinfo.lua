-- LuaDC version 0.9.20
-- 12/20/2025 8:42:38 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
BUILDINFO_WIDTH = 210
BUILDINFO_OUTLINECOLOR = "TPOFWhite"
BuildInfo = 
{ 
    size = 
        { 0, 0, BUILDINFO_WIDTH, 66, }, 
    resolution = 
        { 800, 600, }, 
    stylesheet = "HW2StyleSheet", 
    RootElementSettings = 
    { 
        autosize = 1, }, 
    pixelUVCoords = 1, 
; 
{ 
    type = "Frame", 
    autoarrange = 1, 
    autoarrangeWidth = BUILDINFO_WIDTH, 
    autosize = 1, 
; 
{ 
    type = "Frame", 
    size = 
        { (BUILDINFO_WIDTH + 2), 1, }, 
}, 
{ 
    type = "TextLabel", 
    name = "lblName", 
    size = 
        { BUILDINFO_WIDTH, 13, }, 
    BackgroundGraphic = 
    { 
        texture = "data:ui\\newui\\ingameicons\\popup_borders.mres", 
        textureUV = 
            { 0, 0, 210, 13, }, 
        color = BUILDINFO_OUTLINECOLOR, }, 
    Text = 
    { 
        text = "$3120", 
        font = "ListBoxItemFont", 
        vAlign = "Middle", 
        hAlign = "Left", 
        offset = 
            { 4, 0, }, 
        color = 
            { 0, 0, 0, 255, }, }, 
}, 
{ 
    type = "Frame", 
    name = "frmSmallShipItems", 
    autosize = 1, 
    autoarrange = 1, 
    BackgroundGraphic = 
    { 
        texture = "data:ui\\newui\\ingameicons\\popup_borders.mres", 
        textureUV = 
            { 0, 14, 210, 24, }, 
        color = BUILDINFO_OUTLINECOLOR, }, 
; 
{ 
    type = "TextLabel", 
    name = "lblDescription", 
    size = 
        { BUILDINFO_WIDTH, 0, }, 
    Text = 
    { 
        textStyle = "ResearchInfoTextStyle", }, 
    wrapping = 1, 
    autosize = 1, 
    marginWidth = 3, 
    marginHeight = 3, }, 
}, 
{ 
    type = "Frame", 
    size = 
        { BUILDINFO_WIDTH, 5, }, 
    BackgroundGraphic = 
    { 
        texture = "data:ui\\newui\\ingameicons\\popup_borders.mres", 
        textureUV = 
            { 0, 28, 210, 32, }, 
        color = BUILDINFO_OUTLINECOLOR, }, }, 
}, 
}
