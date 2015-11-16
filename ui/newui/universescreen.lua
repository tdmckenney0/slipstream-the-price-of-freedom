--Copyright Tanner "Emperor" Mckenney
UniverseScreen =
{
    size =
        { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    RootElementSettings =
    {
        backgroundColor =
            { 0, 0, 0, 255, }, },
    pixelUVCoords = 1,
	onShow = [[
				MapX = -1648
				MapY = -1748
				MapXCur = MapX
				MapYCur = MapY

				UI_SetElementPosition("UniverseScreen","Map2",MapX,MapY)
			 ]],
	onUpdate = [[

				if(MapXCur < MapX) then
					MapXCur = MapXCur + 5
				end

				if(MapXCur > MapX) then
					MapXCur = MapXCur - 5
				end

				if(MapYCur > MapY) then
					MapYCur = MapYCur - 5
				end

				if(MapYCur < MapY) then
					MapYCur = MapYCur + 5
				end

				UI_SetElementPosition("UniverseScreen","Map2",MapXCur,MapYCur)

			   ]],
;
{
		type = "Frame",
		name = "Map1",
		visible = 1,
		position = {-50, -150},
		size = {900, 900},
		BackgroundGraphic = {
			type = "Graphic",
			size = {900, 900},
			color = { 255, 255, 255, 255, },
			textureUV = {0,0,4096,4096},
			texture = "Data:UI\\NewUI\\Textures\\galaxymap.tga",
						},
},
{
		type = "Frame",
		name = "Map2",
		visible = 0,
		position = {0, 0},
		size = {4096, 4096},
		BackgroundGraphic = {
			type = "Graphic",
			size = {4096, 4096},
			color = { 255, 255, 255, 255, },
			textureUV = {0,0,4096,4096},
			texture = "Data:UI\\NewUI\\Textures\\galaxymap.tga",
						},
},


--Bottom Navigation Screen
		{
			type = "Frame",
			outerBorderWidth = 1,
			borderColor = "FEColorHeading3",
			BackgroundGraphic =
			{
			texture = "Data:UI\\NewUI\\Textures\\Gradient.tga",
			textureUV =
            { 0, 0, 600, 600, }, },
			backgroundColor = "FEColorBackground1",
			position = {12,544},
			size = {776,44},
			name = "frmRootbottombigfrm",
			;
			-- OUTLINE FRAME
			{
				type = "Frame",
				borderWidth = 2,
				borderColor = "FEColorOutline",
				position = {2,2},
				size = {772,40},
				name = "frmbottomframe",
				;

				-- HELP TEXT
				{
					type = "TextLabel",
					position = {4,4},
					size = {764,13},
					name = "txtLblHELPTEXT",
					Text =
					{
						textStyle = "FEHelpTipTextStyle",
					},
					;
				},

				-- LINE
				{
					type = "Line",
					above = 0,
					lineWidth = 2,
					color = "FEColorOutline",
					p1 = {2, 19},
					p2 = {770, 19},

				},

				-- BUTTONS

				--DEFINITION FOR: (txtBtn) BACK
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					position = {4,23},
					name = "txtBtnBACK",
					helpTip = "$3468",
					helpTipTextLabel = "txtLblHELPTEXT",
					Text =
					{
						-- BACK
						text = "$2610",
						textStyle = "FEButtonTextStyle",
					},
					onMouseClicked = [[UI_ShowScreen("NewMainMenu", eTransition)]],
					;
				},
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					position = {652,23},
					enabled = 0,
					name = "txtBtnRIGHT",
					helpTip = "Move the Map Right",
					helpTipTextLabel = "txtLblHELPTEXT",
					Text =
					{
						-- BACK
						text = "RIght",
						textStyle = "FEButtonTextStyle",
					},
					onMouseClicked = [[
										MapX = MapX - 200
									 ]],
					;
				},
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					position = {530,23},
					name = "txtBtnLEFT",
					enabled = 0,
					helpTip = "Move the Map Left",
					helpTipTextLabel = "txtLblHELPTEXT",
					Text =
					{
						-- BACK
						text = "Left",
						textStyle = "FEButtonTextStyle",
					},
					onMouseClicked = [[
										MapX = MapX + 200
									 ]],
					;
				},
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					position = {408,23},
					name = "txtBtnDOWN",
					enabled = 0,
					helpTip = "Move the Map Down",
					helpTipTextLabel = "txtLblHELPTEXT",
					Text =
					{
						-- BACK
						text = "Down",
						textStyle = "FEButtonTextStyle",
					},
					onMouseClicked = [[
										MapY = MapY - 200
									 ]],
					;
				},
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					position = {286,23},
					name = "txtBtnUP",
					enabled = 0,
					helpTip = "Move the Map Up",
					helpTipTextLabel = "txtLblHELPTEXT",
					Text =
					{
						-- BACK
						text = "Up",
						textStyle = "FEButtonTextStyle",
					},
					onMouseClicked = [[
										MapY = MapY + 200
									 ]],
					;
				},
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					size = {242, 13, },
					enabled = 0,
					position = {530,8},
					name = "txtBtnRESET",
					helpTip = "Reset the Map",
					helpTipTextLabel = "txtLblHELPTEXT",
					Text =
					{
						-- BACK
						text = "Reset",
						textStyle = "FEButtonTextStyle",
					},
					onMouseClicked = [[
								MapX = -1648
								MapY = -1748
									 ]],
					;
				},
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					size = {242, 13, },
					position = {286,8},
					name = "txtBtnTOGBG",
					helpTip = "Toggle Galaxy Overlay",
					helpTipTextLabel = "txtLblHELPTEXT",
					Text =
					{
						-- BACK
						text = "Zoom (+)",
						textStyle = "FEButtonTextStyle",
					},
					onMouseClicked = [[
										UI_SetElementVisible("UniverseScreen", "Map2", 1)
										UI_SetElementVisible("UniverseScreen", "Map1", 0)
										UI_SetElementVisible("UniverseScreen", "txtBtnTOGBG", 0)
										UI_SetElementVisible("UniverseScreen", "txtBtnTOGBG2", 1)
										
										MapX = -1648
										MapY = -1748
										
										MapXCur = MapX
										MapYCur = MapY
										
										UI_SetElementPosition("UniverseScreen","Map2", MapX, MapY)
										
										UI_SetElementEnabled("UniverseScreen", "txtBtnRIGHT", 1)
										UI_SetElementEnabled("UniverseScreen", "txtBtnLEFT", 1)
										UI_SetElementEnabled("UniverseScreen", "txtBtnUP", 1)
										UI_SetElementEnabled("UniverseScreen", "txtBtnDOWN", 1)
										UI_SetElementEnabled("UniverseScreen", "txtBtnRESET", 1)
										
								 ]],
					;
				},
				{
					type = "TextButton",
					buttonStyle = "FEButtonStyle1",
					visible = 0,
					size = {242, 13, },
					position = {286,8},
					name = "txtBtnTOGBG2",
					helpTip = "Toggle Galaxy Overlay",
					helpTipTextLabel = "txtLblHELPTEXT",
					Text =
					{
						-- BACK
						text = "Zoom (-)",
						textStyle = "FEButtonTextStyle",
					},  --255, 255, 255, 255,
					onMouseClicked = [[
										UI_SetElementVisible("UniverseScreen", "Map2", 0)
										UI_SetElementVisible("UniverseScreen", "Map1", 1)
										UI_SetElementVisible("UniverseScreen", "txtBtnTOGBG", 1)
										UI_SetElementVisible("UniverseScreen", "txtBtnTOGBG2", 0)
										
										MapX = -1648
										MapY = -1748
										
										MapXCur = MapX
										MapYCur = MapY
										
										UI_SetElementPosition("UniverseScreen","Map2", MapX, MapY)
										
										UI_SetElementEnabled("UniverseScreen", "txtBtnRIGHT", 0)
										UI_SetElementEnabled("UniverseScreen", "txtBtnLEFT", 0)
										UI_SetElementEnabled("UniverseScreen", "txtBtnUP", 0)
										UI_SetElementEnabled("UniverseScreen", "txtBtnDOWN", 0)
										UI_SetElementEnabled("UniverseScreen", "txtBtnRESET", 0)
							           ]],
					;
				},
			},
		},
}
