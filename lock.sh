#!/bin/bash

# lock.sh - locks your screen using a pixelated screenshot made with
# scrot (uses imlib2).
# Will not show anything when you type in your password.


### Dependency / Conflicts checks, mark error(s):

e=0

markerror () {
	 e=1
 }

bailout () {
	 exit 1
 }

# Check for dependency programs
which convert >/dev/null || (echo "Please install imagemagick." && markerror)
which i3lock >/dev/null || (echo "Please install i3lock." && markerror)

# Check for conflicting xscreensaver process
x="$(ps auxwww | grep -i xscreensaver | grep -vE '(grep|\[defunct\]|xscreensaver-demo)' | wc -l)"
if [[ "$x" -gt 0 ]]; then echo "xscreensaver detected. Please stop xscreensaver." && markerror; fi

# Bailout on errors
if [[ "$e" == 1 ]]; then
	 echo "Errors occured. Exiting gracefully."
	  bailout
fi


### Screenshot / OSD

# get temp filenames
t="$(tempfile).png"
tm="${t}.mod"

# make original screenshot
scrot -q 50 "$t"

# make pixelated version of screenshot
convert -quality 10 -scale 10% -scale 1000% "$t" "$tm"

# remove original screenshot
rm "$t"

### Locking
# -e is supported since i3lock 2.6 (will not validate empty passwords against PAM)
# i3lock -u -e -i "$tm"
i3lock -i "$tm"

# remove pixelated screenshot
rm "$tm"

exit 0
