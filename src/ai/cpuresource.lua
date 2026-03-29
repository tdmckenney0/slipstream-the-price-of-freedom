-- Slipstream: The Price of Freedom - Resource Management
-- Optimized for faster combat with less emphasis on economy

aitrace("LOADING SLIPSTREAM CPU RESOURCING")

function CpuResource_Init()
    -- SLIPSTREAM: Lower collector targets for faster military focus
    cpResourcersPerPath = 3
    cpNumCollectorsPerLatchPoint = 1.5
    cpMaxThreatAddedDistance = 6000
    cpMinThreatAddedDistance = 12000
    
    SetResourceDockFamily("Utility")
    
    -- SLIPSTREAM: Reduced collector counts for faster military transition
    -- Stock: min=5, max=30
    -- Slipstream: min=3, max=15
    sg_minNumCollectors = 3
    sg_maxNumCollectors = 15
    
    if Override_ResourceInit then
        Override_ResourceInit()
    end
end

function CalcDesiredNumCollectors()
    -- SLIPSTREAM: Lower base collectors, faster military transition
    local baseCollectors = 5
    local collectorsToMilitary = 0.5
    local gametime = gameTime()
    
    if g_LOD == 0 then
        baseCollectors = 2
        collectorsToMilitary = 0.4
    elseif g_LOD == 1 then
        baseCollectors = 4
        collectorsToMilitary = 0.5
    elseif g_LOD >= 2 then
        baseCollectors = 5
        collectorsToMilitary = 0.6
    end
    
    -- SLIPSTREAM: Force military focus after time threshold
    -- Reduce collector desire as game progresses
    if gametime > 180 then  -- After 3 minutes
        baseCollectors = baseCollectors - 1
    end
    if gametime > 300 then  -- After 5 minutes
        baseCollectors = baseCollectors - 1
    end
    if gametime > 480 then  -- After 8 minutes
        baseCollectors = 2  -- Minimum collectors, focus on military
    end
    
    if baseCollectors < 2 then
        baseCollectors = 2
    end
    
    -- Initialize maxCollectorsForMilitary if nil
    if not maxCollectorsForMilitary then
        maxCollectorsForMilitary = 8
    end
    
    if s_militaryPop > 0 then
        maxCollectorsForMilitary = (8 + s_militaryPop * collectorsToMilitary)
    else
        maxCollectorsForMilitary = 8
    end
    
    sg_desiredNumCollectors = (GetActiveCollectorSlots() * cpNumCollectorsPerLatchPoint + 1)
    
    local numRU = GetRU()
    -- SLIPSTREAM: More aggressive collector reduction when we have RUs
    if numRU > 300 then
        sg_desiredNumCollectors = (sg_desiredNumCollectors - (numRU - 300) / 500)
    end
    
    -- SLIPSTREAM: Hard cap at 10 collectors - focus on military
    if sg_desiredNumCollectors > 10 then
        sg_desiredNumCollectors = 10
    end
    
    if sg_desiredNumCollectors < baseCollectors then
        sg_desiredNumCollectors = baseCollectors
    end
    
    if sg_desiredNumCollectors >= maxCollectorsForMilitary then
        sg_desiredNumCollectors = maxCollectorsForMilitary
    end
    
    -- Military build priority based on collectors
    local collectorsInSystem = numQueueOfClass(eCollector) or 0
    if collectorsInSystem > 8 then
        sg_militaryToBuildPerCollector = 6
    elseif collectorsInSystem > 6 then
        sg_militaryToBuildPerCollector = 5
    elseif collectorsInSystem > 4 then
        sg_militaryToBuildPerCollector = 4
    elseif collectorsInSystem > 3 then
        sg_militaryToBuildPerCollector = 3
    else
        sg_militaryToBuildPerCollector = 2  -- Always build some military
    end
    
    -- SLIPSTREAM: Increase military priority as game progresses
    if gametime > 240 then
        sg_militaryToBuildPerCollector = sg_militaryToBuildPerCollector + 2
    end
    
    -- Reduce collector priority when under attack
    local threatLevel = UnderAttackThreat()
    if threatLevel > 0 then
        if numRU > 500 then
            sg_desiredNumCollectors = 0
        else
            sg_militaryToBuildPerCollector = (sg_militaryToBuildPerCollector + (threatLevel / 30 + 2))
        end
    end
    
    if sg_desiredNumCollectors > sg_maxNumCollectors then
        sg_desiredNumCollectors = sg_maxNumCollectors
    end
end

function DoResourceBuild()
    CalcDesiredNumCollectors()
    
    local numCollectors = numQueueOfClass(eCollector)
    if numCollectors < sg_desiredNumCollectors and CanBuild(kCollector) == 1 then
        aitrace("Build collector: desired:" .. sg_desiredNumCollectors .. " count:" .. numCollectors)
        Build(kCollector)
        return 1
    end
    
    -- Check if we need refineries
    if GetNumberOfIdleRefineries() <= 0 then
        local numberOfActiveBlobs = GetActiveBlobCount()
        local neededRefineries = 0
        local neededSalvageDropOffs = 0
        
        for activeIndex = 0, (numberOfActiveBlobs - 1), 1 do
            local blobIndex = GetActiveBlobAt(activeIndex)
            local collectors = CollectorsAtBlob(blobIndex)
            local refineryCapacity = CollectorCapacityOfRefineriesAtBlob(blobIndex)
            
            if collectors > refineryCapacity then
                if IsSalvage(blobIndex) ~= 0 then
                    neededSalvageDropOffs = (neededSalvageDropOffs + 1)
                else
                    neededRefineries = (neededRefineries + 1)
                end
            end
        end
        
        -- Only build refineries when safe
        if UnderAttackThreat() > -75 then
            return 0
        end
        
        numActiveOfClass(s_playerIndex, eDropOff)
        if neededRefineries > 0 and numRefineriesQueued == 0 then
            ShipDemandAddByClass(eRefinery, neededRefineries)
        end
        
        numActiveOfClass(s_playerIndex, eSalvageDropOff)
        if neededSalvageDropOffs > 0 and numSalDropsQueued == 0 and UnderAttackThreat() < -75 then
            ShipDemandAddByClass(eSalvageDropOff, neededSalvageDropOffs)
        end
    end
    
    return 0
end
