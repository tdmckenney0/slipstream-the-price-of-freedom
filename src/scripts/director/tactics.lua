-- Slipstream: Tactical Director - tactics helpers (game-rules VM)
--
-- Recipe validated by the Phase-0 smoke test:
--   * time  = Universe_GameTime() (gameTime() does not exist in this VM)
--   * jump  = SobGroup_Despawn -> SobGroup_ExitHyperSpaceSobGroup near an anchor
--   * anchor groups must contain REAL ships (no mothership/shipyard exist) and be
--     NON-EMPTY (an empty anchor dumps ships at the origin)
--   * Player_FillShipsByType CLEARS-and-fills, so union types via a temp group and
--     SobGroup_SobGroupAdd.

-- Strike force ship classes, weighted for hit-n-run composition (NOT the
-- flagship, which is irreplaceable and stays home as an anchor). Each class
-- independently rolls its weight as a 0-100 chance to join a strike group each
-- FORM tick (Tactics_RollStrikeForce) - cheap/small classes are near-certain,
-- capitals are occasional reinforcements. Both races' type-strings are listed;
-- filling a type a player doesn't field simply adds nothing.
g_dirStrikeClasses = {
    { weight = 90, types = { "hgn_interceptor", "vgr_interceptor", "vgr_bomber", "vgr_lancefighter" } },
    { weight = 75, types = { "hgn_assaultcorvette", "hgn_pulsarcorvette", "vgr_missilecorvette", "vgr_lasercorvette" } },
    { weight = 55, types = { "hgn_assaultfrigate", "hgn_torpedofrigate", "hgn_ioncannonfrigate", "vgr_assaultfrigate", "vgr_heavymissilefrigate" } },
    { weight = 35, types = { "hgn_destroyer", "vgr_destroyer" } },
    { weight = 20, types = { "hgn_battlecruiser", "vgr_battlecruiser" } },
}

-- Flattened union of every g_dirStrikeClasses type - the full eligible pool,
-- used to keep an already-committed strike topped up with reinforcements while
-- ENGAGE/REGROUP (see StrikeGroup_Update). Derived so it can't drift out of
-- sync with the class table above.
g_dirStrikeTypes = {}
local dirStrikeTypeCount = 0
local dirStrikeClassIdx, dirStrikeClass, dirStrikeTypeIdx, dirStrikeType
for dirStrikeClassIdx, dirStrikeClass in g_dirStrikeClasses do
    for dirStrikeTypeIdx, dirStrikeType in dirStrikeClass.types do
        dirStrikeTypeCount = dirStrikeTypeCount + 1
        g_dirStrikeTypes[dirStrikeTypeCount] = dirStrikeType
    end
end

-- Home anchor: stationary / base-bound ships that reliably exist.
g_dirHomeTypes = {
    "hgn_resourcecontroller", "vgr_resourcecontroller",
    "hgn_heavycruiser", "vgr_qwaarjetii",
    "hgn_resourcecollector", "vgr_resourcecollector",
}

-- Enemy anchor: prefer their capitals/flagship; broaden to anything so a living
-- enemy always yields a non-empty anchor to jump beside.
g_dirTargetTypes = {
    "hgn_battlecruiser", "vgr_battlecruiser",
    "hgn_heavycruiser", "vgr_qwaarjetii",
    "hgn_destroyer", "vgr_destroyer",
    "hgn_assaultfrigate", "vgr_assaultfrigate",
    "hgn_ioncannonfrigate", "vgr_heavymissilefrigate",
    "hgn_resourcecollector", "vgr_resourcecollector",
}

-- Object types that mark a map as hyperspace-disabled. If ANY of these is present
-- the director falls back to conventional attack-move (a despawn-jump there would
-- strand the strike group). meg_asteroid_inhibitor is the stock in-world blocker;
-- add more types here as you tune (other inhibitor variants, per-map markers, etc).
g_dirInhibitorTypes = {
    "meg_asteroid_inhibitor", "sri_foundry",
}

-- Union all of playerIndex's ships whose type is in typeList into outName.
function Tactics_FillByTypes(playerIndex, outName, typeList)
    SobGroup_Create(outName)
    SobGroup_Clear(outName)
    local tmp = outName .. "_tmp"
    SobGroup_Create(tmp)
    local i, t
    for i, t in typeList do
        SobGroup_Clear(tmp)
        Player_FillShipsByType(tmp, playerIndex, t)
        SobGroup_SobGroupAdd(outName, tmp)
    end
    return SobGroup_Count(outName)
end

function Tactics_FillStrike(p, outName)
    return Tactics_FillByTypes(p, outName, g_dirStrikeTypes)
end

