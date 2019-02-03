#!/bin/bash

#
# This is a simple script that uploads the given input (either a string or a file) to a "loot server".
#

# Some readonly constants
readonly MODE_RAW="RAW"
readonly MODE_FILE="FILE"

# Detect the mode to use, file copying or pipeing
if [ -z "$1" ]; then
    MODE=$MODE_RAW
else
    INPUT_FILE="$1"
    MODE=$MODE_FILE
fi

# Retrieve an UUID that we can use for filename
RANDOM_FILENAME="$(cat /proc/sys/kernel/random/uuid)"

# Determine which transfer mode to use
if [[ $MODE = "$MODE_FILE" ]]; then

    # Get the filename and extension from the original path
    FILENAME="$INPUT_FILE"
    EXTENSION="$(echo "$FILENAME" | rev | cut -d '.' -f1 | rev )"

elif [[ $MODE = "$MODE_RAW" ]]; then
    
    # Create a tmp filepath
    EXTENSION="txt"
    FILENAME="/tmp/loot-tmp-$RANDOM_FILENAME.$EXTENSION"

    # Touch temp file
    touch "$FILENAME"

    # Write a tmp file
    while read -r CMD; do
        echo "$CMD" >> "$FILENAME"
    done

else
    echo "Error: Invalid mode"
    exit 1
fi

# Get the current year
readonly YEAR=`date +"%Y"`

# Calculate the final path
readonly REMOTE_FILE="$YEAR/$RANDOM_FILENAME.$EXTENSION"

# Make the copying to the S3 Store
scp -q "$FILENAME" "$LOOT_REMOTE_SERVER:$LOOT_REMOTE_PATH/$REMOTE_FILE"

# Get the URL
readonly URL="$LOOT_PUBLIC_URL/$REMOTE_FILE"

# Delete the tempromary file if raw mode was used
if [[ $MODE -eq $MODE_RAW ]]; then
    rm FILENAME 2> /dev/null 
fi

# Put the URL on the clipboard if xclip is installed
echo "$URL" | xclip -selection clipboard
echo "$URL" | xclip -selection primary

# Print the URL
echo "$URL"

