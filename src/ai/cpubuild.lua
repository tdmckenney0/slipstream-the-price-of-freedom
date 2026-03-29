-- Slipstream: The Price of Freedom - Ship Building Logic
-- Prioritizes Heavy Battlecruisers and capital ships for fast-paced warfare

aitrace("LOADING SLIPSTREAM CPU BUILD")

dofilepath("data:ai/cpuresource.lua")
dofilepath("data:ai/cpubuildsubsystem.lua")

function CreateBuildDefinitions()
    if s_race == Race_Hiigaran then
        kCollector = HGN_RESOURCECOLLECTOR
        kRefinery = HGN_RESOURCECONTROLLER
        kScout = HGN_SCOUT
        kInterceptor = HGN_INTERCEPTOR
        kBomber = HGN_ATTACKBOMBER
        kCarrier = HGN_CARRIER
        kShipYard = HGN_SHIPYARD
        kDestroyer = HGN_DESTROYER
        kBattleCruiser = HGN_BATTLECRUISER
        kHeavyBattleCruiser = HGN_HEAVYBATTLECRUISER
    else
        kCollector = VGR_RESOURCECOLLECTOR
        kRefinery = VGR_RESOURCECONTROLLER
        kScout = VGR_SCOUT
        kInterceptor = VGR_INTERCEPTOR
        kBomber = VGR_BOMBER
        kCarrier = VGR_CARRIER
        kShipYard = VGR_SHIPYARD
        kDestroyer = VGR_DESTROYER
        kBattleCruiser = VGR_BATTLECRUISER
        kHeavyBattleCruiser = VGR_HEAVYBATTLECRUISER
    end
end

function CpuBuild_PersonalityDemand()
    -- SLIPSTREAM: AGGRESSIVE build priorities - capital ships first!
    if s_race == Race_Hiigaran then
        sg_classPersonalityDemand[eFighter] = 0.75
        sg_classPersonalityDemand[eCorvette] = 0.75
        sg_classPersonalityDemand[eFrigate] = 1.0
        sg_classPersonalityDemand[eCapital] = 1.5  -- High capital priority
    else
        sg_classPersonalityDemand[eFighter] = 0.75
        sg_classPersonalityDemand[eCorvette] = 1.0
        sg_classPersonalityDemand[eFrigate] = 0.75
        sg_classPersonalityDemand[eCapital] = 1.5  -- High capital priority
    end
    
    -- SLIPSTREAM: Platforms are mobile and useful
    sg_classPersonalityDemand[ePlatform] = 0.25
    if Rand(100) < 30 then
        sg_classPersonalityDemand[ePlatform] = 0.5
    end
    
    if g_LOD >= 2 then
        sg_classPersonalityDemand[ePlatform] = (sg_classPersonalityDemand[ePlatform] - 0.5)
    end
    
    aitrace("PersonalityDemand: Fi:" .. sg_classPersonalityDemand[eFighter] .. 
            " Co:" .. sg_classPersonalityDemand[eCorvette] .. 
            " Fr:" .. sg_classPersonalityDemand[eFrigate])
end

