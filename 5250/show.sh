#!/usr/bin/env bash
# Print the steps to VIEW the data manually on the 5250 "green screen".
#
# This does NOT connect to anything — it just shows the commands you type by
# hand. Use this when the IBM i has no SSH (so ../ssh/show.sh can't be used).
#
# Optional: set PUB400_LIB to print your library (default: DEREKWU1).
LIB="${PUB400_LIB:-DEREKWU1}"

cat <<EOF
=== Show the data on the 5250 green screen (manual) ===

1. Open the green screen and connect to your IBM i, e.g.:
     tn5250 pub400.com          (or use IBM ACS / any 5250 emulator)

2. Sign on with your user profile and password.

3. At the "Selection or command  ===>" line, type each command and press
   Enter. Each opens a full-screen report; press F3 (Exit) to come back.

   Current quantities:
     RUNQRY *N $LIB/ITEMS

   When the program last ran:
     RUNQRY *N $LIB/LASTRUN

   (DSPPFM FILE($LIB/ITEMS) also works to browse the raw records.)

This is read-only — it doesn't change any values.
EOF
