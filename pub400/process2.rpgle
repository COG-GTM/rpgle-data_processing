**free
// Runnable adaptation of process.rpgle for IBM i (tested on PUB400.COM).
//
// Same business logic as the example process.rpgle: read each record from the
// input file, double the Quantity field, and write the result to the output
// file. Unlike the illustrative process.rpgle, this version is fully free-form
// and actually compiles and runs (proper file declarations, real I/O).
//
// Compile: CRTBNDRPG PGM(<lib>/PROCESS2) SRCFILE(<lib>/QRPGLESRC) SRCMBR(PROCESS2)
// Run:     CALL <lib>/PROCESS2
ctl-opt dftactgrp(*no) actgrp(*new);

// INPUTF / OUTPUTF are created by setup.sql. SQL gives the record format the
// same name as the table, which RPG disallows, so rename the formats.
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
