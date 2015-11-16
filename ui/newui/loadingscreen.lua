-- LuaDC version 1.0.1
-- 2/14/2005 3:21:40 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
LoadingScreen =
{
    size = { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    pixelUVCoords = 1,
    RootElementSettings =
    {
        backgroundColor = { 0, 0, 0, 255, },
    },
;
{
   type = "Frame",
   name = "bgImage", 
   visible = 1,
   position = {0, 0},
   size = {800, 600},
   BackgroundGraphic = 
   {
	type = "Graphic",
	size = {800, 600},
	color = { 250, 250, 255, 255, },
	textureUV = {0,0,1600,1200},
	texture = "Data:UI\\NewUI\\textures\\background.tga",
   },
},
{
    type = "Frame",
    outerBorderWidth = 1,
    borderColor = "FEColorHeading3",
    backgroundColor = "FEColorBackground1",
    BackgroundGraphic =
    {
        texture = "Data:UI\\NewUI\\Textures\\Gradient.tga",
        textureUV = { 0, 0, 600, 600, }, 
    },
    position = { 275, 287.5, }, --275, 287.5
    size = { 250, 35, },
;
{
    type = "ProgressBar",
    progressColor = { 0, 0, 0, 255, },
    outerBorderWidth = 1,
    borderColor = "FEColorHeading3",
    position = { 10, 5, },
    size = { 230, 7, },
    name = "loadingProgress", 
},
{
    type = "TextLabel",
    name = "moduleLabel",
    position = { 0, 15, },
    size = { 250, 20, },
    Text =
    {
        textStyle = "FEHeading3",
        color = { 0, 0, 0, 255, },
        hAlign = "Center",
        vAlign = "Top",
     },
},
},
}
