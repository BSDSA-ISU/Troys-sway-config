#!/usr/bin/bash

login=$(echo "Exit|Shutdown|Restart|Suspend|Terminal|logout" | rofi -dmenu -no-X -sep "|"  -p "Want to shudown? or Restart?" -window-title "Power Menu")

dmenu() {
    echo "$1" | rofi -p "Are you sure about that?" -dmenu -no-X -window-title "login" -sep "|"
}

shutdown_prompt() {
    dmenu 'Yes|No'
}

Shutdown() {
    opts=$(shutdown_prompt)
    case "$opts" in 
        "Yes")
            systemctl poweroff
            ;;
        "No")
            rofi -e "cancelled"
            return 1
            ;;
        esac
}

Restart() {
    opts=$(dmenu 'Yes|No')
    case "$opts" in
        "Yes")
            systemctl reboot
            ;;
        "No")
            rofi -e "canceled"
            return 1
            ;;
    esac

}



case "$login" in
    "Exit")
        exit
        ;;
    "Shutdown")
        Shutdown
        ;;
    "Restart")
        Restart
        ;;
    "Terminal")
        rofi-sensible-terminal
        ;;
    "Suspend")
        systemctl suspend
        ;;
    "logout")
        pkill waybar &
        pkill hyprland &
        pkill Hyprland &
        pkill sway &
        ;;
esac
