# Arogon_one_fan_control
This is a quick bash script I've written that successfully controls the fan speed on the Argon 1 case without the need for python GPIO. This has been tested and works on Fedora 34, and should work with any system that has i2c capabilities.

The script commands are based off codes found here -> https://github.com/Argon40Tech/Argon-ONE-i2c-Codes

**How This Script Works:**
 This script works by querying the cpu temperature from ```/sys/class/thermal/thermal_zone0/temp``` and sourcing a config file for temperatures/fan power values.
 It will then use i2c commands to set the fan speed via the GPIO pins. 
 If the script is exited or quits, it will automagically set the fan to 100% to prevent overheating if the script fails for some reason.
 
**Where has it been tested?**
 I have tested this works on a Raspberry Pi 4B running Fedora 34 with the Argon One V2 case.
 
 It /should/ work anywhere that the i2c commands can control the GPIO pins of the Pi. 
 
**Installation:**
You will need to make sure you have the following entries in your ```config.txt```

```
dtparam=i2c1=on
dtparam=i2c_arm=on
```
Clone the script/config file and run it. (I will create a systemd file for this soon (hopefully)).

Cheers,
 
PS. This software does not come with any warranty, but I'm open to issues/suggestions.
