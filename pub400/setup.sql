-- Input/output physical files for ../process.rpgle, plus sample data.
-- Run with: RUNSQLSTM SRCSTMF('.../setup.sql') COMMIT(*NONE) NAMING(*SQL)
--
-- NOTE: PUB400's job CCSID is 273 (German), where the SQL decimal separator is
-- a comma. That makes DECIMAL(5,0) mis-parse, so we use DECIMAL(5) (scale
-- defaults to 0). Adjust the schema name (DEREKWU1) to your own library.
-- The DROPs let this be re-run cleanly (they error harmlessly on first run).
DROP TABLE DEREKWU1.INPUTF;
DROP TABLE DEREKWU1.OUTPUTF;
CREATE TABLE DEREKWU1.INPUTF  (ID DECIMAL(5) NOT NULL, ITEMNAME CHAR(30) NOT NULL, QTY DECIMAL(5) NOT NULL);
CREATE TABLE DEREKWU1.OUTPUTF (ID DECIMAL(5) NOT NULL, ITEMNAME CHAR(30) NOT NULL, QTY DECIMAL(5) NOT NULL);

INSERT INTO DEREKWU1.INPUTF VALUES (1, 'Widget', 10);
INSERT INTO DEREKWU1.INPUTF VALUES (2, 'Gadget', 25);
INSERT INTO DEREKWU1.INPUTF VALUES (3, 'Gizmo', 3);
INSERT INTO DEREKWU1.INPUTF VALUES (4, 'Doohickey', 100);
