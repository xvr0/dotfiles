#!/bin/bash

DOWNLOADS_DIR="$HOME/Downloads"
DELETE_MODE=false

# 1. Check for the -d flag at the very beginning
if [[ "$1" == "-d" ]]; then
    DELETE_MODE=true
    shift # Remove -d from arguments
fi

ARG1=$1
ARG2=$2
TIME="ALL"
DEST_PATH=""

# Helper function to check if an argument is a pure number
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

# 2. Parse arguments based on the mode
if [[ "$DELETE_MODE" == true ]]; then
    # Delete Mode Logic
    if is_number "$ARG1"; then
        TIME="$ARG1"
    elif is_number "$ARG2"; then
        TIME="$ARG2" # Handles the "./pdf.sh -d /exam 10" case
    fi
else
    # Move Mode Logic
    if [[ -z "$ARG1" ]]; then
        echo "Error: No arguments provided."
        exit 1
    fi

    if is_number "$ARG1"; then
        if [[ -z "$ARG2" ]]; then
            # The "./pdf.sh 40" case
            echo "Misinput detected: Time given ($ARG1) but no destination path specified. Doing nothing."
            exit 1
        else
            # Handles if you accidentally swap args: ./pdf.sh 30 ~/exam
            TIME="$ARG1"
            DEST_PATH="$ARG2"
        fi
    else
        # The standard move cases
        DEST_PATH="$ARG1"
        if is_number "$ARG2"; then
            TIME="$ARG2" # The "./pdf.sh ~/exam 30" case
        fi
        # If ARG2 is empty, TIME remains "ALL" (The "./pdf.sh ~/exam" case)
    fi
fi

# 3. Create the destination directory if moving
if [[ "$DELETE_MODE" == false && ! -d "$DEST_PATH" ]]; then
    mkdir -p "$DEST_PATH"
fi

# 4. Build the find command dynamically
# Start with the base command
FIND_CMD=(find "$DOWNLOADS_DIR" -maxdepth 1 -name "*.pdf")

# Append the time filter only if TIME is not "ALL"
if [[ "$TIME" != "ALL" ]]; then
    FIND_CMD+=(-mmin "-$TIME")
fi

# 5. Execute the move or delete
if [[ "$DELETE_MODE" == true ]]; then
    if [[ "$TIME" == "ALL" ]]; then
        echo "Trash day: Deleting ALL PDFs in Downloads..."
    else
        echo "Trash day: Deleting PDFs downloaded in the last $TIME minutes..."
    fi
    "${FIND_CMD[@]}" -exec rm -v {} +
else
    if [[ "$TIME" == "ALL" ]]; then
        echo "Organizing: Moving ALL PDFs from Downloads to $DEST_PATH..."
    else
        echo "Organizing: Moving PDFs downloaded in the last $TIME minutes to $DEST_PATH..."
    fi
    "${FIND_CMD[@]}" -exec mv -t "$DEST_PATH/" -v {} +
fi

echo "Done!"
