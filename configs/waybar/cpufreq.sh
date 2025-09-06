#!/usr/bin/sh

cpufreq() {
    freq=$(cpupower frequency-info | grep "available frequency steps" | rofi -dmenu -p "CpuGoovernor" -sep ",")
    echo "$freq" | tr -d " " | tr " " "\n"
}

error() {
    notify-send "Error"

}


GovernorPick() {
    sel=$(echo "Powersave|Performance|Schedutil|Ondemand" | rofi -dmenu -p "CpuGoovernor" -sep "|")

    case "$sel" in
        Performance) 
            if pkexec cpupower frequency-set -g performance --max "$(cpufreq)"; then
             notify-send "Performance mode"
         else
             notify-send "Error"
            fi
            notify-send "Performance mode"
            ;;
        Schedutil)
            if pkexec cpupower frequency-set -g schedutil --max "$(cpufreq)"; then
                notify-send "Schedutil set"
            else
                error
            fi
            ;;
        Powersave)
            if pkexec cpupower frequency-set -g powersave --max "$(cpufreq)"; then
                notify-send "powersave set"
            else
                error
            fi
            ;;
        Ondemand)
            if pkexec cpupower frequency-set -g powersave --max "$(cpufreq)"; then
                echo "powersave set"
            else
                error
            fi
            ;;
        *)
            notify-send "nothing"
    esac
}


GovernorPick




