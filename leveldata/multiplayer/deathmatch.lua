-- LuaDC version 0.9.20
-- 1/13/2008 6:28:56 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
GUID = 
    { 110, 91, 157, 190, 18, 23, 250, 78, 144, 20, 41, 246, 181, 128, 214, 12, }
GameRulesName = "TPOF: Deathmatch"
Description = "Default Game Options for Slipstream: The Price of Freedom"
GameSetupOptions = 
    { 
    { 
        name = "resources", 
        locName = "$3240", 
        tooltip = "$3239", 
        default = 1, 
        visible = 1, 
        choices = 
            { "$3241", "0.5", "$3242", "1.0", "$3243", "2.0", }, }, 
    { 
        name = "unitcaps", 
        locName = "$3214", 
        tooltip = "$3234", 
        default = 1, 
        visible = 1, 
        choices = 
            { "$3215", "Small", "$3216", "Normal", "$3217", "Large", }, }, 
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
{ 
		name = "bgmusic", 
		locName = "Music", 
		tooltip = "SELECT THE BACKGROUND MUSIC", 
		default = 0, 
		visible = 1, 
		choices = 
		{
			"Off", "staging\\Mute.fda",
			"Shuffle", "shuffle",
			"Main Menu Theme", "staging\\staging_01", 
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
			"Battle - Resistance", "staging\\The_Hand_That_Feeds",  
			"Battle - Sajuuk", "battle\\battle_sajuuk", 
			"Battle - Arrival", "battle\\battle_arrival", 
		},
	}, 
  {
          name = "startwith",
          locName = "Fleet",
          tooltip = "Choose A Fleet",
          default = 0,
          visible = 1,
          choices =
          {
              "Default", "one",
              "Instant Action", "instant",
              "Carrier Group", "carriers",
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
	else
		Rule_Add("PlayMusicRule")
	end

    Rule_Add("MainRule")

   if (GetGameSettingAsString("startwith") == "one") then
          SetStartFleetSuffix("")
      elseif (GetGameSettingAsString("startwith") == "instant") then
          SetStartFleetSuffix("Instant")
      elseif (GetGameSettingAsString("startwith") == "carriers") then
          SetStartFleetSuffix("Carriers")                   
      end
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
