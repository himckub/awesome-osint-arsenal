#!/usr/bin/env bash
# ===================================================================
# Awesome OSINT Arsenal — Termux (Android) installer
# Subset of tools known to work on Termux.
# Run from Termux:
#   pkg install -y git && git clone <repo> && cd <repo> && bash install-termux.sh
# ===================================================================
set -uo pipefail

RED="\033[0;31m"; GRN="\033[0;32m"; YLW="\033[1;33m"; BLU="\033[0;34m"; NC="\033[0m"
LOGFILE="$HOME/osint-install-errors.log"
: > "$LOGFILE"
INSTALLED=0; SKIPPED=0; FAILED=0
declare -a FAILED_TOOLS=()

say()  { echo -e "${BLU}[*]${NC} $*"; }
ok()   { echo -e "${GRN}[✓]${NC} $*"; INSTALLED=$((INSTALLED+1)); }
skip() { echo -e "${YLW}[~]${NC} $*"; SKIPPED=$((SKIPPED+1)); }
fail() { echo -e "${RED}[✗]${NC} $*"; FAILED=$((FAILED+1)); FAILED_TOOLS+=("$1"); echo "FAIL: $*" >> "$LOGFILE"; }

install_pkg() {
  local p="$1"
  if dpkg -s "$p" >/dev/null 2>&1; then skip "$p already installed"; return; fi
  if pkg install -y "$p" >/dev/null 2>&1; then ok "$p (pkg)"; else fail "$p (pkg)"; fi
}
install_pip() {
  local p="$1"
  if pip show "$p" >/dev/null 2>&1; then skip "$p (pip) already installed"; return; fi
  if pip install "$p" >/dev/null 2>&1; then ok "$p (pip)"; else fail "$p (pip)"; fi
}
install_git() {
  local repo="$1" dst="$2"
  mkdir -p "$HOME/osint-arsenal"
  if [ -d "$HOME/osint-arsenal/$dst" ]; then skip "$dst already cloned"; return; fi
  if git clone --depth=1 "$repo" "$HOME/osint-arsenal/$dst" >/dev/null 2>&1; then ok "$dst (git)"; else fail "$dst (git)"; fi
}

say "Updating Termux..."
pkg update -y >/dev/null 2>&1 || true
pkg upgrade -y >/dev/null 2>&1 || true

say "Installing core packages..."
pkg install -y python python-pip git curl wget openssh nmap hydra perl >/dev/null 2>&1 || true
termux-setup-storage 2>/dev/null || true

say "Installing Termux-compatible tools..."
install_pkg aircrack-ng  # Aircrack-ng
install_pip blackbird-osint  # Blackbird
install_pip censys  # Censys CLI
install_pip dnsrecon  # dnsrecon
install_pip dnstwist  # dnstwist
install_pkg libimage-exiftool-perl  # ExifTool
install_git https://github.com/Manisso/fsociety.git fsociety  # fsociety
install_pip gitrecon  # Gitrecon
install_pip h8mail  # h8mail
install_pip holehe  # Holehe
install_pkg hydra  # Hydra
install_pip instaloader  # Instaloader
install_git https://github.com/maldevel/IPGeoLocation.git IPGeoLocation  # IPGeoLocation
install_pkg john  # John the Ripper
install_pip maigret  # Maigret
install_pip metagoofil  # Metagoofil
install_git https://github.com/htr-tech/nexphisher.git nexphisher  # NexPhisher
install_pkg nmap  # Nmap
install_git https://github.com/s0md3v/Orbit.git Orbit  # Orbit
install_pip phoneinfoga  # PhoneInfoga
install_git https://github.com/aerosol-can/PhoneSploit.git PhoneSploit  # PhoneSploit
install_pip sherlock-project  # Sherlock
install_pip shodan  # Shodan
install_pip shodan  # Shodan CLI
install_pip snoop  # Snoop
install_pip snscrape  # snscrape
install_pip social-analyzer  # Social Analyzer
install_git https://github.com/ultrasecurity/Storm-Breaker.git Storm-Breaker  # Storm-Breaker
install_pip sublist3r  # Sublist3r
install_pip theHarvester  # theHarvester
install_pip trufflehog  # trufflehog
install_git https://github.com/wishihab/userrecon.git userrecon  # UserRecon
install_git https://github.com/htr-tech/zphisher.git zphisher  # Zphisher

echo
echo "============================================="
echo -e "  Installed: ${GRN}$INSTALLED${NC}"
echo -e "  Skipped:   ${YLW}$SKIPPED${NC}"
echo -e "  Failed:    ${RED}$FAILED${NC}"
echo "============================================="
if (( FAILED > 0 )); then
  echo -e "${RED}Failed tools:${NC} ${FAILED_TOOLS[*]}"
  echo "See $LOGFILE for details."
fi
echo
echo "Tools cloned to: $HOME/osint-arsenal/"
echo "For more tools, see the README.md — many require x86 Linux and won't run on Android."