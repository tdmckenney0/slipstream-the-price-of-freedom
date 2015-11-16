-- LuaDC version 0.9.20
-- 11/11/2008 7:33:44 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
GUID =
    { 110, 91, 157, 190, 18, 23, 250, 78, 144, 20, 41, 246, 181, 128, 214, 12, }
GameRulesName = "TPOF: Basic"
Description = "Basic Game Options for Slipstream: The Price of Freedom. Good for troubleshooting problems."
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
        default = 1,
        visible = 1,
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
        default = 0,
        visible = 1,
        choices =
            { "$3226", "random", "$3227", "fixed", }, },
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


--=============================================================================

	dofilepath("data:soundscripts/playlists/allmusic.lua")
	Rule_Add("RandomMusicRule")

    Rule_Add("MainRule")
end

function MainRule()
    local playerIndex = 0
    local playerCount = Universe_PlayerCount()
    while  playerIndex<playerCount do
        if  Player_IsAlive(playerIndex)==1 then
            if  Player_HasShipWithBuildQueue(playerIndex)==0 then
                Player_Kill(playerIndex)
            end

        end

        playerIndex = (playerIndex + 1)
    end

    local numAlive = 0
    local numEnemies = 0
    local gameOver = 1
    playerIndex = 0
    while  playerIndex<playerCount do
        if  Player_IsAlive(playerIndex)==1 then
            local otherPlayerIndex = 0
            while  otherPlayerIndex<playerCount do
                if  AreAllied(playerIndex, otherPlayerIndex)==0 then
                    if  Player_IsAlive(otherPlayerIndex)==1 then
                        gameOver = 0
                    else
                        numEnemies = (numEnemies + 1)
                    end

                end

                otherPlayerIndex = (otherPlayerIndex + 1)
            end

            numAlive = (numAlive + 1)
        end

        playerIndex = (playerIndex + 1)
    end

    if  numEnemies==0 and numAlive>0 then
        gameOver = 0
    end

    if  gameOver==1 then
        Rule_Add("waitForEnd")
        Event_Start("endGame")
        Rule_Remove("MainRule")
    end

end

function waitForEnd()
    if  Event_IsDone("endGame") then
        setGameOver()
        Rule_Remove("waitForEnd")
    end

end
