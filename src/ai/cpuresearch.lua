-- Slipstream: The Price of Freedom - Research Logic
--
-- TPOF restricts the research *modules*, but a set of "basic" upgrades remain
-- always available: defined with RequiredSubSystems = "" and not listed in
-- scar/restrict.lua, so a player (and the AI) can research them with no research
-- module present. This module makes the AI pursue those upgrades, scaled by the
-- ships it actually fields, and only when it has SPARE economy -- so research
-- never starves ship production. Active on all difficulties, scaled by g_LOD.
--
-- NOTE: unlike stock HW2 AI, CpuResearch_Process() deliberately does NOT bail
-- out on NumResearchSubSystems() == 0. In TPOF that count is always 0 (modules
-- restricted), and the target upgrades need no module. See
-- docs/superpowers/specs/2026-05-25-ai-basic-research-design.md.

aitrace("LOADING SLIPSTREAM CPU RESEARCH")

function CpuResearch_Init()
    if s_race == Race_Hiigaran then
        dofilepath("data:ai/hiigaran_upgrades.lua")
        DoUpgradeDemand = DoUpgradeDemand_Hiigaran
    else
        dofilepath("data:ai/vaygr_upgrades.lua")
        DoUpgradeDemand = DoUpgradeDemand_Vaygr
    end

    sg_lastUpgradeTime = gameTime()

    -- Difficulty-scaled cadence between upgrade pushes (seconds). Hard upgrades
    -- aggressively; Easy only occasionally.
    if g_LOD >= 2 then
        sg_upgradeDelayTime = (45 + Rand(30))
    elseif g_LOD == 1 then
        sg_upgradeDelayTime = (90 + Rand(45))
    else
        sg_upgradeDelayTime = (150 + Rand(60))
    end

    -- Minimum collectors before any RU is diverted to research.
    sg_minNumCollectors = 3
    if g_LOD < 1 then
        sg_minNumCollectors = 5
    end

    if Override_ResearchInit then
        Override_ResearchInit()
    end
end

-- True only when an upgrade is currently researchable and not already done.
-- Chained upgrades fail IsResearchAvailable until their prerequisite completes,
-- so this naturally walks a chain one tier at a time.
function Util_CheckResearch(researchId)
    if IsResearchDone(researchId) == 0 then
        if IsResearchAvailable(researchId) == 1 then
            return 1
        end
    end
    return NIL
end

-- Recurse into upgrade tables/chains, adding demand for each available item.
function inc_research_demand(researchtype, val)
    local typeis = typeid(researchtype)
    if typeis == LT_TABLE then
        for i, v in researchtype do
            inc_research_demand(v, val)
        end
    elseif Util_CheckResearch(researchtype) then
        ResearchDemandAdd(researchtype, val)
    end
end

-- How much "spare economy" we have for research: 0 = none, 1 = some, 2 = plenty.
-- Thresholds drop with difficulty so Hard starts upgrading earlier.
function CpuResearch_EconomicValue()
    local numCollecting = GetNumCollecting()
    local numRU = GetRU()

    local hiRU = 3000
    local hiCol = 7
    local loRU = 1800
    local loCol = 5
    if g_LOD >= 2 then
        hiRU = 1500
        hiCol = 5
        loRU = 700
        loCol = 3
    elseif g_LOD == 1 then
        hiRU = 2000
        hiCol = 6
        loRU = 1000
        loCol = 4
    end

    if (numRU > hiRU and numCollecting > hiCol) or numRU > (hiRU * 3) then
        return 2
    elseif (numRU > loRU and numCollecting > loCol) or numRU > (loRU * 3) then
        return 1
    end
    return 0
end

