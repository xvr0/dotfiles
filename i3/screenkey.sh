#!/bin/bash

if pgrep -x "screenkey" > /dev/null
then
    # If Screenkey is running, kill it
    pkill screenkey
else
    # If Screenkey is not running, start it with custom settings
   screenkey --font-size medium --geometry 1000x1000+1860+800 & # --opacity 0.7 --no-systray &
fi
