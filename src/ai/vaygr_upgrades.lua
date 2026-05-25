-- Slipstream: The Price of Freedom - Vaygr Upgrade Tables
-- ONLY the upgrades that are always available in TPOF: not restricted in
-- scar/restrict.lua, and defined with RequiredSubSystems = "" (no research
-- module needed). Vaygr upgrades are family-wide (TargetType = Family), so each
-- chain improves every ship of that class at once. Chained upgrades list both
-- tiers; inc_research_demand only adds demand for whichever tier is currently
-- available. See docs/superpowers/specs/2026-05-25-ai-basic-research-design.md.

aitrace("LOADING SLIPSTREAM VAYGR UPGRADE INFO")

-- Capital family (SuperCap) - the Vaygr workhorse. Unlike Hiigaran, these are
-- NOT gated behind a restricted weapon tech, so they are always available.
rt_capital = {
    health = { SUPERCAPHEALTHUPGRADE1, SUPERCAPHEALTHUPGRADE2 },
    speed = { SUPERCAPSPEEDUPGRADE1, SUPERCAPSPEEDUPGRADE2 },
}

rt_fighter = {
    speed = { FIGHTERSPEEDUPGRADE1, FIGHTERSPEEDUPGRADE2 },
}

rt_corvette = {
    health = { CORVETTEHEALTHUPGRADE1, CORVETTEHEALTHUPGRADE2 },
    speed = { CORVETTESPEEDUPGRADE1, CORVETTESPEEDUPGRADE2 },
}

rt_frigate = {
    health = { FRIGATEHEALTHUPGRADE1, FRIGATEHEALTHUPGRADE2 },
    -- NOTE: the second Vaygr frigate-speed upgrade's research Name is
    -- "SpeedUpgrade2" (not "FrigateSpeedUpgrade2"), hence the SPEEDUPGRADE2
    -- constant here. FRIGATESPEEDUPGRADE1 is its prerequisite.
    speed = { FRIGATESPEEDUPGRADE1, SPEEDUPGRADE2 },
}

-- Utility family (resource collectors / controllers).
rt_utility = { UTILITYHEALTHUPGRADE1, UTILITYHEALTHUPGRADE2 }
