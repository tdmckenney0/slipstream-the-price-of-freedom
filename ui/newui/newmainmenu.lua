dofilepath("data:engine/version.lua")
NewMainMenu =
{
    size = { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    RootElementSettings =
    {
	backgroundColor = { 0, 0, 0, 0, }, 
    },
    pixelUVCoords = 1,
    onShow = [[
    
		   ]],
     onUpdate = [[
			
		     ]],
;
{
   type = "Frame",
   name = "menubox",
   visible = 1,
   position =  { 237, 150},
   size = {325, 290},
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
  text = "Introduction",
  name = "btnIntro",
  width = 272,
  onMouseClicked = "UI_ShowScreen('Credits', eTransition);",
},
{
    type = "Frame",
    size = { 296, 10, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "Galactic Map",
    name = "btnUniverse",
    enabled = 1,
    width = 272,
    onMouseClicked = "UI_ShowScreen('UniverseScreen', eTransition);",
},
{
    type = "Frame",
    size = { 296, 10, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "Skirmish Battles",
    name = "btnPlayerVsCPU",
    width = 272,
    onMouseClicked = [[
					MenuBoxTarget = 820
				]],
},
{
    type = "Frame",
    size = { 296, 10, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "Local & Online Multiplayer",
    name = "btnMultiplayer",
    width = 272,
    onMouseClicked = "UI_ShowScreen('ConnectionType', eTransition);",
},
{
    type = "Frame",
    size = { 296, 10, },
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    text = "Player Profile Management",
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
    text = "Game Settings",
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
    text = "Quit to Desktop",
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
    position = { 12, 273, },
    size = {300, 20},
    Text =
    {
        textStyle = "FEHeading3",
        text = "December 2024",
        color = { 0, 0, 0, 255, },
        hAlign = "Center",
    },
},
},
{
   type = "Frame",
   name = "XiLogo",
   visible = 1,
   position =  { 384, 565},
   size = {32, 32},
   BackgroundGraphic = 
   {
	type = "Graphic",
	size = {32, 32},
	color = { 255, 255, 255, 255, },
	textureUV = {0,0,64,64},
	texture = "Data:UI\\xi_logo.tga",
   },
    onMouseClicked = [[UI_ShowScreen("CreditsScreen", eTransition)]],
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    name = "btnCampaign",
    position = { 2000, 0, },
    enabled = 0,
    width = 0,
},
{
    type = "TextButton",
    buttonStyle = "FEButtonStyle1",
    name = "btnTutorial",
    position = { 2000, 0, },
    enabled = 0,
    width = 0,
},
}

