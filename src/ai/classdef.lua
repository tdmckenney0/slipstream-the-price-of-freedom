-- Slipstream: The Price of Freedom - AI Class Definitions
-- Enhanced for Heavy Battlecruisers, SRI Ships, and fast-paced tactical gameplay

aitrace("CPU: SLIPSTREAM CLASSDEF LOADED")

squadclass = {}

-- Motherships
squadclass[eMotherShip] = { 
    HGN_MOTHERSHIP, VGR_MOTHERSHIP, VGR_MOTHERSHIP_MAKAAN, 
}

-- Resource Collectors
squadclass[eCollector] = { 
    HGN_RESOURCECOLLECTOR, VGR_RESOURCECOLLECTOR, 
}

-- Scouts and Probes
squadclass[eScout] = { 
    HGN_SCOUT, HGN_PROBE, HGN_PROXIMITYSENSOR, HGN_ECMPROBE, 
    VGR_SCOUT, VGR_PROBE, VGR_PROBE_PROX, VGR_PROBE_ECM, 
}

-- Resource Controllers (Refineries)
squadclass[eRefinery] = { 
    HGN_RESOURCECONTROLLER, VGR_RESOURCECONTROLLER, 
}

-- Builder Ships - SLIPSTREAM: Includes Battlecruisers that can build fighters/corvettes
squadclass[eBuilder] = { 
    HGN_MOTHERSHIP, HGN_CARRIER, HGN_SHIPYARD, HGN_BATTLECRUISER, HGN_HEAVYBATTLECRUISER,
    VGR_MOTHERSHIP, VGR_MOTHERSHIP_MAKAAN, VGR_CARRIER, VGR_SHIPYARD, VGR_BATTLECRUISER, VGR_HEAVYBATTLECRUISER,
}

-- Drop-off Points for Resources
squadclass[eDropOff] = { 
    HGN_MOTHERSHIP, HGN_CARRIER, HGN_SHIPYARD, HGN_RESOURCECONTROLLER, 
    VGR_MOTHERSHIP, VGR_MOTHERSHIP_MAKAAN, VGR_CARRIER, VGR_SHIPYARD, VGR_RESOURCECONTROLLER, 
}

-- Salvage Drop-off Points
squadclass[eSalvageDropOff] = { 
    HGN_MOTHERSHIP, HGN_CARRIER, HGN_SHIPYARD, 
    VGR_MOTHERSHIP, VGR_MOTHERSHIP_MAKAAN, VGR_CARRIER, VGR_SHIPYARD, 
}

-- Fighters
squadclass[eFighter] = { 
    HGN_INTERCEPTOR, HGN_ATTACKBOMBER, HGN_ATTACKBOMBERELITE, 
    VGR_INTERCEPTOR, VGR_BOMBER, VGR_LANCEFIGHTER, 
}

-- Corvettes
squadclass[eCorvette] = { 
    HGN_ASSAULTCORVETTE, HGN_PULSARCORVETTE, HGN_MINELAYERCORVETTE, 
    VGR_MISSILECORVETTE, VGR_LASERCORVETTE, VGR_MINELAYERCORVETTE, VGR_COMMANDCORVETTE, 
}

-- Frigates
squadclass[eFrigate] = { 
    HGN_ASSAULTFRIGATE, HGN_DEFENSEFIELDFRIGATE, HGN_IONCANNONFRIGATE, 
    HGN_MARINEFRIGATE, HGN_MARINEFRIGATE_SOBAN, HGN_TORPEDOFRIGATE, HGN_TORPEDOFRIGATEELITE, 
    VGR_ASSAULTFRIGATE, VGR_HEAVYMISSILEFRIGATE, VGR_INFILTRATORFRIGATE, 
}

-- Capture Ships
squadclass[eCapture] = { 
    HGN_MARINEFRIGATE, HGN_MARINEFRIGATE_SOBAN, VGR_INFILTRATORFRIGATE, 
}

