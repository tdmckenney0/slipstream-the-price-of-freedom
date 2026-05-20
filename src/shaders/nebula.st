static Texture $diffuse

simple defaultPass(Texture $diffuse)
{
    setCap depthBufferCap true
    setCap gouraudCap true
    setCap cullCap false
    setCap texture0Cap true    
    setCap blendCap true
    setCap rescaleNormalCap true
-- setCap fogCap true    
    depthWrite false
    
	
	srcBlend oneBlend
    destBlend oneBlend

    # TPOF shader refresh (phase 2b): cooler, dimmer specular for gritty deep-space nebulae
    material specular  0.35 0.35 0.40 1
    material shininess 40 40 40 40

    textureMode	modulateMode
    
    activeTexture 0
    texture $diffuse     
}

compound nebula()
{
    addPass defaultPass
}
    