#!/usr/bin/bash

interface=$(/bin/ls /sys/class/net | grep -E '^(wl)' | head -n 1)                                       

echo "$interface"