function CpuBuild_Init()
    CreateBuildDefinitions()
    CpuBuildSS_Init()
    CpuResource_Init()
    
    sg_resourceDemand = 0  -- Start building military immediately
    sg_scoutDemand = 0
    sg_militaryDemand = 2  -- Higher military priority
    
    -- SLIPSTREAM: Very early scouting
    sg_randScoutStartBuildTime = (10 + Rand(30))
    sg_randFavorShipType = Rand(100)
    
    sg_classPersonalityDemand = {}
    CpuBuild_PersonalityDemand()
    
    sg_subSystemOverflowDemand = 0
    sg_subSystemDemand = 0
    sg_shipDemand = 8  -- Much higher ship priority - build constantly!
    sg_militaryToBuildPerCollector = 2  -- Always prioritize military
    
    -- Default ship demand rules based on difficulty
    if g_LOD == 0 then
        CpuBuild_DefaultShipDemandRules = CpuBuild_DefaultShipDemandRules_Easy
    elseif g_LOD == 1 then
        CpuBuild_DefaultShipDemandRules = CpuBuild_DefaultShipDemandRules_Med
    else
        CpuBuild_DefaultShipDemandRules = CpuBuild_DefaultShipDemandRules_Hard
    end
    
    -- SLIPSTREAM: Tighter demand ranges for better AI performance
    cp_shipDemandRange = 0.25
    cp_subSystemDemandRange = 0.25
    if g_LOD == 1 then
        cp_shipDemandRange = 0.5
        cp_subSystemDemandRange = 0.5
    end
    if g_LOD == 0 then
        cp_shipDemandRange = 1
        cp_subSystemDemandRange = 1
    end
    
    if Override_BuildDemandInit then
        Override_BuildDemandInit()
    end
    
    kUnitCapId_Fighter = GetUnitCapFamilyId("Fighter")
    kUnitCapId_Corvette = GetUnitCapFamilyId("Corvette")
    kUnitCapId_Frigate = GetUnitCapFamilyId("Frigate")
end

function DetermineClassDemand()
    for i = 0, eMaxCount, 1 do
        if sg_classPersonalityDemand[i] and sg_classPersonalityDemand[i] ~= 0 then
            ShipDemandSetByClass(i, sg_classPersonalityDemand[i])
        end
    end
    ShipDemandSetByClass(eUselessShips, -10)
end

function DetermineAntiChassisDemand(enemyIndex)
    local kFighterCounterScale = 3
    local kCorvetteCounterScale = 1.5
    local kFrigateCounterScale = 1
    
    local AFiDemand = 0
    local ACoDemand = 0
    local AFrDemand = 0
    
    local FiValue = PlayersMilitary_Fighter(enemyIndex, player_max)
    local self_AFiValue = PlayersMilitary_AntiFighter(s_playerIndex, player_max)
    -- Guard nil globals from engine
    if (enemy_FiTotal or 0) < 0 then
        enemy_FiTotal = 0
    end
    
    local CoValue = PlayersMilitary_Corvette(enemyIndex, player_max)
    local self_ACoValue = PlayersMilitary_AntiCorvette(s_playerIndex, player_max)
    if (enemy_CoTotal or 0) < 0 then
        enemy_CoTotal = 0
    end
    
    local MSfrig_correction = 0
    if s_militaryStrengthVersusTarget < 20 then
        MSfrig_correction = 25
    end
    
    PlayersMilitary_Frigate(enemyIndex, player_max)
    local self_AFrValue = PlayersMilitary_AntiFrigate(s_playerIndex, player_max)
    -- Guard nil global from engine
    if (enemy_FrTotal or 0) < 0 then
        enemy_FrTotal = 0
    end
    
    -- Guard nil globals from engine
    if (enemy_ChassisTotal or 0) > 0 then
        if (enemy_FiTotal or 0) > 0 then
            if FiTotalPercent > 70 then
                AFiDemand = (AFiDemand + 3)
            elseif FiTotalPercent > 35 then
                AFiDemand = (AFiDemand + 1.5)
            end
        end
        
        if enemy_CoTotal > 0 then
            if CoTotalPercent > 70 then
                ACoDemand = (ACoDemand + 3)
            elseif CoTotalPercent > 35 then
                ACoDemand = (ACoDemand + 1.5)
            end
        end
        
        if enemy_FrTotal > 0 then
            if FrTotalPercent > 70 then
                AFrDemand = (AFrDemand + 3)
            elseif FrTotalPercent > 35 then
                AFrDemand = (AFrDemand + 1.5)
            end
        end
    end
    
    if AFiDemand > 0 then
        ShipDemandAddByClass(eAntiFighter, AFiDemand)
    end
    
    if ACoDemand > 0 then
        ShipDemandAddByClass(eAntiCorvette, ACoDemand)
    end
    
    if AFrDemand > 0 then
        ShipDemandAddByClass(eAntiFrigate, AFrDemand)
    end
    
    aitrace("AChDmd: AFi:" .. AFiDemand .. " ACo:" .. ACoDemand .. " AFr:" .. AFrDemand)
