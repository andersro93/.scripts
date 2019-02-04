#!/bin/bash

# 
# This script enables easy toggling of the most common display modes. This is meant for laptop use.
#

# Set the folder where display modes are located
readonly DISPLAY_MODE_FOLDER="$HOME/.scripts/display_modes"

# Check if the display mode exists
if [ ! -f "$DISPLAY_MODE_FOLDER/$1.sh" ]; then
    echo "Invalid display mode"
    notify-send 'Display mode' "Invalid display mode" -u critical
    exit 1
fi

# Execute display mode change
eval "$DISPLAY_MODE_FOLDER/$1.sh"

# Restart notification daemon
killall dunst

# Send notification and restart notification daemon
notify-send "Display mode" "Display mode was changed to $1" -u low -t 2000