function DoUpgradeDemand_Hiigaran()
    -- Strikecraft
    local numInterceptors = NumSquadrons(kInterceptor)
    if numInterceptors > 0 then
        inc_research_demand(rt_interceptor.speed, numInterceptors * 1)
    end

    local numBombers = NumSquadrons(kBomber)
    if numBombers > 0 then
        inc_research_demand(rt_bomber.speed, numBombers * 1)
    end

    -- Corvettes
    local numAssaultCorvette = NumSquadrons(HGN_ASSAULTCORVETTE)
    if numAssaultCorvette > 0 then
        inc_research_demand(rt_assaultcorvette, numAssaultCorvette * 1.25)
    end

    local numPulsarCorvette = NumSquadrons(HGN_PULSARCORVETTE)
    if numPulsarCorvette > 0 then
        inc_research_demand(rt_pulsarcorvette, numPulsarCorvette * 1.25)
    end

    -- Frigates
    local numTorpedoFrigate = NumSquadrons(HGN_TORPEDOFRIGATE)
    if numTorpedoFrigate > 0 then
        inc_research_demand(rt_torpedofrigate, numTorpedoFrigate * 1.5)
    end

    -- Ion-cannon and assault frigate chains are gated behind the free
    -- InstaAdvancedFrigateTech; demand it first when we field those frigates so
    -- the chains unlock. Until it completes, the chain upgrades report
    -- unavailable and pick up no demand.
    local numIonFrigate = NumSquadrons(HGN_IONCANNONFRIGATE)
    local numAssaultFrigate = NumSquadrons(HGN_ASSAULTFRIGATE)
    if numIonFrigate > 0 or numAssaultFrigate > 0 then
        inc_research_demand(rt_advancedfrigatetech, 5)
        if numIonFrigate > 0 then
            inc_research_demand(rt_ioncannonfrigate, numIonFrigate * 1.5)
        end
        if numAssaultFrigate > 0 then
            inc_research_demand(rt_assaultfrigate, numAssaultFrigate * 1.5)
        end
    end

    -- Economy (cheap, low priority)
    local numCollectors = NumSquadrons(kCollector)
    if numCollectors > 0 then
        inc_research_demand(rt_collector, numCollectors * 0.3)
    end

    local numRefinery = NumSquadrons(kRefinery)
    if numRefinery > 0 then
        inc_research_demand(rt_controller, numRefinery * 0.5)
    end
end

function DoUpgradeDemand_Vaygr()
    -- Capital ships (family-wide; the Vaygr workhorse).
    local numCapital = numActiveOfClass(s_playerIndex, eCapital) or 0
    if numCapital > 0 then
        inc_research_demand(rt_capital, numCapital * 2)
    end

    -- Fighters
    local numFighter = numActiveOfClass(s_playerIndex, eFighter) or 0
    if numFighter > 1 then
        inc_research_demand(rt_fighter.speed, numFighter * 0.75)
    end

    -- Corvettes
    local numCorvette = numActiveOfClass(s_playerIndex, eCorvette) or 0
    if numCorvette > 1 then
        inc_research_demand(rt_corvette, numCorvette * 1)
    end

    -- Frigates
    local numFrigate = numActiveOfClass(s_playerIndex, eFrigate) or 0
    if numFrigate > 1 then
        inc_research_demand(rt_frigate, numFrigate * 1)
    end

    -- Utility (collectors / controllers; cheap, low priority).
    inc_research_demand(rt_utility, 0.5)
end

function CpuResearch_DefaultResearchDemandRules()
    -- Never research while under heavy attack.
    if UnderAttackThreat() > -20 then
        return
    end

    if sg_doupgrades ~= 1 then
        return
    end

    -- Need a real fighting force before sinking RU into upgrades (skip the gate
    -- on Easy so it still does something).
    if (s_militaryPop or 0) < 5 and g_LOD > 0 then
        return
    end

    local economicValue = CpuResearch_EconomicValue()
    if economicValue <= 0 then
        return
    end

    -- Respect the cadence delay unless the economy is flush (econ > 1).
    local timeSinceUpgrade = (gameTime() - (sg_lastUpgradeTime or 0))
    if timeSinceUpgrade > sg_upgradeDelayTime or economicValue > 1 then
        DoUpgradeDemand()
        sg_lastUpgradeTime = gameTime()
    end
end

function CpuResearch_Process()
    -- Spare-economy gate: require a working economy before any RU goes here.
    if GetNumCollecting() < sg_minNumCollectors and GetRU() < 1500 then
        return 0
    end

    -- One research at a time.
    if IsResearchBusy() == 1 then
        return 0
    end

    ResearchDemandClear()

    if Override_ResearchDemand then
        Override_ResearchDemand()
    else
        CpuResearch_DefaultResearchDemandRules()
    end

    local bestResearch = FindHighDemandResearch()
    if bestResearch ~= 0 then
        aitrace("Research: " .. bestResearch)
        Research(bestResearch)
        return 1
    end

    return 0
end
