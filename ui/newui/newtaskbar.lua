BUILDCOLOR = {0,0,0,0}
RESEARCHCOLOR = {0,0,0,255}
LAUNCHCOLOR = {0,0,0,255}

NEW_TASKBAR_WIDTH = 500
NEW_TASKBAR_HEIGHT = 30

function CreateTaskbarButton(name, text, position, size, onClick, hotKeyID, helpTip, extra)
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

function NewTaskbarCreateShipButton(pName, pWidth, pHeight)
	return {
		type = "Button",
		buttonStyle = "Taskbar_ShipButtonStyle",
		name = pName,
		size = { pWidth, pHeight },
	}
end

function NewTaskbarCreateShipButtonsFrame(pName, pPositionX, pPositionY, pFrameWidth, pFrameHeight, pPadding)
	-- Frame is always centered in its parent.
	local frameWidthWithPadding = pFrameWidth - (pPadding * 2); -- Centered frame

	-- We're fixed to a grid of 7 columns and 2 rows due to hacks in the engine targeting these elements.
	local shipButtonWidth = frameWidthWithPadding / 7;
	local shipButtonHeight = pFrameHeight / 2;

	return {
		type = "Frame",
		name = pName,
		position = {pPositionX, pPositionY},
		size = { frameWidthWithPadding, pFrameHeight},
		autoarrange = 1,
		autoarrangeWidth = frameWidthWithPadding,
		autoarrangeSpace = 0,
		;

		-- first row
		NewTaskbarCreateShipButton("btnShip01", shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip02", shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip03", shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip04", shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip05", shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip06", shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip07", shipButtonWidth, shipButtonHeight),

		-- second row
		NewTaskbarCreateShipButton("btnShip08", shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip09", shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip10", shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip11", shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip12", shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip13", shipButtonWidth, shipButtonHeight),
		NewTaskbarCreateShipButton("btnShip14", shipButtonWidth, shipButtonHeight),
	}
end

NewTaskbar = {
	size = {0, 545, 800, 62}, --was 0, 498, 800, 102
	stylesheet = "HW2StyleSheet",

	-- Flags
	pixelUVCoords = 1, -- Enter pixel coords for texture coords
	callUpdateWhenInactive = 1,

	-- custom
	minimizedPos = { 0, 567 }, --0, 582
	fstringShipCount = "$2764",

	healthBarGoodColor = { 0, 255, 0, 255},
	healthBarPoorColor = { 255, 255, 0, 255},
	healthBarFatalColor = { 255, 0, 0, 255},
	healthBarBackgroundColor = { 128, 128, 128, 255},
	healthBarEnemyColor = { 255, 0, 0, 255},
	healthBarEnemyBackgroundColor = { 128, 0, 0, 255},
	healthBarAlliedBackgroundColor = {255,255,0,255},
	healthBarAlliedBackgroundColor = { 128, 0, 0, 255},

	soundOnShow = "SFX_TaksbarMenuONOFF",
	soundOn = "SFX_TaksbarMenuONOFF",
	backgroundColor = "TPOFGrayHalfTransparent",
	;

	{
		type = "Frame",
		name = "menubar",
		position = {0, 36},
		size = { 800, 21},
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
			size = { 800, 20},
			giveParentMouseInput = 1,
		},

		-- Fleet button
		CreateTaskbarButton("btnFleet", "$2705", {10, 1}, {40, 18.5}, "UI_ToggleScreen( 'FleetMenu', 0)", nil, "$2740", {toggleButton=1}), -- FLEET

		-- Strike group button
		CreateTaskbarButton("btnStrike", "$2714", {60, 1}, {40, 18.5}, nil, nil, "$2741", {toggleButton=1, onMousePressed="UI_ToggleScreen( 'StrikeGroupsMenu', 0)", soundOnClicked="", soundOnPressed="SFX_ButtonClick"}), -- STRIKE GRP

		-- Tactics button
		CreateTaskbarButton("btnTactics", "$2715", {110, 1}, {40, 18.5}, nil, nil, "$2742", {toggleButton=1, onMousePressed="UI_ToggleScreen( 'TacticsMenu', 0)", soundOnClicked="", soundOnPressed="SFX_ButtonClick"}), -- TACTICS

		-- Orders button
		CreateTaskbarButton("btnOrders", "[ORDERS]", {160, 1}, {40, 18.5}, "UI_ToggleScreen( 'OrdersMenu', 0)", 150, "$2729", {toggleButton=1}), -- ORDERS

		-- Events button
		CreateTaskbarButton("btnEvents", "$2707", {315, 1}, {50, 18.5}, "UI_ToggleScreen( 'EventsScreen', 0)", 140, "$2743", {textStyle="Taskbar_MenuButtonTextStyle"}), -- EVENTS

		-- Events button (wide version)
		CreateTaskbarButton("btnEvents_wide", "$2707", {315, 1}, {50, 18.5}, "UI_ToggleScreen( 'EventsScreen', 0)", 140, "$2743", {visible=0}), -- EVENTS

		-- Objectives button
		CreateTaskbarButton("btnObjectives", "GOALS", {255, 1}, {50, 18.5}, "UI_ToggleScreen( 'ObjectivesList', 0)", 137, "$2744"), -- OBJECTIVES

		-- Chat button
		CreateTaskbarButton("btnChat", "$2716", {255, 1}, {50, 18.5}, "UI_ToggleScreen( 'ChatScreen', 0)", 131, "$2747"), -- CHAT

		-- Sensors button
		CreateTaskbarButton("btnSensors", "$2703", {375, 1}, {50, 18.5}, "MainUI_UserEvent( eSensorsManager)", 54, "$2745", {textStyle="Taskbar_MenuButtonTextStyle"}), -- SENSORS

		-- Diplomacy button
		CreateTaskbarButton("btnDiplomacy", "$2713", {495, 1}, {50, 18.5}, "UI_ToggleScreen( 'DiplomacyScreen', 0)", 141, "$2746"), -- DIPLOMACY

		-- Speech recall button
		CreateTaskbarButton("btnRecall", "$2762", {495, 1}, {50, 18.5}, "UI_ToggleScreen( 'SpeechRecall', 0)", 142, "$2763", {visible=0}), -- RECALL

		-- Menu button
		CreateTaskbarButton("btnMenu", "$2702", {435, 1}, {50, 18.5}, "MainUI_UserEvent( eMenu )", 4, "$2774", {toggleButton=0}), -- MENU

		-- Menu button (wide version)
		CreateTaskbarButton("btnMenu_wide", "$2702", {435, 1}, {50, 18.5}, "MainUI_UserEvent( eMenu )", 4, "$2774", {visible=0, toggleButton=0, textStyle="Taskbar_MenuButtonTextStyle"}), -- MENU

		-- Build button
		CreateTaskbarButton("btnBuild", "$2700", {595, 1}, {50, 18.5}, "MainUI_UserEventData( eBuildManager, 1)", 50, "$2748", {toggleButton=1, overColor={ 127, 127, 127, 127}}), -- BUILD

		-- Research button
		CreateTaskbarButton("btnResearch", "$2701", {655, 1}, {50, 18.5}, "MainUI_UserEvent( eResearchManager)", 49, "$2749", {toggleButton=1}),

		-- Launch button
		CreateTaskbarButton("btnLaunch", "$2706", {715, 1}, {50, 18.5}, "MainUI_UserEventData( eLaunchManager, 1)", 52, "$2760", {toggleButton=1}), -- LAUNCH

		--Return
		CreateTaskbarButton("btnShipBack", "<<<", {775, 1}, {15, 18.5}, nil, 52, "$2732", {toggleButton=0, textStyle="Taskbar_PanelButtonTextStyleCarrot", disabledTextColor={0,0,0,0}}), -- LAUNCH

		--Show button (Disabled)
		CreateTaskbarButton("btnHide2", "^", {784, -55}, {15, 18.5}, nil, 55, "$2739", {visible=0, toggleButton=1, overColor={ 127, 127, 127, 127}}), -- LAUNCH

		--Hide Button (Disabled)
		CreateTaskbarButton("btnHide1", "^", {784, -55}, {15, 18.5}, nil, 55, "$2739", {visible=0, toggleButton=1, overColor={ 127, 127, 127, 127}}), -- LAUNCH

	},

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

	{
		type = "Frame",
		name = "taskbar",
		position = { 400 - NEW_TASKBAR_WIDTH / 2, 1 },
		size = {NEW_TASKBAR_WIDTH, NEW_TASKBAR_HEIGHT},
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
	NewTaskbarCreateShipButtonsFrame("shipButtonsFrame", 11, 0, NEW_TASKBAR_WIDTH, NEW_TASKBAR_HEIGHT, 10),

	-- next/prev ship buttons
	{
		type = "Button",
		buttonStyle = "Taskbar_ShipButtonStyle",
		position = {NEW_TASKBAR_WIDTH - 10, 0},
		size = {10, 30},
		name = "btnShipNext",
		Text = {
			font = "ChatFont",
			text = "",
			color = "TPOFBlack",
			hAlign = "Left",
			vAlign = "Top", 
		},
		helpTip = "$2731",
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
		helpTip = "$2730",
		helpTipTextLabel = "commandsHelpTip",
		soundOnClicked = "SFX_ButtonClick",
	},

	-- Ship details
	{
		type = "Frame",
		position = {0, 0},
		size = {NEW_TASKBAR_WIDTH, 30},
		name = "unitStats",
		;

		-- ship icon
		{
			type = "Button",
			position = {(NEW_TASKBAR_WIDTH / 2) - 50, 0},
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
			position = { (NEW_TASKBAR_WIDTH / 2) - 50, 25 },
			size = { 100, 2},
			name = "unitProgress",
		},

		{
			type = "Frame",
			position = { NEW_TASKBAR_WIDTH - 6 * 15, 0},
			size = { 6 * 15, NEW_TASKBAR_HEIGHT },
			;
			-- subsystems
			{
				type = "Frame",
				name = "subsystems",
				position = { 0, 0},
				size = { 6 * 15, NEW_TASKBAR_HEIGHT },
				autoarrange = 1,
				autoarrangeWidth = 6 * 15,
				;
				{
					type = "Button",
					name = "subsystem1",
					buttonStyle = "Taskbar_SubsystemButtonStyle",
				},
				{
					type = "Button",
					name = "subsystem2",
					buttonStyle = "Taskbar_SubsystemButtonStyle",
				},
				{
					type = "Button",
					name = "subsystem3",
					buttonStyle = "Taskbar_SubsystemButtonStyle",
				},
				{
					type = "Button",
					name = "subsystem4",
					buttonStyle = "Taskbar_SubsystemButtonStyle",
				},
				{
					type = "Button",
					name = "subsystem5",
					buttonStyle = "Taskbar_SubsystemButtonStyle",
				},
				{
					type = "Button",
					name = "subsystem6",
					buttonStyle = "Taskbar_SubsystemButtonStyle",
				},
				{
					type = "Button",
					name = "subsystem7",
					buttonStyle = "Taskbar_SubsystemButtonStyle",
				},
				{
					type = "Button",
					name = "subsystem8",
					buttonStyle = "Taskbar_SubsystemButtonStyle",
				},
				{
					type = "Button",
					name = "subsystem9",
					buttonStyle = "Taskbar_SubsystemButtonStyle",
				},
				{
					type = "Button",
					name = "subsystem10",
					buttonStyle = "Taskbar_SubsystemButtonStyle",
				},
				{
					type = "Button",
					name = "subsystem11",
					buttonStyle = "Taskbar_SubsystemButtonStyle",
				},
				{
					type = "Button",
					name = "subsystem12",
					buttonStyle = "Taskbar_SubsystemButtonStyle",
				},
			},

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
		{
			type = "Frame",
			position = { 3, 3},
			size = { 220, 59},
			autoarrange = 1,
			marginHeight = 4,
			;

			{
				type = "Frame",
				autosize = 1,
				;
				{
					type = "TextLabel",
					position = {5, 0},
					size = {45, 13},
					wrapping = 1,
					Text = {
						textStyle = "Taskbar_MenuButtonTextStyle",
						text = "$2708", -- UNIT:
						hAlign = "Left",
						vAlign = "Top",
						color = { 0, 0, 0, 255},
					},
				},
				{
					type = "TextLabel",
					position = {50, 0},
					size = {161, 13},
					wrapping = 1,
					autosize = 1,
					Text = {
						textStyle = "Taskbar_MenuButtonTextStyle",
						color = { 0, 0, 0, 255},
						hAlign = "Left",
						vAlign = "Top",
					},
					name = "unitname",
				},
			},
			{
				type = "Frame",
				autosize = 1,
				;
				{
					type = "TextLabel",
					position = {5, 0},
					size = {45, 13},
					wrapping = 1,
					Text = {
						textStyle = "Taskbar_MenuButtonTextStyle",
						text = "$2709", -- ROLE:
						hAlign = "Left",
						vAlign = "Top",
						color = { 0, 0, 0, 255},
					},
				},
				{
					type = "TextLabel",
					position = {50, 0},
					size = {161, 13},
					wrapping = 1,
					autosize = 1,
					Text = {
						textStyle = "Taskbar_MenuButtonTextStyle",
						color = { 0, 0, 0, 255},
						hAlign = "Left",
						vAlign = "Top",
					},
					name = "unitrole",
				},
			},
		},

		-- stat indicators
		{
			type = "Frame",
			position = { 3, 45},
			autosize = 1,
			autoarrange = 1,
			autoarrangeWidth = 300,
			;
			{
				type = "Frame",
				name = "maxspeedframe",
				size = {67, 15},
				helpTip = "$2711",
				helpTipTextLabel = "commandsHelpTip",
				;
				{
					type = "Frame",
					position = {5, 3},
					size = {9, 9},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\stats_icons.mres",
						textureUV = { 0, 0, 9, 9 },
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
					name = "unitmaxspeed",
				},
			},
			{
				type = "Frame",
				name = "attackdamageframe",
				size = {67, 15},
				helpTip = "$2710",
				helpTipTextLabel = "commandsHelpTip",
				;
				{
					type = "Frame",
					position = {5, 3},
					size = {9, 9},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\stats_icons.mres",
						textureUV = { 11, 0, 20, 9 },
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
					name = "unitattackdamage",
				},
			},
			{
				type = "Frame",
				name = "shieldsframe",
				size = {67, 15},
				helpTip = "$2770",
				helpTipTextLabel = "commandsHelpTip",
				;
				{
					type = "Frame",
					position = {5, 3},
					size = {9, 9},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\stats_icons.mres",
						textureUV = { 22, 0, 31, 9 },
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
					name = "unitshields",
				},
			},
		},
	},

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
   },
}
