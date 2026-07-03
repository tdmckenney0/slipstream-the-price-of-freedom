-- Slipstream: Tactical Director - tactics helpers (game-rules VM)
--
-- Recipe validated by the Phase-0 smoke test:
--   * time  = Universe_GameTime() (gameTime() does not exist in this VM)
--   * jump  = SobGroup_Despawn -> SobGroup_ExitHyperSpaceSobGroup near an anchor
--   * anchor groups must contain REAL ships (no mothership/shipyard exist) and be
--     NON-EMPTY (an empty anchor dumps ships at the origin)
--   * Player_FillShipsByType CLEARS-and-fills, so union types via a temp group and
--     SobGroup_SobGroupAdd.

-- Strike force: the expendable workhorse capitals (NOT the flagship, which is
-- irreplaceable and stays home as an anchor). Both races' type-strings are listed;
-- filling a type a player doesn't field simply adds nothing.
g_dirStrikeTypes = {
    "hgn_battlecruiser", "vgr_battlecruiser",
    "hgn_destroyer", "vgr_destroyer",
}

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
    "meg_asteroid_inhibitor",
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

-- The weakest alive non-ally (fewest awake ships) - arena aggression: crack the
-- softest target first.
function Tactics_PickTargetPlayer(p)
    local best = -1
    local bestShips = 999999
    local q
    for q = 0, Universe_PlayerCount() - 1 do
        if q ~= p and Player_IsAlive(q) == 1 and AreAllied(p, q) == 0 then
            -- Prefer the weakest enemy when the count fn is available; otherwise
            -- just take the first alive non-ally (guard: not used by campaign,
            -- so it may be absent in this VM like gameTime was).
            local n = 0
            if Player_NumberOfAwakeShips then
                n = Player_NumberOfAwakeShips(q)
            end
            if best == -1 or n < bestShips then
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
        jumpCooldown   = 25,   -- seconds between strikes (from regroup end)
        hyperMaxWait   = 12,   -- watchdog: max seconds to wait for in-hyperspace
        engageMaxTime  = 25,   -- seconds before breaking off regardless
        breakHealth    = 0.45, -- group HealthPercentage that triggers hit-n-run
        regroupTime    = 15,   -- seconds parked home before re-forming
        exitProximity  = 2000, -- distance to exit hyperspace from the anchor
        reissueAttack  = 4,    -- seconds between AttackPlayer re-issues
    }
    if lod == 0 then            -- Easy
        k.minStrikeShips = 3; k.jumpCooldown = 70; k.engageMaxTime = 20
        k.breakHealth = 0.60; k.regroupTime = 35
    elseif lod == 1 then        -- Medium
        k.jumpCooldown = 45; k.breakHealth = 0.50; k.regroupTime = 25
    end
    return k
end
