AttackStyleName = AttackRun
Data = {
  howToBreakFormation = StraightAndScatter,
  maxBreakDistance = 7500,
  distanceFromTargetToBreak = 5000,
  safeDistanceFromTargetToDoActions = 5000,
  inRangeMultiplier = 0.9,
  happilySameHeight = 0,
  TooLongOutOfRange = 2,
  useTargetUp = 0,
  moveAttackMaxDistanceMultiplier = 1.2,
  coordSysToUse = Target,
  horizontalMin = 0,
  horizontalMax = 1,
  horizontalFlip = 1,
  verticalMin = 0,
  verticalMax = 1,
  verticalFlip = 1,
  maxTimeToSpendTryingToMatchHeight = 4,
  flyToTargetBecauseItsFarOutOfRangeDelay = 0.5,
  flyToSameHeightAsTargetDelay = 0,
  flyToAboveTheTargetDelay = 0,
  RandomActions = {
    {
      Type = PickNewTarget,
      Weighting = 1,
    },
    {
      Type = InterpolateTarget,
      Weighting = 2000,
    },
    {
      Type = NoAction,
      Weighting = 5000,
    },
  },
  FiringActions = {
    {
      Type = InterpolateTarget,
      Weighting = 500,
    },
  },
}
