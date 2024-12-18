
--========================== Pieplate Tweaks ================================

pieTwkPiePieces                    = 128                                -- number of pieplate segments
pieTwkHorizonPieces                = 24
pieTwkPieClosestDistance           = 200.0                              -- the distance from ship drop-down to moveto point that will be considered close
pieTwkMaxMovementDist              = 40000000000000                             -- maximum movement distance
pieTwkHorizontalHashMarkLength     = 5000                               -- horizon disc tick marks
pieTwkVerticalHashMarkLength       = 2000                               -- horizon disc tick marks
pieTwkHeightSnap                   = 20                                 -- ignore for now
pieTwkShipCloseToPlaneDistance     = 2000                                -- if a ship less than this many units distance above the pieplate a drop-down won't be drawn
pieTwkPieCircleSizeMax             = 0.02                               -- maximum screen percentage size of the moveto disc
pieTwkPieCircleSizeMin             = 0.01                               -- minimum screen percentage size of the moveto disc
pieTwkHeightFactor                 = 1.5                                -- affects how fast the moveTo point goes up and down
pieTwkBoxAngleFactor               = 90                                 -- affects how fast the box depth can be changed
pieTwkBlobThreshold                = 10000                              -- distance to which resource blobs get individual feet

pieTwkMoveToDiscColour             = {0,1,0,1}                          -- colour of the moveto point
pieTwkMoveToPlanarDiscColour       = {0.5,0.5,0.5,1}                      -- colour of the planar moveto point (when in height mode)
pieTwkInvalidDestinationColour     = {1,0,0,1}                          -- colour used when the pieplate is over an invalid destination
pieTwkShipOnPlaneColour            = {0,0,1,1.0}                -- colour of a ship's drop down on the pieplate
pieTwkClosestShipOnPlaneColour     = {0,1,0,1}                          -- colour of a ship's drop down on the pieplate when the moveto point is near it
pieTwkScaleUpTime                  = 1                                -- how many seconds it takes for the pieplate to scale up
pieTwkScaleDownTime                = 2                                -- how many seconds it takes for the pieplate to scale down
pieTwkSeperateDiscs                = false                              -- if this is false the transparent ring and the wireframe ring will be connected
pieLocaleID          		    = "RU"                          -- the localized ru text of hyperspace cost


-- order specific values -----------------------------------------------------
-- valid order names are:   NoOrder,Move,Attack,Build,Dock,Resource,Idle,
--                          WaypointMove,Launch,ToggleAutoLaunch,Parade,Pause,
--                          Alliance,AllianceTransfer,Research,Halt,
--                          CancelResearch,PauseResearch,PauseBuild,
--                          MoveToTopOfQueueOrder,FormStrikeGroup,SetTactics,
--                          Guard,ChangeRanges,Capture,Hyperspace,Scuttle,
--                          MoveToSob,FormHyperspaceGate,HyperspaceViaGate,
--                          SensorPing,Repair,Cloak,HyperspaceOffMap,Retire,
--                          SetRallyPoint,Despawn,LayMines,DefenseField,
--                          Kamikaze,RetireSubSystems,Salvage,AttackMove,
--                          LeaveStrikeGroup,Chat
--
-- you can override as many or as few of the default variables as you want ---

Default =
{
    innerPieColour               = {0.0, 1.0, 0, 1.0},                -- colour of the inner pieplate disc
    rangePieColour               = {0.0, 0.0, 1.0, 0.1},                -- colour of the alpha pieplate disc
    outerPieColour               = {0.5, 0.0, 0.0, 1.0},                -- colour of the outer pieplate disc
}

Hyperspace =
{
    innerPieColour               = {1, 0.0, 1.0, 1.0},                -- colour of the inner pieplate disc
    rangePieColour               = {0, 0.0, 0.8, 0.1},                -- colour of the alpha pieplate disc
    outerPieColour               = {1.0, 0.0, 1.0, 1.0},                -- colour of the outer pieplate disc
}

LayMines =
{
    innerPieColour               = {1.0, 0.0, 0.0, 1.0},                -- colour of the inner pieplate disc
    rangePieColour               = {0.8, 0.0, 0.0, 0.2},                -- colour of the alpha pieplate disc
    outerPieColour               = {1.0, 1.0, 1.0, 1.0},                -- colour of the outer pieplate disc
}

SetRallyPoint =
{
    innerPieColour               = {1.0, 1.0, 1.0, 1.0},                -- colour of the inner pieplate disc
    rangePieColour               = {0.8, 0.8, 0.8, 0.1},                -- colour of the alpha pieplate disc
    outerPieColour               = {1.0, 0.0, 1.0, 1.0},                -- colour of the outer pieplate disc
}

WaypointMove =
{
    innerPieColour               = {0.0, 1.0, 0.0, 1.0},                -- colour of the inner pieplate disc
    rangePieColour               = {0.0, 0.8, 0.0, 0.1},                -- colour of the alpha pieplate disc
    outerPieColour               = {1.0, 1.0, 1.0, 1.0},                -- colour of the outer pieplate disc
}

AttackMove =
{
    innerPieColour               = {1.0, 0.0, 0.0, 1.0},                -- colour of the inner pieplate disc
    rangePieColour               = {0.8, 0.0, 0.0, 0.1},                -- colour of the alpha pieplate disc
    outerPieColour               = {1.0, 1.0, 1.0, 1.0},                -- colour of the outer pieplate disc
}
