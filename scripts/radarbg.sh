#! /bin/bash

cd /tmp/
rm latest.gif
wget http://radar.weather.gov/Conus/RadarImg/latest.gif
convert -modulate 75 -negate latest.gif latest.gif
convert -transparent "#b03e00" latest.gif latest.gif
mv latest.gif radarwall.gif
feh --bg-scale --no-bg /tmp/radarwall.gif
#gconftool-2 -t str --set /desktop/gnome/background/picture_filename /tmp/radarwall.gif
