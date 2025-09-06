#!/bin/bash

#By Troyyy

wallpaper_dir="$(ls ~/Pictures/wallpaper)"
wallpaper="$HOME/.cache/currentwallpaper.png"

# Show the menu using Rofi

SelectWallpaper() {
    chosen=$(echo -e "$wallpaper_dir" | rofi -dmenu -i -p "Choose a wallpaper:3" -l 17 )
}

RandomWallpaper() {
    chosen=$(echo "$wallpaper_dir" | shuf -n 1 )
}


main() {
    notify-send "setting the wallpaper"
    if [[ -z "$chosen" ]]; then
	    notify-send "you didn't pick any wallpaper"
	    return 1
    else
	    wal -i "$HOME/Pictures/wallpaper/$chosen" --cols16 darken -n
	    pkill waybar
	    waybar -c ~/.config/waybar/config-sway.jsonc &
		sleep 3s
		waypaper --wallpaper -- "$path" 
		swaync-client -rs &
	    cp "$HOME/Pictures/wallpaper/$chosen" "$wallpaper"
fi
}

if [[ -n $@ ]]; then
	RandomWallpaper
    path="~/Pictures/wallpaper/$chosen"

	main
else
	SelectWallpaper
    path="~/Pictures/wallpaper/$chosen"

	main
fi

