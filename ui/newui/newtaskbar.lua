function NewTaskbarCreatePrimaryButton(name, text, position, size, onClick, hotKeyID, helpTip, extra)
	local btn = {
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3", -- Common border color
		position = position,
		size = size,
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255}, -- Default over color
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle", -- Default text style
			text = text,
		},
		name = name,
		onMouseClicked = onClick,
		helpTip = helpTip,
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = hotKeyID,
		-- Bugfix: this is needed because of wierd states that arise from closing the strike menu while over the button
		clickedTextColor = { 0, 0, 0, 255},
		ClickedGraphic = {
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV = { 0, 0, 64, 13 },
		},
	}
	
	if extra then
		if extra.textStyle then
			btn.Text.textStyle = extra.textStyle
		end
		if extra.visible then
			btn.visible = extra.visible
		end
		if extra.toggleButton then
			btn.toggleButton = extra.toggleButton
		end
		if extra.overColor then
			btn.overColor = extra.overColor
		end
		if extra.disabledTextColor then
			btn.disabledTextColor = extra.disabledTextColor
		end
		if extra.DisabledGraphic then
			btn.DisabledGraphic = extra.DisabledGraphic
		end
		if extra.onMousePressed then
			btn.onMousePressed = extra.onMousePressed
		end
		if extra.soundOnClicked then
			btn.soundOnClicked = extra.soundOnClicked
		end
		if extra.soundOnPressed then
			btn.soundOnPressed = extra.soundOnPressed
		end
	end
	
	return btn
end

function NewTaskbarCreateDummyButton(pName)
	return {
		type = "Button",
		name = pName,
		position = {0, 0},
		size = {0, 0},
		giveParentMouseInput = 1,
		visible = 0,
	}
end

function NewTaskbarCreateShipButton(pName, pPositionX, pPositionY, pWidth, pHeight)
	return {
		type = "Button",
		buttonStyle = "Taskbar_ShipButtonStyle",
		name = pName,
		size = { pWidth, pHeight },
		position = { pPositionX, pPositionY },
	}
end

function NewTaskbarCreateShipButtonsFrame(pName, pPositionX, pPositionY, pFrameWidth, pFrameHeight, pPadding)
	-- Frame is always centered in its parent.
	local frameWidthWithPadding = pFrameWidth - (pPadding * 2); -- Centered frame

	-- We're fixed to showing 14 ship buttons at a time due to hacks in the engine targeting these elements.
	local shipButtonWidth = frameWidthWithPadding / 14;
	local shipButtonHeight = pFrameHeight;

	return {
		type = "Frame",
		name = pName,
		position = {pPositionX, pPositionY},
		size = { frameWidthWithPadding, pFrameHeight},
		;

		-- first row
		NewTaskbarCreateShipButton("btnShip01", 0, 0, shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip02", shipButtonWidth, 0, shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip03", shipButtonWidth * 2, 0, shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip04", shipButtonWidth * 3, 0, shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip05", shipButtonWidth * 4, 0, shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip06", shipButtonWidth * 5, 0, shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip07", shipButtonWidth * 6, 0, shipButtonWidth, shipButtonHeight),

		-- second row
		NewTaskbarCreateShipButton("btnShip08", shipButtonWidth * 7, 0, shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip09", shipButtonWidth * 8, 0, shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip10", shipButtonWidth * 9, 0, shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip11", shipButtonWidth * 10, 0, shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip12", shipButtonWidth * 11, 0, shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip13", shipButtonWidth * 12, 0, shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip14", shipButtonWidth * 13, 0, shipButtonWidth, shipButtonHeight),
	}
end

function NewTaskbarCreateShipSubsystemButton(pName, pPositionX, pPositionY, pWidth, pHeight)
	return {
		type = "Button",
		name = pName,
		buttonStyle = "Taskbar_SubsystemButtonStyle",
		size = { pWidth, pHeight },
		position = { pPositionX, pPositionY },
		;
		{
			type = "Frame",
			name = "icon",
			size = { pWidth, pHeight, },
			giveParentMouseInput = 1,
		},
	}
end

