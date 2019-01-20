#!/bin/bash

#
# This is a simple script that uploads the given input (either a string or a file) to a "loot server".
#

# Some readonly constants
readonly MODE_RAW="RAW"
readonly MODE_FILE="FILE"
readonly AWS_S3_URL="https://s3.eu-north-1.amazonaws.com"

# Detect the mode to use, file copying or pipeing
if [ -z "$1" ]; then
    MODE=$MODE_RAW
else
    INPUT_FILE="$1"
    MODE=$MODE_FILE
fi

# Check if environment variable for S3 bucket uri is set
if [[ -z "${LOOT_S3_BUCKET_NAME}" ]]; then
    echo "Error: The S3 bucket environment variable is not set, please check that the environment file is loaded in bashrc" 1>&2
    exit 1
fi

# Check if AWS cli is installed
if [[ -z "$(type -p aws)" ]]; then
    echo "Error: It dosen't look like AWS cli is installed or available, please check your configuration" 1>&2
    exit 1
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

# Calculate the final path
S3PATH="s3://$LOOT_S3_BUCKET_NAME/loot/$RANDOM_FILENAME.$EXTENSION"

# Make the copying to the S3 Store
aws s3 cp "$FILENAME" "$S3PATH" --quiet

# Get the URL
URL="$AWS_S3_URL/$LOOT_S3_BUCKET_NAME/loot/$RANDOM_FILENAME.$EXTENSION"

# Delete the tempromary file if raw mode was used
if [[ $MODE -eq $MODE_RAW ]]; then
    rm FILENAME 2> /dev/null 
fi

# Put the URL on the clipboard if xclip is installed
echo "$URL" | xclip -selection clipboard
echo "$URL" | xclip -selection primary

# Print the URL
echo "$URL"

