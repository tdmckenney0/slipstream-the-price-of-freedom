-- Music already played.
playedBin = {}

-- Playlist to shuffle.
PlayList =
{
    -- filepath, title, length (s),			-- default
    { "slipstream\\Ambient",   "Slipstream Ambient - DJZ4K",                        (15 * 60) + 50, },
    { "slipstream\\Suite",     "Slipstream Suite 1 - SRI-Sajuuk",                   (1 * 60), },
    { "slipstream\\Freedom",   "Slipstream Suite 2 (The Price of Freedom) - DJZ4K", (2 * 60) + 54, },
    { "slipstream\\battle_01", "Slipstream Battle No.1 - SRI-Sajuuk",               (2 * 60) + 7, },
}

-- Game Rule Entry function
function RandomMusicRule()
	RandomMusic(PlayList)
end

-- Enable Rule and Keybind
function ShufflePlaylist()
	UI_BindKeyEvent(F1KEY, "RandomMusicRule")
	Rule_Add("RandomMusicRule")
end
    
-- Random music function
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
		-- don't play the same track twice
		if (playedBin[k] == randNum) then
			passBool = 0
			-- if the end of the list has been reached, start over
			if (binLen == listLen) then
				playedBin = {}
			end
			break
		end
	end
	if (passBool == 0) then
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
