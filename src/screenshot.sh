#!/bin/bash

#
# This is a small script that aids in taking screenshots. It will use the loot script in order to automatically
# upload the screenshot to a remote server. This makes it much easier to share screenshots.
#

# Some readonly constants
readonly MODE_SELECTION="selection"
readonly MODE_WINDOW="window"
readonly TMP_DIRECTORY="/tmp"
readonly TMP_FILE="$TMP_DIRECTORY/$(cat /proc/sys/kernel/random/uuid).png"
readonly NOTIFICATION_DAEMON="notify-send"

# Detect what mode to use
if [[ $# -eq 0 ]]; then
    
    # Take screenshot of entire screen(s)
    scrot -z "$TMP_FILE"

elif [[ $1 -eq "$MODE_SELECTION" ]]; then

    # Take screenshot of the selected area
    scrot -s -z "$TMP_FILE"

elif [[ $1 -eq "$MODE_WINDOW" ]]; then

    # Take screenshot of the current window
    scrot -u -z "$TMP_FILE"
else

    echo "Error: unknown mode was specified"
    exit 1
fi

# Use the loot script to upload file to remote server
loot "$TMP_FILE"

# Remove the temp file
rm "$TMP_FILE"

# Send notification after all is done
if [[ $NOTIFICATION_DAEMON -eq 0 ]]; then
    $NOTIFICATION_DAEMON 'Printscreen' 'Screenshot saved to loot' -u low -t 2000
fi

