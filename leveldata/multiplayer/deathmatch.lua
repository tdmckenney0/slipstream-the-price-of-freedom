GUID = { 110, 91, 157, 190, 18, 23, 250, 78, 144, 20, 41, 246, 181, 128, 214, 12, }
GameRulesName = "Slipstream"
Description = "Game Options for Slipstream: The Price of Freedom"
Directories = { Levels = "data:LevelData\\Multiplayer\\slipstream\\", }

GameSetupOptions = {

	{
		name = "resources",
		locName = "$3240",
		tooltip = "$3239",
		default = 1,
		visible = 1,
		choices = { "$3241", "2.0", "$3242", "2.5", "$3243", "3.0", }, 
	},
	
	{
		name = "unitcaps",
		locName = "$3214",
		tooltip = "$3234",
		default = 1,
		visible = 1,
		choices = { "$3215", "Small", "$3216", "Normal", "$3217", "Large"}, 
	},
	
	{
		name = "resstart",
		locName = "$3205",
		tooltip = "$3232",
		default = 0,
		visible = 1,
		choices = { "$3206", "1000", "$3207", "3000", "$3208", "10000", "$3209", "0", }, 
	},
	
	{
		name = "lockteams",
		locName = "$3220",
		tooltip = "$3235",
		default = 0,
		visible = 0,
		choices = { "$3221", "yes", "$3222", "no", }, 
	},
	
	{
		name = "startlocation",
		locName = "$3225",
		tooltip = "$3237",
		default = 0,
		visible = 0,
		choices = { "$3227", "fixed", }, 
	},
	
	{
		name = "randommusic",
		locName = "Music",
		tooltip = "Select the background music",
		default = 0,
		visible = 1,
		choices =
		{
			"Shuffle: Slipstream", "slipstream",
			"Shuffle: All", "shuffle",
			"Shuffle: Ambient", "ambient",
			"Shuffle: Staging", "staging",
			"Shuffle: Battle", "battle",
			"Slipstream: Suite 1", "slipstream\\suite",
			"Slipstream: Suite 2", "slipstream\\freedom",
			"Slipstream: Ambience", "slipstream\\ambient",
			"Slipstream: Battle No.1", "slipstream\\battle_01",
			"Slipstream: Battle No.2", "slipstream\\battle_02",
			"Ambient: No.1", "ambient\\amb_01",
			"Ambient: No.2", "ambient\\amb_02",
			"Ambient: No.3", "ambient\\amb_03",
			"Ambient: No.4", "ambient\\amb_04",
			"Ambient: No.5", "ambient\\amb_05",
			"Ambient: No.6", "ambient\\amb_06",
			"Ambient: No.7", "ambient\\amb_07",
			"Ambient: No.8", "ambient\\amb_08",
			"Ambient: No.9", "ambient\\amb_12",
			"Ambient: No.10", "ambient\\amb_13",
			"Ambient: No.11", "ambient\\amb_14",
			"Battle: No.2", "battle\\battle_04",
			"Battle: No.3, Alternate", "battle\\battle_04_alt",
			"Battle: No.4", "battle\\battle_06",
			"Battle: Arrival", "battle\\battle_arrival",
			"Battle: Keeper", "battle\\battle_keeper",
			"Battle: Movers", "battle\\battle_movers",
			"Battle: Planet Killers", "battle\\battle_planetkillers",
			"Battle: Sajuuk", "battle\\battle_sajuuk",
			"Staging: No.1", "staging\\staging_01",
			"Staging: No.2", "staging\\staging_04",
			"Staging: No.3", "staging\\staging_05",
			"Staging: No.4", "staging\\staging_08",
			"Staging: No.5", "staging\\staging_11",
		},
	},
}
 
dofilepath("data:scripts/scar/restrict.lua")
dofilepath("data:scripts/music.lua")

Events = {}
Events.endGame =
    {
        {
            { "wID = Wait_Start(5)", "Wait_End(wID)", },
        },
    }

function OnInit()

    MPRestrict()

	Play(GetGameSettingAsString("randommusic"))

	Rule_AddInterval("CheckTeamAnyShipsLeftRule", 1)

    Rule_Add("MainRule")
	
	SetStartFleetSuffix("")
	
end


AnyPlayerIndex = 0

-------------------------------------------------------------------------------
-- Kills a player if no team member has any ships
--
function CheckTeamAnyShipsLeftRule()
	local bDead = 1
	for otherPlayerIndex = 0, (Universe_PlayerCount() - 1) do
		if ((AreAllied(AnyPlayerIndex, otherPlayerIndex) == 1) and (Player_IsAlive(otherPlayerIndex) == 1) and (Player_NumberOfShips(otherPlayerIndex) > 0)) then
			bDead = 0
			break
		end
	end
	if (bDead == 1) then
		Player_Kill(AnyPlayerIndex)
	end
	if (AnyPlayerIndex == (Universe_PlayerCount() - 1)) then
		AnyPlayerIndex = 0
	else
		AnyPlayerIndex = AnyPlayerIndex + 1
	end
end

-------------------------------------------------------------------------------
-- counts the size of a player's fleet
--
function Player_NumberOfShips(iPlayer)
	local iRace = Player_GetRace(iPlayer) + 1
	local ShipCount = 0
	dofilepath([[data:scripts/race.lua]])
	dofilepath([[data:scripts/building and research/]] .. races[iRace][1] .. [[/build.lua]])
	for i, iCount in build do
		if (iCount.Type ~= 1) then
			ShipCount = ShipCount + Player_GetNumberOfSquadronsOfTypeAwakeOrSleeping(iPlayer, iCount.ThingToBuild)
		end
	end
	return ShipCount
end

function MainRule()
	local numAlive = 0
	local numEnemies = 0
	local gameOver = 1
	-- check to see if ALL of our enemies are dead, then gameOver
	for playerIndex = 0, (Universe_PlayerCount() - 1) do
		-- only process 'alive' players
		if (Player_IsAlive(playerIndex) == 1) then
			-- compare this player against all others
			for otherPlayerIndex = 0, (Universe_PlayerCount() - 1) do
				-- are enemies?
				if (AreAllied(playerIndex, otherPlayerIndex) == 0) then
					-- is the enemy alive - if so the game is still on
					if (Player_IsAlive(otherPlayerIndex) == 1) then
						gameOver = 0
					else
						numEnemies = numEnemies + 1
					end
				end
			end
			numAlive = numAlive + 1
		end
	end
	-- special case - if there are no enemies then never end
	if ((numEnemies == 0) and (numAlive > 0)) then
		gameOver = 0
	end
	-- if gameOver flag is still set then the game is OVER
	if (gameOver == 1) then
		if (GetGameSettingAsNumber("enablestats") == 1) then
			WriteStats()
		end
		Rule_Add("waitForEnd")
		Event_Start("endGame")
		Rule_Remove("MainRule")
	end
end

function waitForEnd()
	if (Event_IsDone("endGame")) then
		setGameOver()
		Rule_Remove("waitForEnd")
	end
end

