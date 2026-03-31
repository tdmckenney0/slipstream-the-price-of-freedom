#Requires -Version 7.0
<#
.SYNOPSIS
    Launches Requiem for Freedom from the HomeworldRM installation.

.PARAMETER Hw2Path
    Path to the HomeworldRM Steam installation directory.
    If omitted, the script resolves it from the Steam registry key.

.EXAMPLE
    ./launch-rff.ps1
    ./launch-rff.ps1 -Hw2Path "D:\Steam\steamapps\common\Homeworld\HomeworldRM"
#>

param(
    [string]$Hw2Path
)

if (-not $Hw2Path) {
    $SteamRegKey = "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam"
    if (-not (Test-Path $SteamRegKey)) {
        $SteamRegKey = "HKLM:\SOFTWARE\Valve\Steam"
    }
    $SteamInstallPath = (Get-ItemProperty -Path $SteamRegKey -ErrorAction Stop).InstallPath
    $Hw2Path = Join-Path $SteamInstallPath "steamapps\common\Homeworld\Homeworld2Classic"
}

$BinPath = Join-Path $Hw2Path "Bin\Release"
$Exe     = Join-Path $BinPath "Homeworld2.exe"

if (-not (Test-Path $Exe)) {
    Write-Error "Homeworld2.exe not found: $Exe"
    exit 1
}

# Get primary monitor physical resolution (unaffected by DPI scaling)
$VideoController = Get-CimInstance -ClassName Win32_VideoController |
    Where-Object { $_.CurrentHorizontalResolution -gt 0 } |
    Select-Object -First 1
$W = $VideoController.CurrentHorizontalResolution
$H = $VideoController.CurrentVerticalResolution

Write-Host "Launching TPOF at ${W}x${H}..."

Push-Location $BinPath
try {
    & $Exe -moddatapath DataTPOF -overridebigfile -hardwarecursor -nomovies -w $W -h $H
} finally {
    Pop-Location
}