function NewTaskbarCreateShipSubsystemsButtonsFrame(pName, pPositionX, pPositionY, pFrameWidth, pFrameHeight)
	-- We're fixed to displaying 12 subsystem buttons due to hacks in the engine targeting these elements.
	local subsystemButtonWidth = pFrameWidth / 6;
	local subsystemButtonHeight = pFrameHeight / 2;

	return {
		type = "Frame",
		name = pName,
		position = { pPositionX, pPositionY },
		size = { pFrameWidth, pFrameHeight },
		;
		-- Top Row
		NewTaskbarCreateShipSubsystemButton("subsystem1", 0, 0, subsystemButtonWidth, subsystemButtonHeight),
		NewTaskbarCreateShipSubsystemButton("subsystem2", subsystemButtonWidth, 0, subsystemButtonWidth, subsystemButtonHeight),
		NewTaskbarCreateShipSubsystemButton("subsystem3", subsystemButtonWidth * 2, 0, subsystemButtonWidth, subsystemButtonHeight),
		NewTaskbarCreateShipSubsystemButton("subsystem4", subsystemButtonWidth * 3, 0, subsystemButtonWidth, subsystemButtonHeight),
		NewTaskbarCreateShipSubsystemButton("subsystem5", subsystemButtonWidth * 4, 0, subsystemButtonWidth, subsystemButtonHeight),
		NewTaskbarCreateShipSubsystemButton("subsystem6", subsystemButtonWidth * 5, 0, subsystemButtonWidth, subsystemButtonHeight),
		-- Bottom Row
		NewTaskbarCreateShipSubsystemButton("subsystem7", 0, subsystemButtonHeight, subsystemButtonWidth, subsystemButtonHeight),
		NewTaskbarCreateShipSubsystemButton("subsystem8", subsystemButtonWidth, subsystemButtonHeight, subsystemButtonWidth, subsystemButtonHeight),
		NewTaskbarCreateShipSubsystemButton("subsystem9", subsystemButtonWidth * 2, subsystemButtonHeight, subsystemButtonWidth, subsystemButtonHeight),
		NewTaskbarCreateShipSubsystemButton("subsystem10", subsystemButtonWidth * 3, subsystemButtonHeight, subsystemButtonWidth, subsystemButtonHeight),
		NewTaskbarCreateShipSubsystemButton("subsystem11", subsystemButtonWidth * 4, subsystemButtonHeight, subsystemButtonWidth, subsystemButtonHeight),
		NewTaskbarCreateShipSubsystemButton("subsystem12", subsystemButtonWidth * 5, subsystemButtonHeight, subsystemButtonWidth, subsystemButtonHeight),
	}
end

function NewTaskbarCreateShipStatsLabel(pName, pText, pPositionX, pPositionY, pSizeX, pSizeY)
	return {
		type = "TextLabel",
		position = {pPositionX, pPositionY},
		size = {pSizeX, pSizeY},
		wrapping = 1,
		autosize = 1,
		Text = {
			text = pText,
			textStyle = "Taskbar_MenuButtonTextStyle",
			color = { 0, 0, 0, 255},
			hAlign = "Left",
			vAlign = "Top",
		},
		name = pName,
	};
end

function NewTaskbarCreateShipStatsLabelFrame(pName, pPositionX, pPositionY, pSizeX, pSizeY)
	local labelWidth = pSizeX / 10;
	local statWidth = labelWidth * 4;

	return {
		type = "Frame",
		position = { pPositionX, pPositionY },
		size = { pSizeX, pSizeY },
		name = pName,
		;
		NewTaskbarCreateShipStatsLabel("unitnamelabel", "$2708", 0, 0, labelWidth, pSizeY),
		NewTaskbarCreateShipStatsLabel("unitname", nil, labelWidth, 0, statWidth, pSizeY),
		NewTaskbarCreateShipStatsLabel("unitrolelabel", "$2709", labelWidth + statWidth, 0, labelWidth, pSizeY),
		NewTaskbarCreateShipStatsLabel("unitrole", nil, labelWidth + statWidth + labelWidth, 0, statWidth, pSizeY),
	};
end

