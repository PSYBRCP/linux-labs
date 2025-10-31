#!/usr/bin/env bash
set -euo pipefail

LOG="${1:-fake_access.log}"
[[ -f "$LOG" ]] || { echo "Log not found: $LOG"; exit 1; }

OUT="log_summary_$(date +%Y-%m-%d_%H-%M-%S).txt"

section(){ printf "\n==================== %s ====================\n" "$1"; }

{
  echo "Log Summary"
  echo "Source: $LOG"
  echo "Generated: $(date)"

  section "Basics"
  echo "Total requests: $(wc -l < "$LOG")"
  echo "Unique IPs:     $(awk '{print $1}' "$LOG" | sort -u | wc -l)"

  section "Top 10 IPs"
  awk '{print $1}' "$LOG" | sort | uniq -c | sort -nr | head -10

  section "Top 10 Paths"
  awk -F\" '{print $2}' "$LOG" | awk '{print $2}' | sort | uniq -c | sort -nr | head -10

  section "Status Codes"
  awk '{print $9}' "$LOG" | sort | grep -E '^[0-9]{3}$' | uniq -c | sort -nr

  section "User Agents (Top 5)"
  awk -F\" '{print $6}' "$LOG" | sort | uniq -c | sort -nr | head -5

  section "Traffic (Bytes, Approx)"
  awk '{sum+=$10} END {printf "Total bytes: %d\nAverage per req: %.2f\n", sum, (NR?sum/NR:0)}' "$LOG"

} | tee "$OUT"

echo "Saved report to: $OUT"
