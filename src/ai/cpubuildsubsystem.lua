-- Slipstream: The Price of Freedom - Subsystem Building
-- Prioritizes production facilities on Battlecruisers and weapon turrets

function CpuBuildSS_Init()
    if s_race == Race_Hiigaran then
        CpuBuildSS_DefaultSubSystemDemandRules = DoSubSystemDemand_Hiigaran
    else
        CpuBuildSS_DefaultSubSystemDemandRules = DoSubSystemDemand_Vaygr
    end
    
    -- SLIPSTREAM: Faster special subsystem building
    sg_lastSpecialSubSysTime = 0
    sg_specialSubSysDelayTime = (100 + Rand(60))
    sg_retireCountCheck = 0
    sg_buildBCHyperspace = 1
end

function CpuBuildSS_SpecialSubSystemDemand()
    local curGameTime = gameTime()
    local timeSinceSpecialSS = curGameTime - (sg_lastSpecialSubSysTime or 0)
    
    -- Build special subsystems when economy is good
    if s_selfTotalValue > 120 and s_militaryStrength > -5 and UnderAttackThreat() < -70 and timeSinceSpecialSS > sg_specialSubSysDelayTime or GetRU() > 2500 then
        SubSystemDemandGet(FIGHTERPRODUCTION)
        SubSystemDemandGet(CORVETTEPRODUCTION)
        SubSystemDemandGet(FRIGATEPRODUCTION)
        SubSystemDemandGet(CAPSHIPPRODUCTION)
        SubSystemDemandGet(PLATFORMPRODUCTION)
        SubSystemDemandGet(RESEARCH)
        SubSystemDemandGet(ADVANCEDRESEARCH)
        
        aitrace("SS:special demand:" .. productionDemand)
        
        if productionDemand <= 1 then
            -- SLIPSTREAM: Include hyperspace module as high priority
            local specialSubsystems = { HYPERSPACE, CLOAKGENERATOR, FIRECONTROLTOWER, HYPERSPACEINHIBITOR, ADVANCEDARRAY, CLOAKSENSOR }
            
            if g_LOD < 2 then
                specialSubsystems = { HYPERSPACE, CLOAKGENERATOR, FIRECONTROLTOWER, HYPERSPACEINHIBITOR, ADVANCEDARRAY, CLOAKSENSOR }
            end
            
            local minNumber = 10
            local maxNumber = 0
            
            for a, b in specialSubsystems do
                NumSubSystemsQ(b)
                if numberBuilt < minNumber then
                    minNumber = numberBuilt
                end
                if numberBuilt > maxNumber then
                    maxNumber = numberBuilt
                end
            end
            
            for a, b in specialSubsystems do
                local numQueued = NumSubSystemsQ(b)
                if numQueued == 0 then
                    NumSubSystems(b)
                    local demand = 1.5
                    
                    -- SLIPSTREAM: Hyperspace module gets extra priority
                    if b == HYPERSPACE then
                        demand = demand + 1
                    end
                    
                    if minNumber < maxNumber then
                        demand = demand * (1 - (numberBuilt - minNumber) / (maxNumber - minNumber))
                    end
                    
                    SubSystemDemandAdd(b, demand)
                end
            end
            
            sg_lastSpecialSubSysTime = curGameTime
        end
    end
end

function CpuBuildSS_RetireVaygrProductionSubSystems()
    local numCarriers = CarrierCount()
    
    for i = 0, (numCarriers - 1), 1 do
        local carrier = CarrierAt(i)
        local productionId = CarrierProductionSubSystem(carrier)
        
        if productionId ~= 0 then
            local ssdemand = SubSystemDemandGet(productionId)
            if ssdemand < 0 then
                sg_retireCountCheck = (sg_retireCountCheck + 1)
                if sg_retireCountCheck >= 2 then
                    aitrace("VaygrCarrierRetire: Dem:" .. ssdemand .. " Count:" .. sg_retireCountCheck)
                    RetireSubSystem(carrier, productionId)
                    sg_retireCountCheck = 0
                    return
                end
            else
                sg_retireCountCheck = 0
            end
        end
    end
end

function std_minTuple(a, b, c)
    -- Guard nil global
    local minval = minsubs or a or 999999
    if b and b < minval then
        minval = b
    end
    if c and c < minval then
        minval = c
    end
    minsubs = minval
    return minval
end

