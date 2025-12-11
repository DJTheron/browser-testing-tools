echo "Confirm you would like to run all tests (y/n)?"
read confirm_run_all_tests
if [ "$confirm_run_all_tests" != "y" ]; then
    echo "Aborting all tests."
    exit 0
fi

# Source - https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
# Posted by Timmmm, modified by community. See post 'Timeline' for change history
# Retrieved 2025-12-11, License - CC BY-SA 4.0
# Modified by DJTheron on 2025-12-11 to suit browser-testing-tools

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "-- Linux Detected --"
        xdg-settings get default-web-browser | sed 's/\.desktop//'
elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "-- macOS Detected --"
        plutil -p ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist | grep 'https' -b3 |awk 'NR==3 {split($4, arr, "\""); print arr[2]}'
elif [[ "$OSTYPE" == "cygwin" ]]; then
        echo "-- Windows Detected (Cygwin) --"
        reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice /v ProgId
elif [[ "$OSTYPE" == "msys" ]]; then
        echo "-- Windows Detected (MinGW) --"
        reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice /v ProgId
elif [[ "$OSTYPE" == "win32" ]]; then
        echo "-- Windows Detected --"
        reg query HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice /v ProgId
else
        echo "-- Unknown OS --"
        exit 1

fi


# add code to find out whether the browser could block the pop ups by possibly checking what is using the most ram or what processs etc