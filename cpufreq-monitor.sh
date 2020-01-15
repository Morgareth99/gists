#!/bin/sh

while true; do sudo cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq | awk '{freq = $0 / 10^3; if(freq / 10^3 >= 1) {print freq / 10^3 " GHz"} else {print freq " MHz"}}'; sleep 0.2; done


