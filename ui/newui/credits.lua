--Copyright Tanner "Emperor" Mckenney
dofilepath("data:engine/version.lua")
Credits =
{
    size = { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    pixelUVCoords = 1,
    onShow = [[ creditsRoleGo = 0 ]],
    onUpdate = [[
				creditsRoleGo = creditsRoleGo - 0.15

					if(creditsRoleGo < -2000 ) then
						UI_ShowScreen('NewMainMenu', eTransition);
					end
		
					UI_SetElementPosition("Credits","CreditsRole",0, creditsRoleGo);
			   ]],
;
{
    type = "Frame",
	name = "Introduction",
	visible = 1,
	backgroundColor =
            { 0, 0, 0, 0, },
	size =
        { 800, 600, },
    position =
        { 0, 0, },
;

{
    type = "Frame",
	name = "CreditsRole",
	visible = 1,
	backgroundColor =
            { 0, 0, 0, 255, },
	size =
        { 800, 5000, },
    position =
        { 0, 0, },
;
{
		type = "Frame",
		name = "SRILogo",
		visible = 1,
		position = {350, 200},
		size = {800, 400},
		BackgroundGraphic = {
			type = "Graphic",
			size = {100, 100},
			color =
            { 255, 255, 255, 255, },
			textureUV = {0,0,800,800},
			texture = "data:/ui/newui/textures/sri.tga",
		},
},
{
			type = "TextLabel",
			position = {150,300},
			size = {510,200},
			name = "SRIPRESENTS",
			Text =
			{
				-- TUTORIAL
				text = "SUB-REAL INDUSTRIES PRESENTS",
				font = "Heading3Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
		type = "Frame",
		name = "SSLogo",
		position = {200, 700},
		size = {400, 134},
		BackgroundGraphic = {
			type = "Graphic",
			size = {400, 134},
			textureUV = {0,0,800,267},
			texture = "data:/ui/newui/textures/logo.tga",
		},
},
{
			type = "TextLabel",
			position = {150,1000},
			size = {510,200},
			Text =
			{
				text = "The Year is 2681.",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1050},
			size = {510,200},
			Text =
			{
				text = "Mankind is on the eve of",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1100},
			size = {510,200},
			Text =
			{
				text = "Its Destruction.",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1200},
			size = {510,200},
			Text =
			{
				text = "The DSCG and UNCG Factions",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1250},
			size = {510,200},
			Text =
			{
				text = "Have been gridlocked in a",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1300},
			size = {510,200},
			Text =
			{
				text = "320-Year-Long War.",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1400},
			size = {510,200},
			Text =
			{
				text = "The DSCG's Thirst for the",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1450},
			size = {510,200},
			Text =
			{
				text = "Tsaraii Hammer of Light,",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1500},
			size = {510,200},
			Text =
			{
				text = "and the UNCG's drive for Power,",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1550},
			size = {510,200},
			Text =
			{
				text = "have worn humanity down",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
			type = "TextLabel",
			position = {150,1600},
			size = {510,200},
			Text =
			{
				text = "to only a handful of worlds.",
				font = "Heading1Font",
				color = "FEColorHeading1",
				vAlign = "Top",
				hAlign = "Center",
			},
},
{
		type = "Frame",
		name = "Fade1",
		visible = 1,
		position = {0, 0},
		size = {800, 600},
		BackgroundGraphic = {
			type = "Graphic",
			size = {800, 600},
			color =
            { 255, 255, 255, 255, },
			textureUV = {0,0,64,48},
			texture = "data:/art/fx/fade/fade_in.anim",
		},
},
},
},
{
   type = "Frame",
   name = "SkipButton",
   visible = 0,
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
    onMouseClicked = [[
				UI_SetElementVisible("Credits", "Introduction", 0)	
			     ]],
},
},
}