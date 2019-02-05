#!/bin/bash

#
# A small script that allows the user to control the volume and get feedback on the
# actions. 
#
# Created by Anders R. Olsen (github.com/andersro93)
#

# Declare the various types of actions
readonly ACTION_UP="up"
readonly ACTION_DOWN="down"
readonly ACTION_MUTE="mute"
readonly ACTION_MIC_MUTE="mic_mute"

# Set some of the configuration variables
readonly STEP=10
readonly TIMEOUT=900

# Get the current volume
readonly VOL_OLD=$(amixer -D pulse sget Master | grep 'Left:' | awk -F'[][%]' '{ print $2 }')

if [ "$1" == "$ACTION_UP" ]; then

    # Calculate the next volume
    VOL_NEW=`expr $VOL_OLD + $STEP`
    
    # Check if we are above maximum
    if [ $VOL_NEW -ge 100 ]; then

        # Set the new level to 100%
        VOL_NEW=100

    fi

    # Set the volume
    pactl set-sink-volume @DEFAULT_SINK@ "$VOL_NEW%"

    # Notify the user
    notify-send 'Volume' --expire-time $TIMEOUT --urgency low --hint int:value:$VOL_NEW -i audio-volume-medium 'Volume changed'
 

elif [ "$1" == "$ACTION_DOWN" ]; then

    # Calculate the next volume
    VOL_NEW=`expr $VOL_OLD - $STEP`

    # Check if we are below 0
    if [ $VOL_NEW -le 0 ]; then

        # Set the volume to 0
        VOL_NEW=0

    fi

    # Set the volume
    pactl set-sink-volume @DEFAULT_SINK@ "$VOL_NEW%"

    # Notify the user
    notify-send 'Volume' --expire-time $TIMEOUT --urgency low --hint int:value:$VOL_NEW -i audio-volume-medium 'Volume changed'
 

elif [ "$1" == "$ACTION_MUTE" ]; then

    # Toggle the mute
    pactl set-sink-mute @DEFAULT_SINK@ toggle

    # Notify the user
    notify-send 'Volume' --expire-time $TIMEOUT --urgency low -i audio-volume-muted "Toggling mute"

elif [ "$1" == "$ACTION_MIC_MUTE" ]; then

    # Toggle the default capture device
    amixer set Capture toggle

    # Notify the user
    notify-send 'Volume' --expire-time $TIMEOUT --urgency low -i audio-volume-muted "Toggling mute for input device"

else
    # Invalid action was specified
    echo "Invalid action $1"
    
    # Notify the user
    notify-send 'Volume' --expire-time $TIMEOUT --urgency critical -i error "Invalid action was specified: $1"

    # Exit with status code 1
    exit 1
fi

# Update the i3blocks
pkill -RTMIN+2 i3blocks

