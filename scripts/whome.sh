#!/bin/bash
sudo ifconfig wlan0 up
sudo iwconfig wlan0 essid paynewireless
sudo wpa_supplicant -B -Dwext -i wlan0 -c /etc/wpa_supplicant.conf
sleep 10s
sudo dhcpcd wlan0
