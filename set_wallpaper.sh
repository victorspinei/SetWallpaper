#!/bin/bash

# Set environment variables explicitly
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u victor)/bus"

echo "Starting set_wallpaper.sh"

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

wallpaper_path="/home/victor/Pictures/wallpapers/guitarwallpaper_${time}.jpg"
echo "Setting wallpaper to: $wallpaper_path"

# Use qdbus to set the wallpaper
sudo -u victor DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u victor)/bus \
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript \
"string:
var Desktops = desktops();
for (var i=0; i<Desktops.length; i++) {
    var d = Desktops[i];
    d.wallpaperPlugin = 'org.kde.image';
    d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
    d.writeConfig('Image', 'file://$wallpaper_path');
}"