function NewTaskbarCreateShipStatsIndicator(pName, pHelpTip, pPositionX, pPositionY, pSizeX, pSizeY)

	local iconTextureUVMap = {
		["unitmaxspeed"] = { 0, 0, 9, 9 },
		["unitattackdamage"] = { 11, 0, 20, 9 },
		["unitshields"] = { 22, 0, 31, 9 },
	};

	return {
		type = "Frame",
		name = pName .. "frame",
		size = { pSizeX, pSizeY },
		helpTip = pHelpTip,
		helpTipTextLabel = "commandsHelpTip",
		;
		{
			type = "Frame",
			position = {5, 3},
			size = {9, 9},
			BackgroundGraphic = {
				texture = "DATA:UI\\NewUI\\Taskbar\\stats_icons.mres",
				textureUV = iconTextureUVMap[pName] or iconTextureUVMap["unitmaxspeed"],
			},
		},
		{
			type = "TextLabel",
			position = {19, 1},
			size = {49, 13},
			Text = {
				textStyle = "Taskbar_MenuButtonTextStyle",
				color = { 0, 0, 0, 255},
				hAlign = "Left",
				vAlign = "Center",
			},
			name = pName,
		},
	};
end

function NewTaskbarCreateShipStatsIndicatorFrame(pName, pPositionX, pPositionY, pSizeX, pSizeY)
	return {
		type = "Frame",
		position = { pPositionX, pPositionY },
		autosize = 1,
		autoarrange = 1,
		autoarrangeWidth = 300,
		;
		NewTaskbarCreateShipStatsIndicator("unitmaxspeed", "$2711", nil, nil, 67, 15),
		NewTaskbarCreateShipStatsIndicator("unitattackdamage", "$2710", nil, nil, 67, 15),
		NewTaskbarCreateShipStatsIndicator("unitshields", "$2770", nil, nil, 67, 15),
	};
end

function NewTaskbarCreateShipDetailsFrame(pName, pPositionX, pPositionY, pSizeX, pSizeY)
	return {
		type = "Frame",
		position = {pPositionX, pPositionY},
		size = {pSizeX, pSizeY},
		name = pName,
		;

		-- ship icon
		{
			type = "Button",
			position = {(pSizeX / 2) - 50, 0},
			size = {100, 30},
			name = "unitIcon",
			backgroundGraphicHAlign = "Center",
			backgroundGraphicVAlign = "Center",
		},
		-- ship health
		{
			type = "ProgressBar",
			backgroundColor = { 0, 128, 0, 255},
			progressColor = { 0, 255, 0, 255},
			borderColor = { 0, 0, 0, 255},
			outerBorderWidth = 1,
			position = { (pSizeX / 2) - 50, 25 },
			size = { 100, 2},
			name = "unitProgress",
		},

		{
			type = "Frame",
			position = { pSizeX - 6 * 20, 0},
			size = { 6 * 20, pSizeY },
			;
			-- subsystems
			NewTaskbarCreateShipSubsystemsButtonsFrame("subsystems", 0, 0, 6 * 20, pSizeY),

			-- subsystem buttons to copy graphics from when filling above subsystem list
			{
				type = "Button",
				name = "subsystem_production",
				visible = 0,
				size = { 32, 24},
				borderWidth = 1,
				borderColor = "TPOFBlack",
				helpTip = "$2811",
				soundOnClicked = "SFX_ButtonClick",
			},
			{
				type = "Button",
				name = "subsystem_sensor",
				visible = 0,
				size = { 32, 24},
				borderWidth = 1,
				borderColor = "TPOFBlack",
				helpTip = "$2813",
				soundOnClicked = "SFX_ButtonClick",
			},
			{
				type = "Button",
				name = "subsystem_generic",
				visible = 0,
				size = { 32, 24},
				borderWidth = 1,
				borderColor = "TPOFBlack",
				helpTip = "$2812",
				soundOnClicked = "SFX_ButtonClick",
			},
			{
				type = "Button",
				name = "subsystem_innate",
				visible = 0,
				size = { 32, 24},
				borderWidth = 1,
				borderColor = "TPOFBlack",
				helpTip = "$2814",
				soundOnClicked = "SFX_ButtonClick",
			},

			{
				type = "Frame",
				name = "subsystemselected",
				position = { 93, 7},
				size = { 159, 45},
				BackgroundGraphic = {
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_pointer_tpof.tga",
					textureUV = { 0, 0, 159, 45 },
				},
				;

				{
					type = "Frame",
					position = {104, 9},
					size = {64, 32},
					name = "subsystemIcon",
				},
				{
					type = "ProgressBar",
					backgroundColor = { 0, 128, 0, 255},
					progressColor = { 0, 255, 0, 255},
					position = { 111, 6},
					size = { 40, 2},
					name = "subsystemProgress",
				},
			},
		},

		-- stats labels
		NewTaskbarCreateShipStatsLabelFrame("unitstatslabelframe", 3, 3, 200, pSizeY / 2),

		-- stat indicators
		NewTaskbarCreateShipStatsIndicatorFrame("unitstatsindicatorsframe", 3, (pSizeY / 2), nil, nil),
	};
