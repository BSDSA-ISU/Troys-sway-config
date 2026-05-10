#!/usr/bin/bash

cpufreq() {
    freq=$(cpupower frequency-info | grep "available frequency steps" | rofi -dmenu -p "CpuGoovernor" -sep "," -config "/usr/share/rofi/themes/Adapta-Nokto.rasi")
    echo "$freq" | tr -d " " | tr " " "\n"
}

Message() {
    notify-send -a "Koishi dotfile" -i face-smile "$@"
}

MessageErr() {
    notify-send -a "Koishi dotfile" -i dialog-error "$@"
}

GovernorPick() {
    sel=$(echo "Turbo_on|Turbo_off|Powersave|Performance|Schedutil|Ondemand" | rofi -dmenu -p "CpuGoovernor" -sep "|" -config "/usr/share/rofi/themes/Adapta-Nokto.rasi")

    case "$sel" in
	Turbo_on)
	    if pkexec cpupower set --turbo 1; then
		    Message "Turbo on Success!" "now Your system will use Turbo mode."
        else
		    MessageErr "Error" "maybe turbo is not supported on this system"
	    fi
	    ;;
    	Turbo_off)
	    if pkexec cpupower set --turbo 0; then
		    Message "turbo off Success!" "Now Your cpu will not use turbo mode." 
	    else
		    MessageErr "Error" "maybe turbo is not supported on this system"
	    fi
	    ;;
        Performance) 
            if pkexec cpupower frequency-set -g performance --max "$(cpufreq)"; then
                Message "Governor set to Performance" "Now the cpu will maintain higher frequencies"
         else
                MessageErr "Error setting the cpu governor" "maybe missing kernel moules or cpu doesn't support performance mode"
            fi
            ;;
        Schedutil)
            if pkexec cpupower frequency-set -g schedutil --max "$(cpufreq)"; then
                Message "Governor set to Schedutil" "Now the cpu can dynamically switch frequency depends what task there is"
            else
                MessageErr "Error setting the cpu governor" "Maybe Schedutil doesn't support by cpu or the kernel"
            fi
            ;;
        Powersave)
            if pkexec cpupower frequency-set -g powersave --max "$(cpufreq)"; then
                Message "Governor set to Powersave" "Now the cpu is on the lowest frequency possible"
            else
                MessageErr "Error This shouldn't be possible" "powersave disabled in kernel Maybe? Idk really lol, most device supports powersave btw,"
            fi
            ;;
        Ondemand)
		if pkexec cpupower frequency-set -g ondemand --max "$(cpufreq)"; then
                Message "Governor set to ondemand" "use Schedutil instead, this is slower"
            else
                MessageErr "Error setting the cpu governor" "maybe ondemand is not supported by the kernel"
            fi
            ;;
        *)
            notify-send "nothing, just to satisfy Shellcheck"
    esac
}

GovernorPick




