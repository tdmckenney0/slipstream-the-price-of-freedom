-- LuaDC version 0.9.20
-- 11/11/2008 7:35:15 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
FleetMenu =
{
    size =
        { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    claimMousePress = 1,
    RootElementSettings =
    {
        onMouseClicked = "UI_ToggleScreen( 'FleetMenu', 0)", },
    pixelUVCoords = 1,
    onShow = "UI_SetButtonPressed('NewTaskbar', 'btnFleet', 1); UI_SetButtonTextHotkey('FleetMenu', 'btnForm1', '$5453', 149); UI_SetButtonTextHotkey('FleetMenu', 'btnForm2', '$5454', 139); ",
    onHide = "UI_SetButtonPressed('NewTaskbar', 'btnFleet', 0)",
;
{
    type = "Frame",
    name = "rootFrame",
    position =
        { 0, 0, },
    size =
        { 800, 600, },
    giveParentMouseInput = 1,
;
{
    type = "Frame",
    name = "menu",
    position =
        { 4, 514, },
    size =
        { 138, 65, },
    backgroundColor = "IGColorBackground1",
    BackgroundGraphic =
    {
    texture = "DATA:UI\\NewUI\\Textures\\gradient.tga",
    textureUV =
        { 0, 0, 600, 600, }, },
;
{
    type = "TextLabel",
    position =
        { -2, 0, },
    size =
        { 144, 18, },
    Text =
    {
        textStyle = "IGHeading2",
        hAlign = "Left",
        offset =
            { 8, 0, },
        color = "TPOFBlack",
        text = "$5452", },
},
{
    type = "TextButton",
    buttonStyle = "RightClickMenu_ButtonStyle",
    name = "btnForm1",
    toggleButton = 0,
    position =
        { 2, 21, },
    size =
        { 133, 12, },
    Text =
    {
        font = "ButtonFont",
        hAlign = "Left",
        offset =
            { 4, 0, }, },
    onMouseReleased = "UI_HideScreen( 'FleetMenu'); UI_ShowScreen( 'UnitCapInfoPopup', ePopup)",
    hotKeyID = 149,
},
{
    type = "TextButton",
    buttonStyle = "RightClickMenu_ButtonStyle",
    name = "btnForm2",
    toggleButton = 0,
    position =
        { 2, 35, },
    size =
        { 133, 12, },
    Text =
    {
        font = "ButtonFont",
        hAlign = "Left",
        offset =
            { 4, 0, }, },
    onMouseReleased = "UI_HideScreen( 'FleetMenu'); UI_ShowScreen( 'BuildQueueMenu', ePopup)",
    hotKeyID = 139,
},
{
    type = "TextButton",
    buttonStyle = "RightClickMenu_ButtonStyle",
    name = "btnForm3",
    toggleButton = 0,
    position =
        { 2, 49, },
    size =
        { 133, 12, },
    Text =
    {
        font = "ButtonFont",
        hAlign = "Left",
        offset =
            { 4, 0, },
        text = "$5455", },
    onMouseReleased = "UI_HideScreen( 'FleetMenu'); UI_HideScreen( 'BuildQueueMenu'); UI_HideScreen( 'UnitCapInfoPopup');", },
},
{
    type = "Frame",
    name = "menu",
    position =
        { 2, 514, },
    size =
        { 76, 19, },
    onMouseClicked = "UI_ToggleScreen( 'FleetMenu', 0)", },
},
}
