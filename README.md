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

This repository contains an example `RPGLE` program that demonstrates reading data from an input file, processing it, and writing the results to an output file.
- `RPGLE` is a high-level programming language for business applications.
- The program is written in `RPGLE` for the IBM i (AS/400) system.
- The program is designed to be compiled and run on the IBM i (AS/400) system.

---------------

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [PUB400 Initial Setup](#pub400-initial-setup)
    - [Usage](#usage)
    - [Scripts](#scripts)
    - [Important Notes](#important-notes)
- [Resources](#resources)
- [License](#license)
- [Credits](#credits)

## Features

- Reads data from an input file (`INPUTFILE`) using the `ReadInput` procedure.
- Processes each record to double the Quantity field and writes the result to an output file (`OUTPUTFILE`) using the WriteOutput procedure.
- Illustrates basic file I/O operations, data manipulation, and modularization of code using procedures.

## Getting Started

### Prerequisites

- A [PUB400.COM](https://pub400.com) account (free — register with an IBM ID)
- A TN5250 terminal emulator (for initial sign-on and interactive use)
- SSH client (for file transfer and command execution)

### PUB400 Initial Setup

1. **Install a TN5250 client:**
   - **Linux:** Build from source — [github.com/tn5250/tn5250](https://github.com/tn5250/tn5250)
   - **macOS/Windows:** See [tn5250j.org](http://tn5250j.org) or the [PUB400 tools page](https://pub400.com)

2. **Connect and sign on:**
   ```bash
   tn5250 PUB400.COM
   ```
   - Enter your username and initial password at the sign-on screen
   - On first sign-on, you will be forced to change your password
   - Enter your initial password, then your new password twice

3. **SSH access** (available after password change):
   ```bash
   ssh -p 2222 YOUR_USERNAME@PUB400.COM
   ```
   > **Note:** PUB400 uses port **2222** for SSH, not the default 22.

### Usage

1. Clone this repository to your local machine.
2. Set your PUB400 username:
   ```bash
   export PUB400_USERNAME=YOUR_USERNAME
   ```
3. **Connect via TN5250** (interactive green-screen):
   ```bash
   ./scripts/connect.sh
   ```
4. **Connect via SSH** (PASE shell):
   ```bash
   ./scripts/ssh-connect.sh
   ```
5. **Upload RPGLE source** to PUB400:
   ```bash
   ./scripts/upload.sh                    # uploads all *.rpgle files
   ./scripts/upload.sh process.rpgle      # upload a specific file
   ```
6. **Compile on PUB400:**
   ```bash
   ./scripts/compile.sh                   # compiles process.rpgle by default
   ./scripts/compile.sh my_program        # compile a specific source
   ```
7. Check the output file to view the processed data.

### Scripts

| Script | Description |
|--------|-------------|
| [`scripts/connect.sh`](scripts/connect.sh) | Connect to PUB400 via TN5250 terminal |
| [`scripts/ssh-connect.sh`](scripts/ssh-connect.sh) | Connect to PUB400 via SSH (PASE shell) |
| [`scripts/upload.sh`](scripts/upload.sh) | Upload RPGLE source files via SFTP |
| [`scripts/compile.sh`](scripts/compile.sh) | Compile RPGLE source on PUB400 via SSH |

### Important Notes

- This is a simplified example for demonstration purposes.
- The program assumes that the input and output files are defined and accessible on the IBM i (AS/400) system.
- PUB400.COM is a shared public system — be respectful of other users and system resources.

## Resources

- [IBM RPGLE Reference](https://www.ibm.com/docs/en/i/7.4)
- [PUB400.COM](https://pub400.com) — Free public IBM i system
- [TN5250 Terminal Emulator](https://github.com/tn5250/tn5250)
- [IBM i PASE](https://www.ibm.com/docs/en/i/7.4?topic=pase-overview) — Portable Application Solutions Environment

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
