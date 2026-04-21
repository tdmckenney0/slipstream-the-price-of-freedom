#Requires -Version 7.0
<#
.SYNOPSIS
    Launches Homeworld2.exe under the x86 console debugger (cdb) with TPOF active.

.DESCRIPTION
    Resolves the Homeworld 2 Classic install and the cdbX86.exe (or x86 cdb.exe)
    debugger from common locations or environment overrides, then starts the game
    as a child of cdb so any access-violation or fault is caught at the moment of
    crash. By default runs interactively (you get a cdb prompt on first-chance
    exception). Use -Unattended to auto-capture a full minidump and exit, suitable
    for unattended repro runs.

    All paths are resolved at run time — nothing in the script is hard-coded to a
    specific machine. Override with env vars or parameters when auto-detection
    can't find what it needs.

.PARAMETER Hw2Path
    Homeworld 2 Classic install directory (the folder containing Bin\Release).
    If omitted: uses $env:HW2_ROOT, then the Steam registry, then common paths.

.PARAMETER CdbPath
    Full path to cdbX86.exe (or x86 cdb.exe). If omitted: uses $env:CDB_X86, then
    %LOCALAPPDATA%\Microsoft\WindowsApps\cdbX86.exe, then the Windows Kits SDK
    debuggers folder, then PATH.

.PARAMETER DumpDir
    Directory to write minidumps to in -Unattended mode. Defaults to the same
    Bin\Release folder the game writes its own crash dumps into.

.PARAMETER Width, Height
    Render resolution. Defaults to the primary monitor's physical resolution.

.PARAMETER Unattended
    Run cdb non-interactively: continue past the loader breakpoint, then on the
    first access violation capture a full diagnostic snapshot to the log
    (registers, nearest symbol, surrounding disasm, kb/kn call stacks, raw
    stack walk, loaded modules, !analyze -v) and write a full minidump before
    quitting. Use for repro automation; omit for live debugging.

.PARAMETER LogFile
    Path to a cdb session log. Defaults to a timestamped file under the repo's
    .tmp\ directory.

.PARAMETER ExtraArgs
    Extra args passed verbatim to Homeworld2.exe after the standard TPOF flags.

.EXAMPLE
    # Interactive — drop into cdb on first-chance exceptions
    ./tools/debug-tpof.ps1

    # Unattended — run, wait for crash, write dump, exit
    ./tools/debug-tpof.ps1 -Unattended

    # Override install + debugger explicitly
    ./tools/debug-tpof.ps1 -Hw2Path 'D:\Steam\...\Homeworld2Classic' `
                           -CdbPath 'C:\WinSDK\Debuggers\x86\cdb.exe'
#>

param(
    [string]$Hw2Path,
    [string]$CdbPath,
    [string]$DumpDir,
    [int]$Width,
    [int]$Height,
    [switch]$Unattended,
    [string]$LogFile,
    [string[]]$ExtraArgs
)

# ── Path resolution ────────────────────────────────────────────────────────────

function Resolve-HWInstall {
    param([string]$Override)

    if ($Override) {
        if (-not (Test-Path $Override)) {
            Write-Error "Specified Hw2Path not found: $Override"
            exit 1
        }
        return (Resolve-Path $Override).Path
    }

    if ($env:HW2_ROOT -and (Test-Path $env:HW2_ROOT)) {
        return (Resolve-Path $env:HW2_ROOT).Path
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

    foreach ($path in @(
        'C:\Program Files (x86)\Steam\steamapps\common\Homeworld\Homeworld2Classic',
        'C:\Program Files\Steam\steamapps\common\Homeworld\Homeworld2Classic'
    )) {
        if (Test-Path $path) { return $path }
    }

    Write-Error (
        "Could not locate the Homeworld 2 Classic install.`n" +
        "Pass -Hw2Path, or set the HW2_ROOT environment variable."
    )
    exit 1
}

function Resolve-Cdb {
    param([string]$Override)

    if ($Override) {
        if (-not (Test-Path $Override)) {
            Write-Error "Specified CdbPath not found: $Override"
            exit 1
        }
        return (Resolve-Path $Override).Path
    }

    if ($env:CDB_X86 -and (Test-Path $env:CDB_X86)) {
        return (Resolve-Path $env:CDB_X86).Path
    }

    $candidates = @()

    if ($env:LOCALAPPDATA) {
        $candidates += Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\cdbX86.exe'
    }

    foreach ($pf in @(${env:ProgramFiles(x86)}, $env:ProgramFiles)) {
        if ($pf) {
            $kits = Join-Path $pf 'Windows Kits\10\Debuggers\x86\cdb.exe'
            $candidates += $kits
            $kits11 = Join-Path $pf 'Windows Kits\11\Debuggers\x86\cdb.exe'
            $candidates += $kits11
        }
    }

    foreach ($c in $candidates) {
        if (Test-Path $c) { return (Resolve-Path $c).Path }
    }

    foreach ($name in @('cdbX86.exe', 'cdb.exe')) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd) { return $cmd.Source }
    }

    Write-Error (
        "Could not locate an x86 cdb debugger.`n" +
        "Install the Windows SDK 'Debugging Tools for Windows', or set CDB_X86, " +
        "or pass -CdbPath."
    )
    exit 1
}

# ── Resolve everything ─────────────────────────────────────────────────────────

$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path $repoRoot)) { $repoRoot = (Get-Location).Path }

