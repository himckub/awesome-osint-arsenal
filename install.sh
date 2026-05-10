#!/usr/bin/env bash
# ===================================================================
# Awesome OSINT Arsenal — install everything
# Runs each category installer in order.
# Best support: Kali / Debian / Ubuntu / Parrot.
# Partial: Arch / Manjaro / Fedora / RHEL.
# For Android, use: bash termux.sh
# ===================================================================
set -uo pipefail
cd "$(dirname "$0")"

if [ "$EUID" -ne 0 ]; then
  echo "Run me as root:  sudo bash install.sh"
  exit 1
fi

INSTALLERS=(
  "osint.sh"
  "redteam.sh"
  "blueteam.sh"
  "forensics.sh"
  "hardware.sh"
  "labs.sh"
  "extras.sh"
)

LOGFILE="$HOME/osint-install-errors.log"
: > "$LOGFILE"

for inst in "${INSTALLERS[@]}"; do
  echo
  echo "==========================================="
  echo " Running: $inst"
  echo "==========================================="
  bash "$inst"
done

echo
echo "==========================================="
echo " ALL DONE"
echo " Failures (if any) logged to: $LOGFILE"
echo "==========================================="
