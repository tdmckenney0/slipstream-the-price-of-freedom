-- LuaDC version 0.9.20
-- 11/4/2024 10:16:15 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
function RestrictOptions(playerid)
    -- local playerRace = Player_GetRace(playerid)
    -- if  playerRace==Race_Hiigaran then
    -- end 

    -- if  playerRace==Race_Vaygr then
    -- end
end

function MPRestrict()
    local i = 0
    local numplayers = Universe_PlayerCount()
    while  i<numplayers do
        RestrictOptions(i)
        i = (i + 1)
    end 
end
