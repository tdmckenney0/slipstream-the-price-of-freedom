BUILDCOLOR = {0,0,0,0}
RESEARCHCOLOR = {0,0,0,255}
LAUNCHCOLOR = {0,0,0,255}

NewTaskbar = {
	size = {0, 498, 800, 110}, --was 0, 498, 800, 102
	stylesheet = "HW2StyleSheet",

	-- Flags
	pixelUVCoords = 1, -- Enter pixel coords for texture coords
	callUpdateWhenInactive = 1,

	-- custom
	minimizedPos = { 0, 582}, --0, 580
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


	-- black background
	{
		type = "Frame",
		name = "blackBg",
		position = {0, 16},
		size = { 800, 86},
		backgroundColor = { 0, 0, 0, 0 },
		giveParentMouseInput = 1,
	},

	-- background
	{
		type = "Frame",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		position = {0, 0},
		size = { 800, 102},
		BackgroundGraphic = {
			texture = "DATA:UI\\NewUI\\Taskbar\\background.mres",
			textureUV = { 0, 0, 800, 102 },  --was 102
		},
		giveParentMouseInput = 1,
	},
	-- Events button
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		position = {315, 83},
		size = {50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		Text = {
			textStyle = "Taskbar_MenuButtonTextStyle",
			text = "$2707", -- EVENTS
		},
		name = "btnEvents",
		onMouseClicked = "UI_ToggleScreen( 'EventsScreen', 0)",
		helpTip = "$2743",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 140,
	},

	-- Events button (wide version)
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		visible = 0,
		position = {315, 83},
		size = {50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "$2707", -- EVENTS
		},
		name = "btnEvents_wide",
		onMouseClicked = "UI_ToggleScreen( 'EventsScreen', 0)",
		helpTip = "$2743",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 140,
	},

	-- Objectives button
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		position = {255, 83},
		size = {50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "$2704", -- OBJECTIVES
		},
		name = "btnObjectives",
		onMouseClicked = "UI_ToggleScreen( 'ObjectivesList', 0)",
		helpTip = "$2744",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 137,
	},

	-- Chat button
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		position = {255, 83},
		size = {50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "$2716", -- CHAT
		},
		name = "btnChat",
		onMouseClicked = "UI_ToggleScreen( 'ChatScreen', 0)",
		helpTip = "$2747",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 131,
	},

	-- Sensors button
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		position = {375, 83}, --363
		size = {50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		Text = {
			textStyle = "Taskbar_MenuButtonTextStyle",
			text = "$2703", -- SENSORS
		},
		name = "btnSensors",
		onMouseClicked = "MainUI_UserEvent( eSensorsManager)",
		helpTip = "$2745",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 54,
	},

	-- Diplomacy button
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		position = {495, 83},
		size = {50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "$2713", -- DIPLOMACY
		},
		name = "btnDiplomacy",
		onMouseClicked = "UI_ToggleScreen( 'DiplomacyScreen', 0)",
		helpTip = "$2746",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 141,
	},

	-- Speech recall button
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		position = {495, 83},
		size = {50, 18.5},
		visible = 0,
		buttonStyle = "Taskbar_PanelButtonStyle",
	    backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "$2762", -- RECALL
		},
		name = "btnRecall",
		onMouseClicked = "UI_ToggleScreen( 'SpeechRecall', 0)",
		helpTip = "$2763",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 142,
	},

	-- Menu button
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		position = {435, 83},
		size = {50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		toggleButton = 0,
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "$2702", -- MENU
		},
		name = "btnMenu",
		onMouseClicked = "MainUI_UserEvent( eMenu )",
		helpTip = "$2774",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 4,
	},

	-- Menu button (wide version)
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		visible = 0,
		position = {435, 83},
		size = {50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		toggleButton = 0,
		Text = {
			textStyle = "Taskbar_MenuButtonTextStyle",
			text = "$2702", -- MENU
		},
		name = "btnMenu_wide",
		onMouseClicked = "MainUI_UserEvent( eMenu )",
		helpTip = "$2774",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 4,
	},

	-- Build button
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		toggleButton = 1,
		position = {595, 83},
		size = {50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 127},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},

		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "$2700", -- BUILD
		},
		name = "btnBuild",
		onMouseClicked = "MainUI_UserEventData( eBuildManager, 1)", -- 1 means toggle
		helpTip = "$2748",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 50,
	},

	-- Research button
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		toggleButton = 1,
		position = {655, 83},
		size = {50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},

		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "$2701", -- RESEARCH
		},
		name = "btnResearch",
		onMouseClicked = "MainUI_UserEvent( eResearchManager)",
		helpTip = "$2749",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 49,
	},

	-- Launch button
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		toggleButton = 1,
		position = {715, 83},
		size = {50, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "$2706", -- LAUNCH
		},
		name = "btnLaunch",
		onMouseClicked = "MainUI_UserEventData( eLaunchManager, 1)",
		helpTip = "$2760",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 52,
	},

	--Return
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		toggleButton = 1,
		position = {775, 83},
		size = {15, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 255},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "<<<", -- LAUNCH
		},
		name = "btnShipBack",
	--	onMouseClicked = "MainUI_UserEventData( eLaunchManager, 1)",
		helpTip = "$2732",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 52,
	},

	--Hide
	{
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		toggleButton = 1,
		position = {10, 83},
		size = {15, 18.5},
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 127},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "V", -- LAUNCH
		},
		name = "btnHide1",
		helpTip = "$2738",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 55,
	},

	--Show button
   {
		type = "TextButton",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		toggleButton = 1,
		position = {784, 0},  --784,0
		size = {15, 18.5},
		visible = 0,
		buttonStyle = "Taskbar_PanelButtonStyle",
		backgroundColor = { 0, 0, 0, 0},
		overColor = { 127, 127, 127, 127},
		pressedColor = { 255, 255, 255, 255},
		textColor = { 0, 0, 0, 255},
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = "^", -- LAUNCH
		},
		name = "btnHide2",
		helpTip = "$2739",
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = 55,
	},


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
			outerBorderWidth = 1,
			backgroundColor = "IGColorBackground1",
			borderColor = "FEColorHeading3",
			size = {155, 60},
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

			{
				type = "Button",
				buttonStyle = "Taskbar_CommandButtonStyle",
				name = "btnMove",
				onMouseClicked = "MainUI_UserEvent( eMove)",
				helpTip = "$2717",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 10,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 1, 1, 31, 31 },
					},
					DisabledGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 1, 1, 31, 0 },
						color = { 90, 155, 211, 0},
						blackAndWhite = 1,
					},
					giveParentMouseInput = 1,
				},
			},
			{
				type = "Button",
				buttonStyle = "Taskbar_CommandButtonStyle",
				name = "btnAttack",
				onMouseClicked = "MainUI_UserEventData( eControlModifier, 0)",
				helpTip = "$2718",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 115,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 33, 1, 63, 31 },
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
				name = "btnAttackMove",
				onMouseClicked = "MainUI_UserEvent( eMoveAttack )",
				helpTip = "$2724",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 25,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 129, 97, 159, 127},
					},
					DisabledGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 33, 1, 63, 0},
						color = { 90, 155, 211, 0},
						blackAndWhite = 1,
					},
					giveParentMouseInput = 1,
				},
			},
			{
				type = "Button",
				buttonStyle = "Taskbar_CommandButtonStyle",
				name = "btnGuard",
				onMouseClicked = "MainUI_UserEvent( eGuard)",
				helpTip = "$2719",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 14,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 65, 1, 95, 31 },
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
				name = "btnDock",
				onMouseClicked = "MainUI_UserEvent( eDock)",
				helpTip = "$2720",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 15,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 97, 1, 127, 31 },
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
				name = "btnCancelOrders",
				onMouseClicked = "MainUI_UserEvent( eCancelOrders)",
				helpTip = "$2722",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 17,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 33, 97, 63, 127 },
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
				name = "btnWaypoint",
				onMouseClicked = "MainUI_UserEvent( eTempWaypoint)",
				helpTip = "$2727",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 56,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 97, 33, 127, 63 },
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
				name = "btnResource",
				onMouseClicked = "MainUI_UserEventData( eHarvest, 0); MainUI_UserEventData( eHarvest, 1);",
				helpTip = "$2723",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 12,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 1, 33, 31, 63 },
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
				name = "btnHyperspace",
				onMouseClicked = "MainUI_UserEvent( eHyperspace)",
				helpTip = "$2725",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 11,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 33, 33, 63, 63 },
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
				name = "btnRetire",
				onMouseClicked = "MainUI_UserEvent( eRetire)",
				helpTip = "$2728",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 23,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 129, 33, 159, 63 },
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

