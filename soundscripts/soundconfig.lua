-- LuaDC version 0.9.20
-- 11/11/2008 7:34:54 PM
-- LuaDC by Age2uN
-- on error send source file (compiled lua) and this outputfile to Age2uN@gmx.net
--
TRUE = 1
FALSE = 0
MusicTuning =
    {
    {
        volMax = 1,
        volMin = 0.9,
        volMinActive = 0.8,
        distanceMax = 10000,
        distanceMin = 1000,
        fadeTime = 1, },
    {
        volMax = 1,
        volMin = 0.9,
        volMinActive = 0.8,
        distanceMax = 100000,
        distanceMin = 4000,
        fadeTime = 2, },
    {
        volMax = 1,
        volMin = 0.9,
        volMinActive = 0.7,
        distanceMax = 8000,
        distanceMin = 5000,
        fadeTime = 1, },
    {
        volMax = 1,
        volMin = 0.9,
        volMinActive = 0.8,
        distanceMax = 10000,
        distanceMin = 500,
        fadeTime = 5, },
    }
SensorsVolFactor = 0.1
CameraMaxVelocity = 1000
SpeechVolDuckingLevel = 0.2
FEMusic = "data:sound/music/staging/Freedom"
FEmusicVol = 1
GameMusicVol = 1
MinMusicVol = 1
MusicFadeTime = 2
MusicDistance = 94
MusicCrossFadeTime = 2
MusicFadeToStingerTime = 0.5
EnableAmbient = TRUE
EnableMusic = TRUE
MaxAmbients = 64
SpeechQueueTimeout = 5
SpeechQueueInterruptPriority = 100
