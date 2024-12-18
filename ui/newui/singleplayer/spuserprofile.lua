-- LuaDC version 0.9.20
-- 11/11/2008 7:35:18 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
UserProfile =
{
    size =
        { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    pixelUVCoords = 1,
;
{
    type = "Frame",
    position = { 273, 182, },
    size = { 254, 235, }, --254, 215
    outerBorderWidth = 1,
    borderColor = "FEColorHeading3",
    backgroundColor = "FEColorBackground1",
    BackgroundGraphic =
    {
	color = { 255, 255, 255, 255, },
        texture = "Data:UI\\NewUI\\Textures\\Gradient.tga",
        textureUV = { 0, 0, 600, 600, },
    },
;
{
    type = "TextLabel",
    position = { 10, 2, },
    size = { 250, 13, },
    Text =
    {
        textStyle = "FEHeading3",
        text = "$3516", --3506
    }, 
},
{
    type = "TextLabel",
    position = { 10, 17, },
    size = { 250, 10, },
    Text =
    {
        textStyle = "FEHeading4",
        text = "$3518", --3507
    }, 
},
{
    type = "Frame",
    position = { 4, 32, },
    size = { 246, 215, }, --246, 179
;
{
    type = "ListBox",
    position = { 1, 0, },
    size = { 243, 130, },
    name = "m_listProfiles",
    helpTipTextLabel = "m_lblHelpText",
    helpTip = "$3508",
    scrollBarSpace = 6,
},
{
    type = "Line",
    p1 = { 227, 0, },
    p2 = { 227, 130, },
    lineWidth = 1,
    color = "FEColorHeading3",
    above = 1,
},
{
    type = "TextListBoxItem",
    name = "m_itemToClone",
    buttonStyle = "FEListBoxItemButtonStyle",
    visible = 0,
    enabled = 0,
    resizeToListBox = 1,
    Text =
    {
        textStyle = "FEListBoxItemTextStyle", 
    },
    allowDoubleClicks = 1,
},
{
    type = "TextButton",
    name = "m_btnCreateNew",
    position = { 2, (96 + 38), },
    width = 242,
    buttonStyle = "FEButtonStyle1",
    helpTipTextLabel = "m_lblHelpText",
    helpTip = "$3509",
    Text =
    {
        textStyle = "FEButtonTextStyle",
        text = "$3510", 
    },
},
{
    type = "TextButton",
    position = { 2, (111 + 38), },
    width = 242,
    name = "m_btnPlayerSetup",
    helpTipTextLabel = "m_lblHelpText",
    helpTip = "$3511",
    buttonStyle = "FEButtonStyle1",
    Text =
    {
        textStyle = "FEButtonTextStyle",
        text = "$3512", 
    },
},
{
    type = "TextButton",
    position = { 2, (126 + 38), },
    width = 242,
    name = "m_btnDelete",
    buttonStyle = "FEButtonStyle1",
    helpTipTextLabel = "m_lblHelpText",
    helpTip = "$3513",
    name = "m_btnDelete",
    Text =
    {
        textStyle = "FEButtonTextStyle",
        text = "$3514", 
    }, 
},
{
    type = "Line",
    above = 0,
    lineWidth = 1,
    color = "FEColorHeading3",
    p1 = { 2, (141 + 38), },
    p2 = { 244, (141 + 38), },
},
{
    type = "TextButton",
    name = "m_btnAccept",
    position = { 2, (148 + 38), },
    visible = 1,
    width = 242,
    helpTipTextLabel = "m_lblHelpText",
    helpTip = "$3517",
    buttonStyle = "FEButtonStyle2",
    Text =
    {
        textStyle = "FEButtonTextStyle",
        text = "$2619", 
    }, 
},
},
},
{
    type = "Frame",
    position = { 12, 544, },
    size = { 776, 44, },
    name = "frmRootbottombigfrm",
;
{
    type = "Frame",
    borderWidth = 2,
    borderColor = "FEColorOutline",
    position = { 2, 2, },
    size = { 772, 40, },
    name = "frmbottomframe",
;
{
    type = "TextLabel",
    position = { 4, 4, },
    size = { 0, 0, },
    name = "m_lblHelpText",
    Text =
    {
        textStyle = "FEHelpTipTextStyle", 
    },
},
{
    type = "Line",
    above = 0,
    lineWidth = 2,
    color = "FEColorOutline",
    p1 = { 2, 19, },
    p2 = { 770, 19, },
},
{
    type = "TextButton",
    position = { 4, 23, },
    visible = 0,
    buttonStyle = "FEButtonStyle2",
    name = "m_btnCancel",
    helpTipTextLabel = "m_lblHelpText",
    helpTip = "$3515",
    Text =
    {
        textStyle = "FEButtonTextStyle",
        text = "$2619", 
    },
},
},
},
}