-- special attacks switch
		{
			type = "Button",
			position = {157,50},
			size = {13, 13},
			outerBorderWidth = 1,
			borderColor = "FEColorHeading3",
			buttonStyle = "Taskbar_PanelButtonStyle",
			backgroundColor = { 0, 0, 0, 0},
			overColor = { 127, 127, 127, 127},
			pressedColor = { 255, 255, 255, 255},
			textColor = { 0, 0, 0, 255},
			Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = ">", -- LAUNCH
					},
			DisabledGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 33, 1, 63, 0 },
						color = { 90, 155, 211, 0},
						blackAndWhite = 1,
					},
			name = "btnSpecial",
			helpTip = "$2729",
			helpTipTextLabel = "commandsHelpTip",
			hotKeyID = 150,
			onMouseClicked = "UI_SetElementVisible(\"NewTaskbar\", \"specialButtonsframe\", 1); UI_SetElementVisible(\"NewTaskbar\", \"commandButtonsframe\", 0);",
			soundOnClicked = "SFX_ButtonClick",
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
			outerBorderWidth = 1,
			backgroundColor = "IGColorBackground1",
			borderColor = "FEColorHeading3",
			size = {155, 60},
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

			{
				type = "Button",
				buttonStyle = "Taskbar_CommandButtonStyle",
				name = "btnPing",
				onMouseClicked = "MainUI_UserEvent( eSensorPing)",
				helpTip = "$2769",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 147,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 129, 65, 159, 95 },
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
				name = "btnEMP",
				onMouseClicked = "MainUI_UserEventData2( eSpecialAttack, 0, 2)",
				helpTip = "$2768",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 146,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 97, 65, 127, 95 },
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
				name = "btnDefenseField",
				onMouseClicked = "MainUI_UserEvent( eDefenseField)",
				helpTip = "$2765",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 143,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 1, 65, 31, 95 },
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
				name = "btnCloak",
				onMouseClicked = "MainUI_UserEvent( eCloak)",
				helpTip = "$2766",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 144,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 33, 65, 63, 95 },
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
				name = "btnScuttleConfirm",
				onMouseClicked = "MainUI_UserEvent( eScuttle); UI_SetElementVisible(\"NewTaskbar\", \"scuttleButtons\", 0); UI_SetElementVisible(\"NewTaskbar\", \"specialButtons\", 1);",
				helpTip = "$2759",
				helpTipTextLabel = "commandsHelpTip",
				--hotKeyID = 146,
				enabled = 0,
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

			-- bottom row

			{
				type = "Button",
				buttonStyle = "Taskbar_CommandButtonStyle",
				name = "btnRepair",
				onMouseClicked = "MainUI_UserEvent( eRepair)",
				helpTip = "$2726",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 20,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 65, 33, 95, 63 },
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
				name = "btnMines",
				onMouseClicked = "MainUI_UserEvent( eDropMinesInstant)",
				helpTip = "$2772",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 24,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 65, 97, 95, 127 },
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
				name = "btnRally",
				onMouseClicked = "MainUI_UserEvent( eRallyPoint)",
				helpTip = "$2721",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 138,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 129, 1, 159, 31 },
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
				name = "btnRallyObject",
				onMouseClicked = "MainUI_UserEventData( eRallyObject, 0 )",
				helpTip = "$2767",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 22,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 1, 97, 31, 127 },
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
				name = "btnScuttle",
				onMouseClicked = "UI_SetElementVisible(\"NewTaskbar\", \"scuttleButtons\", 1); UI_SetElementVisible(\"NewTaskbar\", \"specialButtonsframe2\", 0);",
				helpTip = "$2773",
				helpTipTextLabel = "commandsHelpTip",
				hotKeyID = 5,
				;
				{
					type = "Frame",
					size = { 30, 30},
					BackgroundGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 97, 97, 127, 127 },
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

		-- special attacks switch
		{
			type = "Button",
			position = {157,50},
			size = {13, 13},
			outerBorderWidth = 1,
			borderColor = "FEColorHeading3",
			buttonStyle = "Taskbar_PanelButtonStyle",
			backgroundColor = { 0, 0, 0, 0},
			overColor = { 127, 127, 127, 127},
			pressedColor = { 255, 255, 255, 255},
			textColor = { 0, 0, 0, 255},
			Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = ">", -- LAUNCH
					},
			DisabledGraphic = {
						texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
						textureUV = { 33, 1, 63, 0 },
						color = { 90, 155, 211, 0},
						blackAndWhite = 1,
								},
			name = "btnSpecial",
			helpTip = "$2729",
			helpTipTextLabel = "commandsHelpTip",
			hotKeyID = 150,
			onMouseClicked = "UI_SetElementVisible(\"NewTaskbar\", \"specialButtonsframe\", 0); UI_SetElementVisible(\"NewTaskbar\", \"commandButtonsframe\", 1);",

			soundOnClicked = "SFX_ButtonClick",
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
				onMouseClicked = "MainUI_UserEvent( eScuttle); UI_SetElementVisible(\"NewTaskbar\", \"scuttleButtons\", 0); UI_SetElementVisible(\"NewTaskbar\", \"specialButtonsframe2\", 1);",
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
				onMouseClicked = "UI_SetElementVisible(\"NewTaskbar\", \"scuttleButtons\", 0); UI_SetElementVisible(\"NewTaskbar\", \"specialButtonsframe2\", 1);",
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
		position = {768, 55},
		size = {13, 28},
		DefaultGraphic = {
			texture = "DATA:UI\\NewUI\\Taskbar\\shipnext.tga",
			textureUV = { 0, 0, 16, 32 },
		},
		OverGraphic = {
			texture = "DATA:UI\\NewUI\\Taskbar\\shipnext_OVER.tga",
			textureUV = { 0, 0, 16, 32 },
		},
		DisabledGraphic = {
			texture = "DATA:UI\\NewUI\\Taskbar\\shipnext.tga",
			textureUV = { 0, 0, 13, 0 },
			color = { 255, 255, 255, 0},
		},
		name = "btnShipNext",
		helpTip = "$2731",
		helpTipTextLabel = "commandsHelpTip",

		soundOnClicked = "SFX_ButtonClick",
	},
	{
		type = "Button",
		position = {768, 19},
		size = {13, 28},
		DefaultGraphic = {
			texture = "DATA:UI\\NewUI\\Taskbar\\shipprev.tga",
			textureUV = { 0, 0, 16, 32 },
		},
		OverGraphic = {
			texture = "DATA:UI\\NewUI\\Taskbar\\shipprev_OVER.tga",
			textureUV = { 0, 0, 16, 32 },
		},
		DisabledGraphic = {
			texture = "DATA:UI\\NewUI\\Taskbar\\shipprev.tga",
			textureUV = { 0, 0, 13, 0 },
			color = { 255, 255, 255, 0},
		},
		name = "btnShipPrev",
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
					texture = "DATA:UI\\NewUI\\Taskbar\\subsystem_pointer.tga",
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
						color = { 255, 255, 255, 255},
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
						color = { 255, 255, 255, 255},
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
						color = { 255, 255, 255, 255},
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
						color = { 255, 255, 255, 255},
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
						color = { 255, 255, 255, 255},
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
						color = { 255, 255, 255, 255},
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
						color = { 255, 255, 255, 255},
						hAlign = "Left",
						vAlign = "Center",
					},
					name = "unitshields",
				},
			},
		},
	},
}
