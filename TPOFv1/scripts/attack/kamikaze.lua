AttackStyleName = AttackRun
Data = {
  howToBreakFormation = StraightAndScatter,
 maxBreakDistance = 1,
  distanceFromTargetToBreak = 1,
  RandomActions = {
    {
      Type = PickNewTarget,
      Weighting = 1,
    },
    {
      Type = NoAction,
      Weighting = 9,
    },
  },
  BeingAttackedActions = {},
  FiringActions = {},
}
