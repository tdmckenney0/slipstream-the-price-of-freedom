-- the playlist
PlayList =
{
	-- filepath, title, length (s),			-- default
	{"ambient\\amb_01", "Ambient No.1", 628,},	-- 157
	{"ambient\\amb_02", "Ambient No.2", 660,},	-- 110
	{"ambient\\amb_03", "Ambient No.3", 620,},	-- 155
	{"ambient\\amb_04", "Ambient No.4", 660,},	-- 110
	{"ambient\\amb_05", "Ambient No.5", 645,},	-- 129
	{"ambient\\amb_06", "Ambient No.6", 618,},	-- 103
	{"ambient\\amb_07", "Ambient No.7", 620,},	-- 124
	{"ambient\\amb_08", "Ambient No.8", 705,},	-- 141
	{"ambient\\amb_12", "Ambient No.12", 628,},	-- 108
	{"ambient\\amb_13", "Ambient No.13", 684,},	-- 114
	{"ambient\\amb_14", "Ambient No.14", 725,},	-- 145
	{"battle\\battle_01", "Battle No.1", 552,},	-- 276
	{"battle\\battle_04", "Battle No.4", 678,},	-- 226
	{"battle\\battle_04_alt", "Battle No.4, Alternate", 720,},	-- 180
	{"battle\\battle_06", "Battle No.6", 764,},	-- 191
	{"battle\\battle_keeper", "Battle - Keeper", 708,},	-- 177
	{"battle\\battle_movers", "Battle - Movers", 632,},	-- 158
	{"battle\\battle_planetkillers", "Battle - Planet Killers", 748,},	-- 187
	{"battle\\battle_sajuuk", "Battle - Sajuuk", 644,},	-- 161
	{"staging\\staging_01", "Slipstream Main Theme - DJZ4K", 211,},	-- 64
	{"staging\\staging_04", "Slipstream Ambient 1 - DJZ4K", 211,},	-- 64

}

--==============================================================================

-- table of previously-played tracks
playedBin = {}

-- the gamerule
function RandomMusicRule()
	RandomMusic(PlayList)
end

function RandomMusic(tPlaylist)
	-- function created by Mikail, EvilleJedi
	-- Input:	<tPlaylist>: the playlist (a table) of songs.
	local passBool = 1
	local musicPath = "data:sound\\music\\"
	local listLen = getn(tPlaylist)
	local binLen = getn(playedBin)
	local randNum = random(listLen)
	local track_file = musicPath .. tPlaylist[randNum][1]
	local track_title = tPlaylist[randNum][2]
	local track_length = tPlaylist[randNum][3]
	local track_m = floor(track_length / 60)
	local track_s = track_length - track_m * 60
	local track_string = "Now playing (" .. randNum .. "/" .. listLen .. "): " .. track_title .. " (" .. track_m .. "m " .. track_s .. "s)"
	for k = 1, binLen do
--		print("playedBin[" .. k .. "] = " .. playedBin[k])
		-- don't play the same track twice
		if (playedBin[k] == randNum) then
			passBool = 0
			-- if the end of the list has been reached, start over
			if (k == listLen) then
				playedBin = {}
			end
			break
		end
	end
	if (passBool == 0) then
--		print("Track has already been played.")
		RandomMusic(tPlaylist)
	else
		Sound_MusicPlay(track_file)
		Subtitle_Message(track_string, 10)
		print(track_string)
		tinsert(playedBin, randNum)
		Rule_AddInterval("RandomMusicRule", track_length)
		Rule_Remove("RandomMusicRule")
	end
end


--==============================================================================

--if (GetGameSettingAsString("RandomMusic") == "on") then
	Rule_Add("RandomMusicRule")
--end
