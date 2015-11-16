AttackStyleName = MoveToTargetAndShoot
Data = {
  howToBreakFormation = StraightAndScatter,
  inRangeMultiplier = 0.9,
  happilySameHeight = 0,
  TooLongOutOfRange = 2,
  moveAttackMaxDistanceMultiplier = 1.2,
  facingAngle = 0,
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
      Weighting = 50,
    },
    {
      Type = NoAction,
      Weighting = 200,
    },
  },
  BeingAttackedActions = {},
  FiringActions = {
  },
}
