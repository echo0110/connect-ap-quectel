#!/bin/bash

# 获取无线网接口名称
output=$(dmesg | grep wlan0)
if [[ -z "$output" || "$output" != *"renamed from"* ]]; then
    interface="wlan0"
else
    output=$(dmesg | grep "renamed from wlan0")
    interface=$(echo "$output" | awk '{sub(":", "", $5); print $5}')
fi

# 获取 SSID 和 BSSID
iw_output=$(iw dev $interface link)
ssid=$(echo "$iw_output" | grep 'SSID:' | awk '{print $2}')
bssid=$(echo "$iw_output" | grep 'Connected to' | awk '{print $3}')

# 输出结果
echo "SSID:$ssid"
echo "BSSID:$bssid"

