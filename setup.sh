#!/bin/bash

# Selections for fzf
MusicPlayer="cmus\nstrawberry\naudacious"
Browser="brave\nfirefox\nwaterfox\nchromium"

# Functions
yayInstall() {
    if [[ -f /bin/yay || -f /usr/bin/yay || -f /usr/local/bin/yay ]]; then
        echo "yay the aur helper is already installed"
    else
        git clone "https://aur.archlinux.org/yay.git"
        cd "yay" || exit
        makepkg -si
        cd ..
        echo "yay the aur helper sucessfully installed"
    fi
}

Music() {
    TheMusicPlayer=$(echo -e $MusicPlayer | fzf --prompt="Select the music player you want")
    echo "$TheMusicPlayer"
}

# assignments
Neededs=(base sway swaync waybar swww noto-fonts noto-fonts-cjk
 otf-font-awesome foot brightnessctl awesome-terminal-fonts)




# disable shellcheck checks momentarily
echo "installing: ${Neededs[*]}"
echo "$MusicPlayer $Browser"
