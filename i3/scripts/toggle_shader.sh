#!/bin/bash

# Define absolute paths
RF_SHADER="/home/xaver/.config/picom/shaders/rf.glsl"
DIM_SHADER="/home/xaver/.config/picom/shaders/dim.glsl"

# State 1: Is the INVERT shader currently running?
if pgrep -f "rf.glsl" > /dev/null; then
    # Switch to State 2 (Low Contrast / Dim)
    killall picom
    sleep 0.5
    picom -b --window-shader-fg "$DIM_SHADER"
    notify-send -t 1500 "Picom" "Low Contrast Mode"

# State 2: Is the DIM shader currently running?
elif pgrep -f "dim.glsl" > /dev/null; then
    # Switch to State 0 (Normal / Off)
    killall picom
    sleep 0.5
    picom -b
    notify-send -t 1500 "Picom" "Normal Mode"

# State 0: No shaders are running
else
    # Switch to State 1 (Inverted)
    killall picom
    sleep 0.5
    picom -b --window-shader-fg "$RF_SHADER"
    notify-send -t 1500 "Picom" "Red Filter Mode"
fi
