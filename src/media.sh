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

# Some configuration variables
readonly SEEK_STEPS=5

# Check if play/pause
if [ "$1" == "$ACTION_TOGGLE" ]; then

    # Toggle playback
    playerctl play-pause

elif [ "$1" == "$ACTION_NEXT" ]; then

    # Next song
    playerctl next

elif [ "$1" == "$ACTION_PREV" ]; then

    # Previous song
    playerctl previous

elif [ "$1" == "$ACTION_SEEK_FORWARD" ]; then

    # Seek forward
    playerctl position "+$SEEK_STEPS"

elif [ "$1" == "$ACTION_SEEK_BACKWARD" ]; then

    # Seek backward
    playerctl position "-$SEEK_STEPS"

else

    echo "Invalid mode"
    exit 1

fi

# Kill i3blocks (forces update)
pkill -RTMIN+3 i3blocks

