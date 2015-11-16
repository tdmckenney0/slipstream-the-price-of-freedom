-- LuaDC version 0.9.20
-- 11/11/2008 7:34:05 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
AttackStyleName = MoveToTargetAndShoot
Data =
{
    howToBreakFormation = StraightAndScatter,
    inRangeMultiplier = 0.2,
    happilySameHeight = 50,
    m_tooLongOutOfRange = 2.5,
    moveAttackMaxDistanceMultiplier = 1.2,
    maxTimeToSpendTryingToMatchHeight = 4,
    flyToTargetBecauseItsFarOutOfRangeDelay = 0.5,
    flyToSameHeightAsTargetDelay = 2,
    flyToAboveTheTargetDelay = 1,
    RandomActions =
        {
        {
            Type = PickNewTarget,
            Weighting = 1, },
        {
            Type = InterpolateTarget,
            Weighting = 4, },
        {
            Type = NoAction,
            Weighting = 55, },
        },
    BeingAttackedActions = {},
    FiringActions = {
        {
            Type = FlightManeuver,
            Weighting = 50,
            FlightManeuverName = "RollCW", },
        {
            Type = FlightManeuver,
            Weighting = 50,
            FlightManeuverName = "RollCCW", },
			}
