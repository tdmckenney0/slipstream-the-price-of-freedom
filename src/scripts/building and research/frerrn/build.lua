-- LuaDC version 0.9.20
-- 11/4/2024 10:16:14 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
Ship = 0
SubSystem = 1
build =
{
    -- Subsystems
    -- {
    --     Type = SubSystem,
    --     ThingToBuild = "",
    --     RequiredResearch = "",
    --     RequiredShipSubSystems = "",
    --     DisplayPriority = 0,
    --     DisplayedName = "$7000",
    --     Description = "$7001",
    -- },
    -- Ships
    {
        Type = Ship,
        ThingToBuild = "Frn_Destroyer",
        RequiredResearch = "",
        RequiredShipSubSystems = "",
        DisplayPriority = 10,
        DisplayedName = "Frn_Destroyer",
        Description = "Frn_Destroyer",
    },
    {
        Type = Ship,
        ThingToBuild = "Frn_Battlecruiser",
        RequiredResearch = "",
        RequiredShipSubSystems = "",
        DisplayPriority = 20,
        DisplayedName = "Frn_Battlecruiser",
        Description = "Frn_Battlecruiser",
    },
    -- Frigates
    {
        Type = Ship,
        ThingToBuild = "frn_assaultfrigate",
        RequiredResearch = "",
        RequiredShipSubSystems = "",
        DisplayPriority = 10,
        DisplayedName = "frn_assaultfrigate",
        Description = "frn_assaultfrigate",
    },
    {
        Type = Ship,
        ThingToBuild = "frn_ioncannonfrigate",
        RequiredResearch = "",
        RequiredShipSubSystems = "",
        DisplayPriority = 20,
        DisplayedName = "frn_ioncannonfrigate",
        Description = "frn_ioncannonfrigate",
    },
    {
        Type = Ship,
        ThingToBuild = "frn_supportfrigate",
        RequiredResearch = "",
        RequiredShipSubSystems = "",
        DisplayPriority = 30,
        DisplayedName = "frn_supportfrigate",
        Description = "frn_supportfrigate",
    },
    {
        Type = Ship,
        ThingToBuild = "frn_cloakingfrigate",
        RequiredResearch = "",
        RequiredShipSubSystems = "",
        DisplayPriority = 40,
        DisplayedName = "frn_cloakingfrigate",
        Description = "frn_cloakingfrigate",
    },
    -- Fighters
    {
        Type = Ship,
        ThingToBuild = "frn_scout",
        RequiredResearch = "",
        RequiredShipSubSystems = "",
        DisplayPriority = 10,
        DisplayedName = "frn_scout",
        Description = "frn_scout",
    },
    {
        Type = Ship,
        ThingToBuild = "frn_interceptor",
        RequiredResearch = "",
        RequiredShipSubSystems = "",
        DisplayPriority = 20,
        DisplayedName = "frn_interceptor",
        Description = "frn_interceptor",
    },
    {
        Type = Ship,
        ThingToBuild = "frn_bomber",
        RequiredResearch = "",
        RequiredShipSubSystems = "",
        DisplayPriority = 30,
        DisplayedName = "frn_bomber",
        Description = "frn_bomber",
    },
}
