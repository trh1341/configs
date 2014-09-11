#!/bin/bash
# Quick n' Dirty IRSSI Connect Script Script
clear
echo -n "Would you like to load defualt settings or new settings? [D/n]: "
read ANSWER

if [ "$ANSWER" = "n" ]; then
	echo -n "Please enter the server you would like to connect to $USER: "
	read SERVER
	echo -n "Do you need a password?: [y/n]: " 
	read AUTH

	if [ "$AUTH" = "y" ]; then
		irssi -c $SERVER -w $PASS
	else
		irssi -c $SERVER
	fi

else
	irssi -c verne.freenode.net -w <password>
fi