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

# Set some of the configuration variables
readonly STEP=10
readonly TIMEOUT=900

# Get the current volume
readonly VOL_OLD=$(amixer -D pulse sget Master | grep 'Left:' | awk -F'[][%]' '{ print $2 }')

if [ "$1" == "$ACTION_UP" ]; then

    # Calculate the next volume
    readonly VOL_NEW=`expr $VOL_OLD + $STEP`
    
    # Check if we are above maximum
    if [ $VOL_NEW -ge 100 ]; then

        # Set volume to 100 %
        pactl set-sink-volume @DEFAULT_SINK@ 100%

        # Notify the user
        notify-send 'Volume' --expire-time 2000 --urgency low --hint int:value:100 -i audio-volume-high 'Volume is now at maximum'

    else
        # Increase volume
        pactl set-sink-volume @DEFAULT_SINK@ "$VOL_NEW%"

        # Notify the user
        notify-send 'Volume' --expire-time $TIMEOUT --urgency low --hint int:value:$VOL_NEW -i audio-volume-medium 'Turning the volume up'
    fi

elif [ "$1" == "$ACTION_DOWN" ]; then

    # Calculate the next volume
    readonly VOL_NEW=`expr $VOL_OLD - $STEP`

    # Check if we are below 0
    if [ $VOL_NEW -le 0 ]; then

        # Set volume to 0 %
        pactl set-sink-volume @DEFAULT_SINK@ 0%

        # Notify the user
        notify-send 'Volume' --expire-time 2000 --urgency low --hint int:value:0 -i audio-volume-low 'Volume is now at minimum'

    else
        # Decrease the volume
        pactl set-sink-volume @DEFAULT_SINK@ "$VOL_NEW%"

        # Notify the user
        notify-send 'Volume' --expire-time $TIMEOUT --urgency low --hint int:value:$VOL_NEW -i audio-volume-medium 'Turning the volume down'
    fi

elif [ "$1" == "$ACTION_MUTE" ]; then

    # Toggle the mute
    pactl set-sink-mute @DEFAULT_SINK@ toggle

    # Notify the user
    notify-send 'Volume' --expire-time $TIMEOUT --urgency low -i audio-volume-muted "Toggling mute"

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

