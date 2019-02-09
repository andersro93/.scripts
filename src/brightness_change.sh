#!/bin/bash

#
# A small script that allows the user to change the screen brightness and get nice feedack based
# on their actions. 
#
# Created by Anders R. Olsen (github.com/andersro93)
#

# Declare the various types of actions
readonly BRIGHTNESS_UP="up"
readonly BRIGHTNESS_DOWN="down"

# Set some of the configuration variables
readonly STEP=10
readonly TIMEOUT=900

# Check if the user wants to increase the brightness
if [ "$1" == "$BRIGHTNESS_UP" ]; then

    # Try to increase the brightness
    xbacklight -inc "$STEP"

elif [ "$1" == "$BRIGHTNESS_DOWN" ]; then

    # Try to decrease the brightness
    xbacklight -dec "$STEP"

else
    # Invalid action was specified
    echo "Invalid action $1"
    
    # Exit with status code 1
    exit 1
fi

# Get the new brightness
readonly BRIGHTNESS=`xbacklight -get`

# Notify the user
notify-send 'Brightness' --expire-time $TIMEOUT --urgency low --hint int:value:$BRIGHTNESS -i display 'Brightness changed'

