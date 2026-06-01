<!-- Begin README -->

<div align="center">
    <a href="https://github.com/scottgriv/rpgle-data_processing" target="_blank">
        <img src="./docs/images/icon.png" width="200" height="200"/>
    </a>
</div>
<br>
<p align="center">
    <a href="https://www.ibm.com/docs/en/i/7.4"><img src="https://img.shields.io/badge/IBM_i_RPGLE-7.4-052FAD?style=for-the-badge&logo=ibm" alt="RPG Badge" /></a>
    <br>
    <a href="https://github.com/scottgriv"><img src="https://img.shields.io/badge/github-follow_me-181717?style=for-the-badge&logo=github&color=181717" alt="GitHub Badge" /></a>
    <a href="mailto:scott.grivner@gmail.com"><img src="https://img.shields.io/badge/gmail-contact_me-EA4335?style=for-the-badge&logo=gmail" alt="Email Badge" /></a>
    <a href="https://www.buymeacoffee.com/scottgriv"><img src="https://img.shields.io/badge/buy_me_a_coffee-support_me-FFDD00?style=for-the-badge&logo=buymeacoffee&color=FFDD00" alt="BuyMeACoffee Badge" /></a>
    <br>
    <a href="https://prgportfolio.com" target="_blank"><img src="https://img.shields.io/badge/PRG-Bronze Project-CD7F32?style=for-the-badge&logo=data:image/svg%2bxml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/Pgo8IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDIwMDEwOTA0Ly9FTiIKICJodHRwOi8vd3d3LnczLm9yZy9UUi8yMDAxL1JFQy1TVkctMjAwMTA5MDQvRFREL3N2ZzEwLmR0ZCI+CjxzdmcgdmVyc2lvbj0iMS4wIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciCiB3aWR0aD0iMjYuMDAwMDAwcHQiIGhlaWdodD0iMzQuMDAwMDAwcHQiIHZpZXdCb3g9IjAgMCAyNi4wMDAwMDAgMzQuMDAwMDAwIgogcHJlc2VydmVBc3BlY3RSYXRpbz0ieE1pZFlNaWQgbWVldCI+Cgo8ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgwLjAwMDAwMCwzNC4wMDAwMDApIHNjYWxlKDAuMTAwMDAwLC0wLjEwMDAwMCkiCmZpbGw9IiNDRDdGMzIiIHN0cm9rZT0ibm9uZSI+CjxwYXRoIGQ9Ik0xMiAzMjggYy04IC04IC0xMiAtNTEgLTEyIC0xMzUgMCAtMTA5IDIgLTEyNSAxOSAtMTQwIDQyIC0zOCA0OAotNDIgNTkgLTMxIDcgNyAxNyA2IDMxIC0xIDEzIC03IDIxIC04IDIxIC0yIDAgNiAyOCAxMSA2MyAxMyBsNjIgMyAwIDE1MCAwCjE1MCAtMTE1IDMgYy04MSAyIC0xMTkgLTEgLTEyOCAtMTB6IG0xMDIgLTc0IGMtNiAtMzMgLTUgLTM2IDE3IC0zMiAxOCAyIDIzCjggMjEgMjUgLTMgMjQgMTUgNDAgMzAgMjUgMTQgLTE0IC0xNyAtNTkgLTQ4IC02NiAtMjAgLTUgLTIzIC0xMSAtMTggLTMyIDYKLTIxIDMgLTI1IC0xMSAtMjIgLTE2IDIgLTE4IDEzIC0xOCA2NiAxIDc3IDAgNzIgMTggNzIgMTMgMCAxNSAtNyA5IC0zNnoKbTExNiAtMTY5IGMwIC0yMyAtMyAtMjUgLTQ5IC0yNSAtNDAgMCAtNTAgMyAtNTQgMjAgLTMgMTQgLTE0IDIwIC0zMiAyMCAtMTgKMCAtMjkgLTYgLTMyIC0yMCAtNyAtMjUgLTIzIC0yNiAtMjMgLTIgMCAyOSA4IDMyIDEwMiAzMiA4NyAwIDg4IDAgODggLTI1eiIvPgo8L2c+Cjwvc3ZnPgo=" alt="Bronze" /></a>
</p>

---------------

<h1 align="center">RPGLE Program: Data Processing Example</h1>

This repository contains an example `RPGLE` program that demonstrates updating rows in a database table on the IBM i: it adds 1 to the `Quantity` of every item, in place, each time it runs.
- `RPGLE` is a high-level programming language for business applications.
- The program is written in `RPGLE` for the IBM i (AS/400) system.
- The program is designed to be compiled and run on the IBM i (AS/400) system.

---------------

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
    - [Usage](#usage)
    - [Important Notes](#important-notes)
- [Resources](#resources)
- [License](#license)
- [Credits](#credits)

## Features

- Adds 1 to the `Quantity` of every row in the `ITEMS` table, in place (cumulative across runs).
- Stamps the time of the run into a single-row `LASTRUN` control file.
- Illustrates reading, updating, and writing rows of a DB2-for-i table from RPG.

## Getting Started

### Usage

RPG is compiled and run **on the IBM i itself** (not on your laptop). [process.rpgle](process.rpgle) was compiled and run on [PUB400.COM](https://pub400.com), a free public IBM i (OS400 V7R5). Two scripts in [ssh/](ssh/) wrap the whole workflow (they connect over SSH); set your credentials first:

```bash
export PUB400_USERNAME=YOURUSER
export PUB400_PASSWORD=yourpassword
```

**Run it** (adds 1 to every quantity). The first run also creates + seeds the `ITEMS` table and compiles the program:

```bash
./ssh/run.sh
```

**View the values** (read-only — current `ITEMS` rows + the `LASTRUN` timestamp):

```bash
./ssh/show.sh
```

**After editing `process.rpgle`** (e.g. changing `QTY + 1` to `QTY + 2`), redeploy by forcing a recompile, then run as usual:

```bash
./ssh/run.sh rebuild
```

**No SSH on your IBM i?** 5250 (telnet) almost always is. `./5250/run.sh` and `./5250/show.sh` don't connect — they just print the commands to type by hand in a green-screen session.

See [pub400/README.md](pub400/README.md) for details, the 5250 commands, and IBM i gotchas.

### Important Notes

- This is a simplified example for demonstration purposes.
- `ITEMS` and `LASTRUN` are DB2-for-i tables created by [pub400/setup.sql](pub400/setup.sql); the values persist on the server and accumulate across runs.

## Resources

- [IBM RPGLE Reference](https://www.ibm.com/docs/en/i/7.4)

## License

This project is released under the terms of **The Unlicense**, which allows you to use, modify, and distribute the code as you see fit. 
- [The Unlicense](https://choosealicense.com/licenses/unlicense/) removes traditional copyright restrictions, giving you the freedom to use the code in any way you choose.
- For more details, see the [LICENSE](LICENSE) file in this repository.

## Credits

**Author:** [Scott Grivner](https://github.com/scottgriv) <br>
**Email:** [scott.grivner@gmail.com](mailto:scott.grivner@gmail.com) <br>
**Website:** [scottgrivner.dev](https://www.scottgrivner.dev) <br>
**Reference:** [Main Branch](https://github.com/scottgriv/rpgle-data_processing) <br>

---------------

<div align="center">
    <a href="https://scottgrivner.dev" target="_blank">
        <img src="./docs/images/footer.png" width="100" height="100"/>
    </a>
</div>

<!-- End README -->
