#!/bin/bash

wpa_supplicant_conf="/home/gensong/wpa_supplicant.conf"
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
cd /lib/modules 

insmod wlan_cnss_core_pcie.ko

sleep 3
insmod wlan.ko
sleep 7


killall wpa_supplicant
sleep 2




output=$(dmesg | grep wlan0)
interface=$(echo "$output" | awk '{sub(":", "", $5); print $5}')

echo "output is $output"
echo "[$(date +%Y-%m-%d\ %H:%M:%S)] interface is :$interface"
rfkill unblock  all
ifconfig $interface up
sleep 2
#wpa_supplicant -B -i "$interface" -c "$wpa_supplicant_conf" -td 2>&1 | while read wpa; do echo "$(date) $wpa"; done >> /home/gensong/connect-ap-quectel/wpa_log.txt &
wpa_supplicant -B -i "$interface" -c "$wpa_supplicant_conf" -td &
sleep 2
#ifconfig $interface 192.168.108.93 netmask 255.255.0.0
sleep 1
sudo cp /home/gensong/resolv.conf /var/run/NetworkManager/
#sudo route add default gw 192.168.31.1

