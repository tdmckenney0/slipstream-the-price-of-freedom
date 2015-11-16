--Copyright Tanner "Emperor" Mckenney
dofilepath("data:engine/version.lua")
Manual =
{
    size = { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    pixelUVCoords = 1,
	;

	{
	   type = "Frame",
	   name = "SkipButton",
	   visible = 1,
	   position =  { 700, 580},
	   size = {75, 12},
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
			type = "TextButton",
			buttonStyle = "FEButtonStyle1",
			text = "Skip",
			name = "btnSkipToMenu",
			enabled = 1,
			width = 75,
			onMouseClicked = [[UI_ShowScreen("NewMainMenu", eTransition)]],
		},
	},
}
