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

    sg_lastRefitTime = -9999
    sg_refitCooldown = 60
end

-- Decide which turret bias to fit on capitals based on the chosen enemy's fleet.
-- "antistrike" when the enemy leans fighters/corvettes; "anticap" when it leans
-- frigates/capitals; "balanced" when mixed or the enemy is unknown.
function CpuLoadout_Mode()
    local e = s_enemyIndex
    if e == -1 then
        return "balanced"
    end
    local strike = PlayersMilitary_Fighter(e, player_max) + PlayersMilitary_Corvette(e, player_max)
    local heavy = PlayersMilitary_Frigate(e, player_max)
        + (PlayersUnitTypeCount(e, player_max, eBattleCruiser) or 0) * 80
        + (PlayersUnitTypeCount(e, player_max, eHeavyBattleCruiser) or 0) * 120
    if strike > (heavy * 1.6) and strike > 20 then
        return "antistrike"
    end
    if heavy > (strike * 1.6) and heavy > 20 then
        return "anticap"
    end
    return "balanced"
end

-- Desired turret list for a capital, given its type and the loadout mode.
-- Turret constants are the same ones the prior fixed loadout used; they resolve
-- at call time (the .subs are loaded by then). Returns NIL for non-capitals.
function CpuLoadout_DesiredTurrets(shipType, mode)
    if s_race == Race_Hiigaran then
        if shipType == kBattleCruiser then
            if mode == "anticap" then
                return { BCIONBEAMTURRET1, BCPLASMABURSTTURRET1 }
            elseif mode == "antistrike" then
                return { BCGATLINGGUNTURRET1, BCPLASMABURSTTURRET1 }
            else
                return { BCIONBEAMTURRET1, BCGATLINGGUNTURRET1 }
            end
        elseif shipType == kDestroyer then
            if mode == "anticap" then
                return { DDPLASMABURSTTURRET1 }
            elseif mode == "antistrike" then
                return { DDGATLINGGUNTURRET1, DDPLASMABURSTTURRET1 }
            else
                return { DDPLASMABURSTTURRET1, DDGATLINGGUNTURRET1 }
            end
        end
    else
        if shipType == kBattleCruiser then
            -- Single missile-battery slot; one anti-capital option.
            return { BCHEAVYFUSIONMISSILE }
        elseif shipType == kDestroyer then
            if mode == "anticap" then
                return { DDPULSECANNONTURRET1 }
            elseif mode == "antistrike" then
                return { DDSCATTERSHOTTURRET1, DDPULSECANNONTURRET1 }
            else
                return { DDPULSECANNONTURRET1, DDSCATTERSHOTTURRET1 }
            end
        end
    end
    return NIL
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