end

function DetermineChassisDemand(enemyIndex)
    local FiDemand = 0
    local CoDemand = 0
    local FrDemand = 0
    
    local AFiValue = PlayersMilitary_AntiFighter(enemyIndex, player_max)
    local ACoValue = PlayersMilitary_AntiCorvette(enemyIndex, player_max)
    local AFrValue = PlayersMilitary_AntiFrigate(enemyIndex, player_max)
    
    -- Guard against nil - ATotal is set by PlayersMilitary functions
    if (ATotal or 0) <= 0 then
        return
    end
    
    if AFiValue > 5 then
        if AFiPercent > 70 then
            FiDemand = (FiDemand - 3)
        elseif AFiPercent > 35 then
            FiDemand = (FiDemand - 1.5)
        end
    end
    
    if ACoValue > 5 then
        if ACoPercent > 70 then
            CoDemand = (CoDemand - 2)
        elseif ACoPercent > 35 then
            CoDemand = (CoDemand - 1)
        end
    end
    
    if AFrValue > 5 then
        if AFrPercent > 70 then
            FrDemand = (FrDemand - 1.5)
        elseif AFrPercent > 35 then
            FrDemand = (FrDemand - 0.5)
        end
    end
    
    ShipDemandAddByClass(eFighter, FiDemand)
    ShipDemandAddByClass(eCorvette, CoDemand)
    ShipDemandAddByClass(eFrigate, FrDemand)
    
    aitrace("ChDmd: Fi:" .. FiDemand .. " Co:" .. CoDemand .. " Fr:" .. FrDemand)
end

function DetermineDemandWithNoCounterInfo()
    if s_militaryPop < 5 then
        aitrace("Dmd:Rand:" .. sg_randFavorShipType)
        if s_race == Race_Hiigaran then
            if sg_randFavorShipType < 40 then
                ShipDemandAddByClass(eFighter, 1)
            elseif sg_randFavorShipType < 65 then
                ShipDemandAddByClass(eCorvette, 1)
            elseif sg_randFavorShipType < 85 then
                ShipDemandAddByClass(eFrigate, 1)
            else
                -- SLIPSTREAM: Higher chance of destroyers/capitals early
                ShipDemandAdd(kDestroyer, 1.5)
            end
        else
            if sg_randFavorShipType < 35 then
                ShipDemandAddByClass(eFighter, 1)
            elseif sg_randFavorShipType < 60 then
                ShipDemandAddByClass(eCorvette, 1)
            elseif sg_randFavorShipType < 85 then
                ShipDemandAddByClass(eFrigate, 1)
            else
                ShipDemandAdd(kDestroyer, 1.5)
            end
        end
    else
        aitrace("Dmd:Asking for AntiFrigates")
        ShipDemandAddByClass(eAntiFrigate, 1.5)
    end
end

function DetermineCounterDemand()
    if s_enemyIndex ~= -1 then
        local enemyMilitaryCount = PlayersMilitaryPopulation(s_enemyIndex, player_max)
        if enemyMilitaryCount >= 3 then
            DetermineChassisDemand(s_enemyIndex)
            DetermineAntiChassisDemand(s_enemyIndex)
            return
        end
    end
    
    DetermineDemandWithNoCounterInfo()
end

