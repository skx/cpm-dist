# A: Standard Utilities

The A-drive contains some "standard" utilities that you might expect to find on a CP/M system:

* ASM.COM
  * CP/M Assembler - see "hello.asm" for example usage.
* A1.COM
  * An Apple emulator, [from David Lee](https://github.com/davidly/a1).
* BE.COM
  * Binary editor, source is included as BE.C in [C:](../C/).
  * [Originally found here](https://github.com/lindehaven/CP-M).
* DDT.COM
  * A simple debugger.
* DUMP.COM
  * Dump file contents - this is enhanced to show both HEX and ASCII contents of files.
  * Written using the Aztec C-compiler, you can find in [C:](../C/), along with source code.
* ED.COM
  * A simple editor.
* FU.COM
  * A simple file utility/manager, written by me.
  * Source is included as FU.C in [C:](../C/).
* LOAD.COM
  * Loader for generated .hex files, produced by ASM.COM
* PAUSE.COM
  * Pause for a key-press.  Source included in `PAUSE.ASM`.
* S.COM
  * A simple vi-like editor, source code can be found in [this repository](https://github.com/udo-munk/s/).
* SLASH.COM
  * Submit commands without a ".SUB" file
  * Example "SLASH G: ; ZORK1"
  * Source from [slant](http://www.retroarchive.org/cpm/cdrom/SIMTEL/SIGM/VOLS000/VOL072/)
* STAT.COM
  * Show file details; note that currently file-sizes are not correct.

Note that the assembler presented here is pretty basic, and you should probably prefer the one included in the [C:](../C/), alongside the Aztec C-compiler.
