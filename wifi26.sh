#!/bin/bash

#interface="rename5"
wpa_supplicant_conf="/home/gensong/wpa_supplicant.conf"
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
cd /lib/modules 

insmod wlan_cnss_core_pcie.ko

sleep 3
insmod wlan.ko
sleep 7


killall wpa_supplicant
sleep 2

#output=$(dmesg | grep wlan0)
#interface=$(echo "$output" | awk '{print $5}')

#echo "output is $output"
#echo "[$(date +%Y-%m-%d\ %H:%M:%S)] interface is :$interface"



output=$(dmesg | grep wlan0)
interface=$(echo "$output" | awk '{sub(":", "", $5); print $5}')

echo "output is $output"
echo "[$(date +%Y-%m-%d\ %H:%M:%S)] interface is :$interface"
#interface="wlP2p33s0"
#wpa_supplicant -B -i "$interface" -c "$wpa_supplicant_conf" -dd -f /home/gensong/wpa_supplicant.log -t "$timestamp"  &
rfkill unblock  all
ifconfig $interface up
sleep 2
wpa_supplicant -B -i "$interface" -c "$wpa_supplicant_conf" -td 2>&1 | while read wpa; do echo "$(date) $wpa"; done >> /home/gensong/wpa_log.txt &
sleep 2
ifconfig $interface 192.168.108.93 netmask 255.255.0.0
sleep 1
sudo cp /home/gensong/resolv.conf /var/run/NetworkManager/
sudo route add default gw 192.168.31.1

#wpa_supplicant -B -i "$interface" -c "$wpa_supplicant_conf" -dd 2>&1 | while read wpa; do echo "$(date) $wpa"; done >> /home/gensong/wpa_log.txt &


#sleep 10
#ping -i 10 192.168.108.253 | while read pong; do echo "$(date) $pong"; done 2>&1 | tee /home/gensong/log.txt &
#ping 192.168.108.249 | while read pong; do echo "$(date) $pong"; done 2>&1 | tee /home/gensong/ping_log.txt &
#wpa_supplicant -D nl80211 -i wlP2p33s0 -c /home/gensong/wpa_supplicant.conf &

