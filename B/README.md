# B: BASIC

The B-drive contains BASIC, in this case:

* BBCBASIC.COM
  * BBC BASIC, with integrated assembler.
  * Enter "*CPM" to exit.
  * Enter "*DIR", to list files, etc.
* MBASIC.COM
  * Microsoft BASIC v5.29 [28-Jul-85]
  * Enter "SYSTEM" to exit.
* OBASIC.COM
  * An older Microsoft BASIC, v5.21 [28-Jul-81]
  * Enter "SYSTEM" to exit.
* TBASIC.COM
  * [Tasty BASIC](https://github.com/dimitrit/tastybasic)
  * Enter "BYE" to exit.



## Sample Programs

* [STARS.BAS](STARS.BAS)
  * Show a sin-wave of stars.
* [ASM.BBC](ASM.BBC)
  * Simple assembly language demonstration program.
  * Ouptuts `A*`.
* [VT100.BAS](VT100.BAS) and [COLOR.BAS](COLOR.BAS)
  * Both work with MBASIC to demonstrate ANSI escape codes and terminal colour-updates.



## Microsoft Basic: Saving & Loading Programs

If you enter a program you can save it via `SAVE "NAME"`, this will create a file named `NAME.BAS` with a tokenized representation of the program you entered.  If you prefer to save the literal ASCII version of the program run:

```
SAVE "STEVE", A
```

That will create `STEVE.BAS` with readable contents.

Loading files can be achieved via `LOAD "NAME"`, again the "`.BAS`" suffix is implied and shouldn't be specified.  Note that loading will load either a tokenized file or the raw ASCII version.

There are some file-related primitives built into MBASIC, for example try entering `FILES` at the prompt.
