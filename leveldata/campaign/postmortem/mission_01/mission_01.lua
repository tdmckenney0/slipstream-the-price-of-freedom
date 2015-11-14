-- import library files, this includes all the helper functions
dofilepath("data:scripts\\SCAR\\SCAR_Util.lua")

-- variables can be created outside of everything, giving them global scope
obj_prim_newobj_id = 0

function OnInit()
	-- Add the Rule_Init
	Rule_Add("Rule_Init")

	-- OnInit isn't a rule so there is no need to remove it
end

function Rule_Init()
	-- Do one of those fancy Intel-tell-the-player-whats-going-on
	Event_Start( "IntelEvent_Intro" )

	-- Tell the Mothership to exit hyperspace
	SobGroup_ExitHyperSpace ("MSGroup", "MS_EnterVolume")

	-- Setup the Win and Lose conditions
	Rule_Add( "Rule_Player_Wins" )
	
	-- We only want this rule to play once - so remove it now
	Rule_Remove( "Rule_Init" )
end

function Rule_Player_Wins()
	-- Check to see if the player has a squadron of Scouts
	if  Player_GetNumberOfSquadronsOfTypeAwakeOrSleeping( 0, "hgn_scout" ) > 0 then

		-- Update the Objective
		Objective_SetState( obj_prim_newobj_id, OS_Complete )

		-- Play final event
		Event_Start( "IntelEvent_Finale" )

		-- Remove the rule
		Rule_Remove( "Rule_Player_Wins" )
	end
end

-- Most important line
Events = {}

Events.IntelEvent_Intro = 
{ 
	{ 
		{
			"Sound_EnableAllSpeech( 1 )",
			""
		}, 
		{
			"Sound_EnterIntelEvent()",
			""
		}, 
		{
			"Universe_EnableSkip(1)",
			""
		}, 
		HW2_LocationCardEvent( "Postmortem Tutorial - Mission 1", 5 ), 
	}, 
	{ 
		HW2_Wait( 2 ), 
		HW2_Letterbox( 1 ), 
		HW2_Wait( 2 ), 
	}, 
	{ 
		HW2_SubTitleEvent( Actor_FleetCommand, "Welcome to the Postmortem campaign. This is Mission 1.", 5 ), 
	}, 
	{
		HW2_Wait( 1 ), 
	}, 
	{
		{
			"obj_prim_newobj_id = Objective_Add( 'Build a Scout', OT_Primary )",
			""
		}, 
		{
			"Objective_AddDescription( obj_prim_newobj_id, 'Build one Scout squadron to win the mission.')",
			""
		}, 
		HW2_SubTitleEvent( Actor_FleetIntel, "Build one Scout squadron to win the mission.", 4 ),
	},
	{
		HW2_Wait( 1 ), 
	},
	{
		HW2_Letterbox( 0 ), 
		HW2_Wait( 2 ), 
		{
			"Universe_EnableSkip(0)",
			""
		},
		{
			"Sound_ExitIntelEvent()",
			""
		},
	},
}
Events.IntelEvent_Finale = 
{
	{ 
		{
			[[Universe_Fade( 1, 2 )]],
			[[]],
		},
		HW2_Wait(3),
	}, 
	{
		HW2_LocationCardEvent("MISSION SUCCESSFUL", 4),
	}, 
	{
		HW2_Wait(2),
	}, 
	{ 
		{
			[[Camera_AllowControl(1)]],
			[[]],
		}, 
		{
			[[setMissionComplete( 1 )]],
			[[]],
		}, 
	}, 
}