-- Pick the next desired turret missing from a capital's slots, chosen by the
-- current loadout mode (which counters the enemy's fleet composition). Returns a
-- subsystem constant (engine constant = UPPERCASE of the .subs typeString) or 0.
function CpuBuildSS_NextMissingTurret(buildShipId)
    local shipType = BuildShipType(buildShipId)
    local turrets = CpuLoadout_DesiredTurrets(shipType, CpuLoadout_Mode())
    if turrets == NIL then
        return 0
    end

    for i, t in turrets do
        if t and BuildShipHasSubSystem(buildShipId, t) == 0 and BuildShipCanBuild(buildShipId, t) == 1 then
            return t
        end
    end

    return 0
end

-- If a capital carries a turret that isn't in the desired list for a decisive
-- mode, retire one such turret (next pass re-arms correctly). Cooldown-gated to
-- prevent churn. Returns 1 if a turret was retired.
function CpuBuildSS_RefitMismatchedTurret(buildShipId, desiredList)
    if desiredList == NIL then
        return 0
    end
    local now = gameTime()
    if (now - (sg_lastRefitTime or -9999)) < (sg_refitCooldown or 60) then
        return 0
    end

    -- All turret constants a TPOF capital could carry (both races, both types).
    local allTurrets = {
        BCIONBEAMTURRET1, BCGATLINGGUNTURRET1, BCPLASMABURSTTURRET1, BCHEAVYFUSIONMISSILE,
        DDPLASMABURSTTURRET1, DDGATLINGGUNTURRET1, DDPULSECANNONTURRET1, DDSCATTERSHOTTURRET1,
    }
    for i, t in allTurrets do
        if t and BuildShipHasSubSystem(buildShipId, t) == 1 then
            local wanted = 0
            for j, d in desiredList do
                if d == t then
                    wanted = 1
                end
            end
            if wanted == 0 then
                aitrace("Loadout refit: retire mismatched turret")
                RetireSubSystem(buildShipId, t)
                sg_lastRefitTime = now
                return 1
            end
        end
    end
    return 0
end

-- Walk the build-ship list and fit one missing desired turret onto a
-- battlecruiser or destroyer; if none is missing, consider one mismatch refit so
-- the loadout tracks the enemy's composition. Kept independent of
-- production-subsystem demand and the s_totalProdSS gate in
-- CpuBuildSS_ProcessEachBuildShip, so a freshly built warship gets armed even
-- before the AI has any production modules. Returns 1 if work was queued.
function CpuBuildSS_ArmCapitalShips()
    local bcount = BuildShipCount()
    if bcount == 0 then
        return 0
    end

    local mode = CpuLoadout_Mode()

    for i = 0, (bcount - 1), 1 do
        local buildShipId = BuildShipAt(i)
        local armTurret = CpuBuildSS_NextMissingTurret(buildShipId)
        if armTurret ~= 0 then
            aitrace("Arm capital: build turret (mode " .. mode .. ")")
            BuildSubSystemOnShip(buildShipId, armTurret)
            return 1
        end
    end

    -- Nothing missing to add: consider one mismatch refit (cooldown-gated, and
    -- only when the mode is decisive so we don't thrash on a balanced enemy).
    for i = 0, (bcount - 1), 1 do
        local buildShipId = BuildShipAt(i)
        local shipType = BuildShipType(buildShipId)
        local desired = CpuLoadout_DesiredTurrets(shipType, mode)
        if (mode == "antistrike" or mode == "anticap") and desired ~= NIL then
            if CpuBuildSS_RefitMismatchedTurret(buildShipId, desired) == 1 then
                return 1
            end
        end
    end

    return 0
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
    -- Arm new battlecruisers/destroyers first, before any production-demand
    -- gating, so their empty weapon hardpoints get filled promptly.
    if CpuBuildSS_ArmCapitalShips() == 1 then
        return 1
    end

    -- Production-module demand machinery removed. The entire path below
    -- (CpuBuildSS_DefaultSubSystemDemandRules -> DoSubSystemDemand_*,
    -- CpuBuildSS_ProcessEachBuildShip, CpuBuildSS_SpecialSubSystemDemand) is built
    -- on the production-FAMILY subsystem constants
    -- (FIGHTERPRODUCTION/CORVETTEPRODUCTION/FRIGATEPRODUCTION). Those are restricted
    -- build options in TPOF, so passing them to SubSystemDemandSet/Get/NumSubSystems
    -- raises an engine "parameter:" error that aborts the AI tick. Production
    -- modules cannot be built here anyway, so the AI focuses on arming capitals
    -- (handled above). The production-demand helpers remain defined below but are
    -- intentionally unreachable.
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
        -- NumSubSystemsQ(PLATFORMPRODUCTION) removed: NumSubSystemsQ on a
        -- production-family constant raises an engine error (see default.lua).
        -- platCount falls back to 0 via the guard below.
        demand = ShipDemandMaxByClass(ePlatform)
        local platCount = platformsubsCount or 0
        if demand > 0.25 then
            SubSystemDemandSet(PLATFORMPRODUCTION, ((demand - 0.5) - platCount))
        end
    end
    
    -- Hyperspace-module-on-shipyard demand removed: the Shipyard is restricted in
    -- TPOF (restrict.lua), so NumSquadrons(kShipYard)/ShipDemandGet(kShipYard)
    -- raise an engine "parameter:" error. Hyperspace modules are still fitted to
    -- battlecruisers via CpuBuildSS_ProcessEachBuildShip and the special-subsystem
    -- demand path.
end

function DoSubSystemDemand_Hiigaran()
    -- TPOF restricts all research / advanced-research modules, so the old
    -- RESEARCH-module gating (which withheld corvette/frigate production until a
    -- research module existed, and that module can never be built) permanently
    -- limited the AI to fighter production. Demand all three production classes
    -- directly instead.
    CpuBuildSS_DoSubSystemProductionDemand(FIGHTERPRODUCTION, eFighter, kUnitCapId_Fighter)
    CpuBuildSS_DoSubSystemProductionDemand(CORVETTEPRODUCTION, eCorvette, kUnitCapId_Corvette)
    CpuBuildSS_DoSubSystemProductionDemand(FRIGATEPRODUCTION, eFrigate, kUnitCapId_Frigate)

    CpuBuildSS_OtherMiscSubSystemDemand()

    -- Guard nil globals
    if (s_totalProdSS or 0) > 0 and (s_militaryPop or 0) > 5 and GetNumCollecting() > 4 and GetRU() > 500 then
        CpuBuildSS_SpecialSubSystemDemand()
    end
end

function DoSubSystemDemand_Vaygr()
    -- TPOF restricts CorvetteTech / FrigateTech and all research modules, so the
    -- old IsResearchDone() gates here permanently blocked Vaygr corvette/frigate
    -- production (those techs can never complete). Demand all three production
    -- classes directly instead.
    CpuBuildSS_DoSubSystemProductionDemand(FIGHTERPRODUCTION, eFighter, kUnitCapId_Fighter)
    CpuBuildSS_DoSubSystemProductionDemand(CORVETTEPRODUCTION, eCorvette, kUnitCapId_Corvette)
    CpuBuildSS_DoSubSystemProductionDemand(FRIGATEPRODUCTION, eFrigate, kUnitCapId_Frigate)

    CpuBuildSS_OtherMiscSubSystemDemand()

    -- Guard nil globals
    if (s_totalProdSS or 0) > 0 and (s_militaryPop or 0) > 5 and GetNumCollecting() > 4 and GetRU() > 500 then
        CpuBuildSS_SpecialSubSystemDemand()
    end
end
