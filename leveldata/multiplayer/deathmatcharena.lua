GUID =
    { 110, 91, 157, 190, 18, 23, 250, 78, 144, 20, 41, 246, 181, 128, 214, 12, }
GameRulesName = "TPOF: Arena"
Description = "You start with a large fleet of ships with every upgrade, and you must destroy all other enemy ships out there. However, there are no production ships available."
Directories =
{
  Levels = "data:LevelData\\Multiplayer\\slipstream\\",
}
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
        default = 2,
        visible = 0,
        choices =
            { "$3215", "Small", "$3216", "Normal", "$3217", "Large"}, },
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
		name = "randommusic",
		locName = "Music",
		tooltip = "Select the background music",
		default = 0,
		visible = 1,
		choices =
		{
			"Slipstream Ambient", "staging\\staging_04",
			"The Price of Freedom", "staging\\staging_01",
			"None", "staging\\Mute.fda",
			"Shuffle All", "shuffle",
			"Shuffle Ambient", "shufflea",
			"Shuffle Battle", "shuffleb",
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

function OnInit()
    MPRestrict()


	randommusic = GetGameSettingAsString("randommusic")

	if randommusic == "shuffle" then
		dofilepath("data:soundscripts/playlists/allmusic.lua")
		Rule_Add("RandomMusicRule")
	elseif randommusic == "shufflea" then
		dofilepath("data:soundscripts/playlists/ambientonly.lua")
		Rule_Add("RandomMusicRule")
	elseif randommusic == "shuffleb" then
		dofilepath("data:soundscripts/playlists/battleonly.lua")
		Rule_Add("RandomMusicRule")
	elseif randommusic == nil then
		dofilepath("data:soundscripts/playlists/allmusic.lua")
		Rule_Add("RandomMusicRule")
	else
		Sound_MusicPlay("data:sound\\music\\" .. GetGameSettingAsString("randommusic"))
	end


	Rule_AddInterval("CheckTeamAnyShipsLeftRule", 1)

    Rule_Add("MainRule")

	SetStartFleetSuffix("Arena")

end



--===============================================================================================
--Runs the random music system..moved from the randommusic.lua so that we can just make playlists.
-- table of previously-played tracks, resets to zero.

playedBin = {}

-- the gamerule - Defines the function to play music through the game
function RandomMusicRule()
	RandomMusic(PlayList)
end

function RandomMusic(tPlaylist)
	-- function created by Mikail, EvilleJedi
	-- Input:	<tPlaylist>: the playlist (a table) of songs.
	local passBool = 1
	local musicPath = "data:sound\\music\\"
	local listLen = getn(tPlaylist)
	local binLen = getn(playedBin)
	local randNum = random(listLen)
	local track_file = musicPath .. tPlaylist[randNum][1]
	local track_title = tPlaylist[randNum][2]
	local track_length = tPlaylist[randNum][3]
	local track_m = floor(track_length / 60)
	local track_s = track_length - track_m * 60
	local track_string = "Now playing (" .. randNum .. "/" .. listLen .. "): " .. track_title .. " (" .. track_m .. "m " .. track_s .. "s)"
	for k = 1, binLen do
		-- don't play the same track twice
		if (playedBin[k] == randNum) then
			passBool = 0
			-- if the end of the list has been reached, start over
			if (k == listLen) then
				playedBin = {}
			end
			break
		end
	end
	if (passBool == 0) then
		RandomMusic(tPlaylist)
	else
		Sound_MusicPlay(track_file)
		Subtitle_Message(track_string, 10)
		print(track_string)
		tinsert(playedBin, randNum)
		Rule_AddInterval("RandomMusicRule", track_length)
		Rule_Remove("RandomMusicRule")
	end
end


--==============================================================================

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
-- Stops the game from terminating even when all enemies are gone
--
function DoNotQuit()
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
