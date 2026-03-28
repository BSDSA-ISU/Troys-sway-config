#!/bin/bash

ConfigPath="Configs"

listconfig=(
    "sway"
    "swaync"
    "swaylock"
    "rofi"
    "fastfetch"
)

# copy the sway configurations
Retr() {
    for i in "${listconfig[@]}"; do
        cp -rvf "$HOME/.config/$i" "./$ConfigPath/"
    done
}

Retr