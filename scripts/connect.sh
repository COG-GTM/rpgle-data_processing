#!/usr/bin/env bash
# Connect to PUB400.COM via TN5250 terminal emulator.
# Usage: ./scripts/connect.sh
#
# Requires: tn5250 (https://github.com/tn5250/tn5250)
# Set PUB400_USERNAME and PUB400_PASSWORD as environment variables,
# or you will be prompted interactively at the sign-on screen.

set -euo pipefail

HOST="PUB400.COM"

if ! command -v tn5250 &>/dev/null; then
  echo "Error: tn5250 is not installed."
  echo "Install it from https://github.com/tn5250/tn5250"
  exit 1
fi

echo "Connecting to ${HOST} via TN5250..."
echo "You will see the IBM i sign-on screen."
echo "Enter your PUB400 username and password when prompted."
echo ""

tn5250 "${HOST}"
