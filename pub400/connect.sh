#!/usr/bin/env bash
# Connect to PUB400.COM (a free public IBM i) for working with this RPGLE program.
#
# Credentials come from environment variables:
#   PUB400_USERNAME  - your PUB400 user profile
#   PUB400_PASSWORD  - your PUB400 password
#
# Usage:
#   ./connect.sh ssh                 # open an interactive PASE shell over SSH (port 2222)
#   ./connect.sh 5250                # open the interactive 5250 green screen (needs tn5250)
#   ./connect.sh run '<command>'     # run one command in the PASE shell and exit
#
# Notes:
#   - SSH is on port 2222. The 5250 telnet port is 23 (992 for SSL).
#   - In the PASE shell, run IBM i CL commands via:  system "DSPLIBL OUTPUT(*PRINT)"
set -euo pipefail

HOST="pub400.com"
SSH_PORT=2222
: "${PUB400_USERNAME:?set PUB400_USERNAME}"
: "${PUB400_PASSWORD:?set PUB400_PASSWORD}"

ssh_base=(sshpass -p "$PUB400_PASSWORD" ssh -p "$SSH_PORT" -o StrictHostKeyChecking=accept-new "$PUB400_USERNAME@$HOST")

case "${1:-ssh}" in
  ssh)  exec "${ssh_base[@]}" ;;
  run)  shift; exec "${ssh_base[@]}" "$@" ;;
  5250) exec tn5250 "$HOST" ;;          # use 'tn5250 ssl:pub400.com' for the SSL port
  *)    echo "usage: $0 {ssh|5250|run '<command>'}" >&2; exit 2 ;;
esac
