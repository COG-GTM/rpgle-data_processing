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
| [`../run.sh`](../run.sh) | Run the program (+1 to every row); sets up + compiles on first run |
| [`../show.sh`](../show.sh) | Print the current `ITEMS` rows + `LASTRUN` timestamp (read-only) |
| [`setup.sql`](setup.sql) | Creates + seeds the `ITEMS` table and the `LASTRUN` table |
| [`connect.sh`](connect.sh) | Open an SSH (PASE) shell or a 5250 green screen |

## Prerequisites
- A PUB400 account (free at https://pub400.com).
- `sshpass`, `ssh`/`scp` on your machine. For the green screen, the
  [`tn5250`](https://github.com/tn5250/tn5250) emulator.
- Credentials in your environment:
  ```bash
  export PUB400_USERNAME=YOURUSER
  export PUB400_PASSWORD=yourpassword
  ```

## Run it
```bash
./run.sh            # +1 to every row (first run also creates/seeds ITEMS and compiles)
./run.sh rebuild    # force a recompile after editing process.rpgle
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
Run it again and every quantity goes up by 1 again (12/27/5/102, …). Use `./show.sh`
to view the values without changing them.

### How "deploy" works
RPG is compiled **on the IBM i**, not on your machine. `run.sh` uploads `process.rpgle`,
copies it into a source member (`QRPGLESRC`), and compiles it into a program object with
`CRTBNDRPG` — only on the first run or when you pass `rebuild`. Normal runs just `CALL` the
already-compiled program, which is why they're fast and simply increment the data.

## Connecting manually
```bash
./pub400/connect.sh ssh                       # interactive PASE shell (SSH, port 2222)
./pub400/connect.sh run 'system "DSPLIBL OUTPUT(*PRINT)"'   # run one CL command
./pub400/connect.sh 5250                       # interactive 5250 green screen (telnet 23)
```

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
