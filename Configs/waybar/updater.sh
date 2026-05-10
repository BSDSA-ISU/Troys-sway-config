#!/usr/bin/env bash

# color
YELLOW="\e[33m"

# Styles
BOLD="\e[1m"

# Reset
RESET="\e[0m"

echo -e "$YELLOW$BOLD$(figlet -n kyouko updater) $RESET"

printf "Do you want to update your system? \ny/n>>"

read -r yn

if [[ $yn = "y" ]]; then
    yay --devel || echo "Exited forcefully"
    echo -e "\n${YELLOW}${BOLD}Update finished!${RESET}"
    read -n1 -r -p "Press any key to exit..."  # Wait for a key press
else
    exit 9
fi
