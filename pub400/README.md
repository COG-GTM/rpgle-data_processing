# Running this example on PUB400 (a public IBM i)

The top-level [`process.rpgle`](../process.rpgle) reads each record from an input file,
adds 1 to the `Quantity` field, writes the result to an output file, and stamps the time of
the run into a single-row `LASTRUN` control file. This folder contains everything needed to
compile and run it on a real IBM i. It was tested against [PUB400.COM](https://pub400.com),
a free public IBM i (currently OS400 V7R5).

## Contents
| File | Purpose |
|------|---------|
| [`../process.rpgle`](../process.rpgle) | The RPGLE program (fully free-form, real file I/O) |
| [`setup.sql`](setup.sql) | Creates the `INPUTF` / `OUTPUTF` / `LASTRUN` files and sample data |
| [`deploy.sh`](deploy.sh) | Upload → create files → compile → run, end-to-end |
| [`connect.sh`](connect.sh) | Open an SSH (PASE) shell or a 5250 green screen |
| [`../show.sh`](../show.sh) | Print the latest `OUTPUTF` rows + `LASTRUN` timestamp (no recompile) |

## Prerequisites
- A PUB400 account (free at https://pub400.com).
- `sshpass`, `ssh`/`scp` on your machine. For the green screen, the
  [`tn5250`](https://github.com/tn5250/tn5250) emulator.
- Credentials in your environment:
  ```bash
  export PUB400_USERNAME=YOURUSER
  export PUB400_PASSWORD=yourpassword
  ```

## One-shot deploy + run
```bash
./pub400/deploy.sh
```
Expected tail:
```
>> OUTPUTF (QTY should be input + 1):
    ID   ITEMNAME                           QTY
     1   Widget                              11
     2   Gadget                              26
     3   Gizmo                                4
     4   Doohickey                          101
>> LASTRUN (time of this run):
UPDATED
2026-06-01-17.21.10.901820
```

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
  `rename(INPUTF:INPREC)` / `rename(OUTPUTF:OUTREC)`.
- **Ports:** 23 = 5250 (telnet), 992 = 5250 over SSL, 2222 = SSH (PASE). Port 22 is closed.
- **CL from PASE:** run CL commands with `system "…"`, e.g. `system "WRKACTJOB"`.
