Lua@ 	ć[Ą°š˛A-   @X:\Homeworld2\Data\UI\NewUI\TacticsMenu.lua                 h   ˙˙˙˙          ˙˙˙˙
   ˙˙˙˙      ý˙˙˙   ˙˙˙˙   ú˙˙˙   ˙˙˙˙   ý˙˙˙         "   '   *   ý˙˙˙+   -   /   4   9   <   ý˙˙˙=   ?   D   I   P   R   T   V   X   ]   d   g   h   ü˙˙˙i   k   m   o   q   v   {   }         ţ˙˙˙         ˙˙˙˙                     Ą   Ł   Ľ   ţ˙˙˙Ť   ­   °   ˙˙˙˙ą   ł   ľ   ˇ   ˙˙˙˙š   ž   Ă   Ĺ   Ç   É   ţ˙˙˙Ď   Ń   Ô   ˙˙˙˙Ő   ý˙˙˙Ö   Ř   ˙˙˙˙Ú   ß   ä   ç   č   é   ý˙˙-      TacticsMenu    size    stylesheet    HW2StyleSheet    claimMousePress    RootElementSettings    onMouseClicked #   UI_ToggleScreen( 'TacticsMenu', 0)    pixelUVCoords    onShow 	  
	UI_SetButtonPressed('NewTaskbar', 'btnTactics', 1);
	UI_SetButtonTextHotkey('TacticsMenu', 'btnPassive', '$3132', 34); 
	UI_SetButtonTextHotkey('TacticsMenu', 'btnDefensive', '$3131', 35); 
	UI_SetButtonTextHotkey('TacticsMenu', 'btnAggressive', '$3130', 36); 
	    onHide 3   UI_SetButtonPressed('NewTaskbar', 'btnTactics', 0)    type    Frame    name 
   rootFrame 	   position    giveParentMouseInput    menu    backgroundColor    IGColorBackground1 
   TextLabel    borderColor    borderWidth    Text 
   textStyle    IGHeading2    hAlign    Left    offset    color    text    $2733    TextButton    buttonStyle    RightClickMenu_ButtonStyle    btnPassive    toggleButton    font    ButtonFont    onMouseReleased 	   hotKeyID    btnDefensive    btnAggressive         ë     G     Ć˙˙Ć˙˙ĆÇ Ć      Ç       G  Q     Ç  V       G    Ç    Ö  Ń  G    Ç    G     Ć˙˙Ć˙˙   G      ĆÇ Ć        V  Q  G    Ç  Ç  G      Ćo    G      F"       G  V    G    G     F˙˙Ć˙˙   G      F# F    Ç    F* 8 ? ?     F  G  Q    Ç    G       Ć Ć˙˙   Ç    ? ? ? ?     G  V    Q  G    Ç  	  Ç  G	  	  Ć˙˙G     F      G      ! Ć    G  Ń   Ç	  
    G       Ć  Ć˙˙   Ö   G
  Ç  
  F V  Q  G    Ç  	  Ç  Ç
  	  Ć˙˙G     F      G      ! Ć    G  Ń   Ç	  
    G       Ć  Ć˙˙   Ö   G
  Ç  
   V  Q  G    Ç  	  Ç    	  Ć˙˙G     F      G      ! Ć    G  Ń   Ç	  
    G       Ć  Ć˙˙   Ö   G
  Ç  
  Ć V    Q  G    Ç  Ç  G     %     G             Ç  V     U          