# Source - https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
# Posted by Timmmm, modified by community. See post 'Timeline' for change history
# Retrieved 2025-12-11, License - CC BY-SA 4.0

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # ...
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
else
        # Unknown.
fi
