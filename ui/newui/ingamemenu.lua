Lua@ 	�[����A,   @X:\Homeworld2\Data\UI\NewUI\InGameMenu.lua                 �  ����          	   
                        ����      ����   !   "   #   %   '   )   +   -   /   ����2   4   ����6   9   :   ;   =   ?   A   C   E   G   ����J   L   N   Q   R   S   U   W   Y   [   ]   _   ����b   d   ����f   i   j   k   m   o   q   s   u   w   ����z   |   ����~   �   �   �   �   �   �   �   �   �����   �   �����   �   �   �   �   �   �   �   �   �����   �   �����   �   �   �   �   �   �   �   �   �����   �   �����   �   �   �   �   �   �   �   �   �����   �   �����   �   �   �   �   �   �   �   �   �����   �   �����   �   �   �   �   �   �   �   �   �����      ����        	          ����    ����          !  #  %  '  )  ����,  .  ����0  3  4  5  7  9  ;  =  ?  A  ����D  F  ����H  K  L  M  O  Q  S  U  W  Y  ����\  ^  ����`  c  ����d  e  g  i  k  m  o  q  ����t  v  ����x  {  ����|  }    �  �  �  �  �  �����  �  �����  �  �����  �  �  �����  �  �����  �����  �  �����  �����  �  �  �  �  �����  �  �  �  �  �  �  �����  �  �  �����  �  �  �  �  �  �  �����  �  �  �  �  �  �  �      ����            ����    ����             "  $  ����'  (  )  *  +  ,  -  .  /  1  ����2  4  6  8  :  <  >  @  ����C  D  E  F  G  H  I  K  ����L  N  P  R  T  V  X  Z  ����]  ^  _  `  a  b  ����c  ����d  f  ����g  i  k  m  o  q  s  u  ����x  ����y  z  ����{  ����|  ~  ����  �  �  �  �  �  �  �  �����  �����  �  �����  �����  �  �����  �  �  �  �  �  �  �  �����  �  �  �����  �����  �  �����  �  �  �  �  �  �  �  �����  �  �  �  �  �����  �����  �  �����  �  �  �  �  �  �  �  �����  �  �  �����  �����  �  �����  ���}      FRM_SPACER    type    Frame    size    BTN_SAVEGAME    TextButton    buttonStyle    FEButtonStyle1    name 
   m_btnSave    width    Text 
   textStyle    FEButtonTextStyle    text    $5564    helpTip    $5550    helpTipTextLabel    m_lblHelpText    onMouseClicked    FE_SaveGameScreen()    BTN_LOADGAME 
   m_btnLoad    $5565    $5551    FE_LoadGameScreen()    BTN_SAVEGAME_CAMPAIGN    m_btnSaveCampaign    $5566    $5552    FE_SaveGameScreen_Campaign()    BTN_LOADGAME_CAMPAIGN    m_btnLoadCampaign    $5567    $5553    FE_LoadGameScreen_Campaign()    BTN_LOADGAME_RECORDED    m_btnLoadRecorded    $5568    $5554    FE_LoadGameScreen_Recorded()    BTN_OPTIONS    $5569    $5555 Q   UI_SetScreenEnabled("InGameOptions", 1); UI_ShowScreen("InGameOptions", ePopup);    BTN_EXITTOWINDOWS    $5570    $5556    MainUI_UserEvent( eExit )    BTN_EXITTOMAINMENU    $5571    $5557    FE_ExitToMainMenu();    BTN_ENDCURRENTGAME    $5579    $5559    BTN_SKIRMISH_STATS %   FE_Retire("MainUI_UserEvent(eMenu)")    BTN_RETIRE    $5572    $5558    BTN_RETURNTOGAME    FEButtonStyle2    $5573    MainUI_UserEvent(eMenu);    BTN_NEXTTUTORIAL    m_btnNextTutorial    $5574    $5560    FE_NextTutorial()    BTN_RESTARTTUTORIAL    m_btnRestartTutorial    $5575    $5561    FE_RestartGame(1)    BTN_RESTARTMISSION    m_btnRestartMission    $5576    $5562    BTN_RESTARTMISSION2    m_btnRestartMission2    FE_RestartGame(0)    BTN_RESTART    m_btnRestart    $5563    InGameMenu    stylesheet    HW2StyleSheet    RootElementSettings    backgroundColor    FEColorBackground2    pixelUVCoords    soundOnShow    SFX_GameMenuONOFF    soundOnHide 	   position    FEColorDialog 	   autosize    outerBorderWidth    borderColor    FEColorPopupOutline    style    FEPopupBackgroundStyle 
   TextLabel    FEHeading3    $5577    offset    vAlign    Top    m_lblSubTitle    FEHeading4    $5578    frmButtonGroup    autoarrange    autoarrangeSpace    frmButtons_PlayerVsCpu    visible    frmButtons_PlayerVsCpuFailed    frmButtons_Campaign    frmButtons_CampaignFailed    frmButtons_Multiplayer    frmButtons_MultiplayerFailed    frmButtons_Tutorial    frmButtons_RecordedGame         �  �   G   �   �   �   �; � ��   �        G   G  �  �    G  �  �; ��  �     G  �  �  �     G  �  �    G        G   G    �  �  �  �  �; ��  �     G  �    �     G  �  �    �    �    G   G  �  �      �  �; ��  �     G  �  G  �     �  �  �    �    �    G   G    G  �  �  �  �; ��  �     G  �  �  �     �  �  �    	        G   G    �	  �  �  �  �; ��  �     G  �  �	  �     
  �  �    G
    S	  �  G   G  �  �  �  �; ��  �     G  �  �
  �       �  �    G  �  �
  �  G   G  �  �  �  �; ��  �     G  �  �  �       �  �    G  �  �  �  G   G  �  �  �  �; ��  �     G  �  �  �       �  �    G  �  �  �  G   G  �  �  �  �; ��  �     G  �  �  �       �  �    G  �  �  �  G   G  �  �  �  �; ��  �     G  �  �  �       �  �    �  �  S  �  G   G  �  �  �  �; ��  �     G  �    �     G  �  �    �  �  �  �  G   G  �  �  �  �; ��  �     G  �    �       �  �    G  �  �    G   G    �  �  �  �  �; ��  �     G  �    �     G  �  �    �    �    G   G      �  �  �  �; ��  �     G  �  G  �     �  �  �    �    �    G   G    G  �  �  �  �; ��  �     G  �  �  �     �  �  �    �        G   G    G  �  �  �  �; ��  �     G  �  �  �     �  �  �    �        G   G      �  �  �  �; ��  �     G  �  �  �     G  �  �    �    �  �  �     �������� �ƕ �  �    G  Q   �  �  V       �G  �  �  �  �    G   �     �   FD ��, ��   �  G  �    �  �  G   �   �  F  �  �   �  ��  ��   �   �   �< �� ��     G  �  �  �    G       �   ���F  ��   �   �   �1 �F ��   �      G  �  �  �  �   � �����     G      Q    �   ��� ��   G       �  �   �   �1 �F ��   �  �     �  �    �  �   � �����   �   V  �  G   �     G    �   ���F ��   �    ��    ��  �  ��    Q  G   �   �  F  �      G  �    ��    ��  F  �G  ���    �  �
  �  �  L  �     �  U  �  G   �   �  F  �  �    G  �    ��    ��  F  �G  ���  �  �
  L  �  �     �  �    G   �   �  F  �  �    G  �    ��    ��  F  �G  ���    �    �
  �  �     �    Q  G   �   �  F  �      G  �    ��    ��  F  �G  ���    �  �       U  Q  G   �   �  F  �  G    G  �    ��    ��  F  �G  ���  �
  �  �     �  U  Q  G   �   �  F  �  �    G  �    ��    ��  F  �G  ���  �
  �  �     �  U  �  G   �   �  F  �  �    G  �    ��    ��  F  �G  ���  �  �  �
  �  �     �  �  Q  G   �   �  F  �      G  �    ��    ��  F  �G  ���  �
  �  �     �  U  U  �      