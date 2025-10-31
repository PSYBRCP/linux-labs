#!/usr/bin/env bash
# Enhanced system report by PSYBRCP

set -euo pipefail

OUT="system_report_$(date +%Y-%m-%d_%H-%M-%S).txt"

# Helper to format section headers
section () { printf "\n==================== %s ====================\n" "$1"; }

# If user supplies "--quick", skip heavy checks
QUICK=false
if [[ "${1:-}" == "--quick" ]]; then
  QUICK=true
fi

{
  echo "System Report"
  echo "Generated: $(date)"
  echo "User: $(whoami)"
  echo "Host: $(hostname)"
  echo "--------------------------------------------"

  section "OS"
  if command -v lsb_release >/dev/null 2>&1; then
    echo "Distro: $(lsb_release -ds)"
  else
    . /etc/os-release && echo "Distro: $PRETTY_NAME"
  fi
  echo "Kernel: $(uname -r)"
  echo "Uptime: $(uptime -p)"

  section "CPU"
  echo "Model:  $(lscpu | awk -F: '/Model name/ {print $2}' | sed 's/^ *//')"
  echo "Cores:  $(nproc)"
  echo "Arch:   $(uname -m)"

  section "Memory"
  free -h

  section "Disk (Top-Level Mounts)"
  df -h -x tmpfs -x devtmpfs | awk 'NR==1 || $6 ~ /^\\/$|^\\/home|^\\/boot/'

  section "Networking (IPv4)"
  ip -4 addr show | awk '/inet /{print $2 " -> " $NF}'
  echo "Default route: $(ip route | awk '/default/ {print $3 " via " $5; exit}')"

  if ! \$QUICK; then
    section "Top 10 Processes (by CPU usage)"
    ps aux --sort=-%cpu | head -n 11

    section "Listening Ports"
    if command -v ss >/dev/null 2>&1; then
      sudo ss -tulpen | head -n 15
    else
      sudo netstat -tulpen | head -n 15
    fi
  else
    section "Quick Mode"
    echo "(Skipped process and port checks for faster run)"
  fi

} | tee "\$OUT"

echo
echo "Saved report to: \$OUT"
