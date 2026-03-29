#Requires -Version 7.0
<#
.SYNOPSIS
    Creates a directory link at refs/rdn pointing to the RDN installation directory.
    Tries a symlink first (Wine-compatible); falls back to a junction on Windows.

.PARAMETER RdnPath
    Path to the Relic Developer's Network installation directory.
    Defaults to "C:\Program Files (x86)\Relic Developer's Network".

.EXAMPLE
    ./link-rdn.ps1
    ./link-rdn.ps1 -RdnPath "D:\RDN"
#>

param(
    [string]$RdnPath = "C:\Program Files (x86)\Relic Developer's Network"
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot  = Split-Path -Parent $ScriptDir
$LinkPath  = Join-Path $RepoRoot "refs\rdn"

if (-not (Test-Path $RdnPath)) {
    Write-Error "RDN directory not found: $RdnPath"
    exit 1
}

if (Test-Path $LinkPath) {
    Write-Host "Link already exists at: $LinkPath"
    exit 0
}

# Try symlink first (works under Wine; requires admin or Developer Mode on native Windows).
# Fall back to junction (native Windows only, no elevated privileges required).
try {
    $null = New-Item -ItemType SymbolicLink -Path $LinkPath -Target $RdnPath -ErrorAction Stop
    Write-Host "Created symlink: $LinkPath -> $RdnPath"
} catch {
    $null = New-Item -ItemType Junction -Path $LinkPath -Target $RdnPath
    Write-Host "Created junction: $LinkPath -> $RdnPath"
}
