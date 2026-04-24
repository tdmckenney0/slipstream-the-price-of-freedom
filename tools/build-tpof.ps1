#Requires -Version 7.0
<#
.SYNOPSIS
    Packs src/ into TPOF.big using the RDN Archive.exe (no Workshop Tool GUI required).

.DESCRIPTION
    Generates an Archive build script that lists every file under src/, then invokes
    refs/rdn/tools/bin/Archive/Archive.exe to produce a .big archive identical in shape
    to one packed by the HW2 Workshop Tool. Compression methods follow the RDN sample
    (ct=2 for Lua/text-like formats, ct=0 for already-compressed media, ct=1 default).

    The resulting .big is addressable in-game via data:<path under src>/... because the
    TOC is created with alias="Data" and relativeroot="" against -r <repo>/src.

.PARAMETER OutputPath
    Where to write the .big. Defaults to .tmp\TPOF.big inside the repo (gitignored).

.PARAMETER Install
    Copy the resulting .big into <Hw2Path>\Data\TPOF.big for use with -mod TPOF.big.

.PARAMETER Hw2Path
    Path to the Homeworld2Classic Steam install. Used only with -Install.
    If omitted, resolved from the Steam registry key.

.PARAMETER ArchivePath
    Path to Archive.exe. If omitted, the script prefers the copy shipped inside the
    Steam Homeworld Workshop Tool (which bundles the MSVCR70/MSVCP70 runtime DLLs it
    needs to launch on modern Windows) and falls back to refs\rdn\tools\bin\Archive\
    Archive.exe. The RDN copy is from 2003 and will fail with a DLL-not-found error
    (-1073741515 / 0xC0000135) if MSVCR70.dll isn't available alongside it.

.PARAMETER KeepBuildScript
    Keep the generated build script at .tmp\tpof-build.txt instead of deleting it
    after a successful pack. Useful for debugging compression overrides.

.PARAMETER Verbose
    Pass -v to Archive.exe for verbose packing output.

.EXAMPLE
    ./build-tpof.ps1
    # Produces .tmp\TPOF.big

.EXAMPLE
    ./build-tpof.ps1 -Install
    # Produces .tmp\TPOF.big and copies it to <HW2>\Data\TPOF.big

.EXAMPLE
    ./build-tpof.ps1 -OutputPath D:\mods\TPOF.big -KeepBuildScript -Verbose
#>

