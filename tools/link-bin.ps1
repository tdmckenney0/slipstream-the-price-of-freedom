#Requires -Version 7.0
<#
.SYNOPSIS
    Creates a directory link at refs/bin pointing to the Homeworld 2 Classic Bin directory.
    Tries a symlink first (Wine-compatible); falls back to a junction on Windows.

.PARAMETER HWPath
    Path to the Homeworld 2 Classic installation directory (the folder containing Bin\Release).
    If omitted, resolved from the HW2_ROOT environment variable, the Steam registry key,
    or common install paths.

.EXAMPLE
    ./link-bin.ps1
    ./link-bin.ps1 -HWPath "D:\Steam\steamapps\common\Homeworld\Homeworld2Classic"
#>

param(
    [string]$HWPath
)

function Resolve-HWInstall {
    param([string]$Override)

    if ($Override) {
        if (-not (Test-Path $Override)) {
            Write-Error "Specified HWPath not found: $Override"
            exit 1
        }
        return $Override
    }

    if ($env:HW2_ROOT -and (Test-Path $env:HW2_ROOT)) {
        return $env:HW2_ROOT
    }

    $regKeys = @(
        'HKLM:\SOFTWARE\WOW6432Node\Valve\Steam',
        'HKLM:\SOFTWARE\Valve\Steam',
        'HKCU:\Software\Valve\Steam'
    )
    foreach ($key in $regKeys) {
        if (Test-Path $key) {
            $props = Get-ItemProperty -Path $key -ErrorAction SilentlyContinue
            if ($props) {
                foreach ($prop in @('InstallPath', 'SteamPath')) {
                    $steamRoot = $props.$prop
                    if ($steamRoot) {
                        $candidate = Join-Path $steamRoot 'steamapps\common\Homeworld\Homeworld2Classic'
                        if (Test-Path $candidate) { return $candidate }
                    }
                }
            }
        }
    }

    $fallbacks = @(
        'C:\Program Files (x86)\Steam\steamapps\common\Homeworld\Homeworld2Classic',
        'C:\Program Files\Steam\steamapps\common\Homeworld\Homeworld2Classic'
    )
    foreach ($path in $fallbacks) {
        if (Test-Path $path) { return $path }
    }

    Write-Error (
        "Could not locate the Homeworld 2 Classic install.`n" +
        "Pass -HWPath to specify it manually, or set the HW2_ROOT environment variable, e.g.:`n" +
        "  ./tools/link-bin.ps1 -HWPath 'D:\Steam\steamapps\common\Homeworld\Homeworld2Classic'"
    )
    exit 1
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot  = Split-Path -Parent $ScriptDir
$LinkPath  = Join-Path $RepoRoot "refs\bin"

$HWInstall = Resolve-HWInstall -Override $HWPath
$BinPath   = Join-Path $HWInstall "Bin"

if (-not (Test-Path $BinPath)) {
    Write-Error "Bin directory not found: $BinPath"
    exit 1
}

$RefsDir = Split-Path -Parent $LinkPath
if (-not (Test-Path $RefsDir)) {
    $null = New-Item -ItemType Directory -Path $RefsDir
}

if (Test-Path $LinkPath) {
    Write-Host "Link already exists at: $LinkPath"
    exit 0
}

try {
    $null = New-Item -ItemType SymbolicLink -Path $LinkPath -Target $BinPath -ErrorAction Stop
    Write-Host "Created symlink: $LinkPath -> $BinPath"
} catch {
    $null = New-Item -ItemType Junction -Path $LinkPath -Target $BinPath
    Write-Host "Created junction: $LinkPath -> $BinPath"
}