function DetermineSpecialDemand()
    -- Interceptor priority when we have production
    if ShipDemandGet(kInterceptor) > 0 and NumSubSystems(FIGHTERPRODUCTION) > 0 and NumSquadrons(kInterceptor) < 3 and s_militaryPop < 10 then
        ShipDemandAdd(kInterceptor, 0.5)
    end
    
    -- SLIPSTREAM: Earlier frigate transition
    if s_selfTotalValue > 80 then
        local additionalFrigDemand = 0.75
        if s_race == Race_Hiigaran then
            NumSubSystemsQ(ADVANCEDRESEARCH)
            -- Guard against nil from NumSubSystemsQ side-effect global
            if (advresearchcount or 0) > 0 then
                additionalFrigDemand = (additionalFrigDemand + 0.5)
            end
        end
        
        ShipDemandAddByClass(eFrigate, additionalFrigDemand)
        ShipDemandAddByClass(eFighter, -0.25)
    end
    
    -- Special ship limits (capture, shield)
    numQueueOfClass(eShield)
    local numFrigates = numQueueOfClass(eFrigate) or 0
    local specialCount = numSpecial or 0
    if numFrigates == 0 or (numFrigates > 0 and specialCount / numFrigates > 0.4) then
        ShipDemandAddByClass(eCapture, -10)
        ShipDemandAddByClass(eShield, -10)
    elseif s_militaryPop < 5 then
        ShipDemandAddByClass(eCapture, -4)
        ShipDemandAddByClass(eShield, -4.5)
    elseif s_militaryPop < 10 then
        ShipDemandAddByClass(eCapture, -2)
        ShipDemandAddByClass(eShield, -2.5)
    elseif s_militaryPop < 15 then
        ShipDemandAddByClass(eCapture, -1)
        ShipDemandAddByClass(eShield, -1.5)
    elseif s_militaryPop > 30 then
        ShipDemandAddByClass(eCapture, 1)
        ShipDemandAddByClass(eShield, 1)
    end
    
    -- Hiigaran torpedo frigate
    if s_race == Race_Hiigaran then
        local torpedoDemand = -0.5
        if IsResearchDone(IMPROVEDTORPEDO) == 1 or s_militaryStrength > 40 or GetRU() > 2500 then
            torpedoDemand = 0
        end
        ShipDemandAdd(HGN_TORPEDOFRIGATE, torpedoDemand)
    end
    
    -- SLIPSTREAM: Heavy Battlecruiser priority (key unit in mod)
    -- Much more aggressive capital ship building
    local numRUs = GetRU()
    local numCollecting = GetNumCollecting()
    
    -- Always try to build capitals once basic economy is up
    if numCollecting >= 3 or numRUs > 500 then
        -- Heavy Battlecruisers are the priority (check if type exists)
        if kHeavyBattleCruiser then
            ShipDemandAdd(kHeavyBattleCruiser, 3.0)
        end
        if kBattleCruiser then
            ShipDemandAdd(kBattleCruiser, 1.5)
        end
        if kDestroyer then
            ShipDemandAdd(kDestroyer, 1.0)
        end
        
        if IsResearchDone(BATTLECRUISERIONWEAPONS) == 1 and kHeavyBattleCruiser then
            ShipDemandAdd(kHeavyBattleCruiser, 1.5)
        end
        
        -- Even higher priority when we have RUs
        if numRUs > 2000 then
            if kHeavyBattleCruiser then
                ShipDemandAdd(kHeavyBattleCruiser, 2.0)
            end
            if kBattleCruiser then
                ShipDemandAdd(kBattleCruiser, 1.0)
            end
        end
    end
    
    -- Counter enemy battlecruisers with bombers
    local numEnemyBattleCruisers = PlayersUnitTypeCount(player_enemy, player_total, eBattleCruiser)
    local numEnemyHeavyBCs = PlayersUnitTypeCount(player_enemy, player_total, eHeavyBattleCruiser)
    if numEnemyBattleCruisers > 0 or numEnemyHeavyBCs > 0 then
        if s_enemyIndex ~= -1 then
            local targetEnemyCruisers = PlayersUnitTypeCount(s_enemyIndex, player_max, eBattleCruiser)
            targetEnemyCruisers = targetEnemyCruisers + PlayersUnitTypeCount(s_enemyIndex, player_max, eHeavyBattleCruiser)
            if targetEnemyCruisers > 0 then
                ssKillaDemand = ((ssKillaDemand or 0) + targetEnemyCruisers * 1.5)
            end
        end
        
        if eSubSystemAttackers then
            ShipDemandAddByClass(eSubSystemAttackers, ssKillaDemand or 0)
        end
    end
    
    -- Shipyard demand
    NumSquadronsQ(kShipYard)
    local shipyardCount = numShipyards or 0
    if shipyardCount == 0 and UnderAttackThreat() < -75 then
        local bcDemand = 0
        if kBattleCruiser then
            bcDemand = bcDemand + (ShipDemandGet(kBattleCruiser) or 0)
        end
        if kHeavyBattleCruiser then
            bcDemand = bcDemand + (ShipDemandGet(kHeavyBattleCruiser) or 0)
        end
        if bcDemand >= 0.5 and kShipYard then
            ShipDemandAdd(kShipYard, (bcDemand - 0.5))
        end
    end
    
    -- Platform priority adjustment
    if s_militaryStrength > 25 * sg_moreEnemies then
        ShipDemandAddByClass(ePlatform, -1.5)
    end
