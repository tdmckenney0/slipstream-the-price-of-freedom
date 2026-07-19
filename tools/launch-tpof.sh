#!/usr/bin/env bash
#
# Launches The Price of Freedom (HW2 Classic) through Steam's Proton on Linux.
# Bash counterpart of launch-tpof.ps1 for the Steam install.
#
# Usage:
#   ./launch-tpof.sh                 # auto-detect everything and launch
#   ./launch-tpof.sh -p <Hw2Path>    # explicit Homeworld2Classic dir (or set HW2_ROOT)
#   ./launch-tpof.sh -w 2560 -h 1440 # override resolution
#   ./launch-tpof.sh --dry-run       # print the launch command without running it
#
# The game must run on the host. When invoked inside a container this script
# re-executes itself on the host via distrobox-host-exec/flatpak-spawn.

set -euo pipefail

APPID=244160  # Homeworld Remastered Collection

hw2_path="${HW2_ROOT:-}"
width="" height="" dry_run=0

usage() { grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0; }

while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--hw2-path) hw2_path="$2"; shift 2 ;;
        -w|--width)    width="$2";    shift 2 ;;
        -h|--height)   height="$2";   shift 2 ;;
        --dry-run)     dry_run=1;     shift ;;
        --help)        usage ;;
        *) echo "Unknown argument: $1" >&2; exit 2 ;;
    esac
done

# --- Hop to the host if we're inside a container -----------------------------
if [[ $dry_run -eq 0 && -f /run/.containerenv || $dry_run -eq 0 && -f /.dockerenv ]]; then
    for helper in distrobox-host-exec host-spawn; do
        if command -v "$helper" >/dev/null 2>&1; then
            echo "Inside a container - re-launching on the host via $helper..."
            exec "$helper" bash "$(realpath "$0")" ${hw2_path:+-p "$hw2_path"} \
                ${width:+-w "$width"} ${height:+-h "$height"}
        fi
    done
    echo "Error: inside a container with no distrobox-host-exec/host-spawn; run this script on the host." >&2
    exit 1
fi

# --- Locate Steam and the game ----------------------------------------------
steam_root=""
for d in "$HOME/.local/share/Steam" "$HOME/.steam/steam" "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam"; do
    [[ -d "$d/steamapps" ]] && { steam_root="$d"; break; }
done
[[ -n "$steam_root" ]] || { echo "Error: Steam installation not found." >&2; exit 1; }

[[ -n "$hw2_path" ]] || hw2_path="$steam_root/steamapps/common/Homeworld/Homeworld2Classic"
exe="$hw2_path/Bin/Release/Homeworld2.exe"
[[ -f "$exe" ]] || { echo "Error: Homeworld2.exe not found: $exe" >&2; exit 1; }

compat_data="$steam_root/steamapps/compatdata/$APPID"
[[ -d "$compat_data/pfx" ]] || {
    echo "Error: no Proton prefix at $compat_data - launch the game once from Steam first." >&2
    exit 1
}

# --- Find the Proton this prefix last ran under ------------------------------
proton=""
if [[ -f "$compat_data/config_info" ]]; then
    # config_info line 2 is a path inside the Proton dist, e.g.
    #   .../steamapps/common/Proton - Experimental/files/share/fonts/
    proton_root="$(sed -n '2p' "$compat_data/config_info" | sed 's#/files/.*##;s#/dist/.*##')"
    [[ -x "$proton_root/proton" ]] && proton="$proton_root/proton"
fi
if [[ -z "$proton" ]]; then
    for d in "$steam_root/steamapps/common/Proton - Experimental" \
             "$steam_root/steamapps/common/Proton"* \
             "$steam_root/compatibilitytools.d/"*; do
        [[ -x "$d/proton" ]] && { proton="$d/proton"; break; }
    done
fi
[[ -n "$proton" ]] || { echo "Error: no Proton installation found." >&2; exit 1; }

# --- Resolution: primary display, fall back to 1920x1080 ---------------------
if [[ -z "$width" || -z "$height" ]]; then
    if command -v xrandr >/dev/null 2>&1; then
        read -r width height < <(xrandr 2>/dev/null | awk '/\*/{split($1,a,"x"); print a[1], a[2]; exit}') || true
    fi
    [[ -n "${width:-}" && -n "${height:-}" ]] || { width=1920; height=1080; }
fi

echo "Launching TPOF at ${width}x${height} via $(basename "$(dirname "$proton")")..."

export STEAM_COMPAT_DATA_PATH="$compat_data"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$steam_root"

cd "$hw2_path/Bin/Release"
cmd=("$proton" run "$exe" -moddatapath DataTPOF -overridebigfile -hardwarecursor -nomovies -w "$width" -h "$height")

if [[ $dry_run -eq 1 ]]; then
    printf 'cd %q\n' "$PWD"
    printf 'STEAM_COMPAT_DATA_PATH=%q STEAM_COMPAT_CLIENT_INSTALL_PATH=%q \\\n' "$compat_data" "$steam_root"
    printf '%q ' "${cmd[@]}"; echo
    exit 0
fi

exec "${cmd[@]}"
