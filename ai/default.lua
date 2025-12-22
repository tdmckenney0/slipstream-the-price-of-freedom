-- Slipstream: The Price of Freedom - Main AI Controller
-- Optimized for fast-paced tactical gameplay

aitrace("SLIPSTREAM CPU LOADED")

g_LOD = getLevelOfDifficulty()

-- Load AI modules
dofilepath("data:ai/classdef.lua")
dofilepath("data:ai/cpubuild.lua")
dofilepath("data:ai/cpuresearch.lua")
dofilepath("data:ai/cpumilitary.lua")

-- Disable aitrace after initialization to reduce log spam
old_aitrace = aitrace
rawset(globals(), "aitrace", NIL)
function aitrace()
end

-- Main initialization
function oninit()
    s_playerIndex = Player_Self()
    s_race = getRace()
    
    -- Enable all AI systems
    sg_dobuild = 1
    sg_dosubsystems = 1
    sg_doresearch = 1
    sg_doupgrades = 1
    sg_domilitary = 1
    cp_processResource = 1
    cp_processMilitary = 1
    
    sg_lastSpendMoneyTime = gameTime()
    
    -- SLIPSTREAM: Reduced money delay for faster gameplay
    -- Stock: Easy=8, Medium=4, Hard=0
    -- Slipstream: Easy=3, Medium=1, Hard=0
    sg_spendMoneyDelay = 0
    if g_LOD < 2 then
        sg_spendMoneyDelay = 1
        if g_LOD < 1 then
            sg_spendMoneyDelay = 3
        end
    end
    
    -- Initialize AI subsystems
    ClassInitialize()
    CpuBuild_Init()
    CpuResearch_Init()
    CpuMilitary_Init()
    
    -- Research demand reset value
    sg_kDemandResetValue = 4
    if s_race == Race_Vaygr then
        sg_kDemandResetValue = 2
    end
    
    -- Allow override hooks
    if Override_Init then
        Override_Init()
    end
    
    sg_reseachDemand = -(sg_kDemandResetValue)
    
    -- SLIPSTREAM: Faster AI tick rate (1 second vs 2 seconds)
    Rule_AddInterval("doai", 1)
end

-- Calculate available build channels based on economy
function CalcOpenBuildChannels()
    local numShipsBuildingShips = NumShipsBuildingShips()
    local numShipsBuildingSubSystems = NumShipsBuildingSubSystems()
    local researchItem = IsResearchBusy()
    
    BuildShipCount()
    
    local numCollecting = GetNumCollecting()
    local numRUs = GetRU()
    
    -- SLIPSTREAM: Very aggressive build channel allocation
    -- Stock: collectors/5 + (RU-500)/1000
    -- Slipstream: collectors/3 + (RU-200)/600 - build as much as possible!
    sg_allowedBuildChannels = numCollecting / 3
    if numRUs > 200 then
        sg_allowedBuildChannels = (sg_allowedBuildChannels + (numRUs - 200) / 600)
    end
    
    -- Always allow at least 2 build channels
    if sg_allowedBuildChannels < 2 then
        sg_allowedBuildChannels = 2
    end
    
    -- Guard against nil values (numItemsBuilding is set by BuildShipCount)
    local itemsBuilding = numItemsBuilding or 0
    s_numOpenBuildChannels = (sg_allowedBuildChannels - itemsBuilding)
    
    s_shipBuildQueuesFull = 0
    local buildShipsTotal = totalBuildShips or 0
    local shipsBuilding = numShipsBuilding or 0
    -- SLIPSTREAM: Only consider queues full if there ARE ships and they're all building
    -- Fixed: 0 == 0 should NOT mean queues are full!
    if buildShipsTotal > 0 and buildShipsTotal == shipsBuilding then
        s_shipBuildQueuesFull = 1
    end
    
    -- Remove least needed item if we're over-committed
    if s_numOpenBuildChannels <= -1.5 then
        RemoveLeastNeededItem()
    end
end

-- Cache current game state for decision making
function CacheCurrentState()
    -- Production subsystem counts
    s_numFiSystems = (NumSubSystems(FIGHTERPRODUCTION) + NumSubSystemsQ(FIGHTERPRODUCTION))
    s_numCoSystems = (NumSubSystems(CORVETTEPRODUCTION) + NumSubSystemsQ(CORVETTEPRODUCTION))
    s_numFrSystems = (NumSubSystems(FRIGATEPRODUCTION) + NumSubSystemsQ(FRIGATEPRODUCTION))
    s_totalProdSS = ((s_numFiSystems + s_numCoSystems) + s_numFrSystems)
    
    -- Military strength calculations
    s_militaryPop = PlayersMilitaryPopulation(s_playerIndex, player_total)
    s_selfTotalValue = PlayersMilitary_Total(s_playerIndex, player_total)
    s_enemyTotalValue = PlayersMilitary_Total(player_enemy, player_max)
    s_militaryStrength = PlayersMilitary_Threat(player_enemy, player_min)
    
    -- Target enemy selection
    s_enemyIndex = GetChosenEnemy()
    s_militaryStrengthVersusTarget = 0
    if s_enemyIndex ~= -1 then
        s_militaryStrengthVersusTarget = PlayersMilitary_Threat(s_enemyIndex, player_max)
    end
end

-- Spend resources on building and research
function SpendMoney()
    if s_numOpenBuildChannels > 0 then
        local buildHasBeenDone = 0
        
        -- Try to build ships
        if sg_dobuild == 1 and s_shipBuildQueuesFull == 0 and sg_reseachDemand < 0 then
            if CpuBuild_Process() == 1 then
                s_numOpenBuildChannels = (s_numOpenBuildChannels - 1)
                sg_reseachDemand = (sg_reseachDemand + 1)
                buildHasBeenDone = 1
            end
        end
        
        -- Try to research
        if s_numOpenBuildChannels > 0 then
            if sg_doresearch == 1 then
                local didResearch = CpuResearch_Process()
                if didResearch == 1 then
                    sg_reseachDemand = -(sg_kDemandResetValue)
                elseif sg_reseachDemand >= 0 and sg_dobuild == 1 and s_shipBuildQueuesFull == 0 and buildHasBeenDone == 0 then
                    CpuBuild_Process()
                end
            else
                sg_reseachDemand = -(sg_kDemandResetValue)
            end
        end
    end
end

-- Main AI loop - runs every tick
function doai()
    CacheCurrentState()
    CalcOpenBuildChannels()
    
    local curTime = gameTime()
    
    -- SLIPSTREAM: Use time delta for spending decisions
    -- timeSinceLastSubSysDemand is an engine-provided global, guard against nil
    local timeSinceSpend = (curTime - (sg_lastSpendMoneyTime or 0))
    if timeSinceSpend >= sg_spendMoneyDelay then
        SpendMoney()
        sg_lastSpendMoneyTime = curTime
    end
    
    -- Process military commands
    if sg_domilitary == 1 then
        CpuMilitary_Process()
    end
end
