-- LuaDC version 0.9.20
-- 11/4/2024 10:16:15 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
function RestrictOptions(playerid)
    local playerRace = Player_GetRace(playerid)
    if  playerRace==Race_Hiigaran then
        Player_RestrictBuildOption(playerid, "Hgn_MS_Production_CorvetteMover")
        Player_RestrictBuildOption(playerid, "Kpr_Mover")
        Player_RestrictBuildOption(playerid, "Hgn_Shipyard_SPG")
        Player_RestrictBuildOption(playerid, "Hgn_MinelayerCorvette")
        Player_RestrictBuildOption(playerid, "Hgn_Probe")
        Player_RestrictBuildOption(playerid, "Hgn_ProximitySensor")
        Player_RestrictBuildOption(playerid, "Hgn_ECMProbe")
        Player_RestrictBuildOption(playerid, "Hgn_MarineFrigate")
        Player_RestrictBuildOption(playerid, "Hgn_DefenseFieldFrigate")
        Player_RestrictBuildOption(playerid, "Hgn_Scout")
        Player_RestrictBuildOption(playerid, "Hgn_AttackBomber")
        Player_RestrictBuildOption(playerid, "Hgn_Shipyard")
        Player_RestrictResearchOption(playerid, "AssaultCorvetteEliteWeaponUpgrade")
        Player_RestrictResearchOption(playerid, "AttackBomberEliteWeaponUpgrade")
        Player_RestrictResearchOption(playerid, "SensorsDowngrade1")
        Player_RestrictResearchOption(playerid, "SensorsDowngrade2")
        Player_RestrictResearchOption(playerid, "SensorsDowngrade3")
        Player_RestrictResearchOption(playerid, "SensorsBackToNormal1")
        Player_RestrictResearchOption(playerid, "SensorsBackToNormal2")
        Player_RestrictResearchOption(playerid, "SensorsBackToNormal3")
        Player_RestrictResearchOption(playerid, "MoverHealthDowngrade")
        Player_RestrictResearchOption(playerid, "MoverHealthUpgrade")
        Player_RestrictResearchOption(playerid, "FrigateHealthUpgradeSPGAME")
        Player_RestrictResearchOption(playerid, "DamageMoverTech")
        Player_RestrictResearchOption(playerid, "KeeperHealthUpgradeSPGAME_LOW")
        Player_RestrictResearchOption(playerid, "KeeperHealthUpgradeSPGAME_MED")
        Player_RestrictResearchOption(playerid, "KeeperHealthUpgradeSPGAME_HIGH")
        Player_RestrictResearchOption(playerid, "KeeperWeaponUpgradeSPGAME_M10_LVL_1")
        Player_RestrictResearchOption(playerid, "KeeperWeaponUpgradeSPGAME_M10_LVL_2")
        Player_RestrictResearchOption(playerid, "KeeperWeaponUpgradeSPGAME_M10_LVL_3")
        Player_RestrictResearchOption(playerid, "KeeperWeaponUpgradeSPGAME_M10_LVL_4")
        Player_RestrictResearchOption(playerid, "KeeperWeaponUpgradeSPGAME_M10_LVL_5")
        Player_RestrictResearchOption(playerid, "KeeperWeaponUpgradeSPGAME_M10_LVL_6")
        Player_RestrictResearchOption(playerid, "KeeperHealthUpgradeSPGAME_M10_LVL_1")
        Player_RestrictResearchOption(playerid, "KeeperHealthUpgradeSPGAME_M10_LVL_2")
        Player_RestrictResearchOption(playerid, "KeeperHealthUpgradeSPGAME_M10_LVL_3")
        Player_RestrictResearchOption(playerid, "AttackDroidHealthUpgradeSPGAME_LOW")
        Player_RestrictResearchOption(playerid, "AttackDroidHealthUpgradeSPGAME_MED")
        Player_RestrictResearchOption(playerid, "AttackDroidHealthUpgradeSPGAME_HIGH")
        Player_RestrictResearchOption(playerid, "AttackDroidWeaponUpgradeSPGAME_LOW")
        Player_RestrictResearchOption(playerid, "AttackDroidWeaponUpgradeSPGAME_MED")
        Player_RestrictResearchOption(playerid, "AttackDroidWeaponUpgradeSPGAME_HIGH")
        Player_RestrictResearchOption(playerid, "RadiationDefenseField")
        Player_RestrictResearchOption(playerid, "GraviticAttractionMines")
        Player_RestrictResearchOption(playerid, "MothershipHealthUpgrade1")
        Player_RestrictResearchOption(playerid, "MothershipMAXSPEEDUpgrade1")
        Player_RestrictResearchOption(playerid, "MothershipBUILDSPEEDUpgrade1")
        Player_RestrictResearchOption(playerid, "HyperspaceCostUpgrade1")
        Player_RestrictResearchOption(playerid, "ShipyardHealthUpgrade1")
        Player_RestrictResearchOption(playerid, "ShipyardMAXSPEEDUpgrade1")
        Player_RestrictResearchOption(playerid, "ShipyardBUILDSPEEDUpgrade1")
        Player_RestrictResearchOption(playerid, "ScoutPingAbility")
        Player_RestrictResearchOption(playerid, "DefenseFieldFrigateShield")
        Player_RestrictResearchOption(playerid, "ScoutEMPAbility")
        Player_RestrictResearchOption(playerid, "ECMProbe")
        Player_RestrictResearchOption(playerid, "SensDisProbe")
        Player_RestrictResearchOption(playerid, "AttackBomberImprovedBombs")
        Player_RestrictResearchOption(playerid, "ImprovedTorpedo")
    end 

    if  playerRace==Race_Vaygr then
        Player_RestrictBuildOption(playerid, "Vgr_PlanetKillerMissile")
        Player_RestrictResearchOption(playerid, "WeakVgrHeavyMissiles")
        Player_RestrictResearchOption(playerid, "HyperspaceRecoveryTimeUpgradeSPGAME")
        Player_RestrictResearchOption(playerid, "HyperspaceTransitionTimeUpgradeSPGAME")
        Player_RestrictResearchOption(playerid, "VaygrCarrierHealthRegenDowngrade")
        Player_RestrictResearchOption(playerid, "ShipyardSpeedDowngradeSPGAME")
        Player_RestrictResearchOption(playerid, "SuperCapHealthUpgradeSPGAME")
        Player_RestrictResearchOption(playerid, "VaygrFrigateHealthUpgradeSPGAME")
        Player_RestrictResearchOption(playerid, "VaygrFrigateHealthRegenDowngradeSPGAME")
        Player_RestrictResearchOption(playerid, "CorvetteHealthUpgradeSPGAME")
        Player_RestrictResearchOption(playerid, "ExtraStrongVgrHeavyMissilesSPGAME")
        Player_RestrictResearchOption(playerid, "VaygrCaptureHack")
        Player_RestrictResearchOption(playerid, "VaygrReduceCaptureHack")
        Player_RestrictResearchOption(playerid, "VaygrRadiationImmunityHack")
        Player_RestrictResearchOption(playerid, "VaygrCarrierHealthUpgrade")
        Player_RestrictResearchOption(playerid, "CorvetteGraviticAttraction")
        Player_RestrictResearchOption(playerid, "MothershipBUILDSPEEDUpgrade1")
        Player_RestrictResearchOption(playerid, "ShipyardBUILDSPEEDUpgrade1")
        Player_RestrictResearchOption(playerid, "ProbeProxSensor")
        Player_RestrictResearchOption(playerid, "ProbeSensorDisruption")
        Player_RestrictResearchOption(playerid, "CorvetteCommand")
        Player_RestrictResearchOption(playerid, "FrigateInfiltrationTech")
        Player_RestrictResearchOption(playerid, "ScoutEMPAbility")
        Player_RestrictResearchOption(playerid, "BomberImprovedBombs")
        Player_RestrictBuildOption(playerid, "Vgr_Scout")
        Player_RestrictBuildOption(playerid, "Vgr_MinelayerCorvette")
        Player_RestrictBuildOption(playerid, "Vgr_HyperSpace_Platform")
        Player_RestrictBuildOption(playerid, "Vgr_Probe")
        Player_RestrictBuildOption(playerid, "Vgr_Probe_Ecm")
        Player_RestrictBuildOption(playerid, "Vgr_Probe_Prox")
        Player_RestrictBuildOption(playerid, "vgr_infiltratorfrigate")
        Player_RestrictBuildOption(playerid, "Vgr_ShipYard")
        Player_RestrictBuildOption(playerid, "Vgr_CommandCorvette")
    end 

end

function MPRestrict()
    local i = 0
    local numplayers = Universe_PlayerCount()
    while  i<numplayers do
        RestrictOptions(i)
        i = (i + 1)
    end 

end
