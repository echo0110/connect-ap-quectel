#!/bin/bash

LOG_FILE="/home/gensong/connect-ap-quectel/log.txt"
TEST_LOG_FILE="/home/gensong/connect-ap-quectel/test_log.txt"
WPA_LOG_FILE="/home/gensong/connect-ap-quectel/wpa_log.txt"
#MAX_SIZE=10485760  # 10MB
MAX_SIZE=314572800  # 300MB
echo "[$(date +%Y-%m-%d\ %H:%M:%S)] log_rotation script  begin" >> "${TEST_LOG_FILE}" | 2>&1
check_log_size() {
    if [ -f "${LOG_FILE}" ]; then
        local size=$(wc -c <"${LOG_FILE}")
        if [ "${size}" -ge "${MAX_SIZE}" ]; then
            >"${LOG_FILE}"
            echo "[$(date +%Y-%m-%d\ %H:%M:%S)] The log exceeds 300M" >> "${TEST_LOG_FILE}" | 2>&1
        fi
    fi
}

check_test_log_size() {
    if [ -f "${TEST_LOG_FILE}" ]; then
        local test_size=$(wc -c <"${TEST_LOG_FILE}")
        if [ "${test_size}" -ge "${MAX_SIZE}" ]; then
            >"${TEST_LOG_FILE}"
            echo "[$(date +%Y-%m-%d\ %H:%M:%S)] The test log exceeds 300M" >> "${TEST_LOG_FILE}" | 2>&1
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


while true; do
    check_log_size
    check_test_log_size
    sleep 60
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] check log size" >> "${TEST_LOG_FILE}" | 2>&1 

done