$hwInstall  = Resolve-HWInstall -Override $Hw2Path
$binRelease = Join-Path $hwInstall 'Bin\Release'
$exe        = Join-Path $binRelease 'Homeworld2.exe'

if (-not (Test-Path $exe)) {
    Write-Error "Homeworld2.exe not found: $exe"
    exit 1
}

$cdb = Resolve-Cdb -Override $CdbPath

if (-not $DumpDir) { $DumpDir = $binRelease }
if (-not (Test-Path $DumpDir)) {
    New-Item -ItemType Directory -Path $DumpDir -Force | Out-Null
}

if (-not $LogFile) {
    $tmpDir = Join-Path $repoRoot '.tmp'
    if (-not (Test-Path $tmpDir)) { New-Item -ItemType Directory -Path $tmpDir -Force | Out-Null }
    $stamp   = Get-Date -Format 'yyyy-MM-dd_HHmmss'
    $LogFile = Join-Path $tmpDir "cdb-tpof-$stamp.log"
}

# ── Resolution ─────────────────────────────────────────────────────────────────

if (-not $Width -or -not $Height) {
    $vc = Get-CimInstance -ClassName Win32_VideoController -ErrorAction SilentlyContinue |
        Where-Object { $_.CurrentHorizontalResolution -gt 0 } |
        Select-Object -First 1
    if ($vc) {
        if (-not $Width)  { $Width  = $vc.CurrentHorizontalResolution }
        if (-not $Height) { $Height = $vc.CurrentVerticalResolution }
    } else {
        if (-not $Width)  { $Width  = 1920 }
        if (-not $Height) { $Height = 1080 }
    }
}

# ── Build cdb command line ─────────────────────────────────────────────────────

$gameArgs = @(
    '-moddatapath', 'DataTPOF',
    '-overridebigfile',
    '-hardwarecursor',
    '-nomovies',
    '-w', $Width,
    '-h', $Height
)
if ($ExtraArgs) { $gameArgs += $ExtraArgs }

$stamp    = Get-Date -Format 'yyyy-MM-dd_HHmmss'
$dumpStem = Join-Path $DumpDir "tpof-cdb-$stamp.dmp"

$scriptFile  = Join-Path $tmpDir "cdb-init-$stamp.cdb"
$handlerFile = Join-Path $tmpDir "cdb-handler-$stamp.cdb"

# cdb's $$><Filename loader does not support quoted paths — bail loudly if the
# path has spaces so the user can override.
foreach ($p in @($scriptFile, $handlerFile, $LogFile, $dumpStem)) {
    if ($p -match '\s') {
        Write-Error "Path contains spaces and cdb cannot quote it: $p`nOverride with -LogFile / -DumpDir to a space-free path."
        exit 1
    }
}

if ($Unattended) {
    # cdb interprets `\` as an escape inside quoted strings (so `\t` → tab,
    # `\U` → `U`, mangling Windows paths). The sxe -c / -c2 command strings
    # include a $$><handlerFile path inside quotes, so use forward slashes for
    # anything that ends up inside a quoted string.
    $dumpFwd    = $dumpStem    -replace '\\', '/'
    $handlerFwd = $handlerFile -replace '\\', '/'

    # Full AV diagnostic handler — sourced via $$>< from the sxe command so the
    # command string stays short and doesn't need escaping. Runs on both
    # first-chance and second-chance so we still capture a dump if an SEH in
    # the target swallows the first-chance (the 2026-04-20 crash only ever
    # fired a second-chance break, with no handler attached — nothing captured).
    $handler = @"
.echo === ACCESS VIOLATION ===
.echo --- registers ---
r
.echo --- nearest symbol ---
ln @eip
.echo --- disasm before eip ---
ub @eip L10
.echo --- disasm at eip ---
u @eip L10
.echo --- kb 40 ---
kb 40
.echo --- kn 40 ---
kn 40
.echo --- raw stack (L100 dwords) ---
dds @esp L100
.echo --- modules ---
lmf
.echo --- !analyze -v ---
!analyze -v
.echo --- writing minidump ---
.dump /ma /u $dumpFwd
.echo --- flushing log and quitting ---
.logflush
.logclose
q
"@

    Set-Content -Path $handlerFile -Value $handler -Encoding ASCII

    $script = @"
.logopen $LogFile
.echo Unattended debug session waiting for AV (first or second chance).
sxe -c "`$`$><$handlerFwd" -c2 "`$`$><$handlerFwd" av
g
"@

    Set-Content -Path $scriptFile -Value $script -Encoding ASCII
    $cdbInit = "`$`$><$scriptFile"
} else {
    $cdbInit = ".logopen $LogFile; .echo Debugger attached. Press 'g' to continue, Ctrl+B Enter to break.; g"
}

$cdbArgs = @(
    '-g',                # skip initial breakpoint
    '-G',                # skip final breakpoint at exit
    '-c', $cdbInit,
    $exe
) + $gameArgs

Write-Host "HW path:   $hwInstall"
Write-Host "Debugger:  $cdb"
Write-Host "Log file:  $LogFile"
if ($Unattended) { Write-Host "Dump on AV: $dumpStem" }
Write-Host "Resolution: ${Width}x${Height}"
Write-Host ''
Write-Host 'Launching Homeworld2.exe under cdb...'

Push-Location $binRelease
try {
    & $cdb @cdbArgs
    $code = $LASTEXITCODE
} finally {
    Pop-Location
}

if (Test-Path $LogFile) {
    Write-Host ''
    Write-Host "cdb log written: $LogFile"
}

exit $code
