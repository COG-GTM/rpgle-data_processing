#!/usr/bin/env bash
# Compile RPGLE source on PUB400.COM via SSH.
# Usage: ./scripts/compile.sh [source_name]
#
# source_name: Name of the .rpgle file (without extension). Defaults to "process".
#
# This script:
#   1. Copies the source from the PASE IFS into a source physical file (QRPGLESRC)
#   2. Compiles it with CRTBNDRPG
#
# Requires: PUB400_USERNAME environment variable.
#
# Note: PUB400 SSH runs on port 2222 (not the default 22).

set -euo pipefail

HOST="PUB400.COM"
PORT="2222"
SOURCE="${1:-process}"
LIB="${PUB400_USERNAME^^}"  # PUB400 library is usually the uppercase username
REMOTE_DIR="/home/${PUB400_USERNAME}/rpgle"

if [[ -z "${PUB400_USERNAME:-}" ]]; then
  echo "Error: PUB400_USERNAME is not set."
  exit 1
fi

# Commands to run on IBM i via SSH (PASE shell -> system CL commands)
# Step 1: Ensure the source physical file exists
# Step 2: Copy the IFS file into the source member
# Step 3: Compile with CRTBNDRPG
COMMANDS=$(cat <<EOF
echo "=== Creating source physical file QRPGLESRC in ${LIB} (if not exists) ==="
system "CRTSRCPF FILE(${LIB}/QRPGLESRC) RCDLEN(112)" 2>/dev/null || true

echo "=== Copying ${SOURCE}.rpgle from IFS to source member ==="
system "CPYFRMSTMF FROMSTMF('${REMOTE_DIR}/${SOURCE}.rpgle') TOMBR('/QSYS.LIB/${LIB}.LIB/QRPGLESRC.FILE/${SOURCE}.MBR') MBROPT(*REPLACE)" 

echo "=== Setting source type to RPGLE ==="
system "CHGPFM FILE(${LIB}/QRPGLESRC) MBR(${SOURCE}) SRCTYPE(RPGLE)"

echo "=== Compiling ${SOURCE} with CRTBNDRPG ==="
system "CRTBNDRPG PGM(${LIB}/${SOURCE}) SRCFILE(${LIB}/QRPGLESRC) SRCMBR(${SOURCE}) DBGVIEW(*SOURCE)"

echo "=== Done ==="
EOF
)

echo "Compiling ${SOURCE}.rpgle on ${HOST} in library ${LIB}..."
echo ""

ssh -o StrictHostKeyChecking=accept-new -o PubkeyAuthentication=no -p "${PORT}" "${PUB400_USERNAME}@${HOST}" "${COMMANDS}"
