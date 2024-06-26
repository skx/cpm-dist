# M: - Mike's Enhanced Small C Compiler for Z80 and CP/M

The M-drive contains the [Mike's Enhanced Small C Compiler](https://github.com/MiguelVis/mescc).

This complements the Aztec Compiler located in [C:](../C).

Original content now follows:



MESCC / Mike's Enhanced Small C Compiler
========================================

MESCC v1.24 - 14 Sep 2021

Mike's Enhanced Small C Compiler for Z80 and CP/M

Copyright (c) 1999-2021 Miguel García / FloppySoftware

**MESCC** is my project of a **C compiler** for the [CP/M operating system](https://en.wikipedia.org/wiki/CP/M) and the Z80 cpu.

[http://www.floppysoftware.es](http://www.floppysoftware.es)

**NOTE**: This project has been extracted from my [RetroProjects](https://github.com/MiguelVis/RetroProjects) repository.

Overview
--------

As it is written in MESCC, it can compile itself.

It is based on the version 1.7 (Oct. 1985) of [Small C](https://en.wikipedia.org/wiki/Small-C) by Ron Cain, Mike Bernson's and John Hill.

MESCC outputs **Z80 assembler** code that can be assembled with **ZSM/Z80ASMUK** (supplied with MESCC), in order to build an HEX file.

The HEX file can be converted to an executable COM file with LOAD (supplied with CP/M 2), HEXCOM (supplied with CP/M 3) or **HEXTOCOM** (supplied with MESCC).

Also is supplied **CCOPT**, a peephole optimizer.

I use MESCC for nearly all my software projects.

![MESCC image](http://www.floppysoftware.es/images/cpm-mescc.jpg "MESCC image")

License
-------

This program is freeware, and it's licensed under the GNU GPL license.

See the file `copying.txt` for more details.

About this file
---------------

This file is only an introduction to MESCC.

Please, read [MESCC.TXT](mescc.txt) for more information.
