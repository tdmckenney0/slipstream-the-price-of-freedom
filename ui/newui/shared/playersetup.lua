Lua@ 	ę[”°¹²A4   @X:\Homeworld2\Data\UI\NewUI\Shared\PlayerSetup.lua          :       @  ’’’’          ’’’’
      ż’’’      ž’’’            "   ü’’’#   %   *   /   2   ż’’’3   5   :   @   ’’’’A   C   H   J   M   N   ż’’’O   Q   V   X   Z   \   _   ž’’’`   b   g   i   l   ’’’’m   o   t   v   y   ’’’’z   |   ~                        ’’’’                   ż’’’”   £   ’’’’Ø   Ŗ   ¬   ®   °   ²   “   ¶   ¹   ŗ   ’’’’»   ½   ž’’’Ā   Ä   Ę   Č   Ź   Ģ   Ļ   Š   ż’’’Ń   Ó   Ų   Ż   ß   į   ć   ę   ē   ’’’’č   ź   ģ   ī   ó   õ   ÷   ł   ü   ż’’’ż   ’     	            ’’’’         "  $  &  -  0  ’’’’1  3  5  7  9  ;  ’’’’>  A  ’’’’B  D  F  H  J  L  ’’’’O  R  ’’’’S  U  X  ż’’’Y  [  `  e  g  i  l  ż’’’m  o  t  y  {  }      ’’’’      ’’’’            ”  ¤  ’’’’„  §  ¬  ±  ³  ø  ŗ  ’’’’Ā  Å  ’’’’Ę  Č  Ķ  Ņ  Ō  Ö  Ū  Ż  ä  ’’’’ģ  ļ  ’’’’š  ņ  ÷  ü  ž         ’’’’      ’’’’        "  $  &  -  ’’’’5  8  ’’’’9  ;  =  B  G  I  K  R  ’’’’Z  ]  ^  ’’’’_  a  f  h  j  ’’’’r  u  v  ’’’’w  y  ~            ’’’’             ¢  ’’’’Ŗ  ­  ’’’’®  °  µ  ŗ  ¼  ¾  Ć  Å  Ģ  ’’’’Ō  ×  ’’’’Ų  Ś  ß  ä  ę  č  ķ  ļ  ’’’’÷  ś  ’’’’ū  ż  ’    	        ’’’’       !  ’’’’"  $  )  +  -  ’’’’5  8  9  ż’’’:  <  >  C  H  P  ž’’’Q  S  U  Z  _  a  f  h  ’’’’p  s  ’’’’t  v  x  }          ’’’’      ’’’’      ”  ¦  Ø  Ŗ  ’’’’­  Æ  ±  “  ż’’’µ  ·  ¹  ¾  Ć  Å  Ē  É  ’’’’Ģ  Ī  Õ  Ü  ć  ź  ń  ų  ’  ’’’’      ’’’’                 ’’’’#  %  ,  3  :  A  H  O  V  ’’’’]  _  b  ż’’’c  e  j  o  q  s  u  ’’’’}      ž’’’                ’’’’¢  „  ¦  ’’’’§  ©  ®  ³  µ  ·  ¼  ¾  ’’’’Ę  Č  Ė  ž’’’Ģ  Ī  Ó  Ų  Ś  Ü  į  ć  ’’’’ė  ī  ļ  ż’’’š  ņ  ō  ł  ū  ż     ż’’’                ’’’’     "  '  )  0  7  >  @  E  J  L  S  ’’’’[  ]  b  g  i  p  ’’’’x  z          ’’’’      ’’’’      ¤  ¦  ­  “  »  ½  Ą  Į  ż’’’Ā  Ä  Ę  Ė  Ķ  Ļ  Ń  Ó  ’’’’Ö  Ų  Ū  ż’’’Ü  Ž  ć  å  ē  é  ’’’’ģ  ī  š  ó  ’’’’ō  ö  ū  ż  ’    ’’’’            ż’’      PlayerSetup    size    stylesheet    HW2StyleSheet    RootElementSettings    backgroundColor    FEColorBackground2    pixelUVCoords    type    Frame 	   position    FEColorDialog    style    FEPopupBackgroundStyle    borderWidth    borderColor    FEColorPopupOutline 	   autosize    autoarrange    outerBorderWidth 
   TextLabel    name    helpTip    Text 
   textStyle    FEHelpTipTextStyle    offset    marginWidth    marginHeight    text    $2775    FEHeading3    hAlign    Left    vAlign    Top    $2776    FEHeading4    $2789 
   TextInput 	   chatname    textInputStyle    FETextInputStyle    width    maxTextLength    helpTipTextLabel    $2791    $2777    DropDownListBox    raceselect 	   selected    ListBox    TextListBoxItem    buttonStyle    FEListBoxItemButtonStyle    resizeToListBox    FEListBoxItemTextStyle    $2787    onMouseClicked o   UI_SetElementVisible("PlayerSetup", "shippreview", 1); UI_SetElementVisible("PlayerSetup", "vshippreview", 0);    $2788 o   UI_SetElementVisible("PlayerSetup", "shippreview", 0); UI_SetElementVisible("PlayerSetup", "vshippreview", 1);    $2792    Line    p1    p2    above    color 
   lineWidth    grid    visible    BackgroundGraphic    texture #   DATA:UI\NewUI\PlayerSetup\grid.tga 
   textureUV    $2793    shippreview (   DATA:UI\NewUI\PlayerSetup\ship_base.tga    giveParentMouseInput    shipteamcolor -   DATA:UI\NewUI\PlayerSetup\ship_teamcolor.tga    shipstripecolor /   DATA:UI\NewUI\PlayerSetup\ship_stripecolor.tga    hgn_emblem1    DATA:Badges/Hiigaran.tga    hgn_emblem2 (   DATA:UI\NewUI\PlayerSetup\labeltext.tga    vshippreview )   DATA:UI\NewUI\PlayerSetup\vship_base.tga    vshipteamcolor .   DATA:UI\NewUI\PlayerSetup\vship_teamcolor.tga    vshipstripecolor 0   DATA:UI\NewUI\PlayerSetup\vship_stripecolor.tga    vgr_emblem )   DATA:UI\NewUI\PlayerSetup\vlabeltext.tga    emblemback    emblemstripes &   DATA:UI\NewUI\PlayerSetup\stripes.tga    emblem    TextButton    FEButtonStyle2    $2779    FEButtonTextStyle "   UI_ShowScreen( 'EmblemSelect', 0)    $2794    RadioButton 
   teamcolor    $2781    dropShadow    overBorderColor    pressedBorderColor 
   textColor    overTextColor    pressedTextColor    clickedColor    clickedTextColor    $2795    stripecolor    $2782    $2796    colorpicker *   DATA:UI\NewUI\PlayerSetup\colorpicker.tga    $2797    cursor *   DATA:UI\NewUI\PlayerSetup\colorcursor.tga 
   greyscale (   DATA:UI\NewUI\PlayerSetup\greyscale.tga    $2778 )   DATA:UI\NewUI\PlayerSetup\greycursor.tga    colorswatches    autoarrangeWidth    colorswatch    Button 
   savecolor &   DATA:UI\NewUI\PlayerSetup\arrowup.tga    OverGraphic    PressedGraphic    $2783 
   pickcolor    $2784    restoreDefaults    FEButtonStyle1    $2805    $2806    $2613    cancelbutton    $2798    $2612    acceptbutton    $2799           Q  G     Ę’’Ę’’ĘĒ Ę      Ē     Q   G    V   Ē          G       % F    G      F| q    G  Ē        G       Ę  Ę     G      Fz Ę      G        G       F  F     G      F{ Ę    Ö       G  G      F{ F      F  Ē      U       G             G        Ē    Ē          G  G      Ęz @        Ē          G  G      Ęz Ę        Ē            G    G      Ęz         Ē    Ē       G       Ę  Ę’’            G  G      Ęz         Ē                    F     G    Ē  Ę’’  Ę’’Ē    G      Ē    G    Ē                      G    Ē    G  	    G	    G    Ē      Q           F Ę    G      F<     Ē  F Ē     G  	    G	     V      Ē	  G  
  G
  
       F> Ę    Ē
  F<   Ę G          Q           F Ę    G      F<     Ē  F Ē     G  Ē    G	     V             F> Ę    G      F<     G  G    Ę’’Ē    G    Ę’’Ę’’Ę’’?   Ē
  F<    Q      G    Ē    Ē         G  G       Ē  V  Q      G    Ē    Ē         G         G  V     G              Ē             G     Ę{       Ę’’Ē      F        G       F     G      Fy Ę5    G  G      Ē       G      Ę’’Ę’’Fy Ę5      G      Ē    Q    G       F     G      Fy Ę5    G        G      Ē  Ö      G            G      ĘJ F/    Ē  Ń   G      ĘJ F/      G      Ę’’Ę’’ĘJ F/   Ö       V  Ń    G       Ę’’Ę’’   G      ĘJ F/    G  Ē  Ē    G      ĘJ F/            Ę’’Ę’’ĘJ F/   Ē    F F+ 3 ?               G       Ę’’Ę’’   G      ĘJ F/    G  G  Ē  Ń   G      ĘJ F/            Ę’’Ę’’ĘJ F/   Ö         U       G  G  Ē       F     G      F F    Ē  Ń           Ę Ę Ę’’Ę’’  Ē    Ę; Ę; Ę; ?   Ö             G  G  G       F F#    G      F F    Ē  Ń           Ę’’Ę’’Ę Ę   Ē    Ę1 Ę1 Ę1 ?   Ö         Õ       G  G      Fy Ę5    Ē             Ę’’Ę’’Fy Ę5               Q    G       F     G      Fy Ę5    G  Ē    Ę’’G      Ē  Ö      G       Ę F
    G      Fm Ę    Ē  Ń   G      Fm Ę            Ę’’Ę’’Fm Ę   Ö       V      G       Ę’’Ę’’   G      Fm Ę    G  G  Ē    G      Fm Ę            Ę’’Ę’’Fm Ę   Ē    F F+ 3 ?               G       Ę’’Ę’’   G      Fm Ę    G  Ē  Ē  Ń   G      Fm Ę            Ę’’Ę’’Fm Ę   Ö             G  G  G       Ę F    G      F F    Ē  Ń           Ę’’Ę’’Ę Ę   Ē    ? ? ? ?   Ö            U       G  G      Fy Ę5    Ē             Ę’’Ę’’Fy Ę5               Ń    G  G  Ē       F ĘL    G      F= Ę    G    F F+ 3 ?   V      G  G         F Ę’’   G      Ę% Ę    Ē  Ń   G      Ę% Ę      G         ?    Ö             G  G          Ę    G      Ę Ę    Ē  Ń   G      Ę Ę            Ę’’Ę’’Ę Ę   Ö                Ē  G         F Fc    G      F=     Ē     G  G           Ē  G              G  G         F I    G      F     Ē  Ń   G  Ē          Ö       Ē    Ę’’Ę’’Ę’’Ę’’  G    ? ? ? Ę       ? ? ? ?   Ē    ? ? ? ?       ? ? ? ?   G    ? ? ? ?       Ę’’Ę’’Ę’’?   Ē    ? ? ? ?   G              G  G  G       F  I    G      F     Ē  Ń   G            Ö       Ē    Ę’’Ę’’Ę’’Ę’’  G    ? ? ? Ę       ? ? ? ?   Ē    ? ? ? ?       ? ? ? ?   G    ? ? ? ?       Ę’’Ę’’Ę’’?   Ē    ? ? ? ?   G      Ē        G       F? P    G      7 Ę    G    Ē       G      Ę’’Ę’’Ę Ę      G        Ö      G       ž’ž’   G           G  Ē  Ē  Ń   G                   Ę’’Ę’’    Ö         U       G       w P    G       Ę    G  G  Ē  Ń   G       Ę            Ę’’Ę’’Ę Ę   Ö   G      Ē  Ö      G       Ę’’’’   G            G  Ē  Ē  Ń   G                     Ę’’Ę’’     Ö         U       G  G  G        ? I    G           Ę;   Q    G  G  Ē     Ę’’G           G    ? Ę’’Ę’’?       Ē    Ę’’Ę’’Ę’’Ę’’  Ö      !  G  G!  G               Ē    Ę’’Ę’’Ę’’Ę’’  G    ? ? ? ?       Ę’’Ę’’Ę’’Ę’’  Ē  Q       F      G             !      Ę’’Ę’’    Ē    Ę’’Ę’’Ę’’?   V  Ē!  Q       F      G             !      Ę’’Ę’’    Ē    ? ? ? ?   V  "  Q       F      G             !      Ę’’Ę’’    Ē    ? ? ? ?   V  G      G"    Q    !  G  "  G       Ę        Ē    Ę’’Ę’’Ę’’Ę’’  G    ? ? ? ?       Ę’’Ę’’Ę’’Ę’’  G      Ē"  V         Ē  G  #       F Ęl    Ē
  Ę' G  G#  Ē     G  #         G      Ē#    Ń    Ē       Ę\ Ęl    G  G#  Ē     G  $         G  G$  G      $  Ö  Ń    Ē       F> Ęl    G    Ē     G  Ē$         G  %  G      G%  Ö    U          