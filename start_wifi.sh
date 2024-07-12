#!/bin/bash

### BEGIN INIT INFO
# Provides:          start_wifi
# Required-Start:    $network
# Required-Stop:     $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start WiFi service
# Description:       This script starts the WiFi service.
### END INIT INFO

echo "start_wifi.sh scrip start test ***********************"
cd /home/gensong/connect-ap-quectel && ./wifi_quectel.sh >> /home/gensong/connect-ap-quectel/log.txt &

cd /home/gensong/connect-ap-quectel/ && ./log_rotation.sh >> /home/gensong/connect-ap-quectel/test_log.txt &
