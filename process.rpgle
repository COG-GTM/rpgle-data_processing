**free
// Data-processing example for IBM i (tested on PUB400.COM, OS400 V7R5).
//
// Increments the Quantity of every row in the ITEMS file by 1, in place, so
// repeated runs accumulate. It also stamps the time of the run into a single
// row in the LASTRUN control file. The files and sample data are created on
// first run by run.sh (via pub400/setup.sql).
//
// Compile: CRTBNDRPG PGM(<lib>/PROCESS) SRCFILE(<lib>/QRPGLESRC) SRCMBR(PROCESS)
// Run:     CALL <lib>/PROCESS
ctl-opt dftactgrp(*no) actgrp(*new);

// ITEMS / LASTRUN are SQL tables. SQL gives the record format the same name as
// the table, which RPG disallows, so rename the formats.
dcl-f items   usage(*update) rename(ITEMS:ITMREC);
dcl-f lastrun usage(*update:*output) rename(LASTRUN:RUNREC);

// Add 1 to the quantity of every row, in place.
read items;
dow not %eof(items);
  QTY = QTY + 1;
  update itmrec;
  read items;
enddo;

// Record when this run happened. LASTRUN holds a single row: update it if it
// exists, otherwise write the first one.
read lastrun;
UPDATED = %timestamp();
if %eof(lastrun);
  write runrec;
else;
  update runrec;
endif;

*inlr = *on;
return;
