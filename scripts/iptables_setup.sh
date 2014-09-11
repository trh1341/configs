#!/bin/sh
#
# Created by James Sullivan
# Last updated 16/07/07
#
#


PATH=/usr/sbin:/sbin:/bin:/usr/bin

# temporarily disable routing
echo 0 > /proc/sys/net/ipv4/ip_forward

# temporarily block all traffic
iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP

# Delete/Flush old iptables rules
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X

#Make chains
iptables -N open
iptables -N interfaces

# Set default policies
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP

# Prevent external packets from using loopback addresses [OPTIONAL]
iptables -A INPUT   -i eth0 -s 127.0.0.1 -j DROP
iptables -A INPUT   -i eth0 -d 127.0.0.1 -j DROP
iptables -A FORWARD -i eth0 -s 127.0.0.1 -j DROP
iptables -A FORWARD -i eth0 -d 127.0.0.1 -j DROP
iptables -A INPUT   -i eth1 -s 127.0.0.1 -j DROP
iptables -A INPUT   -i eth1 -d 127.0.0.1 -j DROP
iptables -A FORWARD -i eth1 -s 127.0.0.1 -j DROP
iptables -A FORWARD -i eth1 -d 127.0.0.1 -j DROP

# Anything coming from/going to Internet should not
# use private addresses [OPTIONAL]
iptables -A INPUT   -i eth0 -s 172.16.0.0/12  -j DROP
iptables -A INPUT   -i eth0 -s 10.0.0.0/8     -j DROP
iptables -A INPUT   -i eth0 -s 192.168.0.0/24 -j DROP
iptables -A FORWARD -i eth0 -s 172.16.0.0/12  -j DROP
iptables -A FORWARD -i eth0 -s 10.0.0.0/8     -j DROP
iptables -A FORWARD -i eth0 -s 192.168.0.0/24 -j DROP

iptables -A INPUT   -i eth1 -s 172.16.0.0/12  -j DROP
iptables -A INPUT   -i eth1 -s 10.0.0.0/8     -j DROP
iptables -A INPUT   -i eth1 -s 192.168.0.0/24 -j DROP
iptables -A FORWARD -i eth1 -s 172.16.0.0/12  -j DROP
iptables -A FORWARD -i eth1 -s 10.0.0.0/8     -j DROP
iptables -A FORWARD -i eth1 -s 192.168.0.0/24 -j DROP


#Force SYN packets check 
#Make sure NEW incoming tcp connections are SYN packets; otherwise we need to drop them:
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

#Force Fragments packets check 
#Packets with incoming fragments. Drop them.
iptables -A INPUT -f -j DROP

#XMAS packets 
#Incoming malformed XMAS packets. Drop them:
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

#Drop all NULL packets 
#Incoming malformed NULL packets:
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP



# Block outgoing NetBios [OPTIONAL]
iptables -A FORWARD -p tcp --sport 137:139 -o eth0 -j LOG --log-prefix "FORWARD DROP: "
iptables -A FORWARD -p tcp --sport 137:139 -o eth0 -j DROP
iptables -A FORWARD -p udp --sport 137:139 -o eth0 -j LOG --log-prefix "FORWARD DROP: "
iptables -A FORWARD -p udp --sport 137:139 -o eth0 -j DROP
iptables -A OUTPUT  -p tcp --sport 137:139 -o eth0 -j LOG --log-prefix "OUTPUT DROP: "
iptables -A OUTPUT  -p tcp --sport 137:139 -o eth0 -j DROP
iptables -A OUTPUT  -p udp --sport 137:139 -o eth0 -j LOG --log-prefix "OUTPUT DROP: "
iptables -A OUTPUT  -p udp --sport 137:139 -o eth0 -j DROP
iptables -A FORWARD -p tcp --sport 137:139 -o eth1 -j LOG --log-prefix "FORWARD DROP: "
iptables -A FORWARD -p tcp --sport 137:139 -o eth1 -j DROP
iptables -A FORWARD -p udp --sport 137:139 -o eth1 -j LOG --log-prefix "FORWARD DROP: "
iptables -A FORWARD -p udp --sport 137:139 -o eth1 -j DROP
iptables -A OUTPUT  -p tcp --sport 137:139 -o eth1 -j LOG --log-prefix "OUTPUT DROP: "
iptables -A OUTPUT  -p tcp --sport 137:139 -o eth1 -j DROP
iptables -A OUTPUT  -p udp --sport 137:139 -o eth1 -j LOG --log-prefix "OUTPUT DROP: "
iptables -A OUTPUT  -p udp --sport 137:139 -o eth1 -j DROP

