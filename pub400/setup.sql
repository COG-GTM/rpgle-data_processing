-- One-time setup: the ITEMS data file (seeded) and the LASTRUN control file.
-- run.sh only runs this when ITEMS doesn't exist yet, so it never wipes data
-- you've accumulated. Run manually with:
--   RUNSQLSTM SRCSTMF('.../setup.sql') COMMIT(*NONE) NAMING(*SQL) ERRLVL(20)
-- (ERRLVL(20) lets the DROPs error harmlessly on a clean run.)
--
-- NOTE: PUB400's job CCSID is 273 (German), where the SQL decimal separator is
-- a comma. That makes DECIMAL(5,0) mis-parse, so we use DECIMAL(5) (scale
-- defaults to 0). Adjust the schema name (DEREKWU1) to your own library.
DROP TABLE DEREKWU1.ITEMS;
DROP TABLE DEREKWU1.LASTRUN;
-- legacy tables from earlier versions of this example; dropped if present
DROP TABLE DEREKWU1.INPUTF;
DROP TABLE DEREKWU1.OUTPUTF;

CREATE TABLE DEREKWU1.ITEMS (ID DECIMAL(5) NOT NULL, ITEMNAME CHAR(30) NOT NULL, QTY DECIMAL(5) NOT NULL);
-- Single-row control file: PROCESS stamps the time of its last run here.
CREATE TABLE DEREKWU1.LASTRUN (UPDATED TIMESTAMP NOT NULL);

INSERT INTO DEREKWU1.ITEMS VALUES (1, 'Widget', 10);
INSERT INTO DEREKWU1.ITEMS VALUES (2, 'Gadget', 25);
INSERT INTO DEREKWU1.ITEMS VALUES (3, 'Gizmo', 3);
INSERT INTO DEREKWU1.ITEMS VALUES (4, 'Doohickey', 100);
