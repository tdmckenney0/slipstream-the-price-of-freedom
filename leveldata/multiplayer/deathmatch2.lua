-- LuaDC version 0.9.20
-- 11/11/2008 7:33:44 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
GUID =
    { 110, 91, 157, 190, 18, 23, 250, 78, 144, 20, 41, 246, 181, 128, 214, 12, }
GameRulesName = "TPOF: Safe Mode"
Description = "Original Homeworld2 Deathmatch Script"
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
        visible = 1,
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
