#!/bin/bash

# 
# This script enables easy toggling of the most common display modes. This is meant for laptop use.
#

# Declare some read only variables
readonly MODE_MOBILE="mobile"
readonly MODE_PRESENTATION="presentation"
readonly MODE_DOCKED="docked"

# Set the default mode
readonly MODE_DEFAULT=$MODE_PORTABLE

# Check if mode was passed to the script, else use the default mode
if [ -z "$1" ]; then
    SELECTED_MODE="$MODE_DEFAULT"
else
    SELECTED_MODE="$1"
fi

# Check if the selected mode was portable
if [ "$SELECTED_MODE" = "$MODE_MOBILE" ]; then 

    # Get the params for portable mode
    XRANDR_PARAMS="$DISPLAY_MODE_PARAMS_MOBILE"

    # Notification message
    NOTIFICATION_MESSAGE="The display mode was changed to mobile mode"

elif [ "$SELECTED_MODE" = "$MODE_PRESENTATION" ]; then

    # Get the params for presentation 
    XRANDR_PARAMS="$DISPLAY_MODE_PARAMS_PRESENTATION"

    # Notification message
    NOTIFICATION_MESSAGE="The display mode was changed to presentation mode"

elif [ "$SELECTED_MODE" = "$MODE_DOCKED" ]; then

    # Get the params for docked mode
    XRANDR_PARAMS="$DISPLAY_MODE_PARAMS_DOCKED" 

    # Notification message
    NOTIFICATION_MESSAGE="The display mode has changed to docked mode"

else
    echo "Invalid mode specified"
    notify-send -u critical 'Display mode' "Invalid display mode: $1" 
    exit 1
fi

# Update XRANDR
xrandr "$XRANDR_PARAMS" &

# Kill a dunst
killall "dunst"

# Restart i3wm
i3-msg "restart" & 

# Send notification
notify-send 'Display mode' "$NOTIFICATION_MESSAGE" -u low -t 2000

