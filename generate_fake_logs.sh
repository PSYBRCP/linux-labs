#!/usr/bin/env bash
set -euo pipefail

LINES="${1:-1000}"
OUT="fake_access.log"

# Reserved “documentation” subnets (RFC 5737)
IPS=(192.0.2 198.51.100 203.0.113)

PATHS=(/ /index.html /about /login /logout /products /cart /checkout /api/v1/items /api/v1/items/42 /search?q=linux /static/app.js /static/style.css)
METHODS=(GET POST)
CODES=(200 200 200 200 201 204 301 302 400 401 403 404 500 502 503)  # weighted toward 200
SIZES=(128 256 512 1024 2048 4096 8192)
UAS=(
"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/129.0"
"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Edge/129.0"
"curl/8.5.0"
"HTTPie/3.2.2"
)

rand() { printf "%s\n" "$@" |  shuf -n1; }

: > "$OUT"
for i in $(seq 1 "$LINES"); do
  ip="$(rand "${IPS[@]}").$((RANDOM % 256))"
  ts="$(date -R)"
  method="$(rand "${METHODS[@]}")"
  path="$(rand "${PATHS[@]}")"
  code="$(rand "${CODES[@]}")"
  size="$(rand "${SIZES[@]}")"
  ua="$(rand "${UAS[@]}")"
  printf '%s - - [%s] "%s %s HTTP/1.1" %s %s "-" "%s"\n' \
    "$ip" "$ts" "$method" "$path" "$code" "$size" "$ua" >> "$OUT"
done

echo "Wrote $LINES lines to $OUT"
