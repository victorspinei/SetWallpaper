#!/bin/bash

# Define the target user
TARGET_USER="victor"
TARGET_USER_HOME="/home/$TARGET_USER"

current_hour=$(date +'%H')

# Determine the time of day and set the appropriate wallpaper
if [ "$current_hour" -ge 7 ] && [ "$current_hour" -lt 11 ]; then
    time="morning"
elif [ "$current_hour" -ge 11 ] && [ "$current_hour" -lt 17 ]; then
    time="afternoon"
elif [ "$current_hour" -ge 17 ] && [ "$current_hour" -lt 21 ]; then
    time="evening"
else
    time="night"
fi

echo "Setting wallpaper to: ${TARGET_USER_HOME}/Pictures/guitarwallpaper_${time}.jpg"

# Get the DBUS_SESSION_BUS_ADDRESS for the target user
USER_DBUS_ADDRESS=$(sudo -u $TARGET_USER dbus-launch | grep 'DBUS_SESSION_BUS_ADDRESS' | awk -F= '{print $2}')

# Run the dbus-send command as the target user
sudo -u $TARGET_USER DBUS_SESSION_BUS_ADDRESS=$USER_DBUS_ADDRESS dbus-send --session --dest=org.kde.plasmashell --type=method_call \
/PlasmaShell org.kde.PlasmaShell.evaluateScript \
"string:
var Desktops = desktops();
for (i = 0; i < Desktops.length; i++) {
    var d = Desktops[i];
    d.wallpaperPlugin = 'org.kde.image';
    d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
    d.writeConfig('Image', 'file://${TARGET_USER_HOME}/Pictures/guitarwallpaper_${time}.jpg');
}"
