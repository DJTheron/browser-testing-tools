# Source - https://stackoverflow.com/questions/32458095/how-can-i-get-the-default-browser-name-in-bash-script-on-mac-os-x
# Posted by HereAGoat
# Retrieved 2025-12-11, License - CC BY-SA 4.0

plutil -p ~/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist | grep 'https' -b3 |awk 'NR==3 {split($4, arr, "\""); print arr[2]}'
