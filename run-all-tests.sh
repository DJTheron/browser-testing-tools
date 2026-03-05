#!/usr/bin/env bash
set -euo pipefail

echo "-- Confirm you would like to run all tests (y/n)? --"
read -r confirm_run_all_tests
if [ "$confirm_run_all_tests" != "y" ]; then
    echo "Aborting all tests."
    exit 0
fi

# Source - https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
# Posted by Timmmm, modified by community. See post 'Timeline' for change history
# Retrieved 2025-12-11, License - CC BY-SA 4.0
# Modified by DJTheron on 2025-12-11 to suit browser-testing-tools

if [[ "${OSTYPE:-$(uname)}" == "linux-gnu"* ]]; then
    echo "------------------ Linux Detected ------------------"
    mem_before=$(free -m | awk '/^Mem:/ {printf "%d", ($2 - $7) / $2 * 100}')
    echo "Current memory pressure: ${mem_before}%"
    echo "0 ${mem_before}%" > ./memory_pressures.txt

    default_browser=$(xdg-settings get default-web-browser 2>/dev/null | cut -d';' -f1 | sed 's/\.desktop$//')
    if [ -z "$default_browser" ]; then
        echo "Could not determine the default browser."
    else
        echo "Default browser: $default_browser"
        open -a "$default_browser" basic-tab-opener.html
        sleep 5
        mem_after=$(free -m | awk '/^Mem:/ {printf "%d", ($2 - $7) / $2 * 100}')
        echo "5 ${mem_after}%" >> ./memory_pressures.txt
        echo "Memory pressure after running basic-tab-opener.html: ${mem_after}%"
        if [ "$((mem_after - mem_before))" -lt 5 ]; then
            echo "Memory pressure did not increase significantly -- browser may have blocked tabs/popups."
        fi

        open -a "$default_browser" autoplay-block-test.html
        sleep 5
        audio_output=$(pactl list sink-inputs | grep -E "State: RUNNING|$default_browser}" || true)
        if [ -z "$audio_output" ]; then
            echo "Autoplay block NOT bypassed."
            echo "Autoplay block NOT bypassed." > ./autoplay_test_results.txt
            open -a "$default_browser" advanced-autoplay-block-test.html
        else
            echo "Autoplay block bypassed."
            echo "$audio_output"
            echo "Autoplay block bypassed." > ./autoplay_test_results.txt
        fi
    fi

elif [[ "${OSTYPE:-$(uname)}" == "darwin"* ]]; then
    echo "------------------ macOS Detected ------------------"
    mem_before=$(memory_pressure | awk 'END{gsub(/%/,"",$NF); printf "%d", 100-$NF}')
    echo "Current memory pressure: ${mem_before}%"
    echo "0 ${mem_before}%" > ./memory_pressures.txt
    bundle_id=$(python3 <<'PY'
import plistlib, pathlib, sys

plist_path = pathlib.Path.home() / "Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist"
try:
    data = plistlib.load(plist_path.open('rb'))
except Exception:
    sys.exit(1)

for handler in data.get('LSHandlers', []):
    if handler.get('LSHandlerURLScheme') in ('http', 'https'):
        value = handler.get('LSHandlerRoleAll')
        if value:
            print(value)
            sys.exit(0)
sys.exit(1)
PY )

    if [ -z "$bundle_id" ]; then
        echo "Could not determine the default browser bundle ID."
    else
        echo "Default browser bundle ID: $bundle_id"
        app_path=$(osascript -e 'on run argv
        set bundleId to item 1 of argv
        try
            return POSIX path of (path to application id bundleId)
        on error
            return ""
        end try
        end run' "$bundle_id")
        if open -b "$bundle_id"; then
            echo "Opened app via bundle ID: $bundle_id"
            [ -n "$app_path" ] && echo "App path: $app_path"

            open -a "$app_path" basic-tab-opener.html

            sleep 5

            mem_after=$(memory_pressure | awk 'END{gsub(/%/,"",$NF); printf "%d", 100-$NF}')
            echo "5 ${mem_after}%" >> ./memory_pressures.txt
            echo "Memory pressure after running basic-tab-opener.html: ${mem_after}%"
            if [ "$((mem_after - mem_before))" -lt 5 ]; then
                echo "Memory pressure did not increase significantly -- browser may have blocked tabs/popups."
            fi

            open -a "$app_path" autoplay-block-test.html
            sleep 5
            audio_output=$(system_profiler SPAudioDataType | grep -E "Running|$bundle_id" || true)
            if [ -z "$audio_output" ]; then
                echo "Autoplay block NOT bypassed."
                echo "Autoplay block NOT bypassed." > ./autoplay_test_results.txt
                open -a "$app_path" advanced-autoplay-block-test.html
            else
                echo "Autoplay block bypassed."
                echo "$audio_output"
                echo "Autoplay block bypassed." > ./autoplay_test_results.txt
            fi

        else
            echo "App not found for bundle ID: $bundle_id"
        fi
    fi

else
    echo "-- Windows/Unknown OS --"
    exit 1
fi