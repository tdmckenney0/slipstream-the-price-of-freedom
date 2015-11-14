dofilepath("data:ui/newui/errormessage.lua") -- for MOREINFOWIDTH and MOREINFOHEIGHT

SBARWIDTH = 20

COLWIDTH = (MOREINFOWIDTH - SBARWIDTH - 4) / 2

MissingModColor = {255,0,0,255} -- text color for missing mods
MissingText = "This Games is not a TPOF Game"

-- Table Border frame
UnmatchingModsTable  = {
	type = "Frame",
	size = {MOREINFOWIDTH , MOREINFOHEIGHT},
	;
	
	-- Horz line
	{
		type = "Line",
		p1 = {0, 19},
		p2 = {MOREINFOWIDTH+2, 19},
		lineWidth = 2,
		above = 0,
		color = "FEColorPopupOutline",
	},
	
	-- Vert line
	{
		type = "Line",
		p1 = {MOREINFOWIDTH-SBARWIDTH+2, 0},
		p2 = {MOREINFOWIDTH-SBARWIDTH+2,MOREINFOHEIGHT+2},
		lineWidth = 2,
		above = 0,
		color = "FEColorPopupOutline",
	},
	
	-- DEFINITION FOR (tbl) tableGames
	{
		type = "Table",
		name = "tableMods",
		
		backgroundColor = {0,0,0,0},
		tableStyle = "FETableStyle",
		
		position = {2,2},
		size = {MOREINFOWIDTH - 5, MOREINFOHEIGHT - 5},
		selectedRowColor = {0,0,0,0},
		
		
		Columns = {
			;
			-- client mods
			{
				width = COLWIDTH,
				TitleCell = {
					type = "TableCell",
					--helpTipTextLabel = "m_lblHelpText",
					--helpTip = "SORT BY SERVER NAME",
					;
					{
						type = "TextButton",
						name = "TableTitleClientMods",
						buttonStyle = "FETableTitleButtonStyle",
						Text = {
							text = "$5165",
							textStyle = "FETableTitleTextStyle",
						},
					}
				},
			},
			
			-- server mods
			{
				width = COLWIDTH,
				TitleCell = {
					type = "TableCell",
					--helpTipTextLabel = "m_lblHelpText",
					--helpTip = "SORT BY NUMBER OF GAMES",
					;
					{
						type = "TextButton",
						name = "TableTitleNumGames",
						buttonStyle = "FETableTitleButtonStyle",
						Text = {
							text = "$5166",
							textStyle = "FETableTitleTextStyle",
						},
					}
				},
			},	
		},
	}
}

	