#!/bin/bash

# copy everything from icons themes to ./icons and themes
cp -rvf "$HOME/.config/sway" "$HOME/.config/waybar" "$HOME/.config/swaync" "$HOME/.config/rofi" "$HOME"/.config/gtk* ./configs
cp -rvf "$HOME"/.local/share/icons/Bibata-Pink-Ice "$HOME"/.local/share/icons/Bibata-Pink-Ice ./icons/
