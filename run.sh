#!/usr/bin/env bash
# Run the program on PUB400: increase every item's QTY by 1 (cumulative).
#
# The first time, this creates the ITEMS data file + seeds it and compiles the
# program. After that it just runs the program, so each invocation adds 1 to
# every row. Use ./show.sh to view the values without changing them.
#
# Requires:
#   PUB400_USERNAME  - your PUB400 user profile
#   PUB400_PASSWORD  - your PUB400 password
# Optional:
#   PUB400_LIB       - target library (default: <USERNAME-uppercase>1, your *CURLIB)
#
# Usage:
#   ./run.sh            # increment by 1 (sets up + compiles on first run)
#   ./run.sh rebuild    # force a recompile (after editing process.rpgle)
set -euo pipefail

HOST="pub400.com"; SSH_PORT=2222
: "${PUB400_USERNAME:?set PUB400_USERNAME}"
: "${PUB400_PASSWORD:?set PUB400_PASSWORD}"

USER_UC=$(printf '%s' "$PUB400_USERNAME" | tr '[:lower:]' '[:upper:]')
LIB="${PUB400_LIB:-${USER_UC}1}"
HOMEDIR="/home/${USER_UC}"
REMOTE_DIR="${HOMEDIR}/rpgle"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-run}"

ssh_run() { sshpass -p "$PUB400_PASSWORD" ssh -p "$SSH_PORT" -o StrictHostKeyChecking=accept-new "$PUB400_USERNAME@$HOST" "$@"; }
scp_put() { sshpass -p "$PUB400_PASSWORD" scp -P "$SSH_PORT" -o StrictHostKeyChecking=accept-new "$1" "$PUB400_USERNAME@$HOST:$2"; }
cl()      { ssh_run "system \"$1\""; }                 # run one CL command (fails if it does)
have()    { ssh_run "system \"CHKOBJ OBJ($LIB/$1) OBJTYPE($2)\"" >/dev/null 2>&1; }  # object exists?

# 1. First-time data setup: only if the ITEMS file doesn't exist yet, so we
#    never wipe quantities you've already accumulated.
if ! have ITEMS "*FILE"; then
  echo ">> first run: creating + seeding $LIB/ITEMS"
  ssh_run "mkdir -p '$REMOTE_DIR'"
  scp_put "$SCRIPT_DIR/pub400/setup.sql" "$REMOTE_DIR/setup.sql"
  cl "RUNSQLSTM SRCSTMF('$REMOTE_DIR/setup.sql') COMMIT(*NONE) NAMING(*SQL) ERRLVL(20)" || true
fi

# 2. Compile the program if it's missing (or when asked to rebuild).
if [ "$MODE" = "rebuild" ] || ! have PROCESS "*PGM"; then
  echo ">> compiling $LIB/PROCESS"
  scp_put "$SCRIPT_DIR/process.rpgle" "$REMOTE_DIR/process.rpgle"
  cl "CRTSRCPF FILE($LIB/QRPGLESRC) RCDLEN(112)" || true
  cl "ADDPFM FILE($LIB/QRPGLESRC) MBR(PROCESS) SRCTYPE(RPGLE)" || true
  cl "CPYFRMSTMF FROMSTMF('$REMOTE_DIR/process.rpgle') TOMBR('/QSYS.LIB/$LIB.LIB/QRPGLESRC.FILE/PROCESS.MBR') MBROPT(*REPLACE) STMFCCSID(1208)"
  cl "DLTPGM PGM($LIB/PROCESS)" || true
  cl "CRTBNDRPG PGM($LIB/PROCESS) SRCFILE($LIB/QRPGLESRC) SRCMBR(PROCESS) DBGVIEW(*SOURCE)"
fi

# 3. Run it: +1 to every row.
echo ">> running PROCESS (every QTY += 1)"
cl "CALL PGM($LIB/PROCESS)"

# 4. Show the result.
echo ">> ITEMS (current quantities):"
ssh_run "system \"RUNQRY QRYFILE(($LIB/ITEMS)) OUTTYPE(*RUNOPT)\""
echo ">> LASTRUN (time of this run):"
ssh_run "system \"RUNQRY QRYFILE(($LIB/LASTRUN)) OUTTYPE(*RUNOPT)\""