-- Shield Ships
squadclass[eShield] = { 
    HGN_DEFENSEFIELDFRIGATE, 
}

-- Platforms - SLIPSTREAM: Platforms are mobile and can be hyperspace deployed
squadclass[ePlatform] = { 
    HGN_GUNTURRET, HGN_IONTURRET, 
    VGR_WEAPONPLATFORM_GUN, VGR_WEAPONPLATFORM_MISSILE, VGR_HYPERSPACE_PLATFORM, 
}

-- Anti-Fighter Units
squadclass[eAntiFighter] = { 
    HGN_INTERCEPTOR, HGN_ASSAULTCORVETTE, HGN_ASSAULTFRIGATE, HGN_GUNTURRET, 
    VGR_INTERCEPTOR, VGR_ASSAULTFRIGATE, VGR_WEAPONPLATFORM_GUN, 
}

-- Anti-Corvette Units
squadclass[eAntiCorvette] = { 
    HGN_PULSARCORVETTE, HGN_TORPEDOFRIGATE, HGN_TORPEDOFRIGATEELITE, HGN_DESTROYER, 
    VGR_LANCEFIGHTER, VGR_LASERCORVETTE, VGR_DESTROYER, 
}

-- Anti-Frigate/Capital Units - SLIPSTREAM: Includes all Heavy Battlecruisers and SRI ships
squadclass[eAntiFrigate] = { 
    HGN_IONTURRET, HGN_ATTACKBOMBER, HGN_ATTACKBOMBERELITE, HGN_IONCANNONFRIGATE, 
    HGN_MARINEFRIGATE, HGN_MARINEFRIGATE_SOBAN, HGN_DEFENSEFIELDFRIGATE, 
    HGN_DESTROYER, HGN_BATTLECRUISER, HGN_HEAVYBATTLECRUISER,
    VGR_BOMBER, VGR_HEAVYMISSILEFRIGATE, VGR_INFILTRATORFRIGATE, 
    VGR_DESTROYER, VGR_BATTLECRUISER, VGR_HEAVYBATTLECRUISER, VGR_WEAPONPLATFORM_MISSILE,
    SRI_DREADNAUGHT, SRI_SAJUUK,
}

-- Capital Ships - SLIPSTREAM: Heavy Battlecruisers are the workhorse capital ships
squadclass[eCapital] = { 
    HGN_CARRIER, HGN_MOTHERSHIP, HGN_SHIPYARD, HGN_DESTROYER, 
    HGN_BATTLECRUISER, HGN_HEAVYBATTLECRUISER, HGN_DREADNAUGHT,
    VGR_CARRIER, VGR_MOTHERSHIP, VGR_MOTHERSHIP_MAKAAN, VGR_SHIPYARD, 
    VGR_DESTROYER, VGR_BATTLECRUISER, VGR_HEAVYBATTLECRUISER,
    SRI_DREADNAUGHT, SRI_SAJUUK,
}

-- Non-Threat Units (for targeting priority)
squadclass[eNonThreat] = { 
    HGN_RESOURCECOLLECTOR, VGR_RESOURCECOLLECTOR, 
    HGN_RESOURCECONTROLLER, VGR_RESOURCECONTROLLER, 
    HGN_CARRIER, HGN_MOTHERSHIP, HGN_SHIPYARD, 
    VGR_CARRIER, VGR_MOTHERSHIP, VGR_MOTHERSHIP_MAKAAN, VGR_SHIPYARD, 
    HGN_SCOUT, HGN_PROBE, HGN_PROXIMITYSENSOR, HGN_ECMPROBE, 
    VGR_SCOUT, VGR_PROBE, VGR_PROBE_PROX, VGR_PROBE_ECM, VGR_HYPERSPACE_PLATFORM, 
}

-- Hyperspace Gates
squadclass[eHyperspaceGate] = { 
    VGR_HYPERSPACE_PLATFORM, 
}

