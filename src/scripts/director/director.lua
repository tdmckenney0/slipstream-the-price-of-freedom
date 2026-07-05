-- Slipstream: The Price of Freedom - Tactical Director (game-rules VM)
--
-- Drives each AI player's expendable capitals in hyperspace jump-strikes and
-- hit-n-run, overlaid on the per-player cpu brain. The two run in separate Lua
-- VMs and share no state: while the director actively issues orders to a strike
-- group those orders win; when it stops (REGROUP) the brain reclaims the ships.
--
-- Hooked from deathmatch.lua OnInit:
--   Director_Init()
--   Rule_AddInterval("Director_Tick", g_directorTickInterval)

dofilepath("data:scripts/director/tactics.lua")
dofilepath("data:scripts/director/strikegroup.lua")

g_directorTickInterval = 2

-- Set to 1 to show per-player state transitions on-screen (Subtitle). print/trace
-- do NOT reach Hw2.log in this VM, so Subtitle is our observability for tuning.
g_directorDebug = 1

function Director_Trace(msg)
    if g_directorDebug == 1 and Subtitle_Message then
        Subtitle_Message("DIR: " .. msg, 4)
    end
end

-- CPU_Exist(playerIndex) is the real engine query for AI-vs-human (1 = CPU,
-- 0 = human or empty slot) - it works for any number/arrangement of human
-- players, unlike the old hardcoded "human is always slot 0" exclusion list
-- (which caused the director to command a human's fleet whenever they weren't
-- in slot 0, or in any match with more than one human).
function Director_IsAIPlayer(p)
    return CPU_Exist(p)
end

-- Resolved once on the first tick (not in Init): map objects from the .level's
-- DetermChunk are reliably spawned by rule-time, the same guarantee deathmatch's
-- slipgate rule relies on. Sets g_disableDirectorJumps in THIS VM, which is where
-- Tactics_JumpsAllowed actually reads it.
function Director_ResolveJumps()
    if Tactics_MapHasInhibitor() > 0 then
        g_disableDirectorJumps = 1
        Director_Trace("hyperspace inhibitor present -> jumps disabled")
    else
        g_disableDirectorJumps = 0
        Director_Trace("no inhibitor -> jumps enabled")
    end
    g_dirJumpsResolved = 1
end

function Director_Init()
    g_directorState = {}
    g_directorAI = {}
    g_disableDirectorJumps = 0
    g_dirJumpsResolved = 0
    local p
    for p = 0, Universe_PlayerCount() - 1 do
        if Director_IsAIPlayer(p) == 1 then
            g_directorAI[p] = 1
            g_directorState[p] = {
                state = "FORM",
                strikeName = "Dir_Strike_" .. p,
                homeName = "Dir_Home_" .. p,
                targetName = "Dir_Target_" .. p,
                targetPlayer = -1,
                stateTime = 0,
                lastJumpTime = -9999,
                lastAttackTime = 0,
            }
        end
    end
end

function Director_Tick()
    if g_dirJumpsResolved ~= 1 then
        Director_ResolveJumps()
    end
    local p, v
    for p, v in g_directorAI do
        if Player_IsAlive(p) == 1 then
            StrikeGroup_Update(p)
        end
    end
end
