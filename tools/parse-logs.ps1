#Requires -Version 7.0
<#
.SYNOPSIS
    Reads and filters Homeworld 2 Classic log and crash dump files.

.DESCRIPTION
    Auto-detects the Homeworld 2 Classic install path and reads Hw2.log or crash
    artifacts from Bin\Release\. With no filter switches, outputs all log lines
    color-coded by severity. Exits 1 if any ERROR or LUA ERROR lines were found.

.PARAMETER HWPath
    Path to the Homeworld 2 Classic installation directory (the folder containing Bin\Release).
    If omitted, resolved from the HW2_ROOT environment variable, the Steam registry key,
    or common install paths.

.PARAMETER Errors
    Show only ERROR and LUA ERROR lines.

.PARAMETER Lua
    Show only Lua-related lines (LUA ERROR, LUA:).

.PARAMETER Mod
    Show only mod loading events and TPOF/slipstream-specific output.

.PARAMETER Tail
    Live-tail the log (like tail -f). Press Ctrl+C to stop.

.PARAMETER Last
    Show only the last N lines of the log before filtering.

.PARAMETER Dumps
    Summarize crash artifacts (*ErrorLog.txt, *.dmp, *.mdmp) instead of reading Hw2.log.

.EXAMPLE
    ./tools/parse-logs.ps1
    ./tools/parse-logs.ps1 -Errors
    ./tools/parse-logs.ps1 -Lua
    ./tools/parse-logs.ps1 -Last 100 -Errors
    ./tools/parse-logs.ps1 -Tail
    ./tools/parse-logs.ps1 -Dumps
    ./tools/parse-logs.ps1 -HWPath "D:\Steam\steamapps\common\Homeworld\Homeworld2Classic" -Errors
#>

param(
    [string]$HWPath,
    [switch]$Errors,
    [switch]$Lua,
    [switch]$Mod,
    [switch]$Tail,
    [int]$Last = 0,
    [switch]$Dumps
)

# ── Path resolution ────────────────────────────────────────────────────────────

function Resolve-HWInstall {
    param([string]$Override)

    if ($Override) {
        if (-not (Test-Path $Override)) {
            Write-Error "Specified HWPath not found: $Override"
            exit 1
        }
        return $Override
    }

    # Check HW2_ROOT environment variable (set by RDN toolkit setup)
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
        "  ./tools/parse-logs.ps1 -HWPath 'D:\Steam\steamapps\common\Homeworld\Homeworld2Classic'"
    )
    exit 1
}

# ── Line helpers ───────────────────────────────────────────────────────────────

function Get-LineColor {
    param([string]$Line)
    if ($Line -match 'LUA ERROR|ERROR:') { return 'Red' }
    if ($Line -match 'WARNING:?')        { return 'Yellow' }
    if ($Line -match 'LUA:')             { return 'Green' }
    if ($Line -match 'MOD:|TPOF|slipstream') { return 'Cyan' }
    return 'White'
}

function Test-LineMatch {
    param([string]$Line)
    if (-not ($Errors -or $Lua -or $Mod)) { return $true }
    if ($Errors -and $Line -match 'LUA ERROR|ERROR:') { return $true }
    if ($Lua    -and $Line -match 'LUA ERROR|LUA:')   { return $true }
    if ($Mod    -and $Line -match 'MOD:|TPOF|slipstream')  { return $true }
    return $false
}

function Test-IsError {
    param([string]$Line)
    return $Line -match 'LUA ERROR|ERROR:'
}

# ── Dump summary ───────────────────────────────────────────────────────────────

function Show-Dumps {
    param([string]$BinRelease)

    $allFiles = Get-ChildItem -Path $BinRelease -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match 'ErrorLog\.txt$|MiniDump\.dmp$|\.mdmp$' } |
        Sort-Object Name

    if (-not $allFiles) {
        Write-Host 'No crash artifacts found.' -ForegroundColor Green
        return
    }

    # Group by incident stem: strip known suffixes to find the shared prefix
    $incidents = [ordered]@{}
    foreach ($f in $allFiles) {
        $stem = $f.BaseName -replace '[-_]?ErrorLog$', '' -replace '[-_]?MiniDump$', ''
        if (-not $stem) { $stem = $f.BaseName }
        if (-not $incidents.Contains($stem)) { $incidents[$stem] = [System.Collections.Generic.List[object]]::new() }
        $incidents[$stem].Add($f)
    }

    foreach ($stem in $incidents.Keys) {
        $files = $incidents[$stem]
        Write-Host "`n── Incident: $stem ──" -ForegroundColor Cyan

        $errorLog = $files | Where-Object { $_.Name -match 'ErrorLog\.txt$' } | Select-Object -First 1
        if ($errorLog) {
            Write-Host "  $($errorLog.Name)" -ForegroundColor White
            Write-Host (Get-Content $errorLog.FullName -Raw).TrimEnd() -ForegroundColor Yellow
        }

        foreach ($f in ($files | Where-Object { $_.Name -notmatch 'ErrorLog\.txt$' })) {
            $sizeKB = [math]::Round($f.Length / 1KB, 1)
            Write-Host "  $($f.Name)  ($sizeKB KB)" -ForegroundColor DarkGray
        }
    }
}

# ── Main ───────────────────────────────────────────────────────────────────────

$hwInstall  = Resolve-HWInstall -Override $HWPath
$binRelease = Join-Path $hwInstall 'Bin\Release'

if (-not (Test-Path $binRelease)) {
    Write-Error "Bin\Release directory not found: $binRelease"
    exit 1
}

Write-Host "HW path: $hwInstall"

if ($Dumps) {
    Show-Dumps -BinRelease $binRelease
    exit 0
}

$logFile = Join-Path $binRelease 'Hw2.log'

if (-not (Test-Path $logFile)) {
    Write-Error "Hw2.log not found: $logFile"
    exit 1
}

$logInfo = Get-Item $logFile
Write-Host "Log:     $logFile (last modified: $($logInfo.LastWriteTime.ToString('yyyy-MM-dd HH:mm')))"
Write-Host ''

$hasErrors  = $false
$errorCount = 0

if ($Tail) {
    Write-Host '[Tailing log — press Ctrl+C to stop]' -ForegroundColor DarkGray
    Get-Content $logFile -Wait | ForEach-Object {
        if (Test-LineMatch -Line $_) {
            if (Test-IsError -Line $_) { $hasErrors = $true }
            Write-Host $_ -ForegroundColor (Get-LineColor -Line $_)
        }
    }
} else {
    $lines = if ($Last -gt 0) {
        Get-Content $logFile -Tail $Last
    } else {
        Get-Content $logFile
    }

    foreach ($line in $lines) {
        if (Test-LineMatch -Line $line) {
            if (Test-IsError -Line $line) {
                $hasErrors = $true
                $errorCount++
            }
            Write-Host $line -ForegroundColor (Get-LineColor -Line $line)
        }
    }

    if ($Errors -or $Lua) {
        Write-Host ''
        $msg   = "$errorCount error(s) found."
        $color = $errorCount -gt 0 ? 'Red' : 'Green'
        Write-Host $msg -ForegroundColor $color
    }
}

exit ($hasErrors ? 1 : 0)