-- Subsystem Attackers (Bombers)
squadclass[eSubSystemAttackers] = { 
    HGN_ATTACKBOMBER, HGN_ATTACKBOMBERELITE, VGR_BOMBER, 
}

-- Non-Critical Subsystems
squadclass[eNonCriticalSubSys] = { 
    CLOAKGENERATOR, FIRECONTROLTOWER, HYPERSPACEINHIBITOR, ADVANCEDARRAY, CLOAKSENSOR, 
}

-- Good Repair Attackers - SLIPSTREAM: Includes all Heavy Battlecruisers and SRI ships
squadclass[eGoodRepairAttackers] = { 
    HGN_INTERCEPTOR, HGN_ASSAULTFRIGATE, HGN_IONCANNONFRIGATE, 
    HGN_DESTROYER, HGN_BATTLECRUISER, HGN_HEAVYBATTLECRUISER,
    VGR_INTERCEPTOR, VGR_MISSILECORVETTE, VGR_ASSAULTFRIGATE, 
    VGR_DESTROYER, VGR_BATTLECRUISER, VGR_HEAVYBATTLECRUISER,
    SRI_DREADNAUGHT, SRI_SAJUUK,
}

-- Extended Classes for AI
eUselessShips = eMaxCount
eBattleCruiser = (eMaxCount + 1)
eHeavyBattleCruiser = (eMaxCount + 2)
eDreadnaught = (eMaxCount + 3)
sg_maxClasses = (eDreadnaught + 1)

-- Useless Ships (low priority to build)
squadclass[eUselessShips] = { 
    HGN_MINELAYERCORVETTE, VGR_MINELAYERCORVETTE, VGR_COMMANDCORVETTE, 
}

-- Battlecruisers - Standard
squadclass[eBattleCruiser] = { 
    HGN_BATTLECRUISER, VGR_BATTLECRUISER, 
}

-- Heavy Battlecruisers - SLIPSTREAM: The main combat capital ships
squadclass[eHeavyBattleCruiser] = { 
    HGN_HEAVYBATTLECRUISER, VGR_HEAVYBATTLECRUISER, 
}

-- Dreadnaughts - SLIPSTREAM: Super-heavy capital ships (SRI special units)
squadclass[eDreadnaught] = { 
    HGN_DREADNAUGHT, SRI_DREADNAUGHT, SRI_SAJUUK, 
}

-- Utility function to add ships to classes
function FastAddToClass(tbl, classid)
    for a, b in tbl do
        AddToClass(b, classid)
    end
end

-- Initialize all class definitions
function ClassInitialize()
    for i = 0, sg_maxClasses, 1 do
        if squadclass[i] then
            FastAddToClass(squadclass[i], i)
        end
    end
    
    -- Register class names for debugging
    AddClassName(eMotherShip, "Motherships")
    AddClassName(eCollector, "Collectors")
    AddClassName(eDropOff, "DropOffs")
    AddClassName(eFighter, "Fighters")
    AddClassName(eFrigate, "Frigates")
    AddClassName(eCorvette, "Corvettes")
    AddClassName(eCapital, "Capital")
    AddClassName(eAntiFighter, "AntiFighter")
    AddClassName(eAntiCorvette, "AntiCorvette")
    AddClassName(eAntiFrigate, "AntiFrigate")
    AddClassName(ePlatform, "Platform")
    AddClassName(eRefinery, "Refinery")
    AddClassName(eHyperspaceGate, "HypGates")
    AddClassName(eShield, "Shields")
    AddClassName(eCapture, "Capture")
    AddClassName(eSubSystemAttackers, "SubSysKillas")
    AddClassName(eBattleCruiser, "BattleCruiser")
    AddClassName(eHeavyBattleCruiser, "HeavyBattleCruiser")
    AddClassName(eDreadnaught, "Dreadnaught")
end
