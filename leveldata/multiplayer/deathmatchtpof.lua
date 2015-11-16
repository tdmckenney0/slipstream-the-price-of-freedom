-- LuaDC version 0.9.20
-- 1/13/2008 6:28:56 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
GUID =
    { 110, 91, 157, 190, 18, 23, 250, 78, 144, 20, 41, 246, 181, 128, 214, 12, }
GameRulesName = "TPOF: Advanced"
Description = "Advanced Game Options for Slipstream: The Price of Freedom. Works only on Windows 2000/XP/Vista/7."
GameSetupOptions =
    {
    {
        name = "resources",
        locName = "$3240",
        tooltip = "$3239",
        default = 1,
        visible = 1,
        choices =
            { "$3241", "2.0", "$3242", "2.5", "$3243", "3.0", }, },
    {
        name = "unitcaps",
        locName = "$3214",
        tooltip = "$3234",
        default = 1,
        visible = 1,
        choices =
            { "$3215", "Small", "$3216", "Normal", "$3217", "Large", "Unlimited", "unlimited"}, },
    {
        name = "resstart",
        locName = "$3205",
        tooltip = "$3232",
        default = 0,
        visible = 1,
        choices =
            { "$3206", "1000", "$3207", "3000", "$3208", "10000", "$3209", "0", }, },
    {
        name = "lockteams",
        locName = "$3220",
        tooltip = "$3235",
        default = 0,
        visible = 0,
        choices =
            { "$3221", "yes", "$3222", "no", }, },
    {
        name = "startlocation",
        locName = "$3225",
        tooltip = "$3237",
        default = 1,
        visible = 1,
        choices =
            { "$3226", "random", "$3227", "fixed", }, },
  {
          name = "startwith",
          locName = "Starting Mode",
          tooltip = "Choose A Starting Fleet",
          default = 0,
          visible = 1,
          choices =
          {
              "Default", "one",
              "Carriers Only", "carriers",
			  "Instant Action", "instant",
          },
   },
   {
		name = "wincondition",
		locName = "Win Condition",
		tooltip = "select the condition for winning the game",
		default = 0,
		visible = 1,
		choices =
		{ "HW2 Normal", 0, "Kill All Enemy Ships", 2, "Quit Manually", 3, },
	},
    {
		name = "bgmusic",
		locName = "Music",
		tooltip = "Select the background music",
		default = 4,
		visible = 1,
		choices =
		{
			"Map Default", "null",
			"No Music", "staging\\Mute.fda",
			"Shuffle", "shuffle",
			"Main Menu Theme", "staging\\staging_01",
			"Slipstream Ambient", "staging\\staging_04",
			"Ambient No.1", "ambient\\amb_01",
			"Ambient No.2", "ambient\\amb_02",
			"Ambient No.3", "ambient\\amb_03",
			"Ambient No.4", "ambient\\amb_04",
			"Ambient No.5", "ambient\\amb_05",
			"Ambient No.6", "ambient\\amb_06",
			"Ambient No.7", "ambient\\amb_07",
			"Ambient No.8", "ambient\\amb_08",
			"Ambient No.12", "ambient\\amb_12",
			"Ambient No.13", "ambient\\amb_13",
			"Ambient No.14", "ambient\\amb_14",
			"Battle No.1", "battle\\battle_01",
			"Battle No.4", "battle\\battle_04",
			"Battle No.4, Alternate", "battle\\battle_04_alt",
			"Battle No.6", "battle\\battle_06",
			"Battle - Keeper", "battle\\battle_keeper",
			"Battle - Movers", "battle\\battle_movers",
			"Battle - Planet Killers", "battle\\battle_planetkillers",
			"Battle - Sajuuk", "battle\\battle_sajuuk",
			"Battle - Arrival", "battle\\battle_arrival",
		},
	},
    }
dofilepath("data:scripts/scar/restrict.lua")

Events = {}
Events.endGame =
    {
        {
            { "wID = Wait_Start(5)", "Wait_End(wID)", },
        },
    }

function PlayMusicRule()
	Sound_MusicPlay("data:sound\\music\\" .. GetGameSettingAsString("bgmusic"))
	Rule_Remove("PlayMusicRule")
end

function OnInit()
    MPRestrict()

	if (GetGameSettingAsString("bgmusic") == "shuffle") then
		dofilepath("data:soundscripts/randommusic.lua")
		print("Random Music")
	else
		Rule_Add("PlayMusicRule")
		print("Custom Music")
	end

if (GetGameSettingAsNumber("wincondition") == 0) then
			Rule_AddInterval("CheckPlayerProductionShipsLeftRule", 1)
		elseif (GetGameSettingAsNumber("wincondition") == 1) then
			Rule_AddInterval("CheckTeamProductionShipsLeftRule", 1)
		elseif (GetGameSettingAsNumber("wincondition") == 2) then
			Rule_AddInterval("CheckTeamAnyShipsLeftRule", 1)
		end


    Rule_Add("MainRule")

   if (GetGameSettingAsString("startwith") == "one") then
          SetStartFleetSuffix("")
		  print("Normal Start")
      elseif (GetGameSettingAsString("startwith") == "carriers") then
          SetStartFleetSuffix("Carriers")
		  print("Carrier Start")
	  elseif (GetGameSettingAsString("startwith") == "instant") then
          SetStartFleetSuffix("instant")
		  print("Instant Action")
	  elseif (GetGameSettingAsString("startwith") == "arena") then
          SetStartFleetSuffix("arena")
		  print("Armageddon")
      end
end


AnyPlayerIndex = 0

-------------------------------------------------------------------------------
-- Kills a player if the player has no production capability
--
function CheckPlayerProductionShipsLeftRule()
	if ((Player_IsAlive(AnyPlayerIndex) == 1) and (Player_HasShipWithBuildQueue(AnyPlayerIndex) == 0)) then
		Player_Kill(AnyPlayerIndex)
	end
	if (AnyPlayerIndex == (Universe_PlayerCount() - 1)) then
		AnyPlayerIndex = 0
	else
		AnyPlayerIndex = AnyPlayerIndex + 1
	end
end

-------------------------------------------------------------------------------
-- Kills a player if no team member has any production capability
--
function CheckTeamProductionShipsLeftRule()
	local bDead = 1
	for otherPlayerIndex = 0, (Universe_PlayerCount() - 1) do
		if ((AreAllied(AnyPlayerIndex, otherPlayerIndex) == 1) and (Player_IsAlive(otherPlayerIndex) == 1) and (Player_HasShipWithBuildQueue(otherPlayerIndex) == 1)) then
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

-------------------------------------------------------------------------------
-- returns the team number of the player (may be different than in the game-setup screen)
--
function Player_Team(iPlayer)
	local TeamsTable = {}
	for playerIndex = 0, (Universe_PlayerCount() - 1) do
		local IsAllied = 0
		for i = 1, getn(TeamsTable) do
			if (AreAllied(playerIndex, TeamsTable[i]) == 1) then
				IsAllied = 1
				break
			end
		end
		if (IsAllied == 0) then
			tinsert(TeamsTable, playerIndex)
		end
	end
	for i = 1, getn(TeamsTable) do
		if (AreAllied(iPlayer, TeamsTable[i]) == 1) then
			return i
		end
	end
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