-- Weighted-random roll of this cycle's strike composition: each class in
-- g_dirStrikeClasses independently rolls its weight as a % chance to
-- contribute, then every rolled-in type is filled/unioned into outName.
-- Called every FORM tick, so the roll (and thus the composition actually
-- despawned/attacked on commit) varies strike to strike.
function Tactics_RollStrikeForce(p, outName)
    SobGroup_Create(outName)
    SobGroup_Clear(outName)
    local tmp = outName .. "_tmp"
    SobGroup_Create(tmp)
    local i, cls
    for i, cls in g_dirStrikeClasses do
        if RandomIntMax(100) <= cls.weight then
            local j, t
            for j, t in cls.types do
                SobGroup_Clear(tmp)
                Player_FillShipsByType(tmp, p, t)
                SobGroup_SobGroupAdd(outName, tmp)
            end
        end
    end
    return SobGroup_Count(outName)
end

function Tactics_FillHome(p, outName)
    return Tactics_FillByTypes(p, outName, g_dirHomeTypes)
end

function Tactics_FillTarget(enemyIndex, outName)
    SobGroup_Create(outName)
    SobGroup_Clear(outName)
    if enemyIndex < 0 then
        return 0
    end
    return Tactics_FillByTypes(enemyIndex, outName, g_dirTargetTypes)
end

-- How many OTHER directors are currently pressuring player q (actively OUT or
-- ENGAGE against them). Scans the existing g_directorState table (set by
-- director.lua) - no separate bookkeeping needed.
function Tactics_TargetLoad(q)
    local load = 0
    local p2, st2
    for p2, st2 in g_directorState do
        if st2.targetPlayer == q and (st2.state == "OUT" or st2.state == "ENGAGE") then
            load = load + 1
        end
    end
    return load
end

-- Prefer the least-pressured alive non-ally first (so multiple AI directors
-- spread out instead of dogpiling one player - e.g. a lone human on a mixed
-- team), falling back to the weakest (fewest awake ships) as a tie-breaker.
function Tactics_PickTargetPlayer(p)
    local best = -1
    local bestLoad = 999999
    local bestShips = 999999
    local q
    for q = 0, Universe_PlayerCount() - 1 do
        if q ~= p and Player_IsAlive(q) == 1 and AreAllied(p, q) == 0 then
            local load = Tactics_TargetLoad(q)
            -- Prefer the weakest enemy when the count fn is available; otherwise
            -- just take the first alive non-ally (guard: not used by campaign,
            -- so it may be absent in this VM like gameTime was).
            local n = 0
            if Player_NumberOfAwakeShips then
                n = Player_NumberOfAwakeShips(q)
            end
            if best == -1 or load < bestLoad or (load == bestLoad and n < bestShips) then
                bestLoad = load
                bestShips = n
                best = q
            end
        end
    end
    return best
end

-- Detect a hyperspace-disabled map by the presence of any g_dirInhibitorTypes
-- object. A scripted jump on such a map would STRAND a despawned strike group (it
-- can never enter hyperspace), so we query at runtime in THIS VM and fall back to
-- conventional attack-move. (A global set in the .level file runs in a different VM
-- and never reaches us - confirmed in testing - so the object query is the reliable
-- cross-VM signal, exactly like deathmatch.lua detects meg_slipgate. -1 matches the
-- neutral/world objects regardless of owner.)
function Tactics_MapHasInhibitor()
    return Tactics_FillByTypes(-1, "Dir_Inhibitors", g_dirInhibitorTypes)
end

function Tactics_JumpsAllowed()
    if g_disableDirectorJumps == 1 then
        return 0
    end
    return 1
end

-- Difficulty-scaled thresholds. getLevelOfDifficulty() may be absent in the rules
-- VM (like gameTime was); default to the most aggressive profile if so.
function Tactics_Knobs()
    local lod = 2
    if getLevelOfDifficulty then
        lod = getLevelOfDifficulty()
    end
    local k = {
        minStrikeShips = 2,    -- capitals required before a strike
        jumpCooldown   = 60,   -- seconds between strikes (from regroup end)
        hyperMaxWait   = 12,   -- watchdog: max seconds to wait for in-hyperspace
        engageMaxTime  = 240,   -- seconds before breaking off regardless
        breakHealth    = 0.45, -- group HealthPercentage that triggers hit-n-run
        regroupTime    = 120,   -- seconds parked home before re-forming
        exitProximity  = 8000, -- distance to exit hyperspace from the anchor
        reissueAttack  = 4,    -- seconds between AttackPlayer re-issues
    }
    if lod == 0 then            -- Easy
        k.minStrikeShips = 3; -- capitals required before a strike
        k.jumpCooldown = 180; -- seconds between strikes (from regroup end)
        k.engageMaxTime = 120; -- seconds before breaking off regardless
        k.breakHealth = 0.60; -- group HealthPercentage that triggers hit-n-run
        k.regroupTime = 240; -- seconds parked home before re-forming
    elseif lod == 1 then        -- Medium
        k.jumpCooldown = 120; -- seconds between strikes (from regroup end)
        k.breakHealth = 0.50; -- group HealthPercentage that triggers hit-n-run
        k.regroupTime = 180; -- seconds parked home before re-forming
    end
    return k
end
