--
-- classdef.lua
--
-- This file only contains ship classfication lists that allow the AI script writer to seperate each ship
-- into different subclasses (fighters, corvettes, anti-fighter, fast, slow,...) This is done to make it easier
-- (and faster) to refer to a ship based on its generalized properties.
--
-- Custom classes can be added at the end but have to be added in a very specific way.
--

aitrace("CPU: CLASSDEF LOADED")


-- table of all squadron class lists
squadclass = {}

-- is mothership
squadclass[eMotherShip] = {
	HGN_MOTHERSHIP,
	HGN_SUPERCARRIER,

	VGR_MOTHERSHIP,
	VGR_MOTHERSHIP_MAKAAN,
}

-- can harvest
squadclass[eCollector] = {
	HGN_RESOURCECOLLECTOR,

	VGR_RESOURCECOLLECTOR,
}

-- is a good scout/explorer
squadclass[eScout] = {
	HGN_SCOUT,
	HGN_PROBE,
	HGN_PROXIMITYSENSOR,
	HGN_ECMPROBE,

	VGR_SCOUT,
	VGR_PROBE,
	VGR_PROBE_PROX,
	VGR_PROBE_ECM,
}

-- is a refinery
squadclass[eRefinery] = {
	HGN_RESOURCECONTROLLER,

	VGR_RESOURCECONTROLLER,
}

-- can build ships
squadclass[eBuilder] = {
	HGN_MOTHERSHIP,
	HGN_CARRIER,  -- will need subsystem
	HGN_SHIPYARD,
	hgn_Supercarrier,

	VGR_MOTHERSHIP,
	VGR_MOTHERSHIP_MAKAAN,
	VGR_CARRIER,  -- will need subsystem
	VGR_SHIPYARD,
}

-- can be used as a resource dropoff
squadclass[eDropOff] = {
	HGN_MOTHERSHIP,
	HGN_CARRIER,  -- will need subsystem
	HGN_SHIPYARD,
	HGN_RESOURCECONTROLLER,
	hgn_Supercarrier,

	VGR_MOTHERSHIP,
	VGR_MOTHERSHIP_MAKAAN,
	VGR_CARRIER,  -- will need subsystem
	VGR_SHIPYARD,
	VGR_RESOURCECONTROLLER,
}

-- can be used as a salvage dropoff
squadclass[eSalvageDropOff] = {
    HGN_MOTHERSHIP,
	HGN_CARRIER,
	HGN_SHIPYARD,
	hgn_Supercarrier,
	VGR_MOTHERSHIP,
	VGR_MOTHERSHIP_MAKAAN,
	VGR_CARRIER,
	VGR_SHIPYARD,
}

-- is a fighter
squadclass[eFighter] = {
	HGN_INTERCEPTOR,
	HGN_ATTACKBOMBER,
	HGN_ATTACKBOMBERELITE,
	HGN_DRONE,
	HGN_DRONE_K,

	VGR_INTERCEPTOR,
	VGR_BOMBER,
	VGR_LANCEFIGHTER,
	VGR_DRONE,
}

-- is a corvette
squadclass[eCorvette] = {
	HGN_ASSAULTCORVETTE,
	HGN_PULSARCORVETTE,
	HGN_MINELAYERCORVETTE,

	VGR_MISSILECORVETTE,
	VGR_LASERCORVETTE,
	VGR_MINELAYERCORVETTE,
	VGR_COMMANDCORVETTE,
}

-- is a frigate
squadclass[eFrigate] = {
	HGN_ASSAULTFRIGATE,
	HGN_DEFENSEFIELDFRIGATE,
	HGN_IONCANNONFRIGATE,
	HGN_MARINEFRIGATE,
	HGN_MARINEFRIGATE_SOBAN,
	HGN_TORPEDOFRIGATE,
	HGN_TORPEDOFRIGATEELITE,

	VGR_ASSAULTFRIGATE,
	VGR_HEAVYMISSILEFRIGATE,
	VGR_INFILTRATORFRIGATE,

}

