#!/bin/sh
while true;
do
   find $HOME/.wallpaper -type f -name '*.jpg' -o -name '*.png' | shuf -n 1 | xargs feh --bg-center
   #feh --bg-center "$(find ~/.wallpaper -name *.jpg | shuf -n 1)"
   sleep 15m
done &

