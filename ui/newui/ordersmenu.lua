-- LuaDC version 0.9.20
-- 11/11/2008 7:35:16 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--

function OrdersMenuCreateItem(pName, pOnMouseClicked, pText, pOrderInList, pHotKeyID)
    return {
        type = "TextButton",
        buttonStyle = "RightClickMenu_ButtonStyle",
        name = pName,
        toggleButton = 0,
        position = { 2, 7 + (pOrderInList * 14), },
        size = { 133, 12, },
        Text =
        {
            font = "ButtonFont",
            hAlign = "Left",
            offset = { 4, 0, },
            text = pText,
        },
        onMouseReleased = "UI_ToggleScreen( 'OrdersMenu', 0)",
        onMouseClicked = pOnMouseClicked,
        hotKeyID = pHotKeyID,
    }
end

function OrdersMenuCreateDivider(pName, pOrderInList)
    return {
        type = "Line",
        p1 = { 2, 7 + (pOrderInList * 14), },
        p2 = { 133, 7 + (pOrderInList * 14), },
        lineWidth = 1,
        color = "TPOFBlack",
    }
end

OrdersMenu =
{
    size =
        { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    claimMousePress = 1,
    RootElementSettings =
    {
        onMouseClicked = "UI_ToggleScreen( 'OrdersMenu', 0)", },
    pixelUVCoords = 1,
    onShow = "UI_SetButtonPressed('NewTaskbar', 'btnOrders', 1);\n	UI_SetButtonTextHotkey('OrdersMenu', 'btnForm1', '$2735', 28); \n	UI_SetButtonTextHotkey('OrdersMenu', 'btnForm2', '$2736', 29); \n	UI_SetButtonTextHotkey('OrdersMenu', 'btnForm3', '$2737', 30); \n	UI_SetButtonTextHotkey('OrdersMenu', 'btnLeave', '$3135', 31); \n	",
    onHide = "UI_SetButtonPressed('NewTaskbar', 'btnOrders', 0)",
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
        { 79, 600 - (2 + 21 + 20 + (7 + (14 * 20))), },
    size =
        { 138, 21 + (7 + (14 * 20)), },
    outerBorderWidth = 1,
    borderColor = "TPOFBlack",
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
        textStyle = "IGHeading1",
        hAlign = "Left",
        offset =
            { 8, 0, },
        color = "TPOFBlack",
        text = "ORDERS", 
    },
},
OrdersMenuCreateItem("btnMove", "MainUI_UserEvent( eMove)", "$3151", 1, 10),
OrdersMenuCreateItem("btnAttack", "MainUI_UserEventData( eControlModifier, 0)", "$3152", 2, 115),
OrdersMenuCreateItem("btnAttackMove", "MainUI_UserEvent( eMoveAttack )", "$5323", 3, 25),
OrdersMenuCreateItem("btnGuard", "MainUI_UserEvent( eGuard)", "$3153", 4, 14),
OrdersMenuCreateItem("btnDock", "MainUI_UserEvent( eDock)", "$3154", 5, 15),
OrdersMenuCreateItem("btnWaypoint", "MainUI_UserEvent( eTempWaypoint)", "$3155", 6, 56),
OrdersMenuCreateItem("btnResource", "MainUI_UserEventData( eHarvest, 0); MainUI_UserEventData( eHarvest, 1);", "$5310", 7, 12),
OrdersMenuCreateItem("btnHyperspace", "MainUI_UserEvent( eHyperspace)", "$5309", 8, 11),
OrdersMenuCreateItem("btnRetire", "MainUI_UserEvent( eRetire)", "$3157", 9, 23),
-- Special Commands (May need separate menu)
OrdersMenuCreateItem("btnPing", "MainUI_UserEvent( eSensorPing)", "$3177", 10, 147),
OrdersMenuCreateItem("btnEMP", "MainUI_UserEventData2( eSpecialAttack, 0, 2)", "$2768", 11, 146),
OrdersMenuCreateItem("btnDefenseField", "MainUI_UserEvent( eDefenseField)", "$3173", 12, 143),
OrdersMenuCreateItem("btnCloak", "MainUI_UserEvent( eCloak)", "$3174", 13, 144),
OrdersMenuCreateItem("btnRepair", "MainUI_UserEvent( eRepair)", "$3189", 14, 20),
OrdersMenuCreateItem("btnMines", "MainUI_UserEvent( eDropMinesInstant)", "$3180", 15, 24),
OrdersMenuCreateItem("btnRally", "MainUI_UserEvent( eRallyPoint)", "$5319", 16, 138),
OrdersMenuCreateItem("btnRallyObject", "MainUI_UserEventData( eRallyObject, 0 )", "$5320", 17, 22),
OrdersMenuCreateItem("btnScuttle", "MainUI_UserEvent( eScuttle)", "$3181", 18, 5),
OrdersMenuCreateDivider("divider", 19),
OrdersMenuCreateItem("btnCancelOrders", "MainUI_UserEvent( eCancelOrders)", "$3156", 20, 17),
},
{
    type = "Frame",
    name = "menu",
    position =
        { 80, 514, },
    size =
        { 72, 19, },
    onMouseClicked = "UI_ToggleScreen( 'OrdersMenu', 0)", },
},
}
