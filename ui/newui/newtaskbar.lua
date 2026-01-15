--- Creates a primary taskbar button with text and various styling options.
-- This is the main factory function for creating interactive buttons in the taskbar menu.
-- @param name string The unique identifier name for the button element
-- @param text string The localized text or string ID to display on the button
-- @param position table {x, y} position coordinates relative to parent
-- @param size table {width, height} dimensions of the button
-- @param onClick string|nil Lua code to execute when the button is clicked
-- @param hotKeyID number|nil The hotkey binding ID for keyboard shortcuts
-- @param helpTip string The localized tooltip string ID shown on hover
-- @param extra table|nil Optional table with additional properties:
--   - textStyle: Override the default text style
--   - visible: Set visibility (0 or 1)
--   - toggleButton: Enable toggle behavior (0 or 1)
--   - overColor: Custom hover color {r, g, b, a}
--   - disabledTextColor: Text color when disabled
--   - DisabledGraphic: Graphic to show when disabled
--   - onMousePressed: Lua code for mouse press event
--   - soundOnClicked: Sound effect on click
--   - soundOnPressed: Sound effect on press
-- @return table A TextButton UI element definition
function NewTaskbarCreatePrimaryButton(name, text, position, size, onClick, hotKeyID, helpTip, extra)
	local btn = {
		type = "TextButton",
		buttonStyle = "Taskbar_PanelButtonStyle",
		position = position,
		size = size,
		Text = {
			textStyle = "Taskbar_PanelButtonTextStyle",
			text = text,
		},
		name = name,
		onMouseClicked = onClick,
		soundOnEnter = "SFX_ButtonEnter",
		soundOnClicked = "SFX_ButtonClick",
		helpTip = helpTip,
		helpTipTextLabel = "commandsHelpTip",
		hotKeyID = hotKeyID,
		-- Bugfix: this is needed because of wierd states that arise from closing the strike menu while over the button
		clickedTextColor = "TPOFWhite",
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
	end
	
	return btn
end

--- Creates an invisible dummy button used as a placeholder or for engine hooks.
-- These buttons are hidden (size 0,0, visible 0) but their names are used by
-- the game engine to bind command functionality.
-- @param pName string The unique name identifier for the dummy button
-- @return table A Button UI element definition with zero size and visibility
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


function NewTaskbarCreateBumperButton(pName, pHelpTip, pPositionX, pPositionY, pWidth, pHeight, pIsVisible)
	return {
		type = "Button",
		buttonStyle = "Taskbar_PanelButtonStyle",
		position = {pPositionX, pPositionY},
		size = {pWidth, pHeight},
		name = pName,
		helpTip = pHelpTip,
		helpTipTextLabel = "commandsHelpTip",
		visible = pIsVisible,
		soundOnEnter = "SFX_ButtonEnter",
		soundOnClicked = "SFX_ButtonClick",
		-- Bugfix: this is needed because of wierd states that arise from closing the strike menu while over the button
		clickedTextColor = "TPOFWhite",
		ClickedGraphic = {
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV = { 0, 0, 64, 13 },
		},
	};
end

--- Creates a single ship selection button for the taskbar ship roster.
-- Used within the ship buttons frame to represent individual selectable ships.
-- @param pName string The unique name identifier (e.g., "btnShip01")
-- @param pPositionX number X position within parent frame
-- @param pPositionY number Y position within parent frame
-- @param pWidth number Width of the button
-- @param pHeight number Height of the button
-- @return table A Button UI element with Taskbar_ShipButtonStyle
function NewTaskbarCreateShipButton(pName, pPositionX, pPositionY, pWidth, pHeight)
	return {
		type = "Button",
		buttonStyle = "Taskbar_ShipButtonStyle",
		name = pName,
		size = { pWidth, pHeight },
		position = { pPositionX, pPositionY },
	}
end

--- Creates a frame containing 14 ship selection buttons arranged in a row.
-- The engine expects exactly 14 ship buttons (btnShip01 through btnShip14) due to
-- hardcoded references. Button widths are calculated to fill the available space.
-- @param pName string The name for the containing frame
-- @param pPositionX number X position of the frame
-- @param pPositionY number Y position of the frame
-- @param pFrameWidth number Total width of the frame (padding will be subtracted)
-- @param pFrameHeight number Height of the frame (also used as button height)
-- @param pPadding number Horizontal padding on each side of the frame
-- @return table A Frame UI element containing 14 ship buttons
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

--- Creates a button representing a ship subsystem (production, sensors, etc.).
-- Each button contains a child frame named "icon" for displaying the subsystem icon.
-- @param pName string The subsystem button name (e.g., "subsystem1")
-- @param pPositionX number X position within parent frame
-- @param pPositionY number Y position within parent frame
-- @param pWidth number Width of the button
-- @param pHeight number Height of the button
-- @return table A Button UI element with Taskbar_SubsystemButtonStyle and icon frame
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

--- Creates a frame containing 12 subsystem buttons arranged in a 6x2 grid.
-- The engine expects exactly 12 subsystem buttons (subsystem1 through subsystem12)
-- due to hardcoded references. Buttons are arranged in two rows of six.
-- @param pName string The name for the containing frame (typically "subsystems")
-- @param pPositionX number X position of the frame
-- @param pPositionY number Y position of the frame
-- @param pFrameWidth number Total width of the frame
-- @param pFrameHeight number Total height of the frame (divided into 2 rows)
-- @return table A Frame UI element containing 12 subsystem buttons
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

--- Creates a text label for displaying ship statistics or labels.
-- Uses Taskbar_MenuButtonTextStyle with black text, left-aligned.
-- @param pName string The unique name for the label (e.g., "unitname", "unitrole")
-- @param pText string|nil The localized text or string ID to display (nil for dynamic content)
-- @param pPositionX number X position within parent frame
-- @param pPositionY number Y position within parent frame
-- @param pSizeX number Width of the label
-- @param pSizeY number Height of the label
-- @return table A TextLabel UI element definition
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

--- Creates a frame containing labels for unit name and role display.
-- Layout: [Name Label][Name Value][Role Label][Role Value]
-- @param pName string The name for the containing frame
-- @param pPositionX number X position of the frame
-- @param pPositionY number Y position of the frame
-- @param pSizeX number Total width of the frame
-- @param pSizeY number Height of the frame
-- @return table A Frame containing unitnamelabel, unitname, unitrolelabel, unitrole labels
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

--- Creates a stat indicator with an icon and value label.
-- Displays ship statistics like speed, attack damage, or shields with
-- an appropriate icon from stats_icons.mres texture.
-- @param pName string The stat name ("unitmaxspeed", "unitattackdamage", or "unitshields")
-- @param pHelpTip string The localized tooltip string ID
-- @param pPositionX number|nil X position (typically nil, uses autoarrange)
-- @param pPositionY number|nil Y position (typically nil, uses autoarrange)
-- @param pSizeX number Width of the indicator frame
-- @param pSizeY number Height of the indicator frame
-- @return table A Frame containing an icon and TextLabel for the stat value
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

--- Creates an auto-arranging frame containing speed, damage, and shield indicators.
-- Uses autoarrange to lay out the three stat indicators horizontally.
-- @param pName string The name for the containing frame
-- @param pPositionX number X position of the frame
-- @param pPositionY number Y position of the frame
-- @param pSizeX number|nil Width (typically nil, uses autosize)
-- @param pSizeY number|nil Height (typically nil, uses autosize)
-- @return table A Frame containing unitmaxspeed, unitattackdamage, and unitshields indicators
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

--- Creates the detailed ship information panel showing icon, health, subsystems, and stats.
-- This is a complex frame containing:
-- - Unit icon display (centered)
-- - Health progress bar
-- - Subsystems frame with 12 subsystem buttons
-- - Hidden subsystem template buttons (production, sensor, generic, innate)
-- - Selected subsystem popup with icon and health
-- - Unit stats labels (name, role) and indicators (speed, damage, shields)
-- @param pName string The name for the details frame (typically "unitStats")
-- @param pPositionX number X position of the frame
-- @param pPositionY number Y position of the frame
-- @param pSizeX number Width of the frame
-- @param pSizeY number Height of the frame
-- @return table A Frame containing all ship detail UI elements
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

--- Creates the main menu bar containing all primary taskbar buttons.
-- This is the horizontal bar with buttons for Fleet, Strike, Tactics, Orders,
-- Events, Objectives, Chat, Sensors, Diplomacy, Recall, Menu, Build, Research,
-- Launch, and navigation controls.
-- @param pName string The name for the menu bar frame
-- @param pPositionX number X position of the menu bar
-- @param pPositionY number Y position of the menu bar
-- @param pSizeX number Width of the menu bar
-- @param pSizeY number Height of the menu bar
-- @return table A Frame containing all menu bar buttons and background
function NewTaskbarCreateMenuBar(pName, pPositionX, pPositionY, pSizeX, pSizeY)
	local buttonHeight = pSizeY - 2; -- 1px border all around.
	local buttonWidth = pSizeX / 20;

	return {
		type = "Frame",
		name = pName,
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
		NewTaskbarCreatePrimaryButton("btnFleet", "$2705", {10, 1}, {buttonWidth, buttonHeight}, "UI_ToggleScreen( 'FleetMenu', 0)", nil, "$2740", {toggleButton=1}), -- FLEET

		-- Strike group button
		NewTaskbarCreatePrimaryButton("btnStrike", "$2714", {60, 1}, {buttonWidth, buttonHeight}, nil, nil, "$2741", {toggleButton=1, onMousePressed="UI_ToggleScreen( 'StrikeGroupsMenu', 0)"}), -- STRIKE GRP

		-- Tactics button
		NewTaskbarCreatePrimaryButton("btnTactics", "$2715", {110, 1}, {buttonWidth, buttonHeight}, nil, nil, "$2742", {toggleButton=1, onMousePressed="UI_ToggleScreen( 'TacticsMenu', 0)"}), -- TACTICS

		-- Orders button
		NewTaskbarCreatePrimaryButton("btnOrders", "$3150", {160, 1}, {buttonWidth, buttonHeight}, "UI_ToggleScreen( 'OrdersMenu', 0)", 150, "$2729", {toggleButton=1}), -- ORDERS

		-- Events button
		NewTaskbarCreatePrimaryButton("btnEvents", "$2707", {315, 1}, {buttonWidth, buttonHeight}, "UI_ToggleScreen( 'EventsScreen', 0)", 140, "$2743"), -- EVENTS

		-- Events button (wide version)
		NewTaskbarCreatePrimaryButton("btnEvents_wide", "$2707", {315, 1}, {buttonWidth, buttonHeight}, "UI_ToggleScreen( 'EventsScreen', 0)", 140, "$2743", {visible=0}), -- EVENTS

		-- Objectives button
		NewTaskbarCreatePrimaryButton("btnObjectives", "GOALS", {255, 1}, {buttonWidth, buttonHeight}, "UI_ToggleScreen( 'ObjectivesList', 0)", 137, "$2744"), -- OBJECTIVES

		-- Chat button
		NewTaskbarCreatePrimaryButton("btnChat", "$2716", {255, 1}, {buttonWidth, buttonHeight}, "UI_ToggleScreen( 'ChatScreen', 0)", 131, "$2747"), -- CHAT

		-- Sensors button
		NewTaskbarCreatePrimaryButton("btnSensors", "$2703", {375, 1}, {buttonWidth, buttonHeight}, "MainUI_UserEvent( eSensorsManager)", 54, "$2745"), -- SENSORS

		-- Diplomacy button
		NewTaskbarCreatePrimaryButton("btnDiplomacy", "$2713", {495, 1}, {buttonWidth, buttonHeight}, "UI_ToggleScreen( 'DiplomacyScreen', 0)", 141, "$2746"), -- DIPLOMACY

		-- Speech recall button
		NewTaskbarCreatePrimaryButton("btnRecall", "$2762", {495, 1}, {buttonWidth, buttonHeight}, "UI_ToggleScreen( 'SpeechRecall', 0)", 142, "$2763", {visible=0}), -- RECALL

		-- Menu button
		NewTaskbarCreatePrimaryButton("btnMenu", "$2702", {435, 1}, {buttonWidth, buttonHeight}, "MainUI_UserEvent( eMenu )", 4, "$2774", {toggleButton=0}), -- MENU

		-- Menu button (wide version)
		NewTaskbarCreatePrimaryButton("btnMenu_wide", "$2702", {435, 1}, {buttonWidth, buttonHeight}, "MainUI_UserEvent( eMenu )", 4, "$2774", {visible=0, toggleButton=0}), -- MENU

		-- Build button
		NewTaskbarCreatePrimaryButton("btnBuild", "$2700", {595, 1}, {buttonWidth, buttonHeight}, "MainUI_UserEventData( eBuildManager, 1)", 50, "$2748", {toggleButton=1}), -- BUILD

		-- Research button
		NewTaskbarCreatePrimaryButton("btnResearch", "$2701", {655, 1}, {buttonWidth, buttonHeight}, "MainUI_UserEvent( eResearchManager)", 49, "$2749", {toggleButton=1}),

		-- Launch button
		NewTaskbarCreatePrimaryButton("btnLaunch", "$2706", {715, 1}, {buttonWidth, buttonHeight}, "MainUI_UserEventData( eLaunchManager, 1)", 52, "$2760", {toggleButton=1}), -- LAUNCH
	};
end

--- Creates the selection bar showing currently selected ships and commands.
-- This is the main selection interface containing:
-- - Ship buttons frame (14 ship buttons for multi-selection)
-- - Previous/Next navigation buttons
-- - Ship details frame (icon, health, subsystems, stats)
-- - Command dummy buttons (Move, Attack, Guard, Dock, etc.) for engine bindings
-- - Special command dummy buttons (Ping, EMP, Cloak, Scuttle, etc.)
-- @param pName string The name for the selection bar frame (typically "taskbar")
-- @param pPositionX number X position of the selection bar
-- @param pPositionY number Y position of the selection bar
-- @param pSizeX number Width of the selection bar
-- @param pSizeY number Height of the selection bar
-- @return table A Frame containing all selection bar UI elements
function NewTaskbarCreateSelectionBar(pName, pPositionX, pPositionY, pSizeX, pSizeY)

	local bumperButtonWidth = pSizeY / 2;
	local bumperButtonHeight = pSizeY / 2;

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
		NewTaskbarCreateShipButtonsFrame("shipButtonsFrame", bumperButtonWidth, 0, pSizeX, pSizeY, bumperButtonWidth),

		-- Ship details
		NewTaskbarCreateShipDetailsFrame("unitStats", bumperButtonWidth, 0, pSizeX - (bumperButtonWidth * 2), pSizeY),

		-- back button, hide buttons
		NewTaskbarCreateBumperButton("btnHide1", "$2738", pSizeX - bumperButtonWidth, 0, bumperButtonWidth, bumperButtonHeight, 1), -- Visible until the engine binding is used
		NewTaskbarCreateBumperButton("btnHide2", "$2739", pSizeX - bumperButtonWidth, 0, bumperButtonWidth, bumperButtonHeight, 0), -- Invisible until the engine binding is used
		NewTaskbarCreateBumperButton("btnShipBack", "$2732", 0, 0, bumperButtonWidth, bumperButtonHeight, 1),

		-- next/prev ship buttons
		NewTaskbarCreateBumperButton("btnShipPrev", "$2730", 0, bumperButtonHeight, bumperButtonWidth, bumperButtonHeight, 0),
		NewTaskbarCreateBumperButton("btnShipNext", "$2731", pSizeX - bumperButtonWidth, bumperButtonHeight, bumperButtonWidth, bumperButtonHeight, 0),
   };
end

SELECTION_BAR_WIDTH = 600
SELECTION_BAR_HEIGHT = 30

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

	-- Menu bar
	NewTaskbarCreateMenuBar("menubar", 0, 36, 800, 21),

	-- Commands help tip label
	{
		type = "TextLabel",
		name = "commandsHelpTip",
		position = {4, SELECTION_BAR_HEIGHT - 8 },
		size = { 214, 13},
		Text = {
			textStyle = "Taskbar_MenuButtonTextStyle",
			color = { 255, 255, 255, 255},
			hAlign = "Left",
		},
	},

	-- Selection bar
	NewTaskbarCreateSelectionBar("taskbar", 400 - SELECTION_BAR_WIDTH / 2, 1, SELECTION_BAR_WIDTH, SELECTION_BAR_HEIGHT),
}
