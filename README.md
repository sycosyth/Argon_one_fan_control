# Arogon_one_fan_control
This is a quick script I've written that successfully controls the fan speed on the Argon 1 case without the need for python GPIO. This has been tested and works on Fedora 34, and should work with any system that has i2c capabilities.

The script commands are based off codes found here -> https://github.com/Argon40Tech/Argon-ONE-i2c-Codes

You will need to make sure you have the following entries in your ```config.txt```

```
dtparam=i2c1=on
dtparam=i2c_arm=on
```
 
This software does not come with any warranty, but I'm open to issues/suggestions.
