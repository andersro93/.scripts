#!/bin/sh

# Disable other outputs
xrandr --output VIRTUAL1 --off --output eDP1 --off --output DP1 --off --off --output HDMI2 --off --output HDMI1 --off --output DP2 --off

# Enable output on external monitors
xrandr --output DP2-1 --primary --mode 1920x1080 --pos 1920x0 --scale 1x1 --rotate normal 
xrandr --output DP2-2 --mode 1920x1080 --pos 0x0 --scale 1x1 --rotate normal  
xrandr --output DP2-3 --mode 1920x1080 --pos 3840x0 --scale 1x1 --rotate normal  

# Enable xresources changes
xrdb -merge "$HOME/.xdocked"

# Restart i3
i3-msg restart