end

function CalculateMilitaryValueGoal(militaryTable, percentOfEnemy)
    local curTime = gameTime()
    local minMilitaryValue = 0
    
    if s_enemyTotalValue * percentOfEnemy > minMilitaryValue then
        minMilitaryValue = s_enemyTotalValue * percentOfEnemy
    end
    
    for k, v in militaryTable do
        if curTime < v[3] then
            if minMilitaryValue < v[1] then
                minMilitaryValue = v[1]
            end
            if minMilitaryValue > v[2] then
                minMilitaryValue = v[2]
            end
        end
    end
    
    return minMilitaryValue
end

-- SLIPSTREAM: Difficulty-specific ship demand rules
function CpuBuild_DefaultShipDemandRules_Easy()
    local valueTable = {
        {20, 60, 120},    -- 0-2 min: 20-60 value
        {40, 100, 300},   -- 2-5 min: 40-100 value
        {80, 200, 600},   -- 5-10 min: 80-200 value
    }
    
    local minMilitaryValue = CalculateMilitaryValueGoal(valueTable, 0.5)
    aitrace("Aim:" .. minMilitaryValue .. " CurMil:" .. s_selfTotalValue .. " Enm:" .. s_enemyTotalValue)
    
    if s_selfTotalValue < minMilitaryValue then
        DetermineClassDemand()
        DetermineCounterDemand()
        DetermineSpecialDemand()
    end
    
    DetermineScoutDemand()
    DetermineBuilderClassDemand()
end

function CpuBuild_DefaultShipDemandRules_Med()
    local valueTable = {
        {30, 80, 90},    -- 0-1.5 min: 30-80 value
        {60, 150, 240},  -- 1.5-4 min: 60-150 value
        {120, 300, 480}, -- 4-8 min: 120-300 value
    }
    
    local minMilitaryValue = CalculateMilitaryValueGoal(valueTable, 0.7)
    aitrace("Aim:" .. minMilitaryValue .. " CurMil:" .. s_selfTotalValue .. " Enm:" .. s_enemyTotalValue)
    
    if s_selfTotalValue < minMilitaryValue then
        DetermineClassDemand()
        DetermineCounterDemand()
        DetermineSpecialDemand()
    end
    
    DetermineScoutDemand()
    DetermineBuilderClassDemand()
end

function CpuBuild_DefaultShipDemandRules_Hard()
    -- SLIPSTREAM: Aggressive build goals
    DetermineClassDemand()
    DetermineCounterDemand()
    DetermineScoutDemand()
    DetermineBuilderClassDemand()
    DetermineSpecialDemand()
end

function CpuBuild_RemoveBuildItems()
    RemoveStalledBuildItems()
end

function CpuBuild_Process()
    ShipDemandClear()
    CpuBuild_RemoveBuildItems()
    
    if Override_ShipDemand then
        Override_ShipDemand()
    else
        CpuBuild_DefaultShipDemandRules()
    end
    
    -- Resource vs military building
    if sg_resourceDemand > 0 or sg_militaryDemand <= 0 then
        if DoResourceBuild() == 1 then
            sg_resourceDemand = (1 - sg_militaryToBuildPerCollector)
            return 1
        end
    end
    
    if sg_militaryDemand > 0 then
        aitrace("**DoMilitaryBuild")
        if DoMilitaryBuild() == 1 then
            if sg_resourceDemand <= 0 then
                sg_resourceDemand = (sg_resourceDemand + 1)
            end
            return 1
        end
    end
    
    return 0