-- can capture other ships
squadclass[eCapture] = {
	HGN_MARINEFRIGATE,
	HGN_MARINEFRIGATE_SOBAN,
	VGR_INFILTRATORFRIGATE,
}

-- has shields
squadclass[eShield] = {
	HGN_DEFENSEFIELDFRIGATE,
	hgn_battlecruiser,
	hgn_battleship,
	Hgn_Carrier,
}

-- is a platform
squadclass[ePlatform] = {
	HGN_GUNTURRET,
	HGN_IONTURRET,

	VGR_WEAPONPLATFORM_GUN,
	VGR_WEAPONPLATFORM_MISSILE,
	VGR_HYPERSPACE_PLATFORM,
}

-- good at attacking fighters
squadclass[eAntiFighter] = {
	HGN_INTERCEPTOR,
	HGN_ASSAULTCORVETTE,
	HGN_ASSAULTFRIGATE,
	HGN_GUNTURRET,
	HGN_DRONE,

	VGR_INTERCEPTOR,
	VGR_ASSAULTFRIGATE,
	VGR_WEAPONPLATFORM_GUN,
	VGR_DRONE,
}

-- good at killing corvettes
squadclass[eAntiCorvette] = {
	HGN_PULSARCORVETTE,
	HGN_TORPEDOFRIGATE,
	HGN_TORPEDOFRIGATEELITE,
	HGN_DESTROYER,

	VGR_LANCEFIGHTER,
	VGR_LAZERCORVETTE,
	VGR_DESTROYER,
}

-- good at killing frigates
squadclass[eAntiFrigate] = {
	HGN_IONTURRET,
	HGN_ATTACKBOMBER,
	HGN_ATTACKBOMBERELITE,
	HGN_IONCANNONFRIGATE,
	HGN_MARINEFRIGATE,
	HGN_MARINEFRIGATE_SOBAN,
	HGN_DEFENSEFIELDFRIGATE,
	HGN_DESTROYER,
	HGN_BATTLECRUISER,
	HGN_SWORD_CRUISER,
	HGN_CROSSBOW_CRUISER,
	HGN_HEAVYDESTROYER,
	HGN_BATTLESHIP,
	HGN_HEAVYBATTLECRUISER,


	VGR_BOMBER,
	VGR_HEAVYMISSILEFRIGATE,
	VGR_INFILTRATORFRIGATE,
	VGR_DESTROYER,
	VGR_BATTLECRUISER,
	VGR_WEAPONPLATFORM_MISSILE,
	VGR_HELIOS,
	VGR_QWAARJETII,
	VGR_VANAARJET,
	VGR_BATTLESHIP,
}

-- is a capital ship
squadclass[eCapital] = {
	HGN_CARRIER,
	HGN_MOTHERSHIP,
	HGN_SHIPYARD,
	HGN_DESTROYER,
	HGN_BATTLECRUISER,
	HGN_SWORD_CRUISER,
	HGN_CROSSBOW_CRUISER,
	HGN_HEAVYDESTROYER,
	HGN_DREADNAUGHT,
	HGN_BATTLESHIP,
	HGN_HEAVYBATTLECRUISER,
	HGN_SUPERCARRIER,

	VGR_CARRIER,
	VGR_MOTHERSHIP,
	VGR_MOTHERSHIP_MAKAAN,
	VGR_SHIPYARD,
	VGR_DESTROYER,
	VGR_HELIOS,
	VGR_QWAARJETII,
	VGR_BATTLESHIP,
	VGR_VANAARJET,
	VGR_BATTLECRUISER,
}
-- eCollector + eScout (maybe refineries - but those things are pretty tough?)
-- this is currently only used to count the number of 'military units' the player/enemy has
squadclass[eNonThreat] = {
	HGN_RESOURCECOLLECTOR,
	VGR_RESOURCECOLLECTOR,
	HGN_RESOURCECONTROLLER,
	VGR_RESOURCECONTROLLER,

	HGN_CARRIER,
	HGN_MOTHERSHIP,
	HGN_SHIPYARD,
	HGN_SUPERCARRIER,
	VGR_CARRIER,
	VGR_MOTHERSHIP,
	VGR_MOTHERSHIP_MAKAAN,
	VGR_SHIPYARD,

	HGN_SCOUT,
	HGN_PROBE,
	HGN_PROXIMITYSENSOR,
	HGN_ECMPROBE,

	VGR_SCOUT,
	VGR_PROBE,
	VGR_PROBE_PROX,
	VGR_PROBE_ECM,

	VGR_HYPERSPACE_PLATFORM,
}