function std_maxTuple(a, b, c)
    -- Guard nil global
    local maxval = maxsubs or a or 0
    if b and b > maxval then
        maxval = b
    end
    if c and c > maxval then
        maxval = c
    end
    maxsubs = maxval
    return maxval
end

function CpuBuildSS_ProcessEachBuildShip()
    local bcount = BuildShipCount()
    if bcount == 0 then
        return 0
    end
    
    if s_totalProdSS == 0 then
        return 0
    end
    
    aitrace("NumSS:Fi:" .. s_numFiSystems .. " Co:" .. s_numCoSystems .. " Fr:" .. s_numFrSystems)
    
    local currentFiDemand = SubSystemDemandGet(FIGHTERPRODUCTION)
    local currentCoDemand = SubSystemDemandGet(CORVETTEPRODUCTION)
    local currentFrDemand = SubSystemDemandGet(FRIGATEPRODUCTION)
    
    local maxRealDemand = std_maxTuple(currentFiDemand, currentCoDemand, currentFrDemand)
    local highestPrioritySSOverall = HighestPrioritySubSystem()
    
    aitrace("SS:Fi:" .. currentFiDemand .. " Co:" .. currentCoDemand .. " Fr:" .. currentFrDemand)
    
    local minNumSameSubs = std_minTuple(s_numFiSystems, s_numCoSystems, s_numFrSystems)
    
    local bestProdSS = FIGHTERPRODUCTION
    -- Initialize maxDemand from fighter demand (first comparison base)
    local fiBuildOffset = fiBuildOffset or 0
    local coBuildOffset = coBuildOffset or 0
    local frBuildOffset = frBuildOffset or 0
    local maxDemand = (currentFiDemand or 0) - fiBuildOffset
    aitrace("Maxdemand:" .. maxDemand .. " MaxReal:" .. maxRealDemand)
    
    if (currentCoDemand - coBuildOffset) > maxDemand then
        maxDemand = (currentCoDemand - coBuildOffset)
        bestProdSS = CORVETTEPRODUCTION
    end
    
    if (currentFrDemand - frBuildOffset) > maxDemand then
        maxDemand = (currentFrDemand - frBuildOffset)
        bestProdSS = FRIGATEPRODUCTION
    end
    
    local economicValue = 0
    local numCollecting = GetNumCollecting()
    local numRU = GetRU()
    
    if UnderAttack() == 0 or UnderAttackThreat() < -100 then
        if numRU > (2000 + bcount * 800) and numCollecting > 6 then
            economicValue = 2
        elseif numRU > (800 + bcount * 400) and numCollecting > 4 then
            economicValue = 1
        end
    end
    
    for i = 0, (bcount - 1), 1 do
        local buildShipId = BuildShipAt(i)
        
        -- SLIPSTREAM: Build hyperspace on Battlecruisers (key feature)
        if sg_buildBCHyperspace == 1 then
            local shipType = BuildShipType(buildShipId)
            -- Check if this is a battlecruiser or heavy battlecruiser
            if shipType == kBattleCruiser or shipType == kHeavyBattleCruiser then
                aitrace("BC:SS")
                if BuildShipHasSubSystem(buildShipId, HYPERSPACE) == 0 and UnderAttackThreat() < -5 then
                    if BuildShipCanBuild(buildShipId, HYPERSPACE) == 1 then
                        aitrace("Build BC Hyperspace")
                        BuildSubSystemOnShip(buildShipId, HYPERSPACE)
                        return 1
                    end
                end
                
                -- SLIPSTREAM: Also try to build production facilities on Heavy BCs
                if shipType == kHeavyBattleCruiser then
                    if BuildShipHasSubSystem(buildShipId, FIGHTERPRODUCTION) == 0 then
                        if currentFiDemand > 0 and BuildShipCanBuild(buildShipId, FIGHTERPRODUCTION) == 1 then
                            aitrace("Build HBC Fighter Production")
                            BuildSubSystemOnShip(buildShipId, FIGHTERPRODUCTION)
                            return 1
                        end
                    end
                    if BuildShipHasSubSystem(buildShipId, CORVETTEPRODUCTION) == 0 then
                        if currentCoDemand > 0 and BuildShipCanBuild(buildShipId, CORVETTEPRODUCTION) == 1 then
                            aitrace("Build HBC Corvette Production")
                            BuildSubSystemOnShip(buildShipId, CORVETTEPRODUCTION)
                            return 1
                        end
                    end
                end
            end
        end
        
        if highestPrioritySSOverall <= maxRealDemand and maxRealDemand >= 0 then
            local hasFi = BuildShipHasSubSystem(buildShipId, FIGHTERPRODUCTION)
            local hasCo = BuildShipHasSubSystem(buildShipId, CORVETTEPRODUCTION)
            local hasFr = BuildShipHasSubSystem(buildShipId, FRIGATEPRODUCTION)
            
            local allowBuild = 0
            
            -- Calculate sscount as total production subsystems on this ship
            local sscount = (hasFi or 0) + (hasCo or 0) + (hasFr or 0)
            
            if sscount > 0 then
                if sscount == 1 and economicValue > 0 then
                    allowBuild = 1
                    aitrace("Scount" .. sscount .. " Econ:" .. economicValue)
                elseif sscount == 2 and economicValue > 1 then
                    allowBuild = 1
                    aitrace("Scount" .. sscount .. " Econ:" .. economicValue)
                else
                    local maxDemandOnShip = -1
                    if hasFi == 1 and currentFiDemand > maxDemandOnShip then
                        maxDemandOnShip = currentFiDemand
                    end
                    if hasCo == 1 and currentCoDemand > maxDemandOnShip then
                        maxDemandOnShip = currentCoDemand
                    end
                    if hasFr == 1 and currentFrDemand > maxDemandOnShip then
                        maxDemandOnShip = currentFrDemand
                    end
                    
                    if maxDemandOnShip < 0 then
                        allowBuild = 1
                    end
                    
                    aitrace("S" .. i .. " FiD:" .. currentFiDemand .. " CoD:" .. currentCoDemand .. " FrD:" .. currentFrDemand)
                    aitrace("S" .. i .. " Max:" .. maxDemandOnShip)
                end
            else
                allowBuild = 1
            end
            
            if allowBuild == 1 then
                if BuildShipCanBuild(buildShipId, bestProdSS) == 1 then
                    aitrace("BuildSS in new func")
                    BuildSubSystemOnShip(buildShipId, bestProdSS)
                    return 1
                end
            end
        end
    end
    
    SubSystemDemandSet(FIGHTERPRODUCTION, -1)
    SubSystemDemandSet(CORVETTEPRODUCTION, -1)
    SubSystemDemandSet(FRIGATEPRODUCTION, -1)
    return 0