end

function DoMilitaryBuild()
    Rand(3)
    local shipId = FindHighDemandShip()
    local highestPriority = HighestPriorityShip()
    
    -- Initialize ssDemand (subsystem demand) - defaults to ship demand
    local ssDemand = sg_subSystemDemand or 0
    
    -- Reduce subsystem demand under attack
    if UnderAttackThreat() > -5 and shipId > 0 and highestPriority >= 0.5 then
        ssDemand = 0
        aitrace("Subsys demand reduced - under attack")
    end
    
    -- SLIPSTREAM: Always try to build ships first (sg_shipDemand is 8)
    if (sg_shipDemand or 0) > ssDemand then
        if shipId > 0 then
            Build(shipId)
            sg_subSystemOverflowDemand = (sg_subSystemOverflowDemand + 1)
            return 1
        end
    end
    
    if sg_dosubsystems == 1 and CpuBuildSS_DoBuildSubSystem() == 1 then
        return 1
    end
    
    return 0
end

function DetermineScoutDemand()
    local curGameTime = gameTime()
    
    if UnderAttackThreat() < -10 and s_militaryPop > 0 and curGameTime > sg_randScoutStartBuildTime then
        local numEnemies = PlayersAlive(player_enemy)
        local shipCount = numQueueOfClass(eScout)
        local numScoutsDemanded = 1
        
        if numEnemies >= 2 then
            numScoutsDemanded = 2
        end
        
        if numEnemies > 2 and s_militaryPop > 7 then
            numScoutsDemanded = (2 + (s_militaryPop - 7) / 10)
        end
        
        if shipCount < numScoutsDemanded then
            ShipDemandAddByClass(eScout, 3.5)
            local scoutRand = Rand(100)
            if scoutRand > 30 then
                ShipDemandAdd(kScout, 1.5)
            end
            sg_randScoutStartBuildTime = (curGameTime + 40)
        end
    end
end

function DetermineBuilderClassDemand()
    local numBuilders = numQueueOfClass(eBuilder)
    local numActiveBuilders = numActiveOfClass(s_playerIndex, eBuilder)
    
    if numBuilders > numActiveBuilders then
        ShipDemandAddByClass(eBuilder, -10)
        return
    end
    
    -- Builder limits by difficulty
    if g_LOD == 0 and numBuilders > 4 then
        ShipDemandAddByClass(eBuilder, -10)
        return
    elseif g_LOD == 1 and numBuilders > 5 then
        ShipDemandAddByClass(eBuilder, -10)
        return
    end
    
    if s_militaryPop < 5 or UnderAttack() == 1 and UnderAttackThreat() > -75 then
        ShipDemandAddByClass(eBuilder, -10)
        return
    end
    
    local numRUs = GetRU()
    if GetNumCollecting() < 5 and numRUs < 10000 then
        return
    end
    
    if numBuilders > 6 then
        numBuilders = 6
    end
    
    -- Calculate builder demand based on RUs
    local RUsNeededToBuildBuilder = 3000 + numBuilders * 1500
    if s_race == Race_Vaygr then
        RUsNeededToBuildBuilder = (RUsNeededToBuildBuilder - 500)
    end
    
    local dif = numRUs - RUsNeededToBuildBuilder
    if dif > 0 then
        local ruPerShip = 1500
        if s_militaryStrength > 30 then
            ruPerShip = 1000
        end
        
        local bonusDemand = dif / ruPerShip
        ShipDemandAddByClass(eBuilder, bonusDemand)
    end
    
    if dif < -2000 then
        local penaltyDemand = dif / 2000
        ShipDemandAddByClass(eBuilder, penaltyDemand)
    end
    
    -- Adjust based on military strength
    local militaryDif = s_selfTotalValue - s_enemyTotalValue * 0.7
    if militaryDif < 0 then
        local militaryDifDemand = militaryDif / 50
        ShipDemandAddByClass(eBuilder, militaryDifDemand)
    end
end
