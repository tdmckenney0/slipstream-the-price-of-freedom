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
        texture = "DATA:UI/NewUI/Background/menu1600.tga",
        textureUV =
            { 0, 0, 1600, 1200, }, },
;
{
    type = "ProgressBar",
    progressColor =
        { 255, 255, 255, 0, },
    position =
        { 44, 300, },
    size =
        { 717, 15, },
    name = "loadingProgress", },
},
{
    type = "TextLabel",
    name = "moduleLabel",
    position =
        { 75, 575, },
    size =
        { 800, 50, },
    Text =
    {
        textStyle = "FEHeading3",
        color =
            { 255, 255, 255, 255, },
        hAlign = "Left",
        vAlign = "Top",},
},
{
    type = "TextLabel",
    name = "loadingtext",
    position =
        { 5, 575, },
	size = {300, 20},
    Text =
    {
        textStyle = "FEHeading3",
		text = "Loading...",
        color =
            { 255, 255, 255, 255, },
        hAlign = "Left",
        vAlign = "Top", },},
}
