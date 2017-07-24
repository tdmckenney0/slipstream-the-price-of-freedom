@echo off
set url=%1
cd ..
set ss=%CD%
cd "%url%" & .\Homeworld2.exe -datapath "%ss%" -overridebigfile -luatrace -hardwarecursor -nomovies