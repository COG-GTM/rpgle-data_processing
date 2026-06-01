#!/usr/bin/env bash
# Print the steps to RUN the program manually on the 5250 "green screen".
#
# This does NOT connect to anything — it just shows the commands you type by
# hand. Use this when the IBM i has no SSH (so ../ssh/run.sh can't be used);
# 5250 (telnet) is essentially always available.
#
# Optional: set PUB400_LIB to print your library (default: DEREKWU1).
LIB="${PUB400_LIB:-DEREKWU1}"

cat <<EOF
=== Run PROCESS on the 5250 green screen (manual) ===

1. Open the green screen and connect to your IBM i, e.g.:
     tn5250 pub400.com          (or use IBM ACS / any 5250 emulator)

2. Sign on with your user profile and password.

3. At the "Selection or command  ===>" line, type this and press Enter
   (adds 1 to every row in $LIB/ITEMS):

     CALL PGM($LIB/PROCESS)

   A blank command line with no error message means it ran. Then use
   ./5250/show.sh for the commands to view the new values.

Note: 5250 can't upload your source or compile, so the program and tables
must already exist (deploy them once with ../ssh/run.sh, FTP, or IBM ACS).
EOF
