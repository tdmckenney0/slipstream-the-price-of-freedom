AttackStyleName = AttackRun
Data = {
  howToBreakFormation = StraightAndScatter,
  maxBreakDistance = 7000,
  distanceFromTargetToBreak = 1000,
  safeDistanceFromTargetToDoActions = 3000,
  useTargetUp = 0,
  coordSysToUse = Target,
  horizontalMin = 0,
  horizontalMax = 1,
  horizontalFlip = 1,
  verticalMin = 0,
  verticalMax = 1,
  verticalFlip = 1,
  RandomActions = {
    {
      Type = PickNewTarget,
      Weighting = 1,
    },
    {
      Type = InterpolateTarget,
      Weighting = 500,
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
