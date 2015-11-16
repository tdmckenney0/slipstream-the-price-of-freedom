dofilepath("data:scripts\\SCAR\\SCAR_Util.lua")
obj_prim_newobj_id = 0

function OnInit()
	Rule_Add("Rule_Init")
end

function Rule_Init()
	Event_Start( "IntelEvent_Intro" )
	SobGroup_CreateShip("MSGroup", "Hgn_Interceptor")
	SobGroup_CreateShip("MSGroup", "Hgn_Interceptor")
	SobGroup_CreateShip("MSGroup", "Hgn_Interceptor")
	SobGroup_CreateShip("MSGroup", "Hgn_Interceptor")
	SobGroup_CreateShip("MSGroup", "Hgn_Interceptor")
	SobGroup_CreateShip("MSGroup", "Hgn_Interceptor")
	SobGroup_ExitHyperSpace ("MSGroup", "MS_EnterVolume")
	Rule_Add( "Rule_Player_Wins")
	Rule_AddInterval( "Enemy_Attack", 20 )
	Rule_Remove( "Rule_Init" )
end

function Enemy_Attack()
	SobGroup_Attack(1, "EnyGroup", "CRGroup")
	Rule_Remove( "Enemy_Attack" )
end

function Rule_Player_Wins()
	if (SobGroup_Empty("CRGroup") == 1) then
		Objective_SetState( obj_prim_newobj_id, OS_Failed )		
		Event_Start( "IntelEvent_Failure" )
		Rule_Remove( "Rule_Player_Wins" )
	elseif (SobGroup_Empty("EnyGroup") == 1) then
		Objective_SetState( obj_prim_newobj_id, OS_Complete )
		Event_Start( "IntelEvent_Finale" )
		Rule_Remove( "Rule_Player_Wins" )
	end
end

Events = {}
Events.IntelEvent_Intro = 
{
	{
		{
			[[Sound_EnableAllSpeech(0)]],
			[[]]
		},
		{
			[[Sound_EnterIntelEvent()]],
			[[]]
		},
		{
			[[Universe_EnableSkip(1)]],
			[[]]
		},
		HW2_LocationCardEvent("Postmortem Tutorial - Mission 7", 5),
	},
	{
		HW2_Letterbox(1),
		HW2_Wait(2),
	},
	{
		{
			[[obj_prim_newobj_id = Objective_Add("Defend a Ship", OT_Primary)]],
			[[]]
		},
		{
			[[Objective_AddDescription(obj_prim_newobj_id, "Defend the carrier from attack. Destroy the attackers.")]],
			[[]]
		},
		HW2_SubTitleEvent(Actor_FleetIntel, "Defend the carrier from attack. Destroy the attackers.", 4),
	},
	{
		HW2_Wait(2),
	},
	{
		HW2_Letterbox(0),
		HW2_Wait(2),
		{
			[[Universe_EnableSkip(0)]],
			[[]]
		},
		{
			[[Sound_ExitIntelEvent()]],
			[[]]
		},
		{
			[[Sound_EnableAllSpeech(1)]],
			[[]]
		},
	},
}
Events.IntelEvent_Finale =
{
	{
		{
			[[Universe_AllowPlayerOrders(0)]],
			[[]],
		},
		{
			[[Universe_Fade(1, 2)]],
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
			[[setMissionComplete(1)]],
			[[]],
		},
	},
}
Events.IntelEvent_Failure =
{
	{
		HW2_LocationCardEvent("MISSION FAILED", 4),
	},
	{
		HW2_Wait(2),
	},
	{
		{
			[[setMissionComplete(0)]],
			[[]],
		},
	},
}
