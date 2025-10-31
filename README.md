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

### Files
- `system_report.sh` – Original version
- `system_reportv2.sh` – Enhanced version with more functionality and modular structure

---

### Run the script

```bash
# Basic full report
./system_reportv2.sh

# Faster version (skips ports and process checks)
./system_reportv2.sh --quick
