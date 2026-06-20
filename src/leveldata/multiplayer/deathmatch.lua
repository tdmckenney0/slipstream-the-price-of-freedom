GUID = { 110, 91, 157, 190, 18, 23, 250, 78, 144, 20, 41, 246, 181, 128, 214, 12, }
GameRulesName = "$8300"
Description = "$8301"
Directories = { Levels = "data:LevelData\\Multiplayer\\slipstream\\", }

GameSetupOptions = {

    -- Slipstream ranges from 1x to 3x resources
    {
        name = "resources",
        locName = "$3240",
        tooltip = "$3239",
        default = 1,
        visible = 1,
        choices = { "$3241", "1.0", "$3242", "2.0", "$3243", "3.0", },
    },

    -- Unit caps are totally open to cut down on battle size.
    {
        name = "unitcaps",
        locName = "$3214",
        tooltip = "$3234",
        default = 1,
        visible = 1,
        choices = { "$3215", "Small", "$3216", "Normal", "$3217", "Large" },
    },

    -- Alliances are fluid in the Slipstream timeline.
    {
        name = "lockteams",
        locName = "$3220",
        tooltip = "$3235",
        default = 0,
        visible = 1,
        choices = { "$3221", "yes", "$3222", "no", },
    },

    -- Starting resources are level-based to align with the scenario model.
    {
        name = "resstart",
        locName = "$3205",
        tooltip = "$3232",
        default = 0,
        visible = 0,
        choices = { "$3209", "0", },
    },

    -- Starting locations are fixed to align with the scenario model.
    {
        name = "startlocation",
        locName = "$3225",
        tooltip = "$3237",
        default = 0,
        visible = 0,
        choices = { "$3227", "fixed", },
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

    ShufflePlaylist()

    Rule_Add("findSlipgatesAndStartEvent")

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

function findSlipgatesAndStartEvent()
    SobGroup_Create("Slipgates")
    Player_FillShipsByType("Slipgates", -1, "meg_slipgate")

    if (SobGroup_Count("Slipgates") > 0) then
        FX_StartEvent("Slipgates", "SlipstreamEffect")
    end

    Rule_Remove("findSlipgatesAndStartEvent")
end
