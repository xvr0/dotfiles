#!/bin/bash

STATE_FILE="/tmp/screen_toggle_state"

# If the file doesn't exist, assume the screen is currently ON
if [ ! -f "$STATE_FILE" ]; then
    echo "on" > "$STATE_FILE"
fi

STATE=$(cat "$STATE_FILE")

if [ "$STATE" = "on" ]; then
    # The screen is on. Mark it as off, wait for key release, and kill power.
    echo "off" > "$STATE_FILE"
    sleep 0.5 && xset dpms force off
else
    # The screen is off. Mark it as on, and force it to stay awake.
    echo "on" > "$STATE_FILE"
    xset dpms force on
fi