end

function CpuBuildSS_DoBuildSubSystem()
    SubSystemDemandClear()
    
    if Override_SubSystemDemand then
        Override_SubSystemDemand()
    else
        CpuBuildSS_DefaultSubSystemDemandRules()
    end
    
    local subSystemId = FindHighDemandSubSystem()
    sg_subSystemOverflowDemand = 0
    
    if s_race == Race_Vaygr then
        CpuBuildSS_RetireVaygrProductionSubSystems()
    end
    
    if subSystemId > 0 then
        if CpuBuildSS_ProcessEachBuildShip() == 1 then
            return 1
        end
        
        subSystemId = FindHighDemandSubSystem()
        if subSystemId > 0 then
            BuildSubSystem(subSystemId)
        end
        
        return 1
    end
    
    return 0
end

function CpuBuildSS_DoSubSystemProductionDemand(ProductionSubSys, eClasstype, familyid)
    local demand = ShipDemandMaxByClass(eClasstype)
    local uc = GetUnitCapForFamily(familyid)
    local ucMax = GetUnitCapMaxForFamily(familyid)
    
    -- Guard nil global (ucLeft set by GetUnitCapForFamily)
    local unitCapLeft = ucLeft or 0
    if unitCapLeft < 2 then
        demand = ((demand - 3) + unitCapLeft)
    end
    
    if demand < 0 then
        demand = -0.5
    end
    
    SubSystemDemandSet(ProductionSubSys, demand)
end

function CpuBuildSS_OtherMiscSubSystemDemand()
    local demand = ShipDemandMaxByClass(eBuilder)
    local capdemand = ShipDemandMaxByClass(eCapital)
    
    if capdemand > demand then
        demand = capdemand
    end
    
    if demand > 0.25 then
        SubSystemDemandSet(CAPSHIPPRODUCTION, (demand - 0.25))
    end
    
    -- Platform production
    if s_militaryStrength < -50 or g_LOD < 1 or GetRU() > 3000 then
        NumSubSystemsQ(PLATFORMPRODUCTION)
        demand = ShipDemandMaxByClass(ePlatform)
        -- Guard nil global from NumSubSystemsQ
        local platCount = platformsubsCount or 0
        if demand > 0.25 then
            SubSystemDemandSet(PLATFORMPRODUCTION, ((demand - 0.5) - platCount))
        end
    end
    
    -- Hyperspace module priority
    local numShipyards = NumSquadrons(kShipYard)
    if numShipyards == 0 then
        local SY_demand = ShipDemandGet(kShipYard)
        if SY_demand > 0 and NumSubSystemsQ(HYPERSPACE) == 0 then
            NumSubSystems(HYPERSPACE)
            local hypDemand = SY_demand + 1
            SubSystemDemandAdd(HYPERSPACE, hypDemand)
        end
    end
