home="$HOME/Pictures/screenshots"

get_save_path() {
    dir=$(zenity --file-selection --directory --title="Choose save directory (Cancel = default)")
    [[ -z "$dir" ]] && dir="$home"
    echo "$dir"
}

ask_save() {
    zenity --question \
        --title="Screenshot Save Option" \
        --text="Do you want to save the screenshot?" \
        --ok-label="Yes" \
        --cancel-label="No"

    echo $?
}

take_fullscreen() {
    local file="$1"
    sleep 3
    grim -l 0 "$file"
}

take_fullscreen_cursor() {
    local file="$1"
    sleep 3
    grim -l 0 -c "$file"
}

take_select() {
    local file="$1"
    area="$(slurp)"
    sleep 3
    grim -g "$area" "$file"
}

take_select_cursor() {
    local file="$1"
    area="$(slurp)"
    sleep 3
    grim -g "$area" -c "$file"
}

run_capture() {
    local mode="$1"
    local dir="$2"

    namef="screenshot_$(date +%d%m%Y_%H%M%S).png"
    file="$dir/$namef"

    case "$mode" in
        FullScreen) take_fullscreen "$file" ;;
        FullScreenCursor) take_fullscreen_cursor "$file" ;;
        SelectScreen) take_select "$file" ;;
        SelectScreenCursor) take_select_cursor "$file" ;;
    esac

    # NOW preview/edit AFTER screenshot exists
    swappy -f "$file"
}

main() {
    choice=$(echo "FullScreen|SelectScreen|FullScreen W Cursor|SelectScreen W Cursor" \
        | rofi -dmenu -p "Take screenshot (3s delay)" -sep "|")

    save=$(ask_save)

    if [[ "$save" -eq 0 ]]; then
        dir=$(get_save_path)
    else
        dir="/tmp"
    fi

    case "$choice" in
        FullScreen) run_capture "FullScreen" "$dir" ;;
        SelectScreen) run_capture "SelectScreen" "$dir" ;;
        "FullScreen W Cursor") run_capture "FullScreenCursor" "$dir" ;;
        "SelectScreen W Cursor") run_capture "SelectScreenCursor" "$dir" ;;
    esac
}

main
