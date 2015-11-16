smTwkBlinkTime = 0.3
smTwkZoomTime = 0.5
smTwkZoomMainView = 0.5
smTwkZoomOutDistance = 12000
smTwkMinZoomOutDistance = 10000
smTwkMaxZoomOutDistance = 45000
smTwkNearClipPlane = 4000
smTwkFarClipPlane = 200000
smTwkFocusCull = 10000
smTwkMaxMovementDistance = 60000
smTwkWidescreen = 1
smTwkBlinkTransitionTime = 0.07
smTwkBlinkOnFraction = 0.8
smTwkHighlightMaxAlpha = 0.3

friendlyPixelSize = 2
alliedPixelSize = 2
enemyPixelSize = 2
missilePixelSize = 2
miscPixelSize = 2

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
horizonRadius = 120000
horizonHeight = 0.07
horizonNumberScale = 0.07
horizonNumberAspect = 1.6

-- Colors --

worldPlaneColour = { 0, 0, 0, 0, }
worldLineColour = { 1, 1, 1, 1, }

missilePixelColour = { 1, 1, 0.2, 1, }
friendlyPixelColour = { 1, 1, 1, 1, }
alliedPixelColour = { 0, 1, 1, 1, }
enemyPixelColour = { 1, 0, 0, 1, }
neutralPixelColour = { 0.9, 0.9, 0.3, 1, }
miscPixelColour = { 1, 1, 1, 1, }

worldGraphics = {

	{
		scaleParam = SPI_WorldPlaneScale,
		colourParam = SPI_WorldLineColour,
		mesh = {
		
			colour = { 0, 0, 1, 0.5, },
			lineWeight = 1,
			LODs = { 1, "UI\\SensorsManager\\Meshes\\WorldPlaneWireframe.hod", },  
		},
		
		placement3D = {
		
			position = 		{ 0, 0, 0, },
			scale = 		{ 1, 1, 1, },
			visibility = 	{ 0, },
			invisibility = 	{ "SVF_FlashOff", }, 
		}, 
	},
	
	{ 
        scaleParam = SPI_WorldPlaneScale, 
        colourParam = SPI_WorldPlaneColour, 
        mesh = 
        { 
        	texture = "data:UI\\SensorsManager\\textures\\disc_tex.tga",
            colour = 
                { 0.64, 0.46, 0, 0.2, }, 
            lineWeight = 1, 
            LODs = 
                { 1, "UI\\SensorsManager\\Meshes\\DiskAbove.hod", }, }, 
        placement3D = 
        { 
            position = 
                { 0, 0, 0, }, 
            scale = 
                { 1, 1, 1, }, 
            visibility = 
                { "SVF_Above", }, 
            invisibility = 
                { "SVF_FlashOff", }, }, }, 
	
	
	{ 
        scaleParam = SPI_WorldPlaneScale, 
        colourParam = SPI_WorldPlaneColour, 
        mesh = 
        { 
        	--texture = "data:UI\\SensorsManager\\textures\\disc_tex.tga",
            colour = 
                { 0.64, 0.46, 0, 0.2, }, 
            lineWeight = 1, 
            LODs = 
                { 1, "UI\\SensorsManager\\Meshes\\DiskBelow.hod", }, }, 
        placement3D = 
        { 
            position = 
                { 0, 0, 0, }, 
            scale = 
                { 1, 1, 1, }, 
            visibility = 
                { "SVF_Below", }, 
            invisibility = 
                { "SVF_FlashOff", }, }, },
	
}
