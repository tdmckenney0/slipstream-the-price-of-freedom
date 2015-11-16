@echo off
set /p url="Paste the path from your Homeworld2 Classic data directory: "
cd ..
mklink Homeworld2.big %url%\Homeworld2.big
mklink English.big %url%\English.big
mklink EnglishSpeech.big %url%\EnglishSpeech.big
mklink Music.big %url%\Music.big