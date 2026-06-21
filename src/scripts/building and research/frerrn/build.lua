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
}
