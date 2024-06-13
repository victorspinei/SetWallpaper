#!/bin/bash

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

echo "Setting wallpaper to: /home/$USER/Pictures/guitarwallpaper_${time}.jpg"

dbus-send --session --dest=org.kde.plasmashell --type=method_call \
/PlasmaShell org.kde.PlasmaShell.evaluateScript \
"string:
var Desktops = desktops();
for (i = 0; i < Desktops.length; i++) {
    var d = Desktops[i];
    d.wallpaperPlugin = 'org.kde.image';
    d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
    d.writeConfig('Image', 'file:///home/$USER/Pictures/guitarwallpaper_${time}.jpg');
}"
