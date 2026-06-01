**free
// Data-processing example for IBM i (tested on PUB400.COM, OS400 V7R5).
//
// Reads each record from the input file, doubles the Quantity field, and
// writes the result to the output file. The input/output physical files and
// some sample data are created by pub400/setup.sql; deploy and run the whole
// thing end-to-end with pub400/deploy.sh.
//
// Compile: CRTBNDRPG PGM(<lib>/PROCESS) SRCFILE(<lib>/QRPGLESRC) SRCMBR(PROCESS)
// Run:     CALL <lib>/PROCESS
ctl-opt dftactgrp(*no) actgrp(*new);

// INPUTF / OUTPUTF are SQL tables. SQL gives the record format the same name
// as the table, which RPG disallows, so rename the formats. The prefix on the
// output file keeps its field names distinct from the input file's.
dcl-f inputf  rename(INPUTF:INPREC);
dcl-f outputf usage(*output) prefix(O_) rename(OUTPUTF:OUTREC);

read inputf;
dow not %eof(inputf);
  O_ID       = ID;
  O_ITEMNAME = ITEMNAME;
  O_QTY      = QTY * 2;
  write outrec;
  read inputf;
enddo;

*inlr = *on;
return;
