#!/bin/bash

# 
# This script allows for easy controll of the media player on the system. Its purpose
# is to make the i3 script look prettier.
#

# Define the different modes
readonly ACTION_TOGGLE="toggle"
readonly ACTION_NEXT="next"
readonly ACTION_PREV="prev"
readonly ACTION_SEEK_FORWARD="seek_forward"
readonly ACTION_SEEK_BACKWARD="seek_backward"

# Icons for the actions
readonly ICON_PLAY="gtk-media-play-ltr"
readonly ICON_PAUSE="gtk-media-pause"
readonly ICON_NEXT="gtk-media-next-ltr"
readonly ICON_PREV="gtk-media-previous-ltr"
readonly ICON_SEEK_FORWARD="gtk-media-forward-ltr"
readonly ICON_SEEK_REWIND="gtk-media-rewind-ltr"

# Some configuration variables
readonly SEEK_STEPS=5

# Notification settings
readonly TIMEOUT="800"
readonly URGENCY="low"

# Check if play/pause
if [ "$1" == "$ACTION_TOGGLE" ]; then

    # Toggle playback
    playerctl play-pause

    # Wait until the daemon gets to do its job
    sleep 0.1

    # Determine the new status of the player
    STATUS=`playerctl status`

    if [ $STATUS == "Playing" ]; then

        # Send a notification
        notify-send "Media control" "Playback started" --expire-time "$TIMEOUT" --urgency "$URGENCY" --icon "$ICON_PLAY"

    elif [ $STATUS == "Paused" ]; then

        # Send a notification
        notify-send "Media control" "Playback paused" --expire-time "$TIMEOUT" --urgency "$URGENCY" --icon "$ICON_PAUSE"

    fi

elif [ "$1" == "$ACTION_NEXT" ]; then

    # Next song
    playerctl next

    # Send a notification
    notify-send "Media control" "Next song" --expire-time "$TIMEOUT" --urgency "$URGENCY" --icon "$ICON_NEXT"

elif [ "$1" == "$ACTION_PREV" ]; then

    # Previous song
    playerctl previous

    # Send a notification
    notify-send "Media control" "Previous song" --expire-time "$TIMEOUT" --urgency "$URGENCY" --icon "$ICON_PREV"  

elif [ "$1" == "$ACTION_SEEK_FORWARD" ]; then

    # Seek forward
    playerctl position "+$SEEK_STEPS"

    # Send a notification
    notify-send "Media control" "Seeking forward" --expire-time "$TIMEOUT" --urgency "$URGENCY" --icon "$ICON_SEEK_FORWARD"  

elif [ "$1" == "$ACTION_SEEK_BACKWARD" ]; then

    # Seek backward
    playerctl position "-$SEEK_STEPS"

    # Send a notification
    notify-send "Media control" "Seeking backwards" --expire-time "$TIMEOUT" --urgency "$URGENCY" --icon "$ICON_SEEK_REWIND"
else

    echo "Invalid mode"
    exit 1

fi

# Kill i3blocks (forces update)
pkill -RTMIN+3 i3blocks

