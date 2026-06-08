-- Slipstream: The Price of Freedom - Hiigaran Upgrade Tables
-- ONLY the upgrades that are always available in TPOF: not restricted in
-- scar/restrict.lua, and defined with RequiredSubSystems = "" (no research
-- module needed). Chained upgrades list both tiers; inc_research_demand only
-- adds demand for whichever tier is currently available, so the chain advances
-- over the match. See docs/superpowers/specs/2026-05-25-ai-basic-research-design.md.

aitrace("LOADING SLIPSTREAM HIIGARAN UPGRADE INFO")

-- Free instant prerequisite (Cost 0 / Time 0) that unlocks the ion-cannon and
-- assault frigate upgrade chains. Researched first when those frigates exist.
rt_advancedfrigatetech = { INSTAADVANCEDFRIGATETECH }

rt_interceptor = {
    speed = { INTERCEPTORMAXSPEEDUPGRADE1, INTERCEPTORMAXSPEEDUPGRADE2 },
}

rt_bomber = {
    speed = { ATTACKBOMBERMAXSPEEDUPGRADE1, ATTACKBOMBERMAXSPEEDUPGRADE2 },
}

rt_assaultcorvette = {
    health = { ASSAULTCORVETTEHEALTHUPGRADE1, ASSAULTCORVETTEHEALTHUPGRADE2 },
    speed = { ASSAULTCORVETTEMAXSPEEDUPGRADE1, ASSAULTCORVETTEMAXSPEEDUPGRADE2 },
}

rt_pulsarcorvette = {
    health = { PULSARCORVETTEHEALTHUPGRADE1, PULSARCORVETTEHEALTHUPGRADE2 },
    speed = { PULSARCORVETTEMAXSPEEDUPGRADE1, PULSARCORVETTEMAXSPEEDUPGRADE2 },
}

rt_torpedofrigate = {
    health = { TORPEDOFRIGATEHEALTHUPGRADE1, TORPEDOFRIGATEHEALTHUPGRADE2 },
    speed = { TORPEDOFRIGATEMAXSPEEDUPGRADE1, TORPEDOFRIGATEMAXSPEEDUPGRADE2 },
}

-- Gated behind INSTAADVANCEDFRIGATETECH (see DoUpgradeDemand_Hiigaran).
rt_ioncannonfrigate = {
    health = { IONCANNONFRIGATEHEALTHUPGRADE1, IONCANNONFRIGATEHEALTHUPGRADE2 },
    speed = { IONCANNONFRIGATEMAXSPEEDUPGRADE1, IONCANNONFRIGATEMAXSPEEDUPGRADE2 },
}

rt_assaultfrigate = {
    health = { ASSAULTFRIGATEHEALTHUPGRADE1, ASSAULTFRIGATEHEALTHUPGRADE2 },
    speed = { ASSAULTFRIGATEMAXSPEEDUPGRADE1, ASSAULTFRIGATEMAXSPEEDUPGRADE2 },
}

rt_collector = { RESOURCECOLLECTORHEALTHUPGRADE1, RESOURCECOLLECTORHEALTHUPGRADE2 }
rt_controller = { RESOURCECONTROLLERHEALTHUPGRADE1, RESOURCECONTROLLERHEALTHUPGRADE2 }
