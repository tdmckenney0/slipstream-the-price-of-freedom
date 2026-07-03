-- Slipstream: Tactical Director - per-AI-player strike-group state machine.
--
-- States:  FORM -> OUT -> ENGAGE -> BACK -> REGROUP -> FORM
--   FORM     gather strike capitals; when strong enough + off cooldown, Despawn
--   OUT      once AreAllInHyperspace, ExitHyperSpaceSobGroup near the enemy
--   ENGAGE   attack; break off when hurt / timed out / target gone
--   BACK     once AreAllInHyperspace, ExitHyperSpaceSobGroup near home
--   REGROUP  stop ordering (cpu brain reclaims the ships) until next cycle
--
-- On hyperspace-disabled maps the OUT/BACK jumps are replaced by conventional
-- attack-move / retreat-move (Tactics_JumpsAllowed() == 0).

function StrikeGroup_Enter(st, newState, now)
    st.state = newState
    st.stateTime = now
end

function StrikeGroup_Update(p)
    local st = g_directorState[p]
    local k = Tactics_Knobs()
    local now = Universe_GameTime()

    -- Strike membership is refreshed only in real-space states. While the group is
    -- despawned (OUT/BACK) we must NOT re-fill it or we'd drop the in-hyperspace
    -- ships and have nothing to bring back. FORM re-rolls the weighted composition
    -- every tick (so commit locks in whatever just rolled); ENGAGE/REGROUP keep
    -- topping up from the full pool so reinforcements built mid-fight join in.
    local strikeCount
    if st.state == "FORM" then
        strikeCount = Tactics_RollStrikeForce(p, st.strikeName)
    elseif st.state == "ENGAGE" or st.state == "REGROUP" then
        strikeCount = Tactics_FillStrike(p, st.strikeName)
    else
        strikeCount = SobGroup_Count(st.strikeName)
    end

    if st.state == "FORM" then
        if strikeCount >= k.minStrikeShips and (now - st.lastJumpTime) >= k.jumpCooldown then
            st.targetPlayer = Tactics_PickTargetPlayer(p)
            if st.targetPlayer >= 0 and Tactics_FillTarget(st.targetPlayer, st.targetName) > 0 then
                st.lastJumpTime = now
                if Tactics_JumpsAllowed() == 1 then
                    Director_Trace("p" .. p .. " STRIKE jump-out (" .. strikeCount .. " caps)")
                    SobGroup_Despawn(st.strikeName)
                    StrikeGroup_Enter(st, "OUT", now)
                else
                    Director_Trace("p" .. p .. " STRIKE conventional")
                    SobGroup_AttackPlayer(st.strikeName, st.targetPlayer)
                    st.lastAttackTime = now
                    StrikeGroup_Enter(st, "ENGAGE", now)
                end
            end
        end
        return
    end

    if st.state == "OUT" then
        -- Only exit once the engine confirms ALL ships are in hyperspace, else the
        -- exit errors ("not in hyperspace"). Watchdog prevents stranding.
        if SobGroup_AreAllInHyperspace(st.strikeName) == 1 then
            if Tactics_FillTarget(st.targetPlayer, st.targetName) > 0 then
                SobGroup_ExitHyperSpaceSobGroup(st.strikeName, st.targetName, k.exitProximity)
                SobGroup_AttackPlayer(st.strikeName, st.targetPlayer)
                Director_Trace("p" .. p .. " IN at enemy")
            else
                -- target gone while we were in hyperspace; come straight home
                Tactics_FillHome(p, st.homeName)
                SobGroup_ExitHyperSpaceSobGroup(st.strikeName, st.homeName, k.exitProximity)
                Director_Trace("p" .. p .. " IN aborted -> home")
            end
            st.lastAttackTime = now
            StrikeGroup_Enter(st, "ENGAGE", now)
        elseif (now - st.stateTime) > k.hyperMaxWait then
            -- Never registered as in-hyperspace. No recovery exit attempt here:
            -- there's no query to confirm it would succeed (only the AreAll*
            -- variants exist - no AreAny), and a group that's merely dead/empty
            -- or a genuine partial mix (some in hyperspace, some not - e.g. a
            -- wounded ship died mid-despawn) both fail ExitHyperSpaceSobGroup
            -- with a hard Lua error that skips the state transition below,
            -- leaving the state stuck re-erroring forever (confirmed in
            -- Hw2.log). Just give up and regroup; the cpu brain reclaims
            -- whatever's actually back in real space.
            Director_Trace("p" .. p .. " OUT watchdog -> REGROUP")
            StrikeGroup_Enter(st, "REGROUP", now)
        end
        return
    end

    if st.state == "ENGAGE" then
        if strikeCount == 0 then
            StrikeGroup_Enter(st, "FORM", now)
            return
        end
        if (now - st.lastAttackTime) >= k.reissueAttack then
            if Player_IsAlive(st.targetPlayer) == 1 then
                SobGroup_AttackPlayer(st.strikeName, st.targetPlayer)
            end
            st.lastAttackTime = now
        end
        local hp = SobGroup_HealthPercentage(st.strikeName)
        local targetGone = (Player_IsAlive(st.targetPlayer) == 0)
            or (Tactics_FillTarget(st.targetPlayer, st.targetName) == 0)
        if hp < k.breakHealth or (now - st.stateTime) > k.engageMaxTime or targetGone then
            if Tactics_JumpsAllowed() == 1 then
                Director_Trace("p" .. p .. " BREAK jump-out (hp " .. hp .. ")")
                SobGroup_Despawn(st.strikeName)
                StrikeGroup_Enter(st, "BACK", now)
            else
                Director_Trace("p" .. p .. " BREAK retreat")
                Tactics_FillHome(p, st.homeName)
                if SobGroup_Count(st.homeName) > 0 then
                    SobGroup_MoveToSobGroup(st.strikeName, st.homeName)
                end
                StrikeGroup_Enter(st, "REGROUP", now)
            end
        end
        return
    end

    if st.state == "BACK" then
        if SobGroup_AreAllInHyperspace(st.strikeName) == 1 then
            Tactics_FillHome(p, st.homeName)
            if SobGroup_Count(st.homeName) > 0 then
                SobGroup_ExitHyperSpaceSobGroup(st.strikeName, st.homeName, k.exitProximity)
            end
            Director_Trace("p" .. p .. " HOME")
            StrikeGroup_Enter(st, "REGROUP", now)
        elseif (now - st.stateTime) > k.hyperMaxWait then
            -- Timed out without registering as in-hyperspace. No recovery exit
            -- attempt here: there's no query to confirm it would succeed (only
            -- the AreAll* variants exist - no AreAny), and a group that's merely
            -- dead/empty or a genuine partial mix (some in hyperspace, some not
            -- - e.g. a wounded ship died mid-despawn) both fail
            -- ExitHyperSpaceSobGroup with a hard Lua error that skips the state
            -- transition below, leaving the state stuck re-erroring forever
            -- (confirmed in Hw2.log). Just give up and regroup; the cpu brain
            -- reclaims whatever's actually back in real space.
            Director_Trace("p" .. p .. " BACK watchdog -> REGROUP")
            StrikeGroup_Enter(st, "REGROUP", now)
        end
        return
    end

    if st.state == "REGROUP" then
        -- Stop issuing orders; the cpu brain reclaims these ships until the next
        -- cycle. Re-form once parked long enough (cooldown is measured from here).
        if (now - st.stateTime) >= k.regroupTime then
            st.lastJumpTime = now
            StrikeGroup_Enter(st, "FORM", now)
        end
        return
    end
end
