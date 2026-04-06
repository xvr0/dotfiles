#!/bin/bash

# Read the current Xft.dpi value from the X resource database
CURRENT_DPI=$(xrdb -query | grep "Xft.dpi" | awk '{print $2}')

if [ "$CURRENT_DPI" == "92" ]; then
    # If native, switch to 150% scaled (363)
    echo "Xft.dpi: 181" | xrdb -merge
    notify-send "DPI Toggled" "Scaled up to 363 DPI"
else
    # Otherwise, revert back to native 242
    echo "Xft.dpi: 92" | xrdb -merge
    notify-send "DPI Toggled" "Reverted to native 242 DPI"
fi
