smTwkBlinkTime = 0.3
smTwkZoomTime = 0.5
smTwkZoomMainView = 0.5
smTwkZoomOutDistance = 12000
smTwkMinZoomOutDistance = 5000
smTwkMaxZoomOutDistance = 45000
smTwkNearClipPlane = 4000
smTwkFarClipPlane = 200000
smTwkFocusCull = 10000
smTwkMaxMovementDistance = 60000
smTwkWidescreen = 1
smTwkBlinkTransitionTime = 0.07
smTwkBlinkOnFraction = 0.8
smTwkHighlightMaxAlpha = 0.3
friendlyPixelColour = { 30 / 255, 252 / 255, 163 / 255, 1, } -- "green-ish"
alliedPixelColour = { 183 / 255, 230 / 255, 30 / 255, 1, }   -- "yellow-ish"
enemyPixelColour = { 252 / 255, 30 / 255, 141 / 255, 1, }    -- "red-ish"
neutralPixelColour = { 1, 1, 1, 1, }
friendlyPixelSize = 3
alliedPixelSize = 3
enemyPixelSize = 3
missilePixelSize = 3
missilePixelColour = { 1, 1, 0.199, 1, }
miscPixelSize = 2
miscPixelColour = { 1, 1, 1, 1, }
worldPlaneColour = { 0.5, 0.5, 0.5, 0.1, }
worldLineColour = { 0.75, 0.75, 0.75, 1, }
worldPlaneToWorldBoundSize = 1
horizonToCameraZoom = 3
letterboxAspect = 1.5
smWorldplaneFlashOnTime = 0.25
smWorldplaneFlashOffTime = 0.25
SPI_WorldPlaneScale = 1
SPI_HorizonLineScale = 2
SPI_HorizonOrigin = 3
SPI_WorldPlaneColour = 4
SPI_WorldLineColour = 5
horizonRadius = 400000
horizonHeight = 0.07
horizonNumberScale = 0.07
horizonNumberAspect = 1.6
worldGraphics =
{
    {
        scaleParam = SPI_HorizonLineScale,
        colourParam = SPI_WorldLineColour,
        mesh =
        {
            colour =
            { 1, 1, 1, 1, },
            lineWeight = 1,
            LODs =
            { 1, "UI\\SensorsManager\\Meshes\\HorizonAbove.hod", },
        },
        placement3D =
        {
            position =
            { 0, 0, 0, },
            scale =
            { 1, 1, 1, },
            visibility =
            { "SVF_Above", },
        },
    },
    {
        scaleParam = SPI_HorizonLineScale,
        colourParam = SPI_WorldLineColour,
        mesh =
        {
            colour =
            { 1, 1, 1, 1, },
            lineWeight = 1,
            LODs =
            { 1, "UI\\SensorsManager\\Meshes\\HorizonBelow.hod", },
        },
        placement3D =
        {
            position =
            { 0, 0, 0, },
            scale =
            { 1, 1, 1, },
            visibility =
            { "SVF_Below", },
        },
    },
}
