AttackStyleName = FaceTarget
Data = {
  inRangeFactor=0.95,
  tooSlowSpeed=100,
  tooFastMultiplier=2.0,
  facingAngle=0,
  tryToMatchHeight = 0, 
  tryToGetAboveTarget=0,
  SlideDistanceMultiplier=0.5,
  flyToTargetBecauseItsFarOutOfRangeDelay = 0, 
  flyToTargetBecauseItsMovingAwayDelay = 1, 
  stopAndFaceTheTargetDelay = 0, 
  RandomActions = {
    {
      Type = PickNewTarget,
      Weighting = 10,
    },
    {
      Type = InterpolateTarget,
      Weighting = 10,
    },
    {
      Type = NoAction,
      Weighting = 500,
    },
  },
  BeingAttackedActions = {},
  FiringActions = {
    { 
            Type = PickNewTarget, 
            Weighting = 1, }, 
   {
      Type = NoAction,
      Weighting = 50,
    },
  },
}
