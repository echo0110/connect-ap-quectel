#!/bin/bash

LOG_FILE="/home/gensong/connect-ap-quectel/ping.txt"
TEST_LOG_FILE="/home/gensong/connect-ap-quectel/test_log.txt"
WPA_LOG_FILE="/home/gensong/connect-ap-quectel/wpa_log.txt"
log_dir="/home/gensong/connect-ap-quectel/logdmesg"

PING_FILE="/home/gensong/connect-ap-quectel/Ping"
#MAX_SIZE=10485760  # 10MB
MAX_SIZE=31457280  # 300MB
echo "[$(date +%Y-%m-%d\ %H:%M:%S)] log_rotation script  begin" >> "${TEST_LOG_FILE}" | 2>&1
check_log_size() {
    if [ -f "${LOG_FILE}" ]; then
        local size=$(wc -c <"${LOG_FILE}")
        if [ "${size}" -ge "${MAX_SIZE}" ]; then
            >"${LOG_FILE}"
            echo "[$(date +%Y-%m-%d\ %H:%M:%S)] The log exceeds 30M" >> "${TEST_LOG_FILE}" | 2>&1
        fi
    fi
}

check_test_log_size() {
    if [ -f "${TEST_LOG_FILE}" ]; then
        local test_size=$(wc -c <"${TEST_LOG_FILE}")
        if [ "${test_size}" -ge "${MAX_SIZE}" ]; then
            >"${TEST_LOG_FILE}"
            echo "[$(date +%Y-%m-%d\ %H:%M:%S)] The test log exceeds 30M" >> "${TEST_LOG_FILE}" | 2>&1
        fi
    fi
}
check_wpa_log_size() {
    if [ -f "${WPA_LOG_FILE}" ]; then
        local test_size=$(wc -c <"${WPA_LOG_FILE}")
        if [ "${test_size}" -ge "${MAX_SIZE}" ]; then
            >"${WPA_LOG_FILE}"
            echo "[$(date +%Y-%m-%d\ %H:%M:%S)] The test log exceeds 300M" >> "${WPA_LOG_FILE}" | 2>&1
        fi
    fi
}

check_logd_size() {
    # Calculate the total size of all files in the directory in MB
    total_size_mb=$(du -sm $log_dir | awk '{print $1}')
    echo "Total size is ${total_size_mb}MB"
    
    # Check if the total size exceeds 10MB
    if [ $total_size_mb -gt 10 ]; then
        echo "Total size of $log_dir is larger than 10MB. Cleaning up..."
        # Clear the directory
        rm -r $log_dir/*
    fi
}


check_logping_size() {
    # Calculate the total size of all files in the directory in MB
    total_size_mb=$(du -sm $PING_FILE | awk '{print $1}')
    echo "Total size is ${total_size_mb}MB"

    # Check if the total size exceeds 10MB
    if [ $total_size_mb -gt 30 ]; then
        echo "Total size of $PING_FILE is larger than 10MB. Cleaning up..."
        # Clear the directory
        rm -r $log_dir/*
    fi
}

while true; do
    check_log_size
    check_test_log_size
    check_logd_size
    check_logping_size
    sleep 60
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] check log size" >> "${TEST_LOG_FILE}" | 2>&1 

done

