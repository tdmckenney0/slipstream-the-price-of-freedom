BUILDCOLOR = {0,0,0,0}
RESEARCHCOLOR = {0,0,0,255}
LAUNCHCOLOR = {0,0,0,255}

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
	end
	
	return btn
end

function CreateTaskbarCommandButton(name, onClick, helpTip, hotKeyID, textureUV, disabledTextureUV, extra)
	local btn = {
		type = "Button",
		buttonStyle = "Taskbar_CommandButtonStyle",
		name = name,
		onMouseClicked = onClick,
		helpTip = helpTip,
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = hotKeyID,
		;
		{
			type = "Frame",
			size = { 30, 30},
			BackgroundGraphic = {
				texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
				textureUV = textureUV,
			},
			DisabledGraphic = {
				texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
				textureUV = disabledTextureUV or { 33, 1, 63, 0 },
				color = { 90, 155, 211, 0},
				blackAndWhite = 1,
			},
			giveParentMouseInput = 1,
		},
	}

	if extra then
		if extra.enabled ~= nil then
			btn.enabled = extra.enabled
		end
		-- Add other properties if needed
	end
	
	return btn
end

NewTaskbar = {
	size = {0, 498, 800, 110}, --was 0, 498, 800, 102
	stylesheet = "HW2StyleSheet",

	-- Flags
	pixelUVCoords = 1, -- Enter pixel coords for texture coords
	callUpdateWhenInactive = 1,

	-- custom
	minimizedPos = { 0, 582}, --0, 582
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

	Regions = {
		{0,15,221, 87},	-- left
		{220,0,363,102},	-- middle
		{581,15,219,87}, -- right
	},
	;

	{
		type = "Frame",
		name = "taskbar",
		position = {0, 0},
		size = { 800, 110},
		giveParentMouseInput = 1,
	;


	-- black background
	{
		type = "Frame",
		name = "blackBg",
		position = {0, 16},
		size = { 0, 0}, --800,86
		backgroundColor = { 0, 0, 0, 0 },
		giveParentMouseInput = 1,
	},

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
		position = {0, 83},
		size = { 800, 20},
		giveParentMouseInput = 1,
	},
	-- Events button
	CreateTaskbarButton("btnEvents", "$2707", {315, 83}, {50, 18.5}, "UI_ToggleScreen( 'EventsScreen', 0)", 140, "$2743", {textStyle="Taskbar_MenuButtonTextStyle"}), -- EVENTS

	-- Events button (wide version)
	CreateTaskbarButton("btnEvents_wide", "$2707", {315, 83}, {50, 18.5}, "UI_ToggleScreen( 'EventsScreen', 0)", 140, "$2743", {visible=0}), -- EVENTS

	-- Objectives button
	CreateTaskbarButton("btnObjectives", "GOALS", {255, 83}, {50, 18.5}, "UI_ToggleScreen( 'ObjectivesList', 0)", 137, "$2744"), -- OBJECTIVES

	-- Chat button
	CreateTaskbarButton("btnChat", "$2716", {255, 83}, {50, 18.5}, "UI_ToggleScreen( 'ChatScreen', 0)", 131, "$2747"), -- CHAT

	-- Sensors button
	CreateTaskbarButton("btnSensors", "$2703", {375, 83}, {50, 18.5}, "MainUI_UserEvent( eSensorsManager)", 54, "$2745", {textStyle="Taskbar_MenuButtonTextStyle"}), -- SENSORS

	-- Diplomacy button
	CreateTaskbarButton("btnDiplomacy", "$2713", {495, 83}, {50, 18.5}, "UI_ToggleScreen( 'DiplomacyScreen', 0)", 141, "$2746"), -- DIPLOMACY

	-- Speech recall button
	CreateTaskbarButton("btnRecall", "$2762", {495, 83}, {50, 18.5}, "UI_ToggleScreen( 'SpeechRecall', 0)", 142, "$2763", {visible=0}), -- RECALL

	-- Menu button
	CreateTaskbarButton("btnMenu", "$2702", {435, 83}, {50, 18.5}, "MainUI_UserEvent( eMenu )", 4, "$2774", {toggleButton=0}), -- MENU

	-- Menu button (wide version)
	CreateTaskbarButton("btnMenu_wide", "$2702", {435, 83}, {50, 18.5}, "MainUI_UserEvent( eMenu )", 4, "$2774", {visible=0, toggleButton=0, textStyle="Taskbar_MenuButtonTextStyle"}), -- MENU

	-- Build button
	CreateTaskbarButton("btnBuild", "$2700", {595, 83}, {50, 18.5}, "MainUI_UserEventData( eBuildManager, 1)", 50, "$2748", {toggleButton=1, overColor={ 127, 127, 127, 127}}), -- BUILD

	-- Research button
	CreateTaskbarButton("btnResearch", "$2701", {655, 83}, {50, 18.5}, "MainUI_UserEvent( eResearchManager)", 49, "$2749", {toggleButton=1}),

	-- Launch button
	CreateTaskbarButton("btnLaunch", "$2706", {715, 83}, {50, 18.5}, "MainUI_UserEventData( eLaunchManager, 1)", 52, "$2760", {toggleButton=1}), -- LAUNCH

	--Return
	CreateTaskbarButton("btnShipBack", "<<<", {775, 83}, {15, 18.5}, nil, 52, "$2732", {toggleButton=0, textStyle="Taskbar_PanelButtonTextStyleCarrot", disabledTextColor={0,0,0,0}, DisabledGraphic={texture="DATA:UI\\NewUI\\Taskbar\\command_icons.mres", textureUV={0,0,0,0}}}), -- LAUNCH

	--Special Switches

	CreateTaskbarButton("btnswitch1", ">>>", {10, 83}, {15, 18.5}, "UI_SetElementVisible(\"NewTaskbar\", \"specialButtonsframe\", 1); UI_SetElementVisible(\"NewTaskbar\", \"commandButtonsframe\", 0); UI_SetElementVisible(\"NewTaskbar\", \"btnswitch1\", 0); UI_SetElementVisible(\"NewTaskbar\", \"btnswitch2\", 1);", 150, "$2729", {toggleButton=0, textStyle="Taskbar_PanelButtonTextStyleCarrot", overColor={ 127, 127, 127, 127}}), -- LAUNCH

	CreateTaskbarButton("btnswitch2", ">>>", {10, 83}, {15, 18.5}, "UI_SetElementVisible(\"NewTaskbar\", \"specialButtonsframe\", 0); UI_SetElementVisible(\"NewTaskbar\", \"commandButtonsframe\", 1); UI_SetElementVisible(\"NewTaskbar\", \"btnswitch2\", 0); UI_SetElementVisible(\"NewTaskbar\", \"btnswitch1\", 1);", 150, "$2729", {visible=0, toggleButton=0, textStyle="Taskbar_PanelButtonTextStyleCarrot", overColor={ 127, 127, 127, 127}}), -- LAUNCH

	--Show button (Disabled)
	CreateTaskbarButton("btnHide2", "^", {784, -55}, {15, 18.5}, nil, 55, "$2739", {visible=0, toggleButton=1, overColor={ 127, 127, 127, 127}}), -- LAUNCH

	--Hide Button (Disabled)
	CreateTaskbarButton("btnHide1", "^", {784, -55}, {15, 18.5}, nil, 55, "$2739", {visible=0, toggleButton=1, overColor={ 127, 127, 127, 127}}), -- LAUNCH


	-- Commands help tip label
	{
		type = "TextLabel",
		name = "commandsHelpTip",
		position = {4, 1},
		size = { 214, 13},
		Text = {
			textStyle = "Taskbar_MenuButtonTextStyle",
			color = { 255, 255, 255, 255},
			hAlign = "Left",
		},
	},

	-- Command buttons

	{
		type = "Frame",
		position = { 0, 19},
		name = "commandButtonsFrame",
		autosize = 1,
		;

		{
			type = "Frame",
			position = {1, 1},
			outerBorderWidth = 0,
			borderColor = "FEColorHeading3",
			DisabledGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 0, 0, 0, 0 },
					},
			size = {155, 60},
		},

		{
			type = "Frame",
			position = {1, 1},
			outerBorderWidth = 1,
			backgroundColor = "IGColorBackground1",
			borderColor = "FEColorHeading3",
			BackgroundGraphic =
			{
				texture = "Data:UI\\NewUI\\Textures\\Gradient.tga",
				textureUV =
            { 0, 0, 600, 600, }, },
			DisabledGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 0, 0, 0, 0 },
					},
			size = {154, 60},
		},


		{
			type = "Frame",
			name = "commandButtonsFrame2",
			position = {0, 0},
			autosize = 1,
			autoarrange = 1,
			autoarrangeWidth = 155,
			autoarrangeHeight = 61,
			autoarrangeSpace = 1,
			;

			CreateTaskbarCommandButton("btnMove", "MainUI_UserEvent( eMove)", "$2717", 10, { 1, 1, 31, 31 }, { 1, 1, 31, 0 }),
			CreateTaskbarCommandButton("btnAttack", "MainUI_UserEventData( eControlModifier, 0)", "$2718", 115, { 33, 1, 63, 31 }),
			CreateTaskbarCommandButton("btnAttackMove", "MainUI_UserEvent( eMoveAttack )", "$2724", 25, { 129, 97, 159, 127}),
			CreateTaskbarCommandButton("btnGuard", "MainUI_UserEvent( eGuard)", "$2719", 14, { 65, 1, 95, 31 }),
			CreateTaskbarCommandButton("btnDock", "MainUI_UserEvent( eDock)", "$2720", 15, { 97, 1, 127, 31 }),
			-- Bottom Row
			CreateTaskbarCommandButton("btnCancelOrders", "MainUI_UserEvent( eCancelOrders)", "$2722", 17, { 33, 97, 63, 127 }),
			CreateTaskbarCommandButton("btnWaypoint", "MainUI_UserEvent( eTempWaypoint)", "$2727", 56, { 97, 33, 127, 63 }),
			CreateTaskbarCommandButton("btnResource", "MainUI_UserEventData( eHarvest, 0); MainUI_UserEventData( eHarvest, 1);", "$2723", 12, { 1, 33, 31, 63 }),
			CreateTaskbarCommandButton("btnHyperspace", "MainUI_UserEvent( eHyperspace)", "$2725", 11, { 33, 33, 63, 63 }),
			CreateTaskbarCommandButton("btnRetire", "MainUI_UserEvent( eRetire)", "$2728", 23, { 129, 33, 159, 63 }),
		},
	},

	-- Special Command buttons
	{
		type = "Frame",
		position = { 1, 19},
		name = "specialButtonsFrame",
		visible = 0,
		autosize = 1,
		;

		{
			type = "Frame",
			position = {1, 1},
			outerBorderWidth = 0,
			borderColor = "FEColorHeading3",
			DisabledGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 0, 0, 0, 0 },
					},
			size = {155, 60},
		},

		{
			type = "Frame",
			position = {1, 1},
			outerBorderWidth = 1,
			backgroundColor = "IGColorBackground1",
			borderColor = "FEColorHeading3",
			BackgroundGraphic =
			{
				texture = "Data:UI\\NewUI\\Textures\\Gradient.tga",
				textureUV =
            { 0, 0, 600, 600, }, },
			DisabledGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 0, 0, 0, 0 },
					},
			size = {154, 60},
		},

		{
			type = "Frame",
			name = "specialButtonsFrame2",
			position = {0, 0},
			autosize = 1,
			autoarrange = 1,
			autoarrangeWidth = 155,
			autoarrangeSpace = 1,
			;

			CreateTaskbarCommandButton("btnPing", "MainUI_UserEvent( eSensorPing)", "$2769", 147, { 129, 65, 159, 95 }),
			CreateTaskbarCommandButton("btnEMP", "MainUI_UserEventData2( eSpecialAttack, 0, 2)", "$2768", 146, { 97, 65, 127, 95 }),
			CreateTaskbarCommandButton("btnDefenseField", "MainUI_UserEvent( eDefenseField)", "$2765", 143, { 1, 65, 31, 95 }),
			CreateTaskbarCommandButton("btnCloak", "MainUI_UserEvent( eCloak)", "$2766", 144, { 33, 65, 63, 95 }),
			CreateTaskbarCommandButton("btnScuttleConfirm", "MainUI_UserEvent( eScuttle); UI_SetElementVisible(\"NewTaskbar\", \"scuttleButtons\", 0); UI_SetElementVisible(\"NewTaskbar\", \"specialButtons\", 1); UI_SetElementVisible(\"NewTaskbar\", \"btnswitch2\", 0);", "$2759", nil, { 225, 97, 255, 127 }, nil, {enabled=0}),
			-- bottom row
			CreateTaskbarCommandButton("btnRepair", "MainUI_UserEvent( eRepair)", "$2726", 20, { 65, 33, 95, 63 }),
			CreateTaskbarCommandButton("btnMines", "MainUI_UserEvent( eDropMinesInstant)", "$2772", 24, { 65, 97, 95, 127 }),
			CreateTaskbarCommandButton("btnRally", "MainUI_UserEvent( eRallyPoint)", "$2721", 138, { 129, 1, 159, 31 }),
			CreateTaskbarCommandButton("btnRallyObject", "MainUI_UserEventData( eRallyObject, 0 )", "$2767", 22, { 1, 97, 31, 127 }),
			CreateTaskbarCommandButton("btnScuttle", "UI_SetElementVisible(\"NewTaskbar\", \"scuttleButtons\", 1); UI_SetElementVisible(\"NewTaskbar\", \"specialButtonsframe2\", 0); UI_SetElementVisible(\"NewTaskbar\", \"btnswitch2\", 0);", "$2773", 5, { 97, 97, 127, 127 }),
		},
	},

	-- Scuttle confirm
	{
		type = "Frame",
		position = { 1, 19},
		name = "scuttleButtons",
		visible = 0,
		autosize = 1,
		;

		{
			type = "TextLabel",
			position = {40, 7},
			size = {80, 30},
			wrapping = 1,
			Text = {
				font = "ButtonFont",
				text = "$2712", -- CONFIRM SCUTTLE?
				hAlign = "Right",
				vAlign = "Top",
				color = { 255, 255, 255, 255},
			},
		},

		{
			type = "Frame",
			position = { 124, 0},
			autosize = 1,
			autoarrange = 1,
			autoarrangeSpace = 1,
			;

			{
				type = "Button",
				buttonStyle = "Taskbar_CommandButtonStyle",
				name = "btnScuttleConfirm",
				onMouseClicked = "MainUI_UserEvent( eScuttle); UI_SetElementVisible(\"NewTaskbar\", \"scuttleButtons\", 0); UI_SetElementVisible(\"NewTaskbar\", \"specialButtonsframe2\", 1); UI_SetElementVisible(\"NewTaskbar\", \"btnswitch2\", 1);",
				helpTip = "$2759",
				helpTipTextLabel = "commandsHelpTip",
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 225, 97, 255, 127 },
					},
					DisabledGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 33, 1, 63, 0 },
						color = { 90, 155, 211, 0},
						blackAndWhite = 1,
					},
					giveParentMouseInput = 1,
				},
			},
			{
				type = "Button",
				buttonStyle = "Taskbar_CommandButtonStyle",
				name = "btnScuttleCancel",
				onMouseClicked = "UI_SetElementVisible(\"NewTaskbar\", \"scuttleButtons\", 0); UI_SetElementVisible(\"NewTaskbar\", \"specialButtonsframe2\", 1); UI_SetElementVisible(\"NewTaskbar\", \"btnswitch2\", 1);",
				helpTip = "$2613",
				helpTipTextLabel = "commandsHelpTip",
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 161, 1, 191, 31 },
					},
					DisabledGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 33, 1, 63, 0 },
						color = { 90, 155, 211, 0},
						blackAndWhite = 1,
					},
					giveParentMouseInput = 1,
				},
			},
		},
	},

	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		toggleButton = 1,
		position = {35, 83},
		size = { 50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		--pressedTextColor = { 0, 224, 255, 255},

		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "$2705", -- FLEET
		},
		name = "btnFleet",
		onMouseClicked = "UI_ToggleScreen( 'FleetMenu', 0)",
		helpTip = "$2740",
		helpTipTextLabel = "commandsHelpTip",

		-- Bugfix: this is needed because of wierd states that arise from closing the strike menu while over the button
		clickedTextColor = { 0, 0, 0, 255},
		ClickedGraphic = {
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV = { 0, 0, 64, 13 },
		},
	},

	-- Strike group button
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		position = {95, 83},
		size = {50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		toggleButton = 1,
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "$2714", -- STRIKE GRP
		},
		name = "btnStrike",
		onMousePressed = "UI_ToggleScreen( 'StrikeGroupsMenu', 0)",
		helpTip = "$2741",
		helpTipTextLabel = "commandsHelpTip",

		soundOnClicked = "",
		soundOnPressed = "SFX_ButtonClick",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},

		-- Bugfix: this is needed because of wierd states that arise from closing the strike menu while over the button
		clickedTextColor = { 0, 0, 0, 255},
		ClickedGraphic = {
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV = { 0, 0, 64, 13 },
		},
	},

	-- Tactics button
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		position = {155, 83},
		size = {50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		toggleButton = 1,
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "$2715", -- TACTICS
		},
		name = "btnTactics",
		onMousePressed = "UI_ToggleScreen( 'TacticsMenu', 0)",
		helpTip = "$2742",
		helpTipTextLabel = "commandsHelpTip",

		soundOnClicked = "",
		soundOnPressed = "SFX_ButtonClick",

		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},

		-- Bugfix: this is needed because of wierd states that arise from closing the strike menu while over the button
		clickedTextColor = { 0, 0, 0, 255},
		ClickedGraphic = {
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV = { 0, 0, 64, 13 },
		},
	},

	-- Ship buttons
	{
		type = "Frame",
		position = {179, 19},
		size = { 590, 64},
		autoarrange = 1,
		autoarrangeWidth = 590,
		autoarrangeSpace = 1,
		;

		-- first row
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip13",
		},
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip11",
		},
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip09",
		},
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip07",
		},
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip05",
		},
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip03",
		},
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip01",
		},

		-- second row
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip14",
		},
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip12",
		},
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip10",
		},
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip08",
		},
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip06",
		},
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip04",
		},
		{
			type = "Button",
			buttonStyle = "Taskbar_ShipButtonStyle",
			name = "btnShip02",
		},
	},

	-- next/prev ship buttons
	{
		type = "Button",
		buttonStyle = "Taskbar_ShipButtonStyle",
		position = {768, 51},
		size = {13, 30},
		name = "btnShipNext",
		Text =
			{
			font = "ChatFont",
			text = ">>>",
			color =
            {  255, 255, 255, 255, },
			hAlign = "Left",
			vAlign = "Top", },
		helpTip = "$2731",
		helpTipTextLabel = "commandsHelpTip",
		soundOnClicked = "SFX_ButtonClick",
	},
	{
		type = "Button",
		buttonStyle = "Taskbar_ShipButtonStyle",
		position = {768, 20},
		size = {13, 30},
		name = "btnShipPrev",
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "", -- LAUNCH
		},
		helpTip = "$2730",
		helpTipTextLabel = "commandsHelpTip",

		soundOnClicked = "SFX_ButtonClick",
	},

	-- Ship details
	{
		type = "Frame",
		position = {176, 19},
		size = {800, 68},  --620,68
		name = "unitStats",
		;

		--background, believe it or not, for everything.

		{
			type = "Frame",
			position = {0, 0},
			size = {800, 62},
			BackgroundGraphic = {
				texture = "DATA:UI\\NewUI\\Taskbar\\unitstats_border.mres",
				textureUV = { 0, 0, 608, 0 },
			},
		},

		-- border
		{
			type = "Frame",
			position = {1, 1},
			outerBorderWidth = 1,
			backgroundColor = "IGColorBackground1",
			borderColor = "FEColorHeading3",
			BackgroundGraphic =
			{
				texture = "Data:UI\\NewUI\\Textures\\Gradient.tga",
				textureUV =
            { 0, 0, 600, 600, }, },
			DisabledGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 1, 1, 31, 0 },
					},
			size = {650, 60},
		},

		-- ship icon
		{
			type = "Button",
			position = {211, 0},
			size = {200, 64},
			name = "unitIcon",
			backgroundGraphicHAlign = "Center",
			backgroundGraphicVAlign = "Center",
		},

		{
			type = "Frame",
			position = { 215, 3},
			size = { 391, 59},
			;

			{
				type = "ProgressBar",
				backgroundColor = { 0, 128, 0, 255},
				progressColor = { 0, 255, 0, 255},
				borderColor = { 0, 0, 0, 255},
				outerBorderWidth = 1,
				position = { 50, 50},
				size = { 100, 2},
				name = "unitProgress",
			},

			-- subsystems
			{
				type = "Frame",
				name = "subsystems",
				position = { 193, 5},
				size = { 210, 48},
				autoarrange = 1,
				autoarrangeWidth = 210,
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
				DefaultGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 0, 0, 32, 24 },
				},
				OverGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 0, 24, 32, 48 },
				},
				PressedGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 0, 48, 32, 72 },
				},
				DisabledGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 0, 0, 32, 24 },
					color = { 255, 255, 255, 200},
				},
				helpTip = "$2811",
				soundOnClicked = "SFX_ButtonClick",
			},
			{
				type = "Button",
				name = "subsystem_sensor",
				visible = 0,
				size = { 32, 24},
				DefaultGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 32, 0, 64, 24 },
				},
				OverGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 32, 24, 64, 48 },
				},
				PressedGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 32, 48, 64, 72 },
				},
				DisabledGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 32, 0, 64, 24 },
					color = { 255, 255, 255, 200},
				},
				helpTip = "$2813",
				soundOnClicked = "SFX_ButtonClick",
			},
			{
				type = "Button",
				name = "subsystem_generic",
				visible = 0,
				size = { 32, 24},
				DefaultGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 64, 0, 96, 24 },
				},
				OverGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 64, 24, 96, 48 },
				},
				PressedGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 64, 48, 96, 72 },
				},
				DisabledGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 64, 0, 96, 24 },
					color = { 255, 255, 255, 200},
				},
				helpTip = "$2812",
				soundOnClicked = "SFX_ButtonClick",
			},
			{
				type = "Button",
				name = "subsystem_innate",
				visible = 0,
				size = { 32, 24},
				DefaultGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 96, 0, 128, 24 },
				},
				OverGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 96, 24, 128, 48 },
				},
				PressedGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 96, 48, 128, 72 },
				},
				DisabledGraphic = {
					size = {32, 24},
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_button.mres",
					textureUV = { 96, 0, 128, 24 },
					color = { 255, 255, 255, 200},
				},
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
				BackgroundGraphic = {
					texture = "DATA:UI\\NewUI\\Taskbar\\stats_box.mres",
					textureUV = { 0, 0, 67, 15 },
				},
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
				BackgroundGraphic = {
					texture = "DATA:UI\\NewUI\\Taskbar\\stats_box.mres",
					textureUV = { 0, 0, 67, 15 },
				},
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
				BackgroundGraphic = {
					texture = "DATA:UI\\NewUI\\Taskbar\\stats_box.mres",
					textureUV = { 0, 0, 67, 15 },
				},
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

   },
}