end

function NewTaskbarCreateMenuBar(pName, pPositionX, pPositionY, pSizeX, pSizeY)
	return {
		type = "Frame",
		name = "menubar",
		position = {pPositionX, pPositionY},
		size = { pSizeX, pSizeY},
		giveParentMouseInput = 1,
		;

		--Background
		{
			type = "Frame",
			outerBorderWidth = 1,
			borderColor = "FEColorHeading3",
			backgroundColor = "IGColorBackground1",
			BackgroundGraphic =
			{
			texture = "DATA:UI\\NewUI\\Textures\\gradient.tga",
			textureUV =
				{ 0, 0, 600, 600, }, },
			position = {0, 1},
			size = { pSizeX, pSizeY - 1},
			giveParentMouseInput = 1,
		},

		-- Fleet button
		NewTaskbarCreatePrimaryButton("btnFleet", "$2705", {10, 1}, {40, 18.5}, "UI_ToggleScreen( 'FleetMenu', 0)", nil, "$2740", {toggleButton=1}), -- FLEET

		-- Strike group button
		NewTaskbarCreatePrimaryButton("btnStrike", "$2714", {60, 1}, {40, 18.5}, nil, nil, "$2741", {toggleButton=1, onMousePressed="UI_ToggleScreen( 'StrikeGroupsMenu', 0)", soundOnClicked="", soundOnPressed="SFX_ButtonClick"}), -- STRIKE GRP

		-- Tactics button
		NewTaskbarCreatePrimaryButton("btnTactics", "$2715", {110, 1}, {40, 18.5}, nil, nil, "$2742", {toggleButton=1, onMousePressed="UI_ToggleScreen( 'TacticsMenu', 0)", soundOnClicked="", soundOnPressed="SFX_ButtonClick"}), -- TACTICS

		-- Orders button
		NewTaskbarCreatePrimaryButton("btnOrders", "[ORDERS]", {160, 1}, {40, 18.5}, "UI_ToggleScreen( 'OrdersMenu', 0)", 150, "$2729", {toggleButton=1}), -- ORDERS

		-- Events button
		NewTaskbarCreatePrimaryButton("btnEvents", "$2707", {315, 1}, {50, 18.5}, "UI_ToggleScreen( 'EventsScreen', 0)", 140, "$2743", {textStyle="Taskbar_MenuButtonTextStyle"}), -- EVENTS

		-- Events button (wide version)
		NewTaskbarCreatePrimaryButton("btnEvents_wide", "$2707", {315, 1}, {50, 18.5}, "UI_ToggleScreen( 'EventsScreen', 0)", 140, "$2743", {visible=0}), -- EVENTS

		-- Objectives button
		NewTaskbarCreatePrimaryButton("btnObjectives", "GOALS", {255, 1}, {50, 18.5}, "UI_ToggleScreen( 'ObjectivesList', 0)", 137, "$2744"), -- OBJECTIVES

		-- Chat button
		NewTaskbarCreatePrimaryButton("btnChat", "$2716", {255, 1}, {50, 18.5}, "UI_ToggleScreen( 'ChatScreen', 0)", 131, "$2747"), -- CHAT

		-- Sensors button
		NewTaskbarCreatePrimaryButton("btnSensors", "$2703", {375, 1}, {50, 18.5}, "MainUI_UserEvent( eSensorsManager)", 54, "$2745", {textStyle="Taskbar_MenuButtonTextStyle"}), -- SENSORS

		-- Diplomacy button
		NewTaskbarCreatePrimaryButton("btnDiplomacy", "$2713", {495, 1}, {50, 18.5}, "UI_ToggleScreen( 'DiplomacyScreen', 0)", 141, "$2746"), -- DIPLOMACY

		-- Speech recall button
		NewTaskbarCreatePrimaryButton("btnRecall", "$2762", {495, 1}, {50, 18.5}, "UI_ToggleScreen( 'SpeechRecall', 0)", 142, "$2763", {visible=0}), -- RECALL

		-- Menu button
		NewTaskbarCreatePrimaryButton("btnMenu", "$2702", {435, 1}, {50, 18.5}, "MainUI_UserEvent( eMenu )", 4, "$2774", {toggleButton=0}), -- MENU

		-- Menu button (wide version)
		NewTaskbarCreatePrimaryButton("btnMenu_wide", "$2702", {435, 1}, {50, 18.5}, "MainUI_UserEvent( eMenu )", 4, "$2774", {visible=0, toggleButton=0, textStyle="Taskbar_MenuButtonTextStyle"}), -- MENU

		-- Build button
		NewTaskbarCreatePrimaryButton("btnBuild", "$2700", {595, 1}, {50, 18.5}, "MainUI_UserEventData( eBuildManager, 1)", 50, "$2748", {toggleButton=1, overColor={ 127, 127, 127, 127}}), -- BUILD

		-- Research button
		NewTaskbarCreatePrimaryButton("btnResearch", "$2701", {655, 1}, {50, 18.5}, "MainUI_UserEvent( eResearchManager)", 49, "$2749", {toggleButton=1}),

		-- Launch button
		NewTaskbarCreatePrimaryButton("btnLaunch", "$2706", {715, 1}, {50, 18.5}, "MainUI_UserEventData( eLaunchManager, 1)", 52, "$2760", {toggleButton=1}), -- LAUNCH

		--Return
		NewTaskbarCreatePrimaryButton("btnShipBack", "<<<", {775, 1}, {15, 18.5}, nil, 52, "$2732", {toggleButton=0, textStyle="Taskbar_PanelButtonTextStyleCarrot", disabledTextColor={0,0,0,0}}), -- LAUNCH

		--Show button (Disabled)
		NewTaskbarCreatePrimaryButton("btnHide2", "^", {784, -55}, {15, 18.5}, nil, 55, "$2739", {visible=0, toggleButton=1, overColor={ 127, 127, 127, 127}}), -- LAUNCH

		--Hide Button (Disabled)
		NewTaskbarCreatePrimaryButton("btnHide1", "^", {784, -55}, {15, 18.5}, nil, 55, "$2739", {visible=0, toggleButton=1, overColor={ 127, 127, 127, 127}}), -- LAUNCH
	};
