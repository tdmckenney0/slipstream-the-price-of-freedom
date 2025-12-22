-- Slipstream: The Price of Freedom - Military Tactics
-- Aggressive combat AI for fast-paced tactical gameplay

aitrace("LOADING SLIPSTREAM CPU MILITARY")

function CpuMilitary_Init()
    -- SLIPSTREAM: Higher attack percentage for all difficulties
    -- Stock: Easy=50, Med/Hard=100
    -- Slipstream: Easy=75, Med/Hard=100
    cp_attackPercent = 100
    if g_LOD == 0 then
        cp_attackPercent = 75
    end
    
    -- SLIPSTREAM: Smaller minimum group sizes for faster attacks
    -- Stock: 5 squads, 200 value
    -- Slipstream: 3 squads, 150 value
    cp_minSquadGroupSize = 3
    cp_minSquadGroupValue = 150
    
    -- SLIPSTREAM: Higher max group sizes (ships have more health in mod)
    cp_maxGroupSize = 18
    cp_maxGroupValue = 400
    
    -- Force attack threshold
    cp_forceAttackGroupSize = 16
    if g_LOD == 1 then
        cp_forceAttackGroupSize = 12
    end
    if g_LOD == 0 then
        cp_forceAttackGroupSize = 10
    end
    
    -- SLIPSTREAM: Higher threat modifier for more aggressive posture
    -- Stock: Easy=0.5, Med=0.75, Hard=0.95
    -- Slipstream: Easy=0.7, Med=0.85, Hard=1.0
    cp_initThreatModifier = 1.0
    if g_LOD == 0 then
        cp_initThreatModifier = 0.7
    elseif g_LOD == 1 then
        cp_initThreatModifier = 0.85
    end
    
    sg_moreEnemies = 0
    sg_militaryRand = Rand(100)
    
    -- SLIPSTREAM: Hyperspace attack settings
    sg_lastHyperspaceTime = 0
    sg_hyperspaceDelay = 30  -- Check hyperspace every 30 seconds
    
    if Override_MilitaryInit then
        Override_MilitaryInit()
    end
end

function CpuMilitary_Process()
    local numEnemies = PlayersAlive(player_enemy)
    local numAllies = PlayersAlive(player_ally)
    sg_moreEnemies = (numEnemies - numAllies)
    
    Logic_military_groupvars()
    Logic_military_attackrules()
    Logic_military_setattacktimer()
    
    -- SLIPSTREAM: Use hyperspace for tactical jumps
    Logic_military_hyperspace()
end

function Logic_military_groupvars()
    -- SLIPSTREAM: Lower minimums for faster attacks
    cp_minSquadGroupSize = 3
    cp_minSquadGroupValue = 100
    
    -- Adjust for enemy count and strength
    if sg_moreEnemies > 0 and s_selfTotalValue < s_enemyTotalValue * 2 then
        cp_minSquadGroupSize = (cp_minSquadGroupSize + 1)
        cp_minSquadGroupValue = (cp_minSquadGroupValue + 50)
    elseif s_militaryStrength > 120 then
        -- We're strong, attack with smaller groups
        cp_minSquadGroupSize = 2
        cp_minSquadGroupValue = 75
    end
end

function Logic_military_attackrules()
    if g_LOD == 0 then
        -- SLIPSTREAM: Even easy AI attacks earlier (10 min vs 20 min)
        if gameTime() > 10 * 60 and s_militaryStrength > 0 then
            cp_attackPercent = 100
        end
        
        -- Go defensive if badly losing
        if s_selfTotalValue * 2.5 < s_enemyTotalValue and s_selfTotalValue > 150 then
            cp_attackPercent = 0
            aitrace("Losing badly! Defensive mode")
        end
    end
end

-- SLIPSTREAM: Hyperspace jump logic for capital ships
function Logic_military_hyperspace()
    local curTime = gameTime()
    local timeSinceHyperspace = curTime - (sg_lastHyperspaceTime or 0)
    
    -- Only try hyperspace jumps periodically
    if timeSinceHyperspace < sg_hyperspaceDelay then
        return
    end
    
    -- Need a valid enemy target
    if s_enemyIndex == -1 then
        return
    end
    
    -- Don't hyperspace if we're being attacked (defend first)
    local threat = UnderAttackThreat()
    if threat > 50 then
        return
    end
    
    -- Check if we have enough military strength to attack
    if s_militaryStrength < 0 and g_LOD > 0 then
        return
    end
    
    -- SLIPSTREAM: Hyperspace capital ships to enemy
    -- Try to jump battlecruisers and destroyers to attack
    local numBC = 0
    local numHBC = 0
    local numDest = 0
    
    if kBattleCruiser then
        numBC = NumSquadrons(kBattleCruiser) or 0
    end
    if kHeavyBattleCruiser then
        numHBC = NumSquadrons(kHeavyBattleCruiser) or 0
    end
    if kDestroyer then
        numDest = NumSquadrons(kDestroyer) or 0
    end
    
    local totalCapitals = numBC + numHBC + numDest
    
    -- If we have capital ships, log and update timer
    -- Note: HW2 AI doesn't have direct hyperspace control API
    -- Capital ships will hyperspace via normal attack behavior if they have modules
    if totalCapitals > 0 then
        if s_selfTotalValue > 100 or s_militaryStrength > 20 then
            aitrace("SLIPSTREAM: Capital ships available for attack: " .. totalCapitals)
            sg_lastHyperspaceTime = curTime
        end
    end
end

function attack_now_timer()
    aitrace("Script: calling attack_now_timer")
    AttackNow()
    
    -- SLIPSTREAM: Also trigger hyperspace attack when attacking
    Logic_military_hyperspace()
    
    Rule_Remove("attack_now_timer")
end

function Logic_military_setattacktimer()
    -- SLIPSTREAM: Much faster attack timers
    -- Stock Hard: 0s delay, 45-75s waves
    -- Stock Med: 400s delay, 160-200s waves
    -- Stock Easy: 600s delay
    -- Slipstream Hard: 0s delay, 20-40s waves
    -- Slipstream Med: 120s delay, 60-90s waves
    -- Slipstream Easy: 240s delay, 90-120s waves
    
    local timedelay = 120
    local wavedelay = 60
    
    if g_LOD == 0 then
        timedelay = 240
        wavedelay = (90 + sg_militaryRand * 0.3)
    elseif g_LOD == 1 then
        timedelay = 120
        wavedelay = (60 + sg_militaryRand * 0.3)
    else -- Hard
        timedelay = 0
        wavedelay = (20 + sg_militaryRand * 0.2)
    end
    
    local gametime = gameTime()
    
    -- Start attack timer once conditions are met
    if gametime >= timedelay or HaveBeenAttacked() == 1 then
        if Rule_Exists("attack_now_timer") == 0 then
            aitrace("Script: Attacktimer added - delay: " .. wavedelay)
            Rule_AddInterval("attack_now_timer", wavedelay)
        end
    end
end
