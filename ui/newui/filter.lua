--Filter is currently disabled!
Filter =
{
    size =
        { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    RootElementSettings = {	},
	clickThrough = 1,
    pixelUVCoords = 1,
	onShow = [[
				zLStart = 215
			 ]],
	onUpdate = [[
					UI_SetElementPosition("NewLaunchMenu","launch",zLStart,0);

					if(zLStart == 15) then
						zLStart = 0
					end

					if(zLStart > 0) then
						zLStart = zLStart - 20
					end
			   ]],
;
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
