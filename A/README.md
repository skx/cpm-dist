# A: Standard Utilities

The A-drive contains some "standard" utilities that you might expect to find on a CP/M system:

* ASM.COM
  * CP/M Assembler - see "hello.asm" for example usage.
* BE.COM
  * Binary editor, source is included as BE.C in [C:](../C/).
  * [Originally found here](https://github.com/lindehaven/CP-M).
* DUMP.COM
  * Dump file contents - this is enhanced to show both HEX and ASCII contents of files.
  * Written using the Aztec C-compiler, you can find in [C:](../C/), along with source code.
* LOAD.COM
  * Loader for generated .hex files, produced by ASM.COM
* S.COM
  * A simple vi-like editor, source code can be found in [this repository](https://github.com/udo-munk/s/).
* STAT.COM
  * Show file details; note that currently file-sizes are not correct.

Note that the assembler presented here is pretty basic, and you should probably prefer the one included in the [C:](../C/), alongside the Aztec C-compiler.



## Custom Utilities

The following utilities are specific to my [cpmulator](https://github.com/skx/cpmulator/), as they use custom BIOS functions:

* CTRLC.COM
  * Allow changing the number of Ctrl-C characters which will trigger a CP/M reboot.  (0 to disable).
* CONSOLE.COM
  * Allow changing the cpmulator output writer between ANSI and ADM-3A emulation, at runtime.
