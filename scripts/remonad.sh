#!/bin/sh
#
# pbrisbin 2009
#
###

# killall conky
for pid in `pgrep conky`; do
  /bin/kill -9 $pid
done

# killall dzen2
for pid in `pgrep dzen2`; do
  /bin/kill -9 $pid
done


# restart xmonad
sleep 1 && /usr/bin/xmonad --restart &

exit 0
