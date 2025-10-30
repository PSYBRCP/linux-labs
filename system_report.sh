# To create a new script from terminal:
# cat > FILENAME.sh << 'EOF'
# write code in between
# End with EOF

#!/usr/bin/env bash
# Simple system report by PSYBRCP

set -euo pipefail

OUT="system_report_$(date +%Y-%m-%d_%H-%M-%S).txt"

# Helper to line up sections
section () { printf "\n==================== %s ====================\n" "$1"; }

{
  echo "System Report"
  echo "Generated: $(date)"
  echo "User: $(whoami)"
  echo "Host: $(hostname)"
  echo "--------------------------------------------"

  section "OS"
  # Try lsb_release; fallback to /etc/os-release
  if command -v lsb_release >/dev/null 2>&1; then
    echo "Distro: $(lsb_release -ds)"
  else
    . /etc/os-release && echo "Distro: $PRETTY_NAME"
  fi
  echo "Kernel: $(uname -r)"
  echo "Uptime: $(uptime -p)"

  section "CPU"
  echo "Model:  $(lscpu | awk -F: '/Model name/ {print $2}' | sed 's/^ *//')"
  echo "Cores:  $(lscpu | awk -F: '/^CPU\\(s\\)/ {print $2}' | sed 's/^ *//')"
  echo "Arch:   $(uname -m)"

  section "Memory"
  free -h

  section "Disk (Top-Level Mounts)"
  df -h -x tmpfs -x devtmpfs | awk 'NR==1 || $6 ~ /^\\/$|^\\/home|^\\/boot/'

  section "Networking (IPv4)"
  ip -4 addr show | awk '/inet /{print $2 " -> " $NF}'
  echo "Default route: $(ip route | awk '/default/ {print $3 " via " $5; exit}')"

} | tee "$OUT"

echo
echo "Saved report to: $OUT"