end

function NewTaskbarCreateSelectionBar(pName, pPositionX, pPositionY, pSizeX, pSizeY)
	return {
		type = "Frame",
		name = pName,
		position = { pPositionX, pPositionY },
		size = { pSizeX, pSizeY },
		outerBorderWidth = 1,
		backgroundColor = "IGColorBackground1",
		borderColor = "FEColorHeading3",
		BackgroundGraphic =
		{
			texture = "Data:UI\\NewUI\\Textures\\Gradient.tga",
			textureUV =
		{ 0, 0, 600, 600, }, },
		;

		-- Ship buttons
		NewTaskbarCreateShipButtonsFrame("shipButtonsFrame", 11, 0, pSizeX, pSizeY, 10),

		-- next/prev ship buttons
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			position = {pSizeX - 10, 0},
			size = {10, 30},
			name = "btnShipNext",
			Text = {
				font = "ChatFont",
				text = "",
				color = "TPOFBlack",
				hAlign = "Left",
				vAlign = "Top", 
			},
			helpTip = "$2730",
			helpTipTextLabel = "commandsHelpTip",
			soundOnClicked = "SFX_ButtonClick",
		},
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			position = {0, 0},
			size = {10, 30},
			name = "btnShipPrev",
			Text = {
				textStyle = "Taskbar_PanelButtonTextStyle",
				text = "",
			},
			helpTip = "$2731",
			helpTipTextLabel = "commandsHelpTip",
			soundOnClicked = "SFX_ButtonClick",
		},

		-- Ship details
		NewTaskbarCreateShipDetailsFrame("unitStats", 0, 0, pSizeX, pSizeY),

		-- Required elements.
		-- black background
		{
			type = "Frame",
			name = "blackBg",
			position = {0, 16},
			size = { 0, 0}, --800,86
			backgroundColor = { 0, 0, 0, 0 },
			giveParentMouseInput = 1,
		},
		-- Command Dummy Buttons
		NewTaskbarCreateDummyButton("btnMove"),
		NewTaskbarCreateDummyButton("btnAttack"),
		NewTaskbarCreateDummyButton("btnAttackMove"),
		NewTaskbarCreateDummyButton("btnGuard"),
		NewTaskbarCreateDummyButton("btnDock"),
		NewTaskbarCreateDummyButton("btnCancelOrders"),
		NewTaskbarCreateDummyButton("btnWaypoint"),
		NewTaskbarCreateDummyButton("btnResource"),
		NewTaskbarCreateDummyButton("btnHyperspace"),
		NewTaskbarCreateDummyButton("btnRetire"),
		-- Special Command Dummy Buttons
		NewTaskbarCreateDummyButton("btnPing"),
		NewTaskbarCreateDummyButton("btnEMP"),
		NewTaskbarCreateDummyButton("btnDefenseField"),
		NewTaskbarCreateDummyButton("btnCloak"),
		NewTaskbarCreateDummyButton("btnScuttleConfirm"),
		NewTaskbarCreateDummyButton("btnRepair"),
		NewTaskbarCreateDummyButton("btnMines"),
		NewTaskbarCreateDummyButton("btnRally"),
		NewTaskbarCreateDummyButton("btnRallyObject"),
		NewTaskbarCreateDummyButton("btnScuttle"),
   };
