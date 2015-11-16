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
    type = "Frame",
	outerBorderWidth = 1,
    borderColor = "FEColorHeading1",
    backgroundColor = "FEColorBackground1",
    position =
        { 275, 287.5, },
    size =
        { 250, 50, }, },
{
    type = "ProgressBar",
    progressColor =
        { 255, 255, 255, 255, },
    position =
        { 279.5, 300, },
    size =
        { 240, 7.5, },
    name = "loadingProgress", },
},
{
    type = "TextLabel",
    name = "moduleLabel",
    position =
        { 0, 312.5, },
    size =
        { 800, 50, },
    Text =
    {
        textStyle = "FEHeading3",
        color =
            { 255, 255, 255, 255, },
        hAlign = "Center",
        vAlign = "Top",},
},
{
    type = "TextLabel",
    name = "loadingtext",
    position =
        { 0, 275, },
	size = {800, 50},
    Text =
    {
        textStyle = "FEHeading3",
		text = "Slipstream: The Price of Freedom",
        color =
            { 255, 255, 255, 0, },
        hAlign = "Center",
        vAlign = "Top", },},
}
