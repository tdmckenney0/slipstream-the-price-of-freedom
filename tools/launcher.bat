@echo off
set /p url="Paste the path from your Homeworld2 Classic Bin\Release directory: "
cd %url%
%url%\Homeworld2.exe -datapath "C:\Users\Tanner Mckenney_2\Projects\slipstream-the-price-of-freedom" -overridebigfile -luatrace -hardwarecursor