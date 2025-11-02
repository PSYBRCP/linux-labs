# To create a new script from terminal
# cat > FILENAME.sh << 'EOF'
# write code in between
# End with EOF

#!/usr/bin/env bash
# Simple system report by PSYBRCP

#!/usr/bin/env bash
set -euo pipefail

report_time="$(date -u '+%a %b %e %T %Z %Y')"
user_name="${USER:-unknown}"
host_name="$(hostname)"

echo "System Report"
echo "Generated: $report_time"
echo "User: $user_name"
echo "Host: $host_name"
echo "--------------------------------------------"
echo

###################### OS ######################
echo "==================== OS ===================="
if command -v lsb_release >/dev/null 2>&1; then
  distro="$(lsb_release -ds)"
else
  distro="$(. /etc/os-release; echo "$NAME $VERSION")"
fi
kernel="$(uname -r)"
uptime_str="$(uptime -p | sed 's/^up //')"

echo "Distro: $distro"
echo "Kernel: $kernel"
echo "Uptime: up $uptime_str"
echo

##################### CPU ######################
echo "==================== CPU ===================="
cpu_model="$(lscpu | awk -F: '/^Model name/{gsub(/^ +/,"",$2); print $2}')"
cpu_cores_logical="$(nproc)"
cpu_arch="$(uname -m)"

echo "Model:  ${cpu_model:-unknown}"
echo "Cores:  ${cpu_cores_logical:-unknown} (logical)"
echo "Arch:   ${cpu_arch}"
echo

################### Memory #####################
echo "==================== Memory ===================="
free -h
echo

################ Disk (Top-Level Mounts) ################
echo "==================== Disk (Top-Level Mounts) ===================="
# Show real filesystems; hide tmpfs, devtmpfs, squashfs (snaps), cgroup, overlay
df -hT -x tmpfs -x devtmpfs -x squashfs -x overlay -x efivarfs \
  | awk 'NR==1 || $2 ~ /ext[234]|xfs|btrfs|zfs|ntfs|vfat|apfs/ {
           printf "%-20s %-10s %-10s %-10s %-10s %-s\n",
                  $1, $2, $3, $4, $6, $7
        }' \
  | sed '1s/Type      /Type      /' \
  | sed '1s/Available/Avail     /'
echo


