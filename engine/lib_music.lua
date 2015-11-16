playedBin = {}

function Play(Music)

	if Music == nil then
		Subtitle_Message("Mac OS X Users: We're sorry, but Homeworld 2 will not allow the advanced game options on your machine. Default Start fleet & Shuffle music Enabled.", 10)
		ShuffleAll()
				
	elseif Music == "shuffle" then
		ShuffleAll()
		
	elseif Music == "ambient" then
		ShuffleAmbient()
		
	elseif Music == "battle" then
		ShuffleBattle()
		
	elseif Music == "staging" then
		ShuffleStaging()
			
	elseif Music == "mute" then
		Sound_MusicPlay("data:sound\\music\\staging\\Mute" )
		
	elseif Music == "credits" then
		Sound_MusicPlay("data:sound\\music\\staging\\Credits" )	
		
	else
		Sound_MusicPlay("data:sound\\music\\" .. Music)
	end
	
end

function ShuffleAll()

	UI_BindKeyEvent(F1KEY, "RandomMusicRule")
	dofilepath("data:soundscripts/playlists/allmusic.lua")
	Rule_Add("RandomMusicRule")
end

function ShuffleAmbient()
	
	UI_BindKeyEvent(F1KEY, "RandomMusicRule")
	dofilepath("data:soundscripts/playlists/ambientonly.lua")
	Rule_Add("RandomMusicRule")
	
end

function ShuffleBattle()
	
	UI_BindKeyEvent(F1KEY, "RandomMusicRule")
	dofilepath("data:soundscripts/playlists/battleonly.lua")
	Rule_Add("RandomMusicRule")
	
end

function ShuffleStaging()
	
	UI_BindKeyEvent(F1KEY, "RandomMusicRule")
	dofilepath("data:soundscripts/playlists/stagingonly.lua")
	Rule_Add("RandomMusicRule")
	
end
    
--Keybinded functions.
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