param(
    [string]$OutputPath,
    [switch]$Install,
    [string]$Hw2Path,
    [string]$ArchivePath,
    [switch]$KeepBuildScript
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot  = Split-Path -Parent $ScriptDir
$SrcPath   = Join-Path $RepoRoot 'src'
$TmpDir    = Join-Path $RepoRoot '.tmp'

if (-not (Test-Path $SrcPath)) {
    Write-Error "src directory not found: $SrcPath"
    exit 1
}

function Resolve-ArchiveExe {
    # 1. Workshop Tool — shipped with matching MSVCR70/MSVCP70, works on modern Windows.
    $SteamRegKey = 'HKLM:\SOFTWARE\WOW6432Node\Valve\Steam'
    if (-not (Test-Path $SteamRegKey)) { $SteamRegKey = 'HKLM:\SOFTWARE\Valve\Steam' }
    $steam = (Get-ItemProperty -Path $SteamRegKey -ErrorAction SilentlyContinue).InstallPath
    if ($steam) {
        $workshop = Join-Path $steam 'steamapps\common\Homeworld\GBXTools\WorkshopTool\Archive.exe'
        if (Test-Path $workshop) { return $workshop }
    }
    # 2. RDN copy — only works if MSVCR70.dll sits next to it.
    $rdn = Join-Path $RepoRoot 'refs\rdn\tools\bin\Archive\Archive.exe'
    if (Test-Path $rdn) {
        $rdnDir = Split-Path -Parent $rdn
        if (-not (Test-Path (Join-Path $rdnDir 'msvcr70.dll'))) {
            Write-Warning "Using RDN Archive.exe but MSVCR70.dll is not next to it — packing will likely fail with exit code -1073741515. Prefer the Workshop Tool copy (install HW via Steam) or pass -ArchivePath."
        }
        return $rdn
    }
    return $null
}

if (-not $ArchivePath) {
    $ArchivePath = Resolve-ArchiveExe
}
if (-not $ArchivePath -or -not (Test-Path $ArchivePath)) {
    Write-Error "Archive.exe not found. Install the Homeworld Workshop Tool via Steam (ships Archive.exe in GBXTools\WorkshopTool\), run tools\link-rdn.ps1, or pass -ArchivePath."
    exit 1
}
Write-Host "Archive.exe: $ArchivePath"

if (-not $OutputPath) {
    $OutputPath = Join-Path $TmpDir 'TPOF.big'
}
$OutputDir = Split-Path -Parent $OutputPath
if (-not (Test-Path $OutputDir)) {
    $null = New-Item -ItemType Directory -Path $OutputDir -Force
}
if (-not (Test-Path $TmpDir)) {
    $null = New-Item -ItemType Directory -Path $TmpDir -Force
}

# Extensions to skip — repo metadata, art source files, and anything HW2 won't read.
$SkipPatterns = @(
    '*.md',         # CLAUDE.md files
    '*.kra',        # Krita source art
    '*.xcf',        # GIMP source art
    '*.obj',        # Maya/Blender mesh exports (not consumed by engine)
    '*.psd',        # Photoshop source
    '*.xls',        # spreadsheets
    '*.big',        # never pack a .big inside a .big
    '*.sfap0',      # Maya scene metadata
    '*.ocx',        # ActiveX controls
    'LICENSE',
    '*emptyfile.txt'
)

# ct=2 — compressed, decompressed in one shot. Per RDN: use for small text/script files.
$CompressOnceExts = @(
    '*.lua', '*.txt', '*.ship', '*.subs', '*.level', '*.miss',
    '*.wepn', '*.events', '*.script', '*.madstate', '*.st', '*.vp',
    '*.wf', '*.ti', '*.resource', '*.pebble', '*.mres'
)

# ct=0 — store raw. Already compressed or media that streams better uncompressed.
$StoreRawExts = @(
    '*.mp3', '*.wav', '*.fda', '*.jpg', '*.png', '*.tga', '*.hod',
    '*.anim', '*.rot', '*.fp', '*.fpa', '*.fpk', '*.fpz'
)

$BuildScriptPath = Join-Path $TmpDir 'tpof-build.txt'

Write-Host "Generating build script: $BuildScriptPath"

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('// Auto-generated by tools\build-tpof.ps1 — do not edit by hand')
$lines.Add('Archive name="TPOFArchive"')
$lines.Add('TOCStart name="TPOFData" alias="Data" relativeroot=""')
$lines.Add('FileSettingsStart defcompression="1"')
$lines.Add('    // Anything under 100 bytes — store raw (compression overhead not worth it)')
$lines.Add('    Override wildcard="*.*" minsize="-1" maxsize="100" ct="0"')
foreach ($ext in $StoreRawExts) {
    $lines.Add("    Override wildcard=`"$ext`" minsize=`"-1`" maxsize=`"-1`" ct=`"0`"")
}
foreach ($ext in $CompressOnceExts) {
    $lines.Add("    Override wildcard=`"$ext`" minsize=`"-1`" maxsize=`"-1`" ct=`"2`"")
}
foreach ($pat in $SkipPatterns) {
    $lines.Add("    SkipFile wildcard=`"$pat`" minsize=`"-1`" maxsize=`"-1`"")
}
$lines.Add('FileSettingsEnd')
$lines.Add('')

# File list — paths relative to -r <SrcPath>. Archive.exe does NOT support wildcards in
# the file list, so we enumerate every file. We still emit SkipFile entries above so
# the override-by-wildcard mechanism remains the source of truth for what gets dropped.
$files = Get-ChildItem -Path $SrcPath -Recurse -File
$skipped = 0
foreach ($f in $files) {
    $rel = $f.FullName.Substring($SrcPath.Length).TrimStart('\','/')
    $shouldSkip = $false
    foreach ($pat in $SkipPatterns) {
        if ($f.Name -like $pat) { $shouldSkip = $true; break }
    }
    if ($shouldSkip) { $skipped++; continue }
    $lines.Add($rel)
}
$lines.Add('TOCEnd')

[System.IO.File]::WriteAllLines($BuildScriptPath, $lines)
$included = $files.Count - $skipped
Write-Host "  Files included: $included"
Write-Host "  Files skipped:  $skipped"

# Archive.exe overwrites in place but be explicit about a stale output.
if (Test-Path $OutputPath) {
    Remove-Item $OutputPath -Force
}

$archiveArgs = @('-a', $OutputPath, '-c', $BuildScriptPath, '-r', $SrcPath)
if ($VerbosePreference -ne 'SilentlyContinue' -or $PSBoundParameters.ContainsKey('Verbose')) {
    $archiveArgs += '-v'
}

Write-Host "Running: $ArchivePath $($archiveArgs -join ' ')"
& $ArchivePath @archiveArgs
$exit = $LASTEXITCODE

if ($exit -ne 0) {
    Write-Error "Archive.exe failed with exit code $exit. Build script kept at $BuildScriptPath for inspection."
    exit $exit
}

if (-not (Test-Path $OutputPath)) {
    Write-Error "Archive.exe reported success but $OutputPath was not created."
    exit 1
}

$bigSize = (Get-Item $OutputPath).Length
Write-Host ("Built: {0} ({1:N0} bytes / {2:N1} MB)" -f $OutputPath, $bigSize, ($bigSize / 1MB))

if (-not $KeepBuildScript) {
    Remove-Item $BuildScriptPath -Force
}

if ($Install) {
    if (-not $Hw2Path) {
        $SteamRegKey = 'HKLM:\SOFTWARE\WOW6432Node\Valve\Steam'
        if (-not (Test-Path $SteamRegKey)) {
            $SteamRegKey = 'HKLM:\SOFTWARE\Valve\Steam'
        }
        $SteamInstallPath = (Get-ItemProperty -Path $SteamRegKey -ErrorAction Stop).InstallPath
        $Hw2Path = Join-Path $SteamInstallPath 'steamapps\common\Homeworld\Homeworld2Classic'
    }
    $InstallDir = Join-Path $Hw2Path 'Data'
    if (-not (Test-Path $InstallDir)) {
        Write-Error "HW2 Data directory not found: $InstallDir"
        exit 1
    }
    $InstallPath = Join-Path $InstallDir 'TPOF.big'
    Copy-Item -Path $OutputPath -Destination $InstallPath -Force
    Write-Host "Installed to: $InstallPath"
    Write-Host "Launch with: Homeworld2.exe -mod TPOF.big"
}