# Allow local loopback [NEEDED]
iptables -A INPUT -i lo -j ACCEPT

# Reject pings [OPTIONAL]
iptables -A INPUT -p icmp --icmp-type echo-request -i eth0 -j DROP
#iptables -A INPUT   -p icmp --icmp-type echo-request -j ACCEPT
#iptables -A FORWARD -p icmp --icmp-type echo-request -j ACCEPT

#ICMP type match blocking 
#Ok if your computer is not a router (like most desktops)
iptables -I INPUT -p icmp --icmp-type redirect -j DROP
iptables -I INPUT -p icmp --icmp-type router-advertisement -j DROP
iptables -I INPUT -p icmp --icmp-type router-solicitation -j DROP
iptables -I INPUT -p icmp --icmp-type address-mask-request -j DROP
iptables -I INPUT -p icmp --icmp-type address-mask-reply -j DROP

############ STATE STUFF ############
# Accept existing connections [NEEDED]
iptables -A INPUT   -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow any new conections from internal network
# [ONLY NEEDED IF PORTS ARE NOT EXPLITLY FORWARDED BELOW]
#iptables -A INPUT -m state --state NEW -i eth0 -j ACCEPT
#####################################

# Externally accessable inbound services [OPTIONAL]
iptables -A INPUT -p tcp -i eth0 --dport 45768:45769 -m state --state NEW -j ACCEPT #Bittorrent
iptables -A INPUT -p udp -i eth0 --dport 45768:45769 -m state --state NEW -j ACCEPT #Bittorrent
iptables -A INPUT -p tcp -i eth0 --dport 36865 -m state --state NEW -j ACCEPT #Dtella
iptables -A INPUT -p udp -i eth0 --dport 36864 -m state --state NEW -j ACCEPT #Dtella
iptables -A INPUT -p udp -i eth0 --dport 1521 -m state --state NEW -j ACCEPT #Dtella
iptables -A INPUT -p tcp -i eth0 --dport 36863 -m state --state NEW -j ACCEPT #Dtella
iptables -A INPUT -p tcp -i eth0 --dport 2031 -m state --state NEW -j ACCEPT #server
iptables -A INPUT -p udp -i eth0 --dport 2031 -m state --state NEW -j ACCEPT #server
iptables -A INPUT -p tcp --dport 4041 -m state --state NEW -j ACCEPT #sshd
iptables -A INPUT -p tcp --dport 6660:6669 -m state --state NEW -j ACCEPT #IRC

# Port Knocking -- use either port 2304 or port 5831 out of sequence to close port 4041
#iptables -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 4041 -m recent --rcheck --name SSH1 -j ACCEPT 
#iptables -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH1 --remove -j DROP 
#iptables -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 5831 -m recent --rcheck --name SSH0 -j SSH-INPUT 
#iptables -A TRAFFIC -m state --state NEW -m tcp -p tcp -m recent --name SSH0 --remove -j DROP 
#iptables -A TRAFFIC -m state --state NEW -m tcp -p tcp --dport 2304 -m recent --name SSH0 --set -j DROP 
#iptables -A SSH-INPUT -m recent --name SSH1 --set -j DROP 


# Internal inbound services [OPTIONAL - DNS NEEDED]
iptables -A INPUT -p udp -i eth0 --dport 53      -m state --state NEW -j ACCEPT #DNS cache
iptables -A INPUT -p tcp -i eth0 --dport 53      -m state --state NEW -j ACCEPT #DNS cache
#iptables -A INPUT -p udp -i eth0 --dport 137:139 -m state --state NEW -j ACCEPT #SAMBA
#iptables -A INPUT -p tcp -i eth0 --dport 445     -m state --state NEW -j ACCEPT #SAMBA
iptables -A INPUT -p udp -i eth1 --dport 53      -m state --state NEW -j ACCEPT #DNS cache
iptables -A INPUT -p tcp -i eth1 --dport 53      -m state --state NEW -j ACCEPT #DNS cache
#iptables -A INPUT -p udp -i eth1 --dport 137:139 -m state --state NEW -j ACCEPT #SAMBA
#iptables -A INPUT -p tcp -i eth1 --dport 445     -m state --state NEW -j ACCEPT #SAMBA

# Allow forwarding of essential services [NEEDED]
iptables -A FORWARD -p tcp --dport 80 -j ACCEPT #WEB
iptables -A FORWARD -p tcp --dport 443 -j ACCEPT #HTTPS

# Masquerade [NEEDED]
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# Enable routing.
echo 1 > /proc/sys/net/ipv4/ip_forward
