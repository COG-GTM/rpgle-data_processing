# Running this example on PUB400 (a public IBM i)

The top-level [`process.rpgle`](../process.rpgle) adds 1 to the `Quantity` of every row in
the `ITEMS` table, in place (so repeated runs accumulate), and stamps the time of the run
into a single-row `LASTRUN` control file. This folder contains the SQL and connection
helpers used to run it on a real IBM i. It was tested against [PUB400.COM](https://pub400.com),
a free public IBM i (currently OS400 V7R5).

## Contents
| File | Purpose |
|------|---------|
| [`../process.rpgle`](../process.rpgle) | The RPGLE program (fully free-form, in-place row update) |
| [`../ssh/run.sh`](../ssh/run.sh) | Run the program (+1 to every row) over SSH; sets up + compiles on first run |
| [`../ssh/show.sh`](../ssh/show.sh) | Print the current `ITEMS` rows + `LASTRUN` timestamp over SSH (read-only) |
| [`../5250/run.sh`](../5250/run.sh) | Run the program over the 5250 green screen (no SSH needed) |
| [`../5250/show.sh`](../5250/show.sh) | Show the current values over the 5250 green screen (no SSH needed) |
| [`setup.sql`](setup.sql) | Creates + seeds the `ITEMS` table and the `LASTRUN` table |

## Prerequisites
- A PUB400 account (free at https://pub400.com).
- `sshpass`, `ssh`/`scp` on your machine. For the green screen, the
  [`tn5250`](https://github.com/tn5250/tn5250) emulator.
- Credentials in your environment:
  ```bash
  export PUB400_USERNAME=YOURUSER
  export PUB400_PASSWORD=yourpassword
  ```

## Run it (SSH)
```bash
./ssh/run.sh            # +1 to every row (first run also creates/seeds ITEMS and compiles)
./ssh/run.sh rebuild    # force a recompile after editing process.rpgle
```
Expected tail of the first run (seed is 10/25/3/100, so +1 → 11/26/4/101):
```
>> running PROCESS (every QTY += 1)
>> ITEMS (current quantities):
    ID   ITEMNAME                           QTY
     1   Widget                              11
     2   Gadget                              26
     3   Gizmo                                4
     4   Doohickey                          101
>> LASTRUN (time of this run):
UPDATED
2026-06-01-17.28.54.963772
```
Run it again and every quantity goes up by 1 again (12/27/5/102, …). Use `./ssh/show.sh`
to view the values without changing them.

## Run it (5250 green screen, no SSH)
Not every IBM i has SSH enabled, but 5250 (telnet) is essentially always available. The
`5250/` scripts **don't connect to anything** — they just print the exact commands you type
by hand in a green-screen session (via [`tn5250`](https://github.com/tn5250/tn5250), IBM ACS,
or any 5250 emulator):
```bash
./5250/run.sh     # prints the steps to CALL PROCESS  (+1 to every row)
./5250/show.sh    # prints the steps to RUNQRY the ITEMS + LASTRUN tables
```
The commands they list are:
```
CALL PGM(DEREKWU1/PROCESS)     -- run: +1 to every row
RUNQRY *N DEREKWU1/ITEMS       -- show: current quantities  (F3 to exit the report)
RUNQRY *N DEREKWU1/LASTRUN     -- show: when it last ran
```
5250 is an interactive terminal, not a file-transfer channel, so — unlike the SSH path — it
can't upload your source or compile. It assumes `PROCESS`/`ITEMS`/`LASTRUN` already exist
(deploy them once with `./ssh/run.sh`, FTP, or IBM ACS).

### How "deploy" works
RPG is compiled **on the IBM i**, not on your machine. `run.sh` uploads `process.rpgle`,
copies it into a source member (`QRPGLESRC`), and compiles it into a program object with
`CRTBNDRPG` — only on the first run or when you pass `rebuild`. Normal runs just `CALL` the
already-compiled program, which is why they're fast and simply increment the data.

## IBM i gotchas worth knowing
- **Decimal separator:** PUB400's job CCSID is 273 (German), so SQL treats the comma as the
  decimal point. `DECIMAL(5,0)` mis-parses — use `DECIMAL(5)` (scale defaults to 0).
- **Record format names:** an SQL-created table gives its record format the same name as the
  table. RPG does not allow a format to share the file's name, so `process.rpgle` uses
  `rename(ITEMS:ITMREC)` / `rename(LASTRUN:RUNREC)`.
- **RUNSQLSTM halts on sev-20:** a clean-run `DROP ... not found` (SQL0204, sev 20) would
  otherwise stop setup before the CREATEs, so the setup runs with `ERRLVL(20)`.
- **Ports:** 23 = 5250 (telnet), 992 = 5250 over SSL, 2222 = SSH (PASE). Port 22 is closed.
- **CL from PASE:** run CL commands with `system "…"`, e.g. `system "WRKACTJOB"`.
