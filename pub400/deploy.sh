#!/usr/bin/env bash
# Deploy, compile, and run process2.rpgle on PUB400.COM end-to-end.
#
# Requires sshpass + scp/ssh, and these environment variables:
#   PUB400_USERNAME  - your PUB400 user profile (e.g. DEREKWU)
#   PUB400_PASSWORD  - your PUB400 password
# Optional:
#   PUB400_LIB       - target library (default: <USERNAME-uppercase>1, your *CURLIB)
#
# What it does:
#   1. uploads setup.sql + ../process.rpgle to your IFS home
#   2. creates the INPUTF/OUTPUTF files and sample data (RUNSQLSTM)
#   3. copies the RPGLE source into QRPGLESRC and compiles it (CRTBNDRPG)
#   4. clears OUTPUTF, runs the program (CALL), and prints the doubled output
set -euo pipefail

HOST="pub400.com"; SSH_PORT=2222
: "${PUB400_USERNAME:?set PUB400_USERNAME}"
: "${PUB400_PASSWORD:?set PUB400_PASSWORD}"

USER_UC=$(printf '%s' "$PUB400_USERNAME" | tr '[:lower:]' '[:upper:]')
LIB="${PUB400_LIB:-${USER_UC}1}"
HOMEDIR="/home/${USER_UC}"
REMOTE_DIR="${HOMEDIR}/rpgle"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

ssh_run()  { sshpass -p "$PUB400_PASSWORD" ssh -p "$SSH_PORT" -o StrictHostKeyChecking=accept-new "$PUB400_USERNAME@$HOST" "$@"; }
scp_put()  { sshpass -p "$PUB400_PASSWORD" scp -P "$SSH_PORT" -o StrictHostKeyChecking=accept-new "$1" "$PUB400_USERNAME@$HOST:$2"; }
cl()       { ssh_run "system \"$1\""; }   # run one CL command

echo ">> target library: $LIB   remote dir: $REMOTE_DIR"
ssh_run "mkdir -p '$REMOTE_DIR'"
scp_put "$SCRIPT_DIR/setup.sql"     "$REMOTE_DIR/setup.sql"
scp_put "$REPO_ROOT/process.rpgle" "$REMOTE_DIR/process.rpgle"

echo ">> creating files + sample data"
cl "RUNSQLSTM SRCSTMF('$REMOTE_DIR/setup.sql') COMMIT(*NONE) NAMING(*SQL)" || true

echo ">> compiling $LIB/PROCESS"
cl "CRTSRCPF FILE($LIB/QRPGLESRC) RCDLEN(112)" || true
cl "ADDPFM FILE($LIB/QRPGLESRC) MBR(PROCESS) SRCTYPE(RPGLE)" || true
cl "CPYFRMSTMF FROMSTMF('$REMOTE_DIR/process.rpgle') TOMBR('/QSYS.LIB/$LIB.LIB/QRPGLESRC.FILE/PROCESS.MBR') MBROPT(*REPLACE) STMFCCSID(1208)"
cl "CRTBNDRPG PGM($LIB/PROCESS) SRCFILE($LIB/QRPGLESRC) SRCMBR(PROCESS) DBGVIEW(*SOURCE)"

echo ">> running PROCESS"
cl "CLRPFM FILE($LIB/OUTPUTF)" || true
cl "CALL PGM($LIB/PROCESS)"

echo ">> OUTPUTF (QTY should be doubled):"
ssh_run "system \"RUNQRY QRYFILE(($LIB/OUTPUTF)) OUTTYPE(*RUNOPT)\""
