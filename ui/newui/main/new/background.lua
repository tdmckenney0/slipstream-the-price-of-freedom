Background =
{
	size = {0, 0, 800, 600},
	stylesheet = "HW2StyleSheet",
	RootElementSettings = {
	},
	pixelUVCoords = 1,
	onShow = [[
				xTarget = -800
				xCurPos = 0
				xBuffer = 0

				rand = random(21, 23)

				print("Random Music Variable is: "..rand)
			 ]],
	onUpdate = [[

				if rand == 1 then
					UI_PlaySound("Music_Slipstream_Ambient")
				elseif rand == 2 then
					UI_PlaySound("Music_The_Price_of_freedom")
				elseif rand == 3 then
					UI_PlaySound("Music_Gravity")
				elseif rand == 4 then
					UI_PlaySound("Music_Gravity")
				end

				UI_SetElementPosition("Background","text1",xCurPos,400)
				UI_SetElementPosition("Background","text2",xCurPos + 800,400)

				UI_SetElementPosition("Background","text3",(xCurPos / 2),225)
				UI_SetElementPosition("Background","text4",(xCurPos / 2) + 800,225)

				UI_SetElementPosition("Background","text5",(-(xCurPos / 3)),-100)
				UI_SetElementPosition("Background","text6",(-((xCurPos / 3) + 1600)),-100)

				UI_SetElementPosition("Background","text7",(xCurPos / 2),375)
				UI_SetElementPosition("Background","text8",(xCurPos / 2) + 800,375)

				UI_SetElementPosition("Background","text9",(-(xCurPos / 1.5)),500)
				UI_SetElementPosition("Background","text10",(-((xCurPos / 1.5) + 800)),500)

				if(xCurPos >= xTarget) then
					xCurPos = xCurPos - 0.1
				end

				xBuffer = xTarget - xCurPos

				if(xBuffer > -1) then
					UI_SetElementPosition("Background","text1",0,450)
					UI_SetElementPosition("Background","text2",800,450)
					xCurPos = 0
				end

			   ]],
	;

	{
		type = "Frame",
		visible = 1,
		position = {0, 0},
		size = {800, 600},
		BackgroundGraphic = {
			type = "Graphic",
			size = {800, 600},
			color =
            { 255, 255, 255, 255, },
			textureUV = {0,0,1600,1200},
			texture = "Data:UI\\NewUI\\Background\\menu1600.tga",
		},
	},

	{
		type = "Frame",
		name = "text1",
		visible = 1,
		position = {0, 400},
		size = {800, 50},
		BackgroundGraphic = {
			type = "Graphic",
			size = {800, 50},
			color =
            { 255, 255, 255, 23, },
			textureUV = {0,0,1600,100},
			texture = "Data:UI\\NewUI\\Background\\text1.tga",
		},
	},

	{
		type = "Frame",
		name = "text2",
		visible = 1,
		position = {800, 400},
		size = {800, 50},
		BackgroundGraphic = {
			type = "Graphic",
			size = {800, 50},
			color =
            { 255, 255, 255, 23, },
			textureUV = {0,0,1600,100},
			texture = "Data:UI\\NewUI\\Background\\text1.tga",
		},
	},

	{
		type = "Frame",
		name = "text3",
		visible = 1,
		position = {0, 225},
		size = {800, 25},
		BackgroundGraphic = {
			type = "Graphic",
			size = {800, 25},
			color =
            { 255, 255, 255, 15, },
			textureUV = {0,0,1600,100},
			texture = "Data:UI\\NewUI\\Background\\text1.tga",
		},
	},

	{
		type = "Frame",
		name = "text4",
		visible = 1,
		position = {800, 225},
		size = {800, 25},
		BackgroundGraphic = {
			type = "Graphic",
			size = {800, 25},
			color =
            { 255, 255, 255, 15, },
			textureUV = {0,0,1600,100},
			texture = "Data:UI\\NewUI\\Background\\text1.tga",
		},
	},

	{
		type = "Frame",
		name = "text5",
		visible = 1,
		position = {800, -100},
		size = {1600, 200},
		BackgroundGraphic = {
			type = "Graphic",
			size = {1600, 200},
			color =
            { 255, 255, 255, 10, },
			textureUV = {0,0,1600,100},
			texture = "Data:UI\\NewUI\\Background\\text1.tga",
		},
	},

	{
		type = "Frame",
		name = "text6",
		visible = 1,
		position = {800, -100},
		size = {1600, 200},
		BackgroundGraphic = {
			type = {1600, 200},
			color =
            { 255, 255, 255, 10, },
			textureUV = {0,0,1600,100},
			texture = "Data:UI\\NewUI\\Background\\text1.tga",
		},
	},

	{
		type = "Frame",
		name = "text7",
		visible = 1,
		position = {0, 375},
		size = {800, 35},
		BackgroundGraphic = {
			type = "Graphic",
			size = {800, 35},
			color =
            { 255, 255, 255, 23, },
			textureUV = {0,0,1600,100},
			texture = "Data:UI\\NewUI\\Background\\text1.tga",
		},
	},

	{
		type = "Frame",
		name = "text8",
		visible = 1,
		position = {800, 375},
		size = {800, 35},
		BackgroundGraphic = {
			type = "Graphic",
			size = {800, 35},
			color =
            { 255, 255, 255, 23, },
			textureUV = {0,0,1600,100},
			texture = "Data:UI\\NewUI\\Background\\text1.tga",
		},
	},

	{
		type = "Frame",
		name = "text9",
		visible = 1,
		position = {0, 500},
		size = {800, 25},
		BackgroundGraphic = {
			type = "Graphic",
			size = {800, 25},
			color =
            { 255, 255, 255, 15, },
			textureUV = {0,0,800,100},
			texture = "Data:UI\\NewUI\\Background\\text2.tga",
		},
	},

	{
		type = "Frame",
		name = "text10",
		visible = 1,
		position = {800,500},
		size = {800, 25},
		BackgroundGraphic = {
			type = "Graphic",
			size = {800, 25},
			color =
            { 255, 255, 255, 15, },
			textureUV = {0,0,800,100},
			texture = "Data:UI\\NewUI\\Background\\text2.tga",
		},
	},


	{
    type = "Frame",
	name = "Color_Test",
	visible = 0,
	position = {0, 0},
	size = {800, 600},
	backgroundColor =
            { 255, 255, 255, 128, },
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
}
