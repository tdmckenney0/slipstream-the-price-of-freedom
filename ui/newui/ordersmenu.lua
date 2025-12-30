-- LuaDC version 0.9.20
-- 11/11/2008 7:35:16 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--

function OrdersMenuCreateItem(pName, pOnMouseClicked, pText, pOrderInList)
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
        helpTip = pText,
		helpTipTextLabel = pName,
        hotKeyID = 28,
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
        { 4, 600 - (2 + 21 + 19 + (7 + (14 * 10))), },
    size =
        { 138, 21 + (7 + (14 * 10)), },
    backgroundColor = "IGColorBackground1",
;
{
    type = "TextLabel",
    position =
        { -2, 0, },
    size =
        { 144, 18, },
    borderColor =
        { 170, 227, 255, 255, },
    borderWidth = 2,
    Text =
    {
        textStyle = "IGHeading2",
        hAlign = "Left",
        offset =
            { 8, 0, },
        color =
            { 255, 255, 255, 255, },
        text = "ORDERS", 
    },
},
OrdersMenuCreateItem("btnMove", "MainUI_UserEvent( eMove)", "$2717", 1),
OrdersMenuCreateItem("btnAttack", "MainUI_UserEventData( eControlModifier, 0)", "$2718", 2),
OrdersMenuCreateItem("btnAttackMove", "MainUI_UserEvent( eMoveAttack )", "$2724", 3),
OrdersMenuCreateItem("btnGuard", "MainUI_UserEvent( eGuard)", "$2719", 4),
OrdersMenuCreateItem("btnDock", "MainUI_UserEvent( eDock)", "$2720", 5),
OrdersMenuCreateItem("btnCancelOrders", "MainUI_UserEvent( eCancelOrders)", "$2722", 6),
OrdersMenuCreateItem("btnWaypoint", "MainUI_UserEvent( eTempWaypoint)", "$2727", 7),
OrdersMenuCreateItem("btnResource", "MainUI_UserEventData( eHarvest, 0); MainUI_UserEventData( eHarvest, 1);", "$2723", 8),
OrdersMenuCreateItem("btnHyperspace", "MainUI_UserEvent( eHyperspace)", "$2725", 9),
OrdersMenuCreateItem("btnRetire", "MainUI_UserEvent( eRetire)", "$2728", 10),
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
