#!/bin/bash

LOG_DIR="$HOME/OpsPilot/logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/health.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "================================"
echo "Timestamp: $(date)"
echo "================================"


echo "===== OpsPilot Server Health Check ====="

echo ""
echo "Hostname:"
hostname

echo ""
echo "Uptime:"
uptime

echo ""
echo "Disk Usage:"
df -h /

DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$DISK_USAGE" -ge 80 ]; then
    echo "WARNING: Disk usage is above 80%!"
else
    echo "OK: Disk usage is normal."
fi

echo ""
echo "Memory Usage:"
free -h

MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}')

if [ "$MEMORY_USAGE" -ge 80 ]; then
    echo "WARNING: Memory usage is above 80%!"
else
    echo "OK: Memory usage is normal."
fi

echo ""
echo "CPU Load:"

CPU_LOAD=$(awk '{print $1}' /proc/loadavg)

echo "Current CPU Load: $CPU_LOAD"

CPU_CORES=$(nproc)

if awk -v cpu_load="$CPU_LOAD" -v cores="$CPU_CORES" 'BEGIN {exit !(cpu_load > cores)}'; then
    echo "WARNING: CPU load is high!"
else
    echo "OK: CPU load is normal."
fi

echo ""
echo "===== Health Check Completed ====="
