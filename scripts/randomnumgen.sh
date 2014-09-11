#!/bin/bash
RANDOM=`seq 1 10 | sort -R | head -1`
RANDOM2=`seq 1 10 | sort -R | head -$RANDOM | tail -1`
#echo -n "Random Number: "
if [ -n "$1" ]; then
	seq 1 $1 | sort -R | head -$RANDOM2 | tail -1
else
	echo "Please use like this: $0 <maximum number>"
fi
