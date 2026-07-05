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
    
    -- Enable all AI systems. TPOF restricts the research *modules*, but a set of
    -- basic upgrades remain always available (see cpuresearch.lua) and the AI
    -- pursues them from spare economy via sg_doupgrades.
    sg_dobuild = 1
    sg_dosubsystems = 1
    sg_domilitary = 1
    sg_doupgrades = 1
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
    
    -- Initialize AI subsystems (CpuResearch_Init after CpuBuild_Init: it relies
    -- on the k* ship constants set up in CreateBuildDefinitions).
    ClassInitialize()
    CpuBuild_Init()
    CpuResearch_Init()
    CpuMilitary_Init()

    -- Allow override hooks
    if Override_Init then
        Override_Init()
    end

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
    -- Production subsystem counts.
    -- IMPORTANT: NumSubSystems()/NumSubSystemsQ() called with a production-FAMILY
    -- constant (FIGHTERPRODUCTION/CORVETTEPRODUCTION/FRIGATEPRODUCTION) raises an
    -- engine error in HW2 Classic ("parameter:" + traceback). Because this runs
    -- unconditionally first in every doai tick, that error aborted the entire AI
    -- loop from game start, so the AI did nothing. The HW2 AI Toolkit hit the same
    -- issue and hard-zeroed these (see refs/hwat-0-2-32-0-src/ai/default.lua:166).
    -- TPOF is capital-ship-centric with production modules heavily restricted, so
    -- treating these counts as 0 is consistent and unblocks the AI.
    s_numFiSystems = 0
    s_numCoSystems = 0
    s_numFrSystems = 0
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

-- Spend open build channels on ships and subsystems. Research/upgrades are
-- handled separately by CpuResearch_Process() (called from doai) and only draw
-- on spare economy, so they never compete for the build channels allocated here.
function SpendMoney()
    if s_numOpenBuildChannels > 0 and sg_dobuild == 1 and s_shipBuildQueuesFull == 0 then
        CpuBuild_Process()
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
        -- Research basic upgrades from spare economy. Does not use build
        -- channels, so it runs alongside ship-building; CpuResearch_Process
        -- self-gates on economy, threat, and its own cadence.
        if sg_doupgrades == 1 then
            CpuResearch_Process()
        end
        sg_lastSpendMoneyTime = curTime
    end
    
    -- Process military commands
    if sg_domilitary == 1 then
        CpuMilitary_Process()
    end
end
