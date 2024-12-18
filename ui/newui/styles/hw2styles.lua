-- Cold Fusion LUA Decompiler v1.0.0
-- By 4E534B
-- Date: 12-15-2024 Time: 11:14:45
-- On error(s), send source (compiled) file to 4E534B@gmail.com
-- 
-- This file contains some strange custom operator that I don't think is valid lua syntax: ',;'.
HW2StyleSheet =
{
	defaultElementStyle = "DefaultStyle",
	defaultTextStyle = "DefaultTextStyle",
	defaultButtonStyle = "DefaultButtonStyle",
	defaultScrollBarStyle = "DefaultScrollBarStyle",
	defaultScrollViewStyle = "DefaultScrollViewStyle",
	defaultListBoxStyle = "FEListBoxStyle",
	defaultDropDownListBoxStyle = "FEDropDownListBoxStyle",
	defaultTextInputStyle = "DefaultTextInputStyle",
	defaultTableStyle = "FETableStyle",
	pixelUVCoords = 1,
	StringAttributes =
	{
		{
			name = "FEColorHeading1",
			string = "255,255,255,255",
		},
		{
			name = "FEColorHeading2",
			string = "255,255,255,255",
		},
		{
			name = "FEColorHeading3",
			string = "0,0,0,255",
		},
		{
			name = "FEColorHeading4",
			string = "0,0,0,255",
		},
		{
			name = "FEColorBackground1",
			string = "157,172,194,200",
		},
		{
			name = "FEColorBackground2",
			string = "0,0,0,128",
		},
		{
			name = "FEColorDialog",
			string = "157,172,194,225",
		},
		{
			name = "FEColorOutline",
			string = "0,0,0,0",
		},
		{
			name = "FEColorPopupOutline",
			string = "0,0,0,0",
		},
		{
			name = "FEColorScrollButtonDefault",
			string = "255,255,255,127",
		},
		{
			name = "FEColorScrollButtonOver",
			string = "255,255,255,255",
		},
		{
			name = "FEColorScrollButtonPressed",
			string = "255,255,255,255",
		},
		{
			name = "FEColorScrollButtonDisabled",
			string = "151,151,151,255",
		},
		{
			name = "FEColorDisabled",
			string = "151,151,151,255",
		},
		{
			name = "IGColorBackground1",
			string = "157,172,194,200",
		},
		{
			name = "IGColorOutline",
			string = "255,255,255,255",
		},
		{
			name = "IGColorProgress1",
			string = "255,255,255,255",
		},
		{
			name = "IGColorProgress2",
			string = "255,255,255,255",
		},
		{
			name = "IGColorButton",
			string = "255,255,255,255",
		},
		{
			name = "IGColorButtonBorder",
			string = "0,0,0,255",
		},
		{
			name = "IGColorButtonOver",
			string = "255,255,255,255",
		},
		{
			name = "IGColorButtonOverBorder",
			string = "255,255,255,255",
		},
		{
			name = "IGColorButtonPressed",
			string = "255,255,255,127",
		},
		{
			name = "IGColorButtonPressedBorder",
			string = "255,255,255,255",
		},
		{
			name = "IGColorButtonFlash",
			string = "48,108,136,255",
		},
		{
			name = "IGColorButtonFlashBorder",
			string = "255,255,255,255",
		},
		{
			name = "IGColorButtonText",
			string = "255,255,255,255",
		},
		{
			name = "IGColorButtonDisabled",
			string = "127,127,127,127",
		},
		{
			name = "IGColorButtonDisabledBorder",
			string = "48,108,136,255",
		},
		{
			name = "IGColorButtonDisabledText",
			string = "48,108,136,255",
		},
		{
			name = "IGColorFacilityDisabled",
			string = "255,255,255,200",
		},
	},
	DefaultTextStyle =
	{
		type = "Text",
		color =
		{
			0,
			0,
			0,
			255,
		},
		hAlign = "Left",
		vAlign = "Middle",
		font = "ButtonFont",
	},
	DefaultStyle =
	{
		type = "InterfaceElement",
		position =
		{
			0,
			0,
		},
		size =
		{
			100,
			100,
		},
		enabled = 1,
		visible = 1,
	},
	DefaultButtonStyle =
	{
		type = "Button",
		style = "DefaultStyle",
		toggleButton = 0,
		pressed = 0,
		size =
		{
			120,
			13,
		},
	},
	DefaultScrollBar_ScrollVertButtonStyle =
	{
		type = "Button",
		size =
		{
			13,
			13,
		},
		soundOnClicked = "SFX_ScrollButtonClick",
	},
	DefaultScrollBar_ScrollHorzButtonStyle =
	{
		type = "Button",
		size =
		{
			13,
			13,
		},
		soundOnClicked = "SFX_ScrollButtonClick",
	},
	DefaultScrollBar_TrackVertStyle =
	{
		size =
		{
			13,
			17,
		},
		minSize =
		{
			13,
			17,
		},
		borderWidth = 1,
		backgroundColor = "FEColorScrollButtonDefault",
		borderColor = "FEColorScrollButtonDefault",
		pressedColor = "FEColorScrollButtonPressed",
		pressedBorderColor = "FEColorScrollButtonOver",
		overColor = "FEColorScrollButtonDefault",
		overBorderColor = "FEColorScrollButtonOver",
		disabledColor = "FEColorScrollButtonDisabled",
		disabledBorderColor = "FEColorScrollButtonDisabled",
		DefaultGraphic =
		{
			size =
			{
				11,
				15,
			},
			texture = "DATA:UI\\NewUI\\Styles\\ScrollGripVert.mres",
			textureUV =
			{
				0,
				0,
				11,
				15,
			},
			color =
			{
				0,
				0,
				0,
				255,
			},
		},
		soundOnClicked = "",
		soundOnReleased = "SFX_ScrollBarPage",
	},
	DefaultScrollBar_TrackHorzStyle =
	{
		size =
		{
			17,
			13,
		},
		minSize =
		{
			17,
			13,
		},
		borderWidth = 1,
		backgroundColor = "FEColorScrollButtonDefault",
		borderColor = "FEColorScrollButtonDefault",
		pressedColor = "FEColorScrollButtonPressed",
		pressedBorderColor = "FEColorScrollButtonOver",
		overColor = "FEColorScrollButtonDefault",
		overBorderColor = "FEColorScrollButtonOver",
		disabledColor = "FEColorScrollButtonDisabled",
		disabledBorderColor = "FEColorScrollButtonDisabled",
		DefaultGraphic =
		{
			size =
			{
				15,
				11,
			},
			texture = "DATA:UI\\NewUI\\Styles\\ScrollGripHorz.mres",
			textureUV =
			{
				0,
				0,
				15,
				11,
			},
			color =
			{
				0,
				0,
				0,
				255,
			},
		},
		soundOnClicked = "",
		soundOnReleased = "SFX_ScrollBarPage",
	},
	DefaultScrollBarStyle =
	{
		type = "ScrollBar",
		range =
		{
			0,
			100,
		},
		scrollPosition = 0,
		stepSize = 5,
		pageSize = 20,
		orientation = "Vertical",
		soundOnPage = "SFX_ScrollBarPage",
		TrackFrame =
		{
			type = "Frame",
			backgroundColor =
			{
				53,
				163,
				250,
				50,
			},
		},
		UpButton =
		{
			type = "Button",
			buttonStyle = "DefaultScrollBar_ScrollVertButtonStyle",
			size =
			{
				13,
				15,
			},
			disabledColor =
			{
				0,
				0,
				0,
				0,
			},
			DisabledGraphic =
			{
				position =
				{
					0,
					0,
				},
				size =
				{
					13,
					13,
				},
				texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\vert_disabled.mres",
				textureUV =
				{
					0,
					0,
					13,
					13,
				},
				color = "FEColorScrollButtonDisabled",
			},
			;
			{
				type = "Button",
				size =
				{
					13,
					13,
				},
				position =
				{
					0,
					0,
				},
				giveParentMouseInput = 1,
				borderWidth = 1,
				backgroundColor = "FEColorScrollButtonDefault",
				borderColor = "FEColorScrollButtonDefault",
				pressedColor = "FEColorScrollButtonDefault",
				pressedBorderColor = "FEColorScrollButtonOver",
				overColor = "FEColorScrollButtonDefault",
				overBorderColor = "FEColorScrollButtonOver",
				disabledColor = "FEColorScrollButtonDisabled",
				disabledBorderColor = "FEColorScrollButtonDisabled",
				DefaultGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\vert_default.mres",
					textureUV =
					{
						0,
						0,
						13,
						13,
					},
				},
				OverGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\vert_default.mres",
					textureUV =
					{
						0,
						0,
						13,
						13,
					},
				},
				PressedGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\vert_pressed.mres",
					textureUV =
					{
						0,
						0,
						13,
						13,
					},
				},
			},
		},
		DownButton =
		{
			type = "Button",
			buttonStyle = "DefaultScrollBar_ScrollVertButtonStyle",
			size =
			{
				13,
				15,
			},
			disabledColor =
			{
				0,
				0,
				0,
				0,
			},
			DisabledGraphic =
			{
				position =
				{
					0,
					2,
				},
				size =
				{
					13,
					13,
				},
				texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\vert_disabled.mres",
				textureUV =
				{
					0,
					13,
					13,
					0,
				},
				color = "FEColorScrollButtonDisabled",
			},
			;
			{
				type = "Button",
				size =
				{
					13,
					13,
				},
				position =
				{
					0,
					2,
				},
				giveParentMouseInput = 1,
				borderWidth = 1,
				backgroundColor = "FEColorScrollButtonDefault",
				borderColor = "FEColorScrollButtonDefault",
				pressedColor = "FEColorScrollButtonDefault",
				pressedBorderColor = "FEColorScrollButtonOver",
				overColor = "FEColorScrollButtonDefault",
				overBorderColor = "FEColorScrollButtonOver",
				disabledColor = "FEColorScrollButtonDisabled",
				disabledBorderColor = "FEColorScrollButtonDisabled",
				DefaultGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\vert_default.mres",
					textureUV =
					{
						0,
						13,
						13,
						0,
					},
				},
				OverGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\vert_default.mres",
					textureUV =
					{
						0,
						13,
						13,
						0,
					},
				},
				PressedGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\vert_pressed.mres",
					textureUV =
					{
						0,
						13,
						13,
						0,
					},
				},
			},
		},
		LeftButton =
		{
			type = "Button",
			buttonStyle = "DefaultScrollBar_ScrollHorzButtonStyle",
			size =
			{
				15,
				13,
			},
			disabledColor =
			{
				0,
				0,
				0,
				0,
			},
			DisabledGraphic =
			{
				position =
				{
					0,
					0,
				},
				size =
				{
					13,
					13,
				},
				texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\horz_disabled.mres",
				textureUV =
				{
					0,
					0,
					13,
					13,
				},
				color = "FEColorScrollButtonDisabled",
			},
			;
			{
				type = "Button",
				size =
				{
					13,
					13,
				},
				position =
				{
					0,
					0,
				},
				giveParentMouseInput = 1,
				borderWidth = 1,
				backgroundColor = "FEColorScrollButtonDefault",
				borderColor = "FEColorScrollButtonDefault",
				pressedColor = "FEColorScrollButtonDefault",
				pressedBorderColor = "FEColorScrollButtonOver",
				overColor = "FEColorScrollButtonDefault",
				overBorderColor = "FEColorScrollButtonOver",
				disabledColor = "FEColorScrollButtonDisabled",
				disabledBorderColor = "FEColorScrollButtonDisabled",
				DefaultGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\horz_default.mres",
					textureUV =
					{
						0,
						0,
						13,
						13,
					},
				},
				OverGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\horz_default.mres",
					textureUV =
					{
						0,
						0,
						13,
						13,
					},
				},
				PressedGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\horz_pressed.mres",
					textureUV =
					{
						0,
						0,
						13,
						13,
					},
				},
			},
		},
		RightButton =
		{
			type = "Button",
			buttonStyle = "DefaultScrollBar_ScrollHorzButtonStyle",
			size =
			{
				15,
				13,
			},
			disabledColor =
			{
				0,
				0,
				0,
				0,
			},
			DisabledGraphic =
			{
				position =
				{
					2,
					0,
				},
				size =
				{
					13,
					13,
				},
				texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\horz_disabled.mres",
				textureUV =
				{
					13,
					0,
					0,
					13,
				},
				color = "FEColorScrollButtonDisabled",
			},
			;
			{
				type = "Button",
				size =
				{
					13,
					13,
				},
				position =
				{
					2,
					0,
				},
				giveParentMouseInput = 1,
				borderWidth = 1,
				backgroundColor = "FEColorScrollButtonDefault",
				borderColor = "FEColorScrollButtonDefault",
				pressedColor = "FEColorScrollButtonDefault",
				pressedBorderColor = "FEColorScrollButtonOver",
				overColor = "FEColorScrollButtonDefault",
				overBorderColor = "FEColorScrollButtonOver",
				disabledColor = "FEColorScrollButtonDisabled",
				disabledBorderColor = "FEColorScrollButtonDisabled",
				DefaultGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\horz_default.mres",
					textureUV =
					{
						13,
						0,
						0,
						13,
					},
				},
				OverGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\horz_default.mres",
					textureUV =
					{
						13,
						0,
						0,
						13,
					},
				},
				PressedGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\horz_pressed.mres",
					textureUV =
					{
						13,
						0,
						0,
						13,
					},
				},
			},
		},
		TrackVertButton =
		{
			type = "Button",
			buttonStyle = "DefaultScrollBar_TrackVertStyle",
		},
		TrackHorzButton =
		{
			type = "Button",
			name = "trackHorzButton",
			buttonStyle = "DefaultScrollBar_TrackHorzStyle",
		},
	},
	DefaultScrollViewStyle =
	{
		type = "ScrollView",
		name = "noNameScrollView",
		size =
		{
			250,
			250,
		},
		scrollHorz = 1,
		scrollVert = 1,
		contentsSize =
		{
			500,
			500,
		},
		scrollPosition =
		{
			0,
			0,
		},
		VertScrollBar =
		{
			type = "ScrollBar",
			name = "DefaultScrollView_vertScrollBar",
			orientation = "Vertical",
		},
		HorzScrollBar =
		{
			type = "ScrollBar",
			name = "DefaultScrollView_horzScrollBar",
			orientation = "Horizontal",
		},
	},
	DefaultTextInputStyle =
	{
		type = "TextInput",
		cursorPosition = 0,
		cursorDelay = 350,
		cursorWidth = 1,
		cursorColor =
		{
			255,
			255,
			255,
			255,
		},
		autosize = 0,
		marginWidth = 3,
		maxTextLength = 256,
		Text =
		{
			color =
			{
				255,
				255,
				255,
				255,
			},
			font = "ButtonFont",
			vAlign = "Middle",
			hAlign = "Left",
		},
		soundOnPressed = "SFX_TextInputClicked",
		soundOnAccept = "SFX_TextInputAccept",
	},
	INTROTEXT =
	{
		type = "Text",
		font = "Heading1Font",
		color = "FEColorHeading1",
		vAlign = "Top",
		hAlign = "Center",
		offset =
		{
			0,
			0,
		},
	},
	FEHeading1 =
	{
		type = "Text",
		font = "Heading1Font",
		color = "FEColorHeading1",
		vAlign = "Middle",
		hAlign = "Left",
		offset =
		{
			0,
			0,
		},
	},
	FEHeading2 =
	{
		type = "Text",
		font = "Heading2Font",
		color = "FEColorHeading2",
		vAlign = "Middle",
		hAlign = "Left",
		offset =
		{
			0,
			0,
		},
	},
	FEHeading3 =
	{
		type = "Text",
		font = "Heading3Font",
		color = "FEColorHeading3",
		vAlign = "Middle",
		hAlign = "Left",
		offset =
		{
			0,
			0,
		},
	},
	FEHeading4 =
	{
		type = "Text",
		font = "Heading4Font",
		color = "FEColorHeading4",
		vAlign = "Middle",
		hAlign = "Left",
		offset =
		{
			0,
			0,
		},
	},
	FEHelpTipTextStyle =
	{
		type = "Text",
		font = "ButtonFont",
		color =
		{
			0,
			0,
			0,
			255,
		},
		vAlign = "Middle",
		hAlign = "Left",
	},
	FEButtonTextStyle =
	{
		type = "Text",
		font = "ButtonFont",
		color =
		{
			0,
			0,
			0,
			255,
		},
		vAlign = "Middle",
		hAlign = "Center",
	},
	FEListBoxItemTextStyle =
	{
		type = "Text",
		font = "ButtonFont",
		color =
		{
			0,
			0,
			0,
			255,
		},
		vAlign = "Middle",
		hAlign = "Left",
		offset =
		{
			4,
			0,
		},
	},
	FETableTitleTextStyle =
	{
		type = "Text",
		textStyle = "FEButtonTextStyle",
		color =
		{
			0,
			0,
			0,
			255,
		},
		vAlign = "Middle",
		hAlign = "Left",
		offset =
		{
			4,
			0,
		},
	},
	FETableCellTextStyle =
	{
		type = "Text",
		font = "ListBoxItemFont",
		vAlign = "Middle",
		hAlign = "Left",
		offset =
		{
			4,
			0,
		},
		color =
		{
			255,
			255,
			255,
			255,
		},
	},
	SubtitleSPTextStyle =
	{
		type = "Text",
		font = "SPSubtitleFont",
		vAlign = "Top",
		hAlign = "Left",
		offset =
		{
			4,
			0,
		},
		color =
		{
			255,
			255,
			255,
			255,
		},
	},
	SubtitleGenericTextStyle =
	{
		type = "Text",
		font = "GenericSubtitleFont",
		vAlign = "Top",
		hAlign = "Left",
		offset =
		{
			4,
			0,
		},
		color =
		{
			255,
			255,
			255,
			255,
		},
	},
	SubtitleLocationCardTextStyle =
	{
		type = "Text",
		font = "LocationCardFont",
		vAlign = "Top",
		hAlign = "Center",
		offset =
		{
			0,
			0,
		},
		color =
		{
			255,
			255,
			255,
			255,
		},
	},
	FEPopupBackgroundStyle =
	{
		type = "InterfaceElement",
		backgroundColor =
		{
				162,
				162,
				162,
				0,
		},
		BackgroundGraphic =
		{
			texture = "DATA:UI\\NewUI\\Clearbg.tga",
			textureUV =
			{
				0,
				0,
				0, --16
				0, --128
			},
			stretchOnDraw = 0,
			color =
			{
				162,
				162,
				162,
				0,
			},
		},
	},
	--Mercury Button
	FEButtonStyle1 =
	{
		type = "Button",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		size =
		{
			120,
			12,
		},
		--toggleButton = 1,
		flashSpeed = 250,
		disabledTextColor = "FEColorDisabled",
		soundOnEnter = "SFX_ButtonEnter",
		soundOnClicked = "SFX_ButtonClick",
		Text =
		{
			textStyle = "FEButtonTextStyle",
		},
		DefaultGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			color =
				{ 175, 175, 175, 255, },
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		OverGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		ClickedGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		PressedGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		FlashGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
			color =
			{
				220,
				220,
				255,
				255,
			},
		},
		flashTextColor =
		{
			0,
			0,
			0,
			255,
		},
		flashColor =
		{
			255,
			255,
			255,
			255,
		},
		textColor =
		{
			0,
			0,
			0,
			255,
		},
		pressedTextColor =
		{
			0,
			0,
			0,
			255,
		},
		clickedTextColor =
		{
			255,
			255,
			255,
			255,
		},
		overTextColor =
		{
			0,
			0,
			0,
			255,
		},
		--outerBorderWidth = 1,
		borderColor =
		{
			0,
			0,
			0,
			255,
		},
		overBorderColor =
		{
			0,
			0,
			0,
			255,
		},
		clickedBorderColor =
		{
			0,
			0,
			0,
			255,
		},
		pressedBorderColor =
		{
			0,
			0,
			0,
			255,
		},
		disabledColor =
		{
			127,
			127,
			127,
			0,
		},
		disabledTextColor =
		{
			127,
			127,
			127,
			0,
		},
	},
	FEButtonStyle2 =
	{
		type = "Button",
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		size =
		{
			120,
			12,
		},
		--toggleButton = 1,
		flashSpeed = 250,
		disabledTextColor = "FEColorDisabled",
		soundOnEnter = "SFX_ButtonEnter",
		soundOnClicked = "SFX_ButtonClick",
		Text =
		{
			textStyle = "FEButtonTextStyle",
		},
		DefaultGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			color =
				{ 175, 175, 175, 255, },
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		OverGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		ClickedGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		PressedGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		FlashGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
			color =
			{
				220,
				220,
				255,
				255,
			},
		},
		flashTextColor =
		{
			0,
			0,
			0,
			255,
		},
		flashColor =
		{
			255,
			255,
			255,
			255,
		},
		textColor =
		{
			0,
			0,
			0,
			255,
		},
		pressedTextColor =
		{
			0,
			0,
			0,
			255,
		},
		clickedTextColor =
		{
			255,
			255,
			255,
			255,
		},
		overTextColor =
		{
			0,
			0,
			0,
			255,
		},
		--outerBorderWidth = 1,
		borderColor =
		{
			0,
			0,
			0,
			255,
		},
		overBorderColor =
		{
			0,
			0,
			0,
			255,
		},
		clickedBorderColor =
		{
			0,
			0,
			0,
			255,
		},
		pressedBorderColor =
		{
			0,
			0,
			0,
			255,
		},
		disabledColor =
		{
			127,
			127,
			127,
			0,
		},
		disabledTextColor =
		{
			127,
			127,
			127,
			0,
		},
	},
	--EndMercury
	FEButtonStyle1NoEnterSound =
	{
		type = "Button",
		buttonStyle = "FEButtonStyle1",
		soundOnEnter = "",
	},
	FEButtonStyle2NoEnterSound =
	{
		type = "Button",
		buttonStyle = "FEButtonStyle1",
		soundOnEnter = "",
	},
	FETabButtonStyle =
	{
		type = "Button",
		size =
		{
			90,
			15,
		},
		borderWidth = 1,
		backgroundColor =
		{
			0,
			0,
			0,
			45,
		},
		borderColor = "FEColorHeading3",
		textColor = "FEColorOutline",
		overColor =
		{
			0,
			0,
			0,
			127,
		},
		overBorderColor = "FEColorHeading3",
		overTextColor =
		{
			0,
			0,
			0,
			255,
		},
		pressedColor = 
		{
			0,
			0,
			0,
			200,
		},
		pressedBorderColor = "FEColorHeading3",
		pressedTextColor =
		{
			255,
			255,
			255,
			255,
		},
		disabledColor =
		{
			0,
			0,
			0,
			255,
		},
		disabledBorderColor =
		{
			152,
			152,
			152,
			255,
		},
		disabledTextColor =
		{
			152,
			152,
			152,
			255,
		},
		flashColor =
		{
			255,
			255,
			255,
			255,
		},
		soundOnEnter = "SFX_TabEnter",
	},
	FEListBoxItemButtonStyle =
	{
		type = "Button",
		size =
		{
			192,
			13,
		},
		borderWidth = 1,
		borderColor =
		{
			0,
			0,
			0,
			0,
		},
		backgroundColor =
		{
			255,
			255,
			255,
			127,
		},
		overBorderColor =
		{
			0,
			0,
			0,
			0,
		},
		overColor =
		{
			127,
			127,
			127,
			127,
		},
		pressedBorderColor =
		{
			255,
			255,
			255,
			255,
		},
		pressedColor =
		{
			255,
			255,
			255,
			127,
		},
		disabledColor =
		{
			50,
			50,
			50,
			255,
		},
		disabledBorderColor =
		{
			152,
			152,
			152,
			255,
		},
		disabledTextColor =
		{
			152,
			152,
			152,
			255,
		},
		soundOnEnter = "SFX_ListBoxItemEnter",
		soundOnClicked = "SFX_ListBoxItemClick",
	},
	FETableTitleButtonStyle =
	{
		backgroundColor = "FEColorOutline",
		defaultColor = "FEColorOutline",
		overColor =
		{
			0,
			0,
			0,
			255,
		},
		pressedColor =
		{
			255,
			255,
			255,
			255,
		},
		soundOnEnter = "SFX_ButtonEnter",
		soundOnClicked = "SFX_ButtonClick",
	},
	FECheckBoxButtonStyle =
	{
		type = "Button",
		toggleButton = 1,
		size =
		{
			13,
			13,
		},
		backgroundColor =
		{
			33,
			54,
			77,
			255,
		},
		borderColor =
		{
			56,
			162,
			250,
			255,
		},
		borderWidth = 2,
		disabledColor =
		{
			50,
			50,
			50,
			255,
		},
		disabledBorderColor =
		{
			152,
			152,
			152,
			255,
		},
		disabledTextColor =
		{
			152,
			152,
			152,
			255,
		},
		flashColor =
		{
			254,
			116,
			7,
			255,
		},
		soundOnButtonPressed = "SFX_CheckBoxUnchecked",
		soundOnButtonUnpressed = "SFX_CheckBoxChecked",
		PressedGraphic =
		{
			size =
			{
				13,
				13,
			},
			texture = "DATA:\\UI\\NewUI\\Elements\\checkbox.mres",
			textureUV =
			{
				0,
				0,
				13,
				13,
			},
			color =
			{
				56,
				162,
				250,
				255,
			},
		},
		DisabledPressedGraphic =
		{
			size =
			{
				13,
				13,
			},
			texture = "DATA:\\UI\\NewUI\\Elements\\checkbox.mres",
			textureUV =
			{
				0,
				0,
				13,
				13,
			},
			color =
			{
				152,
				152,
				152,
				255,
			},
		},
	},
	FERadioButtonStyle =
	{
		type = "Button",
		buttonStyle = "FECheckBoxButtonStyle",
	},
	FEReadyButtonStyle =
	{
		type = "Button",
		buttonStyle = "FECheckBoxButtonStyle",
		soundOnButtonPressed = "SFX_ReadyButtonChecked",
		soundOnButtonUnpressed = "SFX_ReadyButtonUnchecked",
	},
	FEScrollBarStyle =
	{
		type = "ScrollBar",
		scrollBarStyle = "DefaultScrollBarStyle",
	},
	FEListBoxStyle =
	{
		type = "ListBox",
		size =
		{
			256,
			256,
		},
		selected = 0,
		leftScroll = 0,
		showScrollBar = 1,
		ScrollBar =
		{
			type = "ScrollBar",
			name = "ListBoxStyle_scrollBar",
		},
		marginHeight = 2,
		scrollBarSpace = 2,
	},
	FEDropDownListBoxStyle =
	{
		type = "DropDownListBox",
		size =
		{
			208,
			13,
		},
		itemsToShowOnDrop = 10,
		soundOnClicked = "SFX_DropDownListClick",
		ListBox =
		{
			type = "ListBox",
			name = "listLevelsListBox",
			listBoxStyle = "FEListBoxStyle",
			size =
			{
				208,
				130,
			},
			backgroundColor =
			{
				255,
				255,
				255,
				127,
			},
			scrollBarSpace = 1,
			soundOnExit = "",
		},
		Button =
		{
			type = "Button",
			buttonStyle = "DefaultScrollBar_ScrollVertButtonStyle",
			size =
			{
				15,
				13,
			},
			disabledColor =
			{
				0,
				0,
				0,
				0,
			},
			DisabledGraphic =
			{
				position =
				{
					2,
					0,
				},
				size =
				{
					13,
					13,
				},
				texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\vert_disabled.mres",
				textureUV =
				{
					0,
					13,
					13,
					0,
				},
				color = "FEColorScrollButtonDisabled",
			},
			soundOnClicked = "SFX_DropDownListClick",
			;
			{
				type = "Button",
				size =
				{
					13,
					13,
				},
				position =
				{
					2,
					0,
				},
				giveParentMouseInput = 1,
				borderWidth = 1,
				backgroundColor = "FEColorScrollButtonDefault",
				borderColor = "FEColorScrollButtonDefault",
				pressedColor = "FEColorScrollButtonDefault",
				pressedBorderColor = "FEColorScrollButtonOver",
				overColor = "FEColorScrollButtonDefault",
				overBorderColor = "FEColorScrollButtonOver",
				disabledColor = "FEColorScrollButtonDisabled",
				disabledBorderColor = "FEColorScrollButtonDisabled",
				DefaultGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\vert_default.mres",
					textureUV =
					{
						0,
						13,
						13,
						0,
					},
				},
				PressedGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\vert_pressed.mres",
					textureUV =
					{
						0,
						13,
						13,
						0,
					},
				},
				OverGraphic =
				{
					size =
					{
						13,
						13,
					},
					texture = "DATA:UI\\NewUI\\Styles\\ArrowButtons\\vert_pressed.mres",
					textureUV =
					{
						0,
						13,
						13,
						0,
					},
				},
			},
		},
		soundOnEnter = "SFX_DropDownListEnter",
	},
	FETextInputStyle =
	{
		type = "TextInput",
		size =
		{
			120,
			13,
		},
		borderWidth = 1,
		backgroundColor =
		{
			62,
			86,
			98,
			255,
		},
		borderColor =
		{
			112,
			157,
			180,
			255,
		},
		borderWidth = 1,
		Text =
		{
			color =
			{
				255,
				255,
				255,
				255,
			},
			font = "ButtonFont",
			vAlign = "Middle",
			hAlign = "Left",
		},
	},
	FEChatTextInputStyle =
	{
		type = "TextInput",
		size =
		{
			120,
			21,
		},
		borderColor = "FEColorOutline",
		borderWidth = 2,
		marginWidth = 5,
		Text =
		{
			color =
			{
				255,
				255,
				255,
				255,
			},
			font = "ButtonFont",
			vAlign = "Middle",
			hAlign = "Left",
		},
	},
	FETableStyle =
	{
		type = "Table",
		size =
		{
			300,
			200,
		},
		backgroundColor =
		{
			0,
			0,
			0,
			255,
		},
		showColumnTitles = 1,
		showRowTitles = 0,
		headerSpacing = 6,
		cellSpacing =
		{
			2,
			2,
		},
		sortByColumn = 0,
		defaultRowHeight = 15,
		defaultColWidth = 100,
		titleHeight = 15,
		scrollHorz = 0,
		scrollVert = 1,
		contentsSize =
		{
			300,
			400,
		},
		scrollPosition =
		{
			0,
			0,
		},
		selectedRowColor = "FEColorOutline",
		DefaultColTitleCell =
		{
			type = "TableCell",
			name = "hw2tablecoltitle",
			;
			{
				type = "TextButton",
				buttonStyle = "FETableTitleButtonStyle",
				Text =
				{
					textStyle = "FETableTitleTextStyle",
				},
			},
		},
		DefaultCell =
		{
			type = "TableCell",
			name = "hw2tablecell",
			giveParentMouseInput = 1,
			;
			{
				type = "TextLabel",
				name = "lblDefaultCell",
				giveParentMouseInput = 1,
				marginWidth = 4,
				Text =
				{
					textStyle = "FEListBoxItemTextStyle",
					vAlign = "Middle",
					hAlign = "Left",
					color =
					{
						255,
						255,
						255,
						255,
					},
				},
			},
		},
	},
	FESliderStyle =
	{
		type = "ScrollBar",
		orientation = "Horizontal",
		resizeToParent = 0,
		size =
		{
			212,
			13,
		},
		range =
		{
			0,
			100,
		},
		stepSize = 1,
		pageSize = 20,
		TrackVertButton =
		{
			type = "Button",
			buttonStyle = "DefaultScrollBar_TrackVertStyle",
			maxSize =
			{
				13,
				17,
			},
		},
		TrackHorzButton =
		{
			type = "Button",
			name = "trackHorzButton",
			buttonStyle = "DefaultScrollBar_TrackHorzStyle",
			maxSize =
			{
				17,
				13,
			},
		},
	},
	FESliderLabelStyle =
	{
		type = "InterfaceElement",
		borderColor = "FEColorScrollButtonDefault",
		borderWidth = 1,
		backgroundColor =
		{
			0,
			175,
			255,
			127,
		},
		size =
		{
			40,
			13,
		},
		marginWidth = 4,
		Text =
		{
			font = "ButtonFont",
			vAlign = "Middle",
			hAlign = "Right",
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
	},
	FEBorderListBoxStyle =
	{
		type = "ListBox",
		size =
		{
			200,
			100,
		},
		borderColor = "IGColorOutline",
		borderWidth = 1,
		marginWidth = 3,
		marginHeight = 3,
		scrollBarSpace = 6,
	},
	FEInfoButtonStyle =
	{
		type = "Button",
		size =
		{
			16,
			16,
		},
		DefaultGraphic =
		{
			texture = "data:ui/newui/network/infobutton.mres",
			textureUV =
			{
				0,
				0,
				16,
				16,
			},
			color =
			{
				56,
				162,
				250,
			},
		},
		OverGraphic =
		{
			texture = "data:ui/newui/network/infobutton.mres",
			textureUV =
			{
				0,
				0,
				16,
				16,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		PressedGraphic =
		{
			texture = "data:ui/newui/network/infobutton.mres",
			textureUV =
			{
				0,
				0,
				16,
				16,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
	},
	IGHeading1 =
	{
		type = "Text",
		textStyle = "FEHeading3",
	},
	IGHeading2 =
	{
		type = "Text",
		textStyle = "FEHeading4",
	},
	IGHeading3 =
	{
		type = "Text",
		textStyle = "FEHeading4",
	},
	IGButtonTextStyle =
	{
		type = "Text",
		textStyle = "FEButtonTextStyle",
	},
	IGListBoxItemTextStyle =
	{
		type = "Text",
		textStyle = "FEListBoxItemTextStyle",
	},
	IGListBoxItemButtonStyle =
	{
		type = "Button",
		buttonStyle = "FEListBoxItemButtonStyle",
	},
	IGHelpTipTextStyle =
	{
		type = "Text",
		font = "ButtonFont",
		color =
		{
			255,
			255,
			255,
			255,
		},
		vAlign = "Middle",
		hAlign = "Left",
	},
	IGButtonStyle1 =
	{
		type = "Button",
		buttonStyle = "FEButtonStyle1",
	},
	IGButtonStyle1NoEnterSound =
	{
		type = "Button",
		buttonStyle = "FEButtonStyle1NoEnterSound",
	},
	IGRadioButtonStyle =
	{
		type = "Button",
		size =
		{
			120,
			30,
		},
		toggleButton = 1,
		DefaultGraphic =
		{
			size =
			{
				13,
				13,
			},
			texture = "data:ui\\newui\\elements\\radio_button.mres",
			textureUV =
			{
				0,
				0,
				13,
				13,
			},
			color = "FEColorScrollButtonDefault",
		},
		OverGraphic =
		{
			size =
			{
				13,
				13,
			},
			texture = "data:ui\\newui\\elements\\radio_button.mres",
			textureUV =
			{
				0,
				0,
				13,
				13,
			},
			color = "FEColorScrollButtonOver",
		},
		PressedGraphic =
		{
			size =
			{
				13,
				13,
			},
			texture = "data:ui\\newui\\elements\\radio_button.mres",
			textureUV =
			{
				28,
				0,
				41,
				13,
			},
			color = "FEColorScrollButtonOver",
		},
		DisabledGraphic =
		{
			size =
			{
				13,
				13,
			},
			texture = "data:ui\\newui\\elements\\radio_button.mres",
			textureUV =
			{
				0,
				0,
				13,
				13,
			},
			color = "FEColorScrollButtonDisabled",
		},
		soundOnClicked = "SFX_CheckBoxChecked",
	},
	IGRadioButtonTextStyle =
	{
		type = "Text",
		font = "ButtonFont",
		color =
		{
			255,
			255,
			255,
			255,
		},
		hAlign = "Left",
		vAlign = "Middle",
		offset =
		{
			16,
			0,
		},
	},
	IGListBoxStyle =
	{
		type = "ListBox",
		listBoxStyle = "FEListBoxStyle",
	},
	IGDropDownListBoxStyle =
	{
		type = "DropDownListBox",
		dropDownListBoxStyle = "FEDropDownListBoxStyle",
	},
	IGCheckBoxStyle =
	{
		type = "Button",
		buttonStyle = "FECheckBoxButtonStyle",
	},
	IGTabButtonStyle =
	{
		type = "Button",
		buttonStyle = "FETabButtonStyle",
		borderColor = "FEColorPopupOutline",
		textColor = "FEColorPopupOutline",
		overBorderColor = "FEColorPopupOutline",
		pressedColor = "FEColorPopupOutline",
		pressedBorderColor = "FEColorPopupOutline",
		pressedTextColor =
		{
			0,
			0,
			0,
			255,
		},
	},
	BuildManagerButton1 =
	{
		type = "Button",
		buttonStyle = "IGButtonStyle1",
		size =
		{
			23,
			23,
		},
	},
	BuildManagerbutton1 =
	{
		type = "Button",
		buttonStyle = "FEButtonStyle2",
	},
	IGButtonFacility =
	{
		type = "Button",
		size =
		{
			24,
			25,
		},
		soundOnEnter = "SFX_FacilityTabEnter",
		flashColor =
		{
			0,
			0,
			0,
			0,
		},
		flashBorderColor =
		{
			0,
			0,
			0,
			0,
		},
		borderWidth = 0,
	},
	IGButtonShowAll =
	{
		type = "Button",
		buttonStyle = "IGButtonFacility",
		size =
		{
			206,
			15,
		},
		DefaultGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_showall.mres",
			textureUV =
			{
				0,
				0,
				206,
				15,
			},
		},
		PressedGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_showall.mres",
			textureUV =
			{
				0,
				15,
				206,
				30,
			},
		},
		FlashGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_showall.mres",
			textureUV =
			{
				0,
				15,
				206,
				30,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		textColor =
		{
			0,
			0,
			0,
			255,
		},
		overTextColor =
		{
			127,
			127,
			127,
			255,
		},
		pressedTextColor =
		{
			255,
			255,
			255,
			255,
		},
		Text =
		{
			font = "ButtonFont",
			hAlign = "Center",
			vAlign = "Middle",
		},
	},
	IGButtonFighter =
	{
		type = "Button",
		buttonStyle = "IGButtonFacility",
		DefaultGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_norm.mres",
			textureUV =
			{
				0,
				0,
				24,
				25,
			},
		},
		BackgroundGraphic2 =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_no_build.mres",
			textureUV =
			{
				0,
				0,
				24,
				25,
			},
		},
		OverGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_over.mres",
			textureUV =
			{
				0,
				0,
				24,
				25,
			},
		},
		PressedGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				0,
				0,
				24,
				25,
			},
		},
		FlashGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				0,
				0,
				24,
				25,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		DisabledGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_none.mres",
			textureUV =
			{
				0,
				0,
				24,
				25,
			},
			color = "IGColorFacilityDisabled",
		},
	},
	IGButtonCorvette =
	{
		type = "Button",
		buttonStyle = "IGButtonFacility",
		DefaultGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_norm.mres",
			textureUV =
			{
				0,
				25,
				24,
				50,
			},
		},
		BackgroundGraphic2 =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_no_build.mres",
			textureUV =
			{
				0,
				25,
				24,
				50,
			},
		},
		OverGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_over.mres",
			textureUV =
			{
				0,
				25,
				24,
				50,
			},
		},
		FlashGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				0,
				25,
				24,
				50,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		PressedGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				0,
				25,
				24,
				50,
			},
		},
		DisabledGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_none.mres",
			textureUV =
			{
				0,
				25,
				24,
				50,
			},
			color = "IGColorFacilityDisabled",
		},
	},
	IGButtonFrigate =
	{
		type = "Button",
		buttonStyle = "IGButtonFacility",
		DefaultGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_norm.mres",
			textureUV =
			{
				0,
				50,
				24,
				75,
			},
		},
		BackgroundGraphic2 =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_no_build.mres",
			textureUV =
			{
				0,
				50,
				24,
				75,
			},
		},
		FlashGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				0,
				50,
				24,
				75,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		OverGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_over.mres",
			textureUV =
			{
				0,
				50,
				24,
				75,
			},
		},
		PressedGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				0,
				50,
				24,
				75,
			},
		},
		DisabledGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_none.mres",
			textureUV =
			{
				0,
				50,
				24,
				75,
			},
			color = "IGColorFacilityDisabled",
		},
	},
	IGButtonCapital =
	{
		type = "Button",
		buttonStyle = "IGButtonFacility",
		DefaultGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_norm.mres",
			textureUV =
			{
				0,
				75,
				24,
				100,
			},
		},
		BackgroundGraphic2 =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_no_build.mres",
			textureUV =
			{
				0,
				75,
				24,
				100,
			},
		},
		FlashGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				0,
				75,
				24,
				100,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		OverGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_over.mres",
			textureUV =
			{
				0,
				75,
				24,
				100,
			},
		},
		PressedGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				0,
				75,
				24,
				100,
			},
		},
		DisabledGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_none.mres",
			textureUV =
			{
				0,
				75,
				24,
				100,
			},
			color = "IGColorFacilityDisabled",
		},
	},
	IGButtonPlatform =
	{
		type = "Button",
		buttonStyle = "IGButtonFacility",
		DefaultGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_norm.mres",
			textureUV =
			{
				24,
				0,
				48,
				25,
			},
		},
		BackgroundGraphic2 =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_no_build.mres",
			textureUV =
			{
				24,
				0,
				48,
				25,
			},
		},
		FlashGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				24,
				0,
				48,
				25,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		OverGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_over.mres",
			textureUV =
			{
				24,
				0,
				48,
				25,
			},
		},
		PressedGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				24,
				0,
				48,
				25,
			},
		},
		DisabledGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_none.mres",
			textureUV =
			{
				24,
				0,
				48,
				25,
			},
			color = "IGColorFacilityDisabled",
		},
	},
	IGButtonUtility =
	{
		type = "Button",
		buttonStyle = "IGButtonFacility",
		DefaultGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_norm.mres",
			textureUV =
			{
				24,
				25,
				48,
				50,
			},
		},
		BackgroundGraphic2 =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_no_build.mres",
			textureUV =
			{
				24,
				25,
				48,
				50,
			},
		},
		FlashGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				24,
				25,
				48,
				50,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		OverGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_over.mres",
			textureUV =
			{
				24,
				25,
				48,
				50,
			},
		},
		PressedGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				24,
				25,
				48,
				50,
			},
		},
		DisabledGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_none.mres",
			textureUV =
			{
				24,
				25,
				48,
				50,
			},
			color = "IGColorFacilityDisabled",
		},
	},
	IGButtonSubsystemModules =
	{
		type = "Button",
		buttonStyle = "IGButtonFacility",
		DefaultGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_norm.mres",
			textureUV =
			{
				24,
				50,
				48,
				75,
			},
		},
		BackgroundGraphic2 =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_no_build.mres",
			textureUV =
			{
				24,
				50,
				48,
				75,
			},
		},
		OverGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_over.mres",
			textureUV =
			{
				24,
				50,
				48,
				75,
			},
		},
		FlashGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				24,
				50,
				48,
				75,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		PressedGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				24,
				50,
				48,
				75,
			},
		},
		DisabledGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_none.mres",
			textureUV =
			{
				24,
				50,
				48,
				75,
			},
			color = "IGColorFacilityDisabled",
		},
	},
	IGButtonSubsystemSensors =
	{
		type = "Button",
		buttonStyle = "IGButtonFacility",
		DefaultGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_norm.mres",
			textureUV =
			{
				24,
				75,
				48,
				100,
			},
		},
		BackgroundGraphic2 =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_no_build.mres",
			textureUV =
			{
				24,
				75,
				48,
				100,
			},
		},
		FlashGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				24,
				75,
				48,
				100,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		OverGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_over.mres",
			textureUV =
			{
				24,
				75,
				48,
				100,
			},
		},
		PressedGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_down.mres",
			textureUV =
			{
				24,
				75,
				48,
				100,
			},
		},
		DisabledGraphic =
		{
			texture = "data:ui\\newui\\facility\\facilities_icons_none.mres",
			textureUV =
			{
				24,
				75,
				48,
				100,
			},
			color = "IGColorFacilityDisabled",
		},
	},
	IGPrevButton =
	{
		type = "Button",
		size =
		{
			13,
			72,
		},
		DefaultGraphic =
		{
			texture = "DATA:UI\\NewUI\\InGameIcons\\info_buttons.mres",
			textureUV =
			{
				0,
				31,
				13,
				103,
			},
			color = "FEColorScrollButtonDefault",
		},
		OverGraphic =
		{
			texture = "DATA:UI\\NewUI\\InGameIcons\\info_buttons.mres",
			textureUV =
			{
				0,
				31,
				13,
				103,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		PressedGraphic =
		{
			texture = "DATA:UI\\NewUI\\InGameIcons\\info_buttons.mres",
			textureUV =
			{
				0,
				31,
				13,
				103,
			},
			color = "FEColorScrollButtonPressed",
		},
		DisabledGraphic =
		{
			texture = "DATA:UI\\NewUI\\InGameIcons\\info_buttons.mres",
			textureUV =
			{
				0,
				31,
				13,
				103,
			},
			color = "FEColorScrollButtonDisabled",
		},
		soundOnEnter = "SFX_ButtonEnter",
		soundOnClicked = "SFX_ButtonClick",
	},
	IGNextButton =
	{
		type = "Button",
		size =
		{
			13,
			72,
		},
		DefaultGraphic =
		{
			texture = "DATA:UI\\NewUI\\InGameIcons\\info_buttons.mres",
			textureUV =
			{
				13,
				31,
				0,
				103,
			},
			color = "FEColorScrollButtonDefault",
		},
		OverGraphic =
		{
			texture = "DATA:UI\\NewUI\\InGameIcons\\info_buttons.mres",
			textureUV =
			{
				13,
				31,
				0,
				103,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		PressedGraphic =
		{
			texture = "DATA:UI\\NewUI\\InGameIcons\\info_buttons.mres",
			textureUV =
			{
				13,
				31,
				0,
				103,
			},
			color = "FEColorScrollButtonPressed",
		},
		DisabledGraphic =
		{
			texture = "DATA:UI\\NewUI\\InGameIcons\\info_buttons.mres",
			textureUV =
			{
				13,
				31,
				0,
				103,
			},
			color = "FEColorScrollButtonDisabled",
		},
		soundOnEnter = "SFX_ButtonEnter",
		soundOnClicked = "SFX_ButtonClick",
	},
	IGCloseButton =
	{
		type = "Button",
		size =
		{
			15,
			15,
		},
		borderWidth = 1,
		borderColor =
		{
			0,
			0,
			0,
			255,
		},
		overBorderColor =
		{
			255,
			255,
			255,
			255,
		},
		BackgroundGraphic =
		{
			size =
			{
				15,
				15,
			},
			texture = "DATA:UI\\NewUI\\InGameIcons\\close.mres",
			textureUV =
			{
				0,
				0,
				15,
				15,
			},
			color =
			{
				0,
				0,
				0,
				255,
			},
		},
		OverGraphic =
		{
			size =
			{
				15,
				15,
			},
			texture = "DATA:UI\\NewUI\\InGameIcons\\close.mres",
			textureUV =
			{
				0,
				0,
				15,
				15,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		soundOnEnter = "SFX_ButtonEnter",
		soundOnClicked = "SFX_ButtonClick",
	},
	Taskbar_PanelButtonTextStyle =
	{
		type = "Text",
		font = "ButtonFont",
		textStyle = "IGButtonTextStyle",
		color =
		{
			0,
			0,
			0,
			255,
		},
		size = 8,
		style = 1,
		hAlign = "Center",
	},
	Taskbar_PanelButtonTextStyleCarrot =
	{
		type = "Text",
		font = "ChatFont",
		textStyle = "IGButtonTextStyle",
		color =
		{
			0,
			0,
			0,
			255,
		},
		size = 8,
		style = 1,
		hAlign = "Center",
	},
	Taskbar_PanelButtonStyle =
	{
		type = "Button",
		size =
		{
			68,
			13,
		},
		toggleButton = 1,
		flashSpeed = 250,
		DefaultGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		OverGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		ClickedGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		PressedGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		FlashGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\panelbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
			color =
			{
				220,
				220,
				255,
				255,
			},
		},
		flashTextColor =
		{
			0,
			0,
			0,
			255,
		},
		flashColor =
		{
			255,
			255,
			255,
			255,
		},
		textColor =
		{
			0,
			0,
			0,
			255,
		},
		pressedTextColor =
		{
			0,
			0,
			0,
			255,
		},
		clickedTextColor =
		{
			255,
			255,
			255,
			255,
		},
		overTextColor =
		{
			0,
			0,
			0,
			255,
		},
		outerBorderWidth = 1,
		borderColor =
		{
			0,
			0,
			0,
			0,
		},
		overBorderColor =
		{
			0,
			0,
			0,
			255,
		},
		clickedBorderColor =
		{
			0,
			0,
			0,
			0,
		},
		pressedBorderColor =
		{
			0,
			0,
			0,
			255,
		},
		disabledColor =
		{
			127,
			127,
			127,
			0,
		},
		disabledTextColor =
		{
			127,
			127,
			127,
			0,
		},
		soundOnClicked = "SFX_ButtonClick",
	},
	Taskbar_MenuButtonTextStyle =
	{
		type = "Text",
		font = "ButtonFont",
		color = "IGColorButtonText",
		size = 8,
		style = 1,
		hAlign = "Center",
	},
	Taskbar_MenuButtonStyle =
	{
		type = "Button",
		size =
		{
			132,
			13,
		},
		toggleButton = 1,
		DefaultGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\hollowbutton.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		OverGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\hollowbutton_pressed.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		ClickedGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\hollowbutton_clicked.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		PressedGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\hollowbutton_pressed.tga",
			textureUV =
			{
				0,
				0,
				64,
				13,
			},
		},
		flashSpeed = 250,
		textColor =
		{
			0,
			175,
			255,
			255,
		},
		overTextColor =
		{
			128,
			215,
			255,
			255,
		},
		clickedTextColor =
		{
			255,
			255,
			255,
			255,
		},
		pressedTextColor =
		{
			128,
			215,
			255,
			255,
		},
		outerBorderWidth = 1,
		borderColor =
		{
			0,
			0,
			0,
			0,
		},
		overBorderColor =
		{
			0,
			0,
			0,
			0,
		},
		clickedBorderColor =
		{
			0,
			0,
			0,
			0,
		},
		pressedBorderColor =
		{
			255,
			255,
			255,
			255,
		},
		soundOnClicked = "SFX_ButtonClick",
	},
	Taskbar_MenuButtonStyle_Wide =
	{
		type = "Button",
		buttonStyle = "Taskbar_MenuButtonStyle",
		size =
		{
			132,
			13,
		},
		DefaultGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\hollowbutton_wide.tga",
			textureUV =
			{
				0,
				0,
				128,
				13,
			},
		},
		OverGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\hollowbutton_wide_pressed.tga",
			textureUV =
			{
				0,
				0,
				128,
				13,
			},
		},
		ClickedGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\hollowbutton_wide_clicked.tga",
			textureUV =
			{
				0,
				0,
				128,
				13,
			},
		},
		PressedGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\hollowbutton_wide_pressed.tga",
			textureUV =
			{
				0,
				0,
				128,
				13,
			},
		},
	},
	Taskbar_SensorsButtonStyle =
	{
		type = "Button",
		size =
		{
			96,
			13,
		},
		backgroundColor =
		{
			238,
			188,
			5,
			255,
		},
		overColor =
		{
			187,
			146,
			4,
			255,
		},
		flashColor =
		{
			255,
			255,
			255,
			255,
		},
		flashSpeed = 250,
		soundOnClicked = "SFX_ButtonClick",
	},
	Taskbar_ControlGroups1ButtonStyle =
	{
		type = "Button",
		size =
		{
			33,
			11,
		},
		OverGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\controlgroups.mres",
			textureUV =
			{
				0,
				0,
				33,
				11,
			},
			color =
			{
				0,
				160,
				255,
				128,
			},
		},
		PressedGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\controlgroups.mres",
			textureUV =
			{
				0,
				0,
				33,
				11,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		FlashGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\controlgroups.mres",
			textureUV =
			{
				0,
				0,
				33,
				11,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		flashSpeed = 150,
		Text =
		{
			type = "Text",
			font = "ButtonFont",
			color =
			{
				255,
				255,
				255,
				255,
			},
			size = 8,
			style = 1,
			hAlign = "Center",
			vAlign = "Center",
			dropShadow = 1,
		},
		soundOnEnter = "SFX_TaskbarControlGroupsEnter",
		soundOnClicked = "SFX_ButtonClick",
	},
	Taskbar_ControlGroups2ButtonStyle =
	{
		type = "Button",
		size =
		{
			33,
			11,
		},
		OverGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\controlgroups.mres",
			textureUV =
			{
				33,
				0,
				0,
				11,
			},
			color =
			{
				0,
				160,
				255,
				128,
			},
		},
		PressedGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\controlgroups.mres",
			textureUV =
			{
				33,
				0,
				0,
				11,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		FlashGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\controlgroups.mres",
			textureUV =
			{
				33,
				0,
				0,
				11,
			},
			color =
			{
				255,
				255,
				255,
				255,
			},
		},
		flashSpeed = 150,
		Text =
		{
			type = "Text",
			font = "ButtonFont",
			color =
			{
				255,
				255,
				255,
				255,
			},
			size = 8,
			style = 1,
			hAlign = "Center",
			vAlign = "Center",
			dropShadow = 1,
		},
		soundOnEnter = "SFX_TaskbarControlGroupsEnter",
		soundOnClicked = "SFX_ButtonClick",
	},
	Taskbar_ShipButtonStyle =
	{
		type = "Button",
		toggleButton = 0,
		outerBorderWidth = 1,
		borderColor = "FEColorHeading3",
		backgroundColor = "IGColorBackground1",
		size =
		{
			83,
			30,
		},
		DefaultGraphic =
		{
		color =
            { 255, 255, 255, 255, },
        texture = "DATA:UI\\NewUI\\Textures\\gradient.tga",
        textureUV =
            { 0, 0, 600, 600, }, },
		OverGraphic =
		{
		color =
            { 170, 170, 170, 255, },
        texture = "DATA:UI\\NewUI\\Textures\\gradient.tga",
        textureUV =
            { 0, 0, 600, 600, }, },
		PressedGraphic =
		{
		color =
            { 0, 0, 0, 255, },
        texture = "DATA:UI\\NewUI\\Textures\\gradient.tga",
        textureUV =
            { 0, 0, 600, 600, }, },
		DisabledGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\ship_button.mres",
			textureUV =
			{
				0,
				0,
				0,
				0,
			},
		},
		helpTipTextLabel = "commandsHelpTip",
		soundOnClicked = "SFX_ButtonClick",
		;
		{
			type = "Frame",
			name = "shipIcon",
			size =
			{
				81,
				30,
			},
			giveParentMouseInput = 1,
			backgroundGraphicHAlign = "Center",
			backgroundGraphicVAlign = "Center",
			;
			{
				type = "ProgressBar",
				backgroundColor =
				{
					99,
					101,
					99,
					255,
				},
				progressColor =
				{
					51,
					255,
					0,
					255,
				},
				position =
				{
					10,
					27,
				},
				size =
				{
					65,
					2,
				},
				name = "shipHealth",
				giveParentMouseInput = 1,
			},
			{
				type = "TextLabel",
				hAlign = "Right",
				position =
				{
					 - 4,
					14,
				},
				size =
				{
					30,
					13,
				},
				name = "shipCount",
				Text =
				{
					textStyle = "FEHeading4",
					color =
					{
						255,
						255,
						255,
						255,
					},
					hAlign = "Right",
					vAlign = "Bottom",
				},
				giveParentMouseInput = 1,
			},
		},
	},
	Taskbar_CommandButtonStyle =
	{
		type = "Button",
		size =
		{
			30,
			30,
		},
		DefaultGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
			textureUV =
			{
				225,
				1,
				255,
				0,
			},
		},
		OverGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
			textureUV =
			{
				225,
				33,
				255,
				0,
			},
		},
		PressedGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
			textureUV =
			{
				225,
				65,
				255,
				95,
			},
		},
		DisabledGraphic =
		{
			texture = "DATA:UI\\NewUI\\Taskbar\\command_icons.mres",
			textureUV =
			{
				225,
				1,
				255,
				0,
			},
			color =
			{
				255,
				255,
				255,
				0,
			},
		},
		soundOnClicked = "SFX_ButtonClick",
	},
	Taskbar_SubsystemButtonStyle =
	{
		type = "Button",
		name = "subsystem1",
		size =
		{
			32,
			24,
		},
		helpTipTextLabel = "commandsHelpTip",
		soundOnClicked = "SFX_ButtonClick",
		;
		{
			type = "Frame",
			name = "icon",
			size =
			{
				32,
				24,
			},
			giveParentMouseInput = 1,
		},
	},
	RightClickMenu_ButtonTextStyle =
	{
		type = "Text",
		font = "ButtonFont",
		color =
		{
			0,
			175,
			255,
			255,
		},
		size = 8,
		style = 1,
		hAlign = "Center",
	},
	RightClickMenu_ButtonStyle =
	{
		type = "Button",
		toggleButton = 1,
		borderWidth = 1,
		borderColor =
		{
			0,
			175,
			255,
			255,
		},
		overColor =
		{
			48,
			108,
			136,
			255,
		},
		overBorderColor =
		{
			255,
			255,
			255,
			255,
		},
		pressedColor =
		{
			48,
			108,
			136,
			255,
		},
		disabledBorderColor =
		{
			0,
			175,
			255,
			255,
		},
		disabledTextColor =
		{
			0,
			175,
			255,
			128,
		},
		soundOnClicked = "SFX_RightClickMenuClick",
	},
	DiplomacyScreen_ButtonTextStyle =
	{
		type = "Text",
		font = "ButtonFont",
		color =
		{
			0,
			175,
			255,
			255,
		},
		size = 8,
		style = 1,
		hAlign = "Center",
	},
	DiplomacyScreen_ButtonStyle =
	{
		type = "Button",
		buttonStyle = "FEButtonStyle1",
	},
	DiplomacyScreen_PlayerButtonTextStyle =
	{
		type = "Text",
		font = "ButtonFont",
		color =
		{
			255,
			255,
			255,
			255,
		},
		size = 8,
		style = 1,
		hAlign = "Left",
		soundOnClicked = "SFX_ButtonClick",
	},
	DiplomacyScreen_PlayerButtonStyle =
	{
		type = "Button",
		size =
		{
			219,
			27,
		},
		toggleButton = 1,
		borderWidth = 1,
		borderColor = "IGColorOutline",
		disabledBorderColor = "IGColorOutline",
		pressedColor = "IGColorButtonPressed",
		overBorderColor =
		{
			255,
			255,
			255,
			255,
		},
		flashColor = "IGColorButtonPressed",
		flashBorderColor =
		{
			255,
			255,
			255,
			255,
		},
		flashSpeed = 250,
		soundOnClicked = "SFX_ButtonClick",
		;
		{
			type = "TextLabel",
			name = "name",
			position =
			{
				20,
				0,
			},
			size =
			{
				135,
				27,
			},
			Text =
			{
				textStyle = "DiplomacyScreen_PlayerButtonTextStyle",
			},
			giveParentMouseInput = 1,
		},
		{
			type = "Frame",
			position =
			{
				155,
				5,
			},
			size =
			{
				60,
				16,
			},
			backgroundColor =
			{
				94,
				151,
				48,
				255,
			},
			outerBorderWidth = 1,
			borderColor =
			{
				0,
				0,
				0,
				255,
			},
			name = "teamcolor",
			visible = 0,
			giveParentMouseInput = 1,
			;
			{
				type = "Frame",
				position =
				{
					20,
					0,
				},
				size =
				{
					40,
					16,
				},
				name = "teamstripe",
				BackgroundGraphic =
				{
					size =
					{
						40,
						16,
					},
					texture = "DATA:UI\\NewUI\\PlayerSetup\\stripes_small.tga",
					textureUV =
					{
						0,
						0,
						40,
						16,
					},
				},
				giveParentMouseInput = 1,
			},
			{
				type = "Frame",
				position =
				{
					3,
					0,
				},
				size =
				{
					16,
					16,
				},
				name = "emblem",
				BackgroundGraphic =
				{
					size =
					{
						16,
						16,
					},
					texture = "DATA:Badges/Hiigaran.tga",
					textureUV =
					{
						0,
						0,
						64,
						64,
					},
				},
				giveParentMouseInput = 1,
			},
		},
		{
			type = "Frame",
			position =
			{
				4,
				7,
			},
			size =
			{
				11,
				11,
			},
			name = "iconrequest",
			visible = 0,
			BackgroundGraphic =
			{
				size =
				{
					11,
					11,
				},
				texture = "DATA:UI\\NewUI\\InGameIcons\\allyrequest.tga",
				textureUV =
				{
					0,
					0,
					11,
					11,
				},
			},
			giveParentMouseInput = 1,
		},
		{
			type = "Frame",
			position =
			{
				4,
				7,
			},
			size =
			{
				11,
				11,
			},
			name = "iconallies",
			visible = 0,
			BackgroundGraphic =
			{
				size =
				{
					11,
					11,
				},
				texture = "DATA:UI\\NewUI\\InGameIcons\\allies.tga",
				textureUV =
				{
					0,
					0,
					11,
					11,
				},
			},
			giveParentMouseInput = 1,
		},
	},
	ResearchInfoTextStyle =
	{
		type = "Text",
		font = "ChatFont",
		color =
		{
			255,
			255,
			255,
			255,
		},
		hAlign = "Left",
	},
	Chat_PlayerButtonStyle =
	{
		type = "Button",
		size =
		{
			86,
			13,
		},
		borderWidth = 1,
		borderColor = "IGColorOutline",
		overColor =
		{
			48,
			108,
			136,
			128,
		},
		pressedColor =
		{
			48,
			108,
			136,
			255,
		},
		disabledColor =
		{
			0,
			0,
			0,
			0,
		},
		disabledBorderColor = "IGColorOutline",
		textColor =
		{
			255,
			255,
			255,
			255,
		},
		overTextColor =
		{
			255,
			255,
			255,
			255,
		},
		pressedTextColor =
		{
			255,
			255,
			255,
			255,
		},
		disabledTextColor =
		{
			255,
			255,
			255,
			128,
		},
		marginWidth = 6,
		Text =
		{
			textStyle = "Taskbar_MenuButtonTextStyle",
			hAlign = "Left",
		},
		soundOnClicked = "SFX_ButtonClick",
	},
}