end

function DoSubSystemDemand_Hiigaran()
    CpuBuildSS_DoSubSystemProductionDemand(FIGHTERPRODUCTION, eFighter, kUnitCapId_Fighter)
    
    NumSubSystemsQ(RESEARCH)
    local highestCorvetteDemand = ShipDemandMaxByClass(eCorvette)
    local highestFrigateDemand = ShipDemandMaxByClass(eFrigate)
    local capdemand = ShipDemandMaxByClass(eCapital)
    
    -- Guard nil globals from NumSubSystemsQ
    local resDemand = researchdemand or 0
    if highestFrigateDemand > resDemand then
        resDemand = highestFrigateDemand
    elseif capdemand > resDemand then
        resDemand = capdemand
    end
    researchdemand = resDemand
    
    local resCount = researchcount or 0
    if resCount == 0 then
        SubSystemDemandSet(RESEARCH, (researchdemand + 0.5))
    else
        CpuBuildSS_DoSubSystemProductionDemand(CORVETTEPRODUCTION, eCorvette, kUnitCapId_Corvette)
        CpuBuildSS_DoSubSystemProductionDemand(FRIGATEPRODUCTION, eFrigate, kUnitCapId_Frigate)
        
        NumSubSystemsQ(ADVANCEDRESEARCH)
        local doAdvResearch = 0
        
        if s_numFrSystems > 0 then
            researchdemand = (researchdemand + 0.5)
        end
        
        -- SLIPSTREAM: Earlier advanced research
        if advresearchcount == 0 and researchdemand >= 0.25 and UnderAttackThreat() < -5 then
            if s_militaryPop > 5 or s_selfTotalValue > 100 or s_militaryStrength > 25 then
                SubSystemDemandSet(ADVANCEDRESEARCH, (researchdemand - 0.25))
            end
        end
    end
    
    CpuBuildSS_OtherMiscSubSystemDemand()
    
    -- Guard nil globals
    if (researchcount or 0) > 0 and (s_totalProdSS or 0) > 0 and (s_militaryPop or 0) > 5 and GetNumCollecting() > 4 and GetRU() > 500 then
        CpuBuildSS_SpecialSubSystemDemand()
    end
end

function DoSubSystemDemand_Vaygr()
    CpuBuildSS_DoSubSystemProductionDemand(FIGHTERPRODUCTION, eFighter, kUnitCapId_Fighter)
    
    NumSubSystemsQ(RESEARCH)
    local highestCorvetteDemand = ShipDemandMaxByClass(eCorvette)
    local highestFrigateDemand = ShipDemandMaxByClass(eFrigate)
    local capdemand = ShipDemandMaxByClass(eCapital)
    
    if researchcount == 0 then
        if highestFrigateDemand > researchdemand then
            researchdemand = highestFrigateDemand
        elseif capdemand > researchdemand then
            researchdemand = capdemand
        end
        
        SubSystemDemandSet(RESEARCH, (researchdemand + 1))
    end
    
    if IsResearchDone(CORVETTETECH) == 1 then
        CpuBuildSS_DoSubSystemProductionDemand(CORVETTEPRODUCTION, eCorvette, kUnitCapId_Corvette)
    end
    
    if IsResearchDone(FRIGATETECH) == 1 then
        CpuBuildSS_DoSubSystemProductionDemand(FRIGATEPRODUCTION, eFrigate, kUnitCapId_Frigate)
    end
    
    CpuBuildSS_OtherMiscSubSystemDemand()
    
    -- Guard nil globals
    if (researchcount or 0) > 0 and (s_totalProdSS or 0) > 0 and (s_militaryPop or 0) > 5 and GetNumCollecting() > 4 and GetRU() > 500 then
        CpuBuildSS_SpecialSubSystemDemand()
    end
end
