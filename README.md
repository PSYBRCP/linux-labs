# linux-labs
Learning Linux basics in a VirtualBox home lab.

## 1. System Report (v1 & v2)

This project generates a detailed text-based report of the current Linux system. It includes key information about:

- Operating system and kernel
- CPU model and architecture
- Memory usage
- Disk usage
- Network configuration
- (Version 2 only) Top CPU processes, listening ports, and quick mode support

This tool is useful when you need to capture a snapshot of a system for troubleshooting or documentation purposes.

---

## Data Safety & .gitignore

This project intentionally excludes all generated data files (`*.txt`, `*.log`, etc.) from version control using a `.gitignore` file.

Only scripts and documentation are published — any system data, logs, or reports created during testing stay local.

This reflects standard best practices for securing sensitive or environment-specific information in development and security workflows.

---

### Files
- `system_report.sh` – Original version
- `system_reportv2.sh` – Enhanced version with more functionality and modular structure

---

### Run

```bash
# Basic full report
./system_reportv2.sh

# Faster version (skips ports and process checks)
./system_reportv2.sh --quick
```
---

## 2. Diagnostics Report

Generates a quick system diagnostics snapshot with hardware/OS details, CPU + memory stats, disk usage, and a basic network reachability check. Designed to be fast, readable, and safe for local use.

### Files
- `diagnostics_report.sh` – Main script that writes a timestamped report file (e.g., `diagnostics_report_2025-10-31_14-22-18.txt`)

### Run
```bash
./diagnostics_report.sh
```
---

## Project 3: Log Generation & Analysis

This project simulates a simplified web server logging environment using Bash scripting.
It includes two main scripts: one for generating synthetic access logs, and another for analyzing them to extract insights similar to what you’d find in cybersecurity, network monitoring, or SIEM workflows.

---

### Files
| File | Description |
|-------|-------------|
| `generate_fake_logs.sh` | Generates synthetic Apache-style access logs with randomized IPs, URLs, methods, status codes, and user agents. |
| `analyze_logs.sh` | Parses log files and produces a readable analytics report (top IPs, most accessed paths, status code breakdown, etc.). |

---

### Features
Generates thousands of fake logs with realistic request fields 
Extracts:
- Total requests
- Number of unique IPs
- Top 10 IP addresses
- Top 10 requested paths
- HTTP status code counts
Automatically timestamps output reports
Works fully offline — no real traffic or sensitive data involved
Log files are **excluded from Git** via `.gitignore` (only scripts are versioned)

---

### Run

**1. Generate fake logs (example: 2000 entries)**  
```bash
./generate_fake_logs.sh 2000

**2. Analyze fake logs
./analyze_logs.sh
```