end

NEW_TASKBAR_WIDTH = 500
NEW_TASKBAR_HEIGHT = 30

NewTaskbar = {
	size = {0, 545, 800, 62}, --was 0, 498, 800, 102
	stylesheet = "HW2StyleSheet",

	-- Flags
	pixelUVCoords = 1, -- Enter pixel coords for texture coords
	callUpdateWhenInactive = 1,

	-- custom
	minimizedPos = { 0, 567 }, --0, 582
	fstringShipCount = "$2764",

	healthBarGoodColor = { 30, 252, 163, 255 }, -- "green-ish"
	healthBarPoorColor = { 215, 205, 0, 255 }, -- "yellow-ish"
	healthBarFatalColor = { 165, 0, 0, 255 }, -- "red-ish"
	healthBarBackgroundColor = { 128, 128, 128, 255},
	healthBarEnemyColor = { 252, 30, 141, 255 }, -- "red-ish"
	healthBarEnemyBackgroundColor = { 128, 0, 0, 255},
	healthBarAlliedBackgroundColor = {255,255,0,255},
	healthBarAlliedBackgroundColor = { 128, 0, 0, 255},

	soundOnShow = "SFX_TaksbarMenuONOFF",
	soundOn = "SFX_TaksbarMenuONOFF",
	backgroundColor = "TPOFGrayHalfTransparent",
	;

	NewTaskbarCreateMenuBar("menubar", 0, 36, 800, 21),

	-- Commands help tip label
	{
		type = "TextLabel",
		name = "commandsHelpTip",
		position = {4, NEW_TASKBAR_HEIGHT - 8 },
		size = { 214, 13},
		Text = {
			textStyle = "Taskbar_MenuButtonTextStyle",
			color = { 255, 255, 255, 255},
			hAlign = "Left",
		},
	},

	NewTaskbarCreateSelectionBar("taskbar", 400 - NEW_TASKBAR_WIDTH / 2, 1, NEW_TASKBAR_WIDTH, NEW_TASKBAR_HEIGHT),
}
