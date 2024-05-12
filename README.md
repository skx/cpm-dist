# CP/M Distribution

This repository contains a list of binaries, Z80-based, for use with CP/M systems.



## Organization

The layout of the repository is based upon "drives".  CP/M did not initially support directories, and many systems exist which are not running those versions that did.  Instead CP/M had a notion of a drive, for example "A:", "B:", etc.

This repository has grouped the drives into what seemed like a consistent fashion.



## Usage

If you have a CP/M system, or emulator, which supports the use of a directory-as-a-drive you should be able to clone the repository and start using things.

Using my [cpmulator](https://github.com/skx/cpmulator/) for example:

```sh
$ cpmulator -directories
A> G:
G> ZORK1
..
West of House
You are standing in an open field west of a white house, with
a boarded front door.
There is a small mailbox here.
```



## Contents

Currently the contents are in-flux, but when we have more this section will be expanded.

| Drive    | Contents | Notes                                  |
|----------|----------|----------------------------------------|
| [A:](A/) | Standard | Standard-ish utilities for general use |
| [B:](B/) | BASIC    | BASIC Interpreter                      |
| [C:](C/) | C        | Aztec C Compiler                       |
| D:       |          |                                        |
| E:       |          |                                        |
| F:       |          |                                        |
| [G:](G/) | Games    | Text-based adventures, so far          |
| H:       |          |                                        |
| I:       |          |                                        |
| J:       |          |                                        |
| K:       |          |                                        |
| L:       |          |                                        |
| M:       |          |                                        |
| N:       |          |                                        |
| O:       |          |                                        |
| [P:](P/) | Pascal   | Turbo Pascal 3.00A                     |
