#!/bin/bash
##################################################
# Add route table                                #
# Author by Dethroner, 2020                      #
##################################################

# netstat -rn

echo "192.168.121.125	hd-17496.sam-solutions.net" >> /etc/hosts
route add -host 192.168.121.125 gw 10.0.2.2

# route add -net 192.168.2.0 netmask 255.255.255.0 gw 192.168.0.1
# route add -net 192.168.2.0/24 gw 192.168.0.1