NewMainMenu =
{
    size = { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    RootElementSettings =
    {
	backgroundColor = { 0, 0, 0, 0, }, 
    },
    pixelUVCoords = 1,
;
{
   type = "Frame",
   name = "menubox",
   visible = 1,
   position =  { 237, (300 - (270 / 2))},
   size = {325, 270},
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
   visible = 1,
   position =  { 28, 5},
   size = {270, 68},
   BackgroundGraphic = 
   {
	type = "Graphic",
	size = {270, 68},
	color = { 0, 0, 0, 255, },
	textureUV = {0,0,800,200},
	texture = "Data:UI\\NewUI\\Textures\\logo.tga",
   },
},
{ 
    type = "Line", 
    p1 =  { 10, 80, }, 
    p2 =  { 315, 80, }, 
    lineWidth = 1, 
    color = "FEColorHeading3", 
}, 
{
    type = "Frame",
    autosize = 1,
    position = { 25, 85, }, 
    autoarrange = 1,
    autoarrangeWidth = 304, 
    autoarrangeSpace = 0,
    maxSize = { 276, 400, },
;
{
    type = "Frame",
    size = { 304, 10, },
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
  buttonStyle = "FEButtonStyle1",
  text = "$2602",
  name = "btnTutorial",
  width = 272,
},
{
    type = "Frame",
    size = { 296, 10, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "$2604",
    name = "btnPlayerVsCPU",
    width = 272,
},
{
    type = "Frame",
    size = { 296, 10, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "$2614",
    name = "btnMultiplayer",
    width = 272,
    onMouseClicked = [[
					UI_SetNextScreen("ConnectionType", "NewMainMenu");
					UI_SetPreviousScreen("ConnectionType", "NewMainMenu");
					UI_ShowScreen("ConnectionType", eTransition);
				]],
},
{
    type = "Frame",
    size = { 296, 10, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "$2616",
    name = "btnProfile",
    width = 272,
    onMouseClicked = [[
					UI_SetNextScreen("UserProfile", "NewMainMenu");
					UI_SetPreviousScreen("UserProfile", "NewMainMenu");
					UI_ShowScreen("UserProfile", eTransition);
				]],
},
{
    type = "Frame",
    size = { 296, 10, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "$2607",
    name = "btnOptions",
    width = 272,
    onMouseClicked = [[UI_ShowScreen("FEGameOptions", eTransition)]],
},
{
    type = "Frame",
    size = { 296, 10, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "$2609",
    name = "btnExit",
    width = 272,
    onMouseClicked = "UI_ExitApp();", },
},
{
    type = "Frame",
    size = { 296, 10, }, 
},
},
{
    type = "TextLabel",
    name = "lblVersion",
    position = { 12, 250, },
    size = {300, 20},
    Text =
    {
        textStyle = "FEHeading3",
        text = "v4.1",
        color = { 0, 0, 0, 255, },
        hAlign = "Center",
    },
},
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    name = "btnCampaign",
    position = { 2000, 0, },
    enabled = 0,
    width = 0,
},
}

