#!/bin/bash
# All these comands come from here -> https://github.com/Argon40Tech/Argon-ONE-i2c-Codes

# If this script ends, set to fan to 100%
prev_val=100
trap 'i2cset -y 1 0x01a 0x64' EXIT

if [ -f /opt/argon_one_fan_control/argon_fan_control.conf ]; then
    conf_file='/opt/argon_one_fan_control/argon_fan_control.conf'
else
    conf_file='./argon_fan_control.conf'
fi

get_temp() {
    temp_raw=$(cat /sys/class/thermal/thermal_zone0/temp)
    cpu_temp=$((${temp_raw}/1000))
}

set_fan_speed() {
    local dec=$1
    local hex=$(printf '%x\n' ${dec})
    if [ ${prev_val} != $dec ]; then
        i2cset -y 1 0x01a 0x${hex} >/dev/null
        echo "Fan speed set to ${dec}%. CPU at ${cpu_temp}°C."
	prev_val=$dec
    fi
}

fan_control() {
    get_temp_array=$(cat ${conf_file} | grep -v '#' | sort --human-numeric-sort --reverse)

    for entry in ${get_temp_array} ; {
        temp=$(echo $entry | awk -F '=' '{ print $1 }')
        fan_power=$(echo $entry | awk -F '=' '{ print $2 }')

        # Sanity Check the power values
        if [ ${fan_power} -gt 100 ]; then
            echo "${entry} is not valid, fan power must be <100"
            exit 1
        elif [ $fan_power -lt 0 ]; then
            echo "${entry} is not valid, fan power must be >0"
            exit 1
        fi

        if [ ${cpu_temp} -gt ${temp} ]; then
            set_fan_speed ${fan_power}
	    break
        fi
    }
}

while true ; do
    get_temp
    fan_control
    sleep 10
done
