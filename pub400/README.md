# Running this example on PUB400 (a public IBM i)

The top-level [`process.rpgle`](../process.rpgle) reads each record from an input file,
doubles the `Quantity` field, and writes the result to an output file. This folder contains
everything needed to compile and run it on a real IBM i. It was tested against
[PUB400.COM](https://pub400.com), a free public IBM i (currently OS400 V7R5).

## Contents
| File | Purpose |
|------|---------|
| [`../process.rpgle`](../process.rpgle) | The RPGLE program (fully free-form, real file I/O) |
| [`setup.sql`](setup.sql) | Creates the `INPUTF` / `OUTPUTF` files and sample data |
| [`deploy.sh`](deploy.sh) | Upload → create files → compile → run, end-to-end |
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

## One-shot deploy + run
```bash
./pub400/deploy.sh
```
Expected tail:
```
>> OUTPUTF (QTY should be doubled):
    ID   ITEMNAME                           QTY
     1   Widget                              20
     2   Gadget                              50
     3   Gizmo                                6
     4   Doohickey                          200
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
