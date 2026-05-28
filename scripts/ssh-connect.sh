#!/usr/bin/env bash
# Connect to PUB400.COM via SSH (PASE shell).
# Usage: ./scripts/ssh-connect.sh
#
# Requires PUB400_USERNAME environment variable.
# You will be prompted for your password interactively.
#
# Note: PUB400 SSH runs on port 2222 (not the default 22).

set -euo pipefail

HOST="PUB400.COM"
PORT="2222"

if [[ -z "${PUB400_USERNAME:-}" ]]; then
  echo "Error: PUB400_USERNAME is not set."
  echo "Export it before running this script:"
  echo "  export PUB400_USERNAME=youruser"
  exit 1
fi

echo "Connecting to ${HOST}:${PORT} as ${PUB400_USERNAME} via SSH..."

ssh -o StrictHostKeyChecking=accept-new -p "${PORT}" "${PUB400_USERNAME}@${HOST}"
