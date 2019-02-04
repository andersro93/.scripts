#!/bin/sh

# Disable other outputs
xrandr --output VIRTUAL1 --off --output DP2-1 --off --output DP2-2 --off --output DP2-3 --off --output DP1 --off --off --output HDMI2 --off --output HDMI1 --off --output DP2 --off

# Enable output on external monitors
xrandr --output eDP1 --primary --mode 3840x2160 --pos 0x0 --scale 1x1 --rotate normal 

# Enable xresources changes
xrdb -merge "$HOME/.xmobile"

# Restart i3
i3-msg restart

