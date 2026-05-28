#!/usr/bin/env bash
# Upload RPGLE source files to PUB400.COM via SFTP.
# Usage: ./scripts/upload.sh [file ...]
#
# If no files are specified, uploads all *.rpgle files from the repo root.
#
# Files are placed in /home/${PUB400_USERNAME}/rpgle/ on the IBM i PASE
# filesystem. Use the compile script to compile them into ILE RPG programs.
#
# Requires: PUB400_USERNAME environment variable.
#
# Note: PUB400 SSH/SFTP runs on port 2222 (not the default 22).

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HOST="PUB400.COM"
PORT="2222"
REMOTE_DIR="/home/${PUB400_USERNAME}/rpgle"

if [[ -z "${PUB400_USERNAME:-}" ]]; then
  echo "Error: PUB400_USERNAME is not set."
  exit 1
fi

# Collect files to upload
if [[ $# -gt 0 ]]; then
  FILES=("$@")
else
  mapfile -t FILES < <(find "${REPO_ROOT}" -maxdepth 1 -name '*.rpgle' -type f)
fi

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "No RPGLE source files found to upload."
  exit 1
fi

echo "Uploading ${#FILES[@]} file(s) to ${HOST}:${REMOTE_DIR}/ ..."

# Build SFTP batch commands
BATCH_FILE=$(mktemp)
trap 'rm -f "${BATCH_FILE}"' EXIT

echo "-mkdir ${REMOTE_DIR}" >> "${BATCH_FILE}"
echo "cd ${REMOTE_DIR}" >> "${BATCH_FILE}"
for f in "${FILES[@]}"; do
  echo "put ${f}" >> "${BATCH_FILE}"
done
echo "ls -la" >> "${BATCH_FILE}"

sftp -o StrictHostKeyChecking=accept-new -o PubkeyAuthentication=no -P "${PORT}" -b "${BATCH_FILE}" "${PUB400_USERNAME}@${HOST}"

echo ""
echo "Upload complete. Files are in ${REMOTE_DIR}/ on ${HOST}."
echo "Run ./scripts/compile.sh to compile the RPGLE source."
