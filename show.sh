#!/usr/bin/env bash
# Show the latest data this program produced on PUB400, without recompiling.
# Prints the current OUTPUTF rows and the single LASTRUN "last updated" timestamp.
#
# Requires:
#   PUB400_USERNAME  - your PUB400 user profile
#   PUB400_PASSWORD  - your PUB400 password
# Optional:
#   PUB400_LIB       - target library (default: <USERNAME-uppercase>1, your *CURLIB)
#
# Usage:  ./show.sh
set -euo pipefail

HOST="pub400.com"; SSH_PORT=2222
: "${PUB400_USERNAME:?set PUB400_USERNAME}"
: "${PUB400_PASSWORD:?set PUB400_PASSWORD}"

USER_UC=$(printf '%s' "$PUB400_USERNAME" | tr '[:lower:]' '[:upper:]')
LIB="${PUB400_LIB:-${USER_UC}1}"

ssh_run() { sshpass -p "$PUB400_PASSWORD" ssh -p "$SSH_PORT" -o StrictHostKeyChecking=accept-new "$PUB400_USERNAME@$HOST" "$@"; }

echo ">> OUTPUTF (latest results) in $LIB:"
ssh_run "system \"RUNQRY QRYFILE(($LIB/OUTPUTF)) OUTTYPE(*RUNOPT)\""

echo
echo ">> LASTRUN (when PROCESS last ran) in $LIB:"
ssh_run "system \"RUNQRY QRYFILE(($LIB/LASTRUN)) OUTTYPE(*RUNOPT)\""
