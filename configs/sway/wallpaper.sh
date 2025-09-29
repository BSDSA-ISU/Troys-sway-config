#!/bin/bash

#By Troyyy

wallpaper_dir="$(ls ~/Pictures/wallpaper)"
wallpaper="$HOME/.cache/currentwallpaper.png"
wallpaperblurred="$HOME/.cache/bluredcurrentwallpaper.png"

# Show the menu using Rofi

SelectWallpaper() {
    chosen=$(echo -e "$wallpaper_dir" | rofi -dmenu -i -p "Choose a wallpaper:3" -l 17 )
}

RandomWallpaper() {
    chosen=$(echo "$wallpaper_dir" | shuf -n 1 )
}

# sets the wallpaper and put the blur and wallpaper image on ~/.cache
main() {
	# refuses to run if no wallpaper picked
    notify-send "setting the wallpaper"
    if [[ -z "$chosen" ]]; then
	    notify-send "you didn't pick any wallpaper"
	    return 1
    else
		# configure the color
	    wal -b 000000 -i "$HOME/Pictures/wallpaper/$chosen" --cols16 darken -n

		# kill aka reload the waybar
	    pkill waybar
	    waybar -c ~/.config/waybar/config-sway.jsonc &
		sleep 3s

		# sets the wallpaper
		waypaper --wallpaper -- "$path" 
		swaync-client -rs &
	    cp "$HOME/Pictures/wallpaper/$chosen" "$wallpaper"
		magick "$HOME/Pictures/wallpaper/$chosen" -blur 0x20 "$wallpaperblurred"
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

