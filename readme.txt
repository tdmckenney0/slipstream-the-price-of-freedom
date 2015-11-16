Thanks for downloading TPOF v2.5c!

1. Setup
2. Troubleshooting
3. Notes
4. Credits
-----------------------------

1) Setup
	
For Windows Users:

	1) Place the TPOFv2.5c.big and RunTPOF.bat in the Homeworld2\Data\ directory. (Usually found at: C:\Program Files\Sierra\Homeworld2\Data\)

	2) Double click the "RunTPOF" File (Look for RunTPOF.bat too)
	
	3) To make a shortcut, right click RunTPOF, point to "send to", then point and click on Desktop (Create Shortcut).

	4) Enjoy!

For Mac users:

	1) Drop the "Launch 2.5c.terminal" where ever you like, but place the TPOFv2.5c.big file in your homeworld2/data/ directory (should be /Applications/Homeworld2/Data/) 

	2) Double Click the "Launch 2.5c.terminal" file

	3) If you installed homeworld 2 somewhere else on your mac, open the "Launch 2.5b.terminal" file in Textedit. Then, edit this line: 

		<string>/Applications/Homeworld\ 2/Homeworld\ 2.app/Contents/MacOS/Homeworld\ 2 -mod TPOFv2.5c.big -luatrace -hardwarecursor</string>
		
		Change "/Applications/" to where ever you installed you have the homeworld2 folder DO NOT CHANGE ANYTHING ELSE! Save the file. Double click it to play.
	4) Enjoy!

----------------------------
2) Toubleshooting
	
	Mac Users: You can run all three Gametypes, but in advanced mode, you will not be able to select your starting fleet or music. Instead you will be be given the shuffle music option by default. 
	Windows Users: 
	
	If you experience crashing problems, try these solutions

	1) add "-windowed" (without quotes)  to the batch file (you can edit it by right clicking, and selecting edit , change the line "homeworld2.exe -mod TPOFv2.5b.big -hardwarecursor -luatrace" to 
		"homeworld2.exe -mod TPOFv2.5b.big -hardwarecursor -luatrace -windowed" also: use -h and -w to adjust size EX. if your screen is 1280x1024, do "-h 1280 -w 1024" [no quotes] on your shortcut)
	2) Reduce your quality settings in the settings menu
	3) Close all programs in the background.
	4) Lower the screen resolution. I experimented and found that TPoF Will crash with intensive effects on high-resolutions. 
	5) Turning off the details in the settings menu works as well. 

----------------------------
3. Notes

	This build cleans up a lot of code and finished a ton of unfinished things. This is to aim TPOF at a more refinement, and prepare it 
	for the upcoming campaign programming.  Also note, that I am looking at TPOF being feature-complete in version 2.6.
----------------------------
4. Credits:

TFS v2.6 Mod Development Team (Sagyxil) - Nuclear Missiles and UNCG Cluster Missiles
Axel - Models and Ships
Mikhail - Campaign and Gameplay scripts

----------------------------
Copyright Sub-Real Industries 2009. All Rights Reserved. 