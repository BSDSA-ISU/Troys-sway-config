#!/usr/bin/bash

wallpaper="$HOME/.config/sway/wallpaper.sh"
image="$HOME/.cache/currentwallpaper.png"

if [[ -f "$image" ]]; then
    waypaper --wallpaper $image --backend swww
else
    bash $wallpaper
fi
