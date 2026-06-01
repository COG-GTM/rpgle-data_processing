**free
// Data-processing example for IBM i (tested on PUB400.COM, OS400 V7R5).
//
// Reads each record from the input file, adds 1 to the Quantity field, and
// writes the result to the output file. After processing, it stamps a single
// run-level "last updated" timestamp into the LASTRUN control file. The
// physical files and sample data are created by pub400/setup.sql; deploy and
// run the whole thing end-to-end with pub400/deploy.sh.
//
// Compile: CRTBNDRPG PGM(<lib>/PROCESS) SRCFILE(<lib>/QRPGLESRC) SRCMBR(PROCESS)
// Run:     CALL <lib>/PROCESS
ctl-opt dftactgrp(*no) actgrp(*new);

// INPUTF / OUTPUTF / LASTRUN are SQL tables. SQL gives the record format the
// same name as the table, which RPG disallows, so rename the formats. The
// prefix on the output file keeps its field names distinct from the input's.
dcl-f inputf  rename(INPUTF:INPREC);
dcl-f outputf usage(*output) prefix(O_) rename(OUTPUTF:OUTREC);
dcl-f lastrun usage(*update:*output) rename(LASTRUN:RUNREC);

read inputf;
dow not %eof(inputf);
  O_ID       = ID;
  O_ITEMNAME = ITEMNAME;
  O_QTY      = QTY + 1;
  write outrec;
  read inputf;
enddo;

// Record when this run last updated the data. LASTRUN holds a single row:
// update it if it exists, otherwise write the first one.
read lastrun;
UPDATED = %timestamp();
if %eof(lastrun);
  write runrec;
else;
  update runrec;
endif;

*inlr = *on;
return;
