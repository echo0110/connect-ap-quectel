#!/bin/bash

wpa_supplicant_conf="/home/gensong/wpa_supplicant.conf"
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

killall wpa_supplicant

cd /lib/modules 

insmod wlan_cnss_core_pcie.ko

sleep 3
insmod wlan.ko
sleep 7

killall wpa_supplicant
sleep 2
killall wpa_supplicant

#output=$(dmesg | grep wlan0)
#interface="wlan0" #$(echo "$output" | awk '{sub(":", "", $5); print $5}')
output=$(dmesg | grep wlan0)
if [[ -z "$output" || "$output" != *"renamed from"* ]]; then
    interface="wlan0"
else
    output=$(dmesg | grep "renamed from wlan0")
    interface=$(echo "$output" | awk '{sub(":", "", $5); print $5}')
fi

echo "output is $output"
echo "[$(date +%Y-%m-%d\ %H:%M:%S)] interface is :$interface"
rfkill unblock  all
ifconfig $interface up
sleep 2
wpa_supplicant -Dnl80211 -i "$interface" -c "$wpa_supplicant_conf" -td &
sleep 2
#ifconfig $interface 192.168.108.93 netmask 255.255.0.0

IP=$(sed -n '1p' /home/gensong/WIFI_CONFIG/wifi_config)
NETMASK=$(sed -n '2p' /home/gensong/WIFI_CONFIG/wifi_config)
GW=$(sed -n '3p' /home/gensong/WIFI_CONFIG/wifi_config)

ifconfig $interface $IP netmask $NETMASK
sleep 1
#sudo cp /home/gensong/resolv.conf /var/run/NetworkManager/
cp /home/gensong/resolv.conf /etc/resolv.conf
#sudo route add default gw 192.168.31.1
route add default gw $GW


sleep 2
cd /home/gensong/ap/ && ./set_ap.sh > logap &
