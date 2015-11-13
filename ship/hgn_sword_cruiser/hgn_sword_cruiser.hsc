// HOD script file.
// Created by CFHodEd v3.0.8


// 2 materials located.
STAT_Add("Main_Hull", "ship", 2); {
	STAT_SetParamter(1, 1, 5, 0, 0, 0, 0, 1, "$diffuse");
	STAT_SetParamter(1, 2, 5, 0, 0, 0, 0, 4, "$glow");
}
STAT_Add("Burner", "ship", 2); {
	STAT_SetParamter(2, 1, 5, 0, 0, 0, 0, 2, "$diffuse");
	STAT_SetParamter(2, 2, 5, 0, 0, 0, 0, 4, "$glow");
}


// 92 joints located.
HIER_Add("Hardpoint_DCTFront_Position", "Root", 0, 37.55001, -9, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_DCTFront_Rest", "Hardpoint_DCTFront_Position", 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_DCTFront_Direction", "Hardpoint_DCTFront_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_DCTBack_Position", "Root", 0.12, 35.68999, -205.7902, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_DCTBack_Rest", "Hardpoint_DCTBack_Position", 0, 0, -1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_DCTBack_Direction", "Hardpoint_DCTBack_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_DCTTop_Position", "Root", 0, -19.51001, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_DCTTop_Rest", "Hardpoint_DCTTop_Position", 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_DCTTop_Direction", "Hardpoint_DCTTop_Position", 0, -1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_DCTBottom_Position", "Root", 0, -8.31012, 96.86, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_DCTBottom_Rest", "Hardpoint_DCTBottom_Position", 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_DCTBottom_Direction", "Hardpoint_DCTBottom_Position", 0, -1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("EngineNozzle1", "Root", 0, 0, -178, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Turret_Bottom_Position", "Root", 0, -18, -138, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Turret_Bottom_Rest", "Hardpoint_Turret_Bottom_Position", 0, 0, -1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Turret_Bottom_Direction", "Hardpoint_Turret_Bottom_Position", 0, -1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP1_Position", "Root", -26.5, 7.029978, 3.35, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP1_Rest", "Hardpoint_Left_CP1_Position", -1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP1_Direction", "Hardpoint_Left_CP1_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP2_Position", "Root", -26.5, 7.029978, 30.35, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP2_Rest", "Hardpoint_Left_CP2_Position", -1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP2_Direction", "Hardpoint_Left_CP2_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP3_Position", "Root", -26.5, 7.029978, 57.35, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP3_Rest", "Hardpoint_Left_CP3_Position", -1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP3_Direction", "Hardpoint_Left_CP3_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP4_Position", "Root", -26.5, 7.029978, 84.35, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP4_Rest", "Hardpoint_Left_CP4_Position", -1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP4_Direction", "Hardpoint_Left_CP4_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP5_Position", "Root", -26.5, 7.029978, 111.35, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP5_Rest", "Hardpoint_Left_CP5_Position", -1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Left_CP5_Direction", "Hardpoint_Left_CP5_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP1_Position", "Root", 26.5, 7.029978, 3.35, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP1_Rest", "Hardpoint_Right_CP1_Position", 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP1_Direction", "Hardpoint_Right_CP1_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP2_Position", "Root", 26.5, 7.029978, 30.35, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP2_Rest", "Hardpoint_Right_CP2_Position", 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP2_Direction", "Hardpoint_Right_CP2_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP3_Position", "Root", 26.5, 7.029978, 57.35, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP3_Rest", "Hardpoint_Right_CP3_Position", 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP3_Direction", "Hardpoint_Right_CP3_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP4_Position", "Root", 26.5, 7.029978, 84.35, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP4_Rest", "Hardpoint_Right_CP4_Position", 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP4_Direction", "Hardpoint_Right_CP4_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP5_Position", "Root", 26.5, 7.029978, 111.35, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP5_Rest", "Hardpoint_Right_CP5_Position", 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_Right_CP5_Direction", "Hardpoint_Right_CP5_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS1_Position", "Root", -38, 27, 11, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS1_Rest", "Hardpoint_PDS1_Position", 0, 0, -1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS1_Direction", "Hardpoint_PDS1_Position", -1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS2_Position", "Root", -38, 27, 91.04, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS2_Rest", "Hardpoint_PDS2_Position", 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS2_Direction", "Hardpoint_PDS2_Position", -1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS3_Position", "Root", -25, 41, 139, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS3_Rest", "Hardpoint_PDS3_Position", 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS3_Direction", "Hardpoint_PDS3_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS4_Position", "Root", -33.32994, -9, -18.43999, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS4_Rest", "Hardpoint_PDS4_Position", 0, 0, -1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS4_Direction", "Hardpoint_PDS4_Position", -2, -1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS5_Position", "Root", -33.32994, -9, 43.87013, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS5_Rest", "Hardpoint_PDS5_Position", 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS5_Direction", "Hardpoint_PDS5_Position", -2, -1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS6_Position", "Root", -33.32994, -9, -112, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS6_Rest", "Hardpoint_PDS6_Position", 0, 0, -1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS6_Direction", "Hardpoint_PDS6_Position", -2, -1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS7_Position", "Root", -33.32994, -9, -170, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS7_Rest", "Hardpoint_PDS7_Position", 0, 0, -1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS7_Direction", "Hardpoint_PDS7_Position", -2, -1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS8_Position", "Root", 38, 27, 11, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS8_Rest", "Hardpoint_PDS8_Position", 0, 0, -1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS8_Direction", "Hardpoint_PDS8_Position", 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS9_Position", "Root", 38, 27, 91.04, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS9_Rest", "Hardpoint_PDS9_Position", 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS9_Direction", "Hardpoint_PDS9_Position", 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS10_Position", "Root", 25, 41, 139, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS10_Rest", "Hardpoint_PDS10_Position", 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS10_Direction", "Hardpoint_PDS10_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS11_Position", "Root", 33.32994, -9, -18.43999, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS11_Rest", "Hardpoint_PDS11_Position", 0, 0, -1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS11_Direction", "Hardpoint_PDS11_Position", 2, -1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS12_Position", "Root", 33.32994, -9, 43.87013, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS12_Rest", "Hardpoint_PDS12_Position", 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS12_Direction", "Hardpoint_PDS12_Position", 2, -1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS13_Position", "Root", 33.32994, -9, -112, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS13_Rest", "Hardpoint_PDS13_Position", 0, 0, -1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS13_Direction", "Hardpoint_PDS13_Position", 2, -1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS14_Position", "Root", 33.32994, -9, -170, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS14_Rest", "Hardpoint_PDS14_Position", 0, 0, -1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS14_Direction", "Hardpoint_PDS14_Position", 2, -1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS15_Position", "Root", 0, 55, -126, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS15_Rest", "Hardpoint_PDS15_Position", 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);
HIER_Add("Hardpoint_PDS15_Direction", "Hardpoint_PDS15_Position", 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1);


// 0 NavLights located.


// 0 markers located.


// 0 dockpaths located.


// 8 BNDVs located.
BNDV_SetNumVertices(8); {
	BNDV_SetVertex(1, -1, -1, -1);
	BNDV_SetVertex(2, 0, 0, 0);
	BNDV_SetVertex(3, 0, 0, 0);
	BNDV_SetVertex(4, 0, 0, 0);
	BNDV_SetVertex(5, 0, 0, 0);
	BNDV_SetVertex(6, 0, 0, 0);
	BNDV_SetVertex(7, 1, 1, 1);
	BNDV_SetVertex(8, 0, 0, 0);
}

// 0 level lights located.

// 0 point star field groups located.

// 0 textured star field groups located.


// EOF
