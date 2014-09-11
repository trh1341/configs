#!/bin/bash
sudo iwconfig wlan0 essid linksys
sudo dhcpcd wlan0
