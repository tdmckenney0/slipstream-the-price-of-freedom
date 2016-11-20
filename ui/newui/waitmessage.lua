-- LuaDC version 0.9.20
-- 11/11/2008 7:35:16 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
WaitMessage =
{
    size =
        { 0, 0, 800, 600, },
    stylesheet = "HW2StyleSheet",
    pixelUVCoords = 1,
    RootElementSettings =
    {
        backgroundColor = "FEColorBackground2", },
;
{
    type = "Frame",
    position =
        { 273, 250, },
    size =
        { 254, 100, },
    backgroundColor = "FEColorDialog",
	outerBorderWidth = 1,
    borderColor = "FEColorHeading3",
;
{
    type = "Frame",
    position =
        { 4, 4, },
    size =
        { (254 + -8), 70, },
    style = "FEPopupBackgroundStyle",
},
{
    type = "Frame",
    position =
        { 2, 2, },
    size =
        { 250, 32, },
;
{
    type = "Frame",
    size =
        { 250, 34, },
    borderWidth = 2,
    borderColor = "FEColorPopupOutline", },
},
{
    type = "TextLabel",
    position =
        { 10, 2, },
    size =
        { 200, 13, },
    Text =
    {
        textStyle = "FEHeading3",
        text = "$5167", },
},
{
    type = "TextLabel",
    position =
        { 10, 17, },
    size =
        { 200, 10, },
    Text =
    {
        textStyle = "FEHeading4",
        text = "$5168", },
},
{
    type = "Frame",
    outerBorderWidth = 2,
    position =
        { 4, 32, },
    size =
        { 246, 64, },
    borderColor = "FEColorPopupOutline",
;
{
    type = "TextLabel",
    position =
        { 8, 6, },
    size =
        { 230, 45, },
    wrapping = 1,
    marginHeight = 2,
    marginWidth = 2,
    name = "m_lblErrorMessage",
    Text =
    {
        textStyle = "FEHelpTipTextStyle",
        vAlign = "Top", },
},
{
    type = "Line",
    p1 =
        { 0, 47, },
    p2 =
        { 254, 47, },
    lineWidth = 2,
    color = "FEColorPopupOutline",
    above = 1,
},
{
    type = "TextButton",
    position =
        { 2, 49, },
    name = "m_btnCancel",
    width = (246 + -4),
    buttonStyle = "FEButtonStyle2",
    Text =
    {
        textStyle = "FEButtonTextStyle",
        text = "$2613", }, },
},
},
}