-- is a hyperspace gate
squadclass[eHyperspaceGate] =
{
	VGR_HYPERSPACE_PLATFORM
}

-- good at killing subsystems
squadclass[eSubSystemAttackers] =
{
	HGN_ATTACKBOMBER,
	HGN_ATTACKBOMBERELITE,
	VGR_BOMBER,
}

-- non critical subsystems
squadclass[eNonCriticalSubSys] =
{
	CLOAKGENERATOR,
	FIRECONTROLTOWER,
	HYPERSPACEINHIBITOR,
	ADVANCEDARRAY,
	CLOAKSENSOR,
	PlanetSmasher,
}

-- good at killing repairing collectors
squadclass[eGoodRepairAttackers] =
{
	HGN_INTERCEPTOR,
	HGN_ASSAULTFRIGATE,
	HGN_IONCANNONFRIGATE,
	HGN_DESTROYER,
	HGN_HEAVYDESTROYER,
	HGN_SWORD_CRUISER,
	HGN_BATTLECRUISER,

	VGR_INTERCEPTOR,
	VGR_MISSILECORVETTE,
	VGR_ASSAULTFRIGATE,
	VGR_DESTROYER,
	VGR_HELIOS,
	VGR_BATTLECRUISER,

}

-------------------------------------------
-- CUSTOM classes

-- do not exceed eMaxUserCount(32)

eUselessShips = eMaxCount
eBattleCruiser = eMaxCount + 1
-- this number should be one greater then the highest class
sg_maxClasses = eBattleCruiser+1

-- ships that the AI should not build because they are not used properly
squadclass[ eUselessShips ] =
{
	HGN_MINELAYERCORVETTE,

	VGR_MINELAYERCORVETTE,
	VGR_COMMANDCORVETTE,
}

-- is a battlecruiser
squadclass[eBattleCruiser] =
{
	HGN_BATTLECRUISER,
	HGN_BATTLESHIP,
	HGN_HEAVYBATTLECRUISER,

	VGR_BATTLESHIP,
	VGR_BATTLECRUISER,
	VGR_VANAARJET,
	VGR_DREADNAUGHT,
}

--
-- FUNCTIONS TO ADD SQUADRON TYPES TO CLASS SYSTEM
--

function FastAddToClass( tbl, classid )
	for a,b in tbl do
		AddToClass( b, classid )
	end
end

function ClassInitialize()

	for i=0, sg_maxClasses do
		if (squadclass[i]) then
			FastAddToClass( squadclass[i], i )
		end
	end

	-- debug: name all the classes to be displayed on screen
	AddClassName( eMotherShip, "Motherships")
	AddClassName( eCollector, "Collectors")
	AddClassName( eDropOff, "DropOffs")
	AddClassName( eFighter, "Fighters")
	AddClassName( eFrigate, "Frigates")
	AddClassName( eCorvette, "Corvettes")
	AddClassName( eCapital, "Capital")
	AddClassName( eAntiFighter, "AntiFighter")
	AddClassName( eAntiCorvette, "AntiCorvette")
	AddClassName( eAntiFrigate, "AntiFrigate")
	AddClassName( ePlatform, "Platform")
	AddClassName( eRefinery, "Refinery")
	AddClassName( eHyperspaceGate, "HypGates")
	AddClassName( eShield, "Shields")
	AddClassName( eCapture, "Capture")
	AddClassName( eSubSystemAttackers, "SubSysKillas")
	AddClassName( eBattleCruiser, "BattleCruiser")


end

