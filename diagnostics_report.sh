#!/bin/bash
# diagnostics_report.sh
# Author: PSYBRCP
# Purpose: Generate a system diagnostics report including CPU, memory, disk, and network info.

OUT="diagnostics_report_$(date +%Y-%m-%d_%H-%M-%S).txt"

# Function: Section divider
divider() {
    echo "==================== $1 ====================" >> "$OUT"
}

# Function: System summary
system_info() {
    divider "SYSTEM INFO"
    hostnamectl >> "$OUT"
    echo "" >> "$OUT"
}

# Function: CPU and memory stats
cpu_memory() {
    divider "CPU & MEMORY"
    lscpu | grep 'Model name' >> "$OUT"
    free -h >> "$OUT"
    echo "" >> "$OUT"
}

# Function: Disk usage
disk_usage() {
    divider "DISK USAGE"
    df -h --total | grep -E 'Filesystem|total' >> "$OUT"
    echo "" >> "$OUT"
}

# Function: Network check
network_check() {
    divider "NETWORK CHECK"
    ping -c 2 8.8.8.8 &>/dev/null && echo "✅ Internet reachable" >> "$OUT" || echo "❌ No internet connection" >> "$OUT"
    ip a | grep inet >> "$OUT"
    echo "" >> "$OUT"
}

# Run all functions
system_info
cpu_memory
disk_usage
network_check

echo "Diagnostics complete. Report saved to $OUT"
