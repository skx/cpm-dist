
DX-Forth 1.0                                           97-12-28
------------

This is the documentation for DX-Forth 1.0.  It is divided into
two parts:

- A walk-through which introduces new users (even those without
  previous forth experience) to a few concepts and illustrates
  some of DX-Forth's special features.  However, no attempt is
  made to teach forth - for this, get hold of an introductory
  book such as 'Starting FORTH' by Brodie or 'Mastering Forth' by
  Tracy & Anderson.

- A technical section for prospective DX-Forth programmers.  It
  assumes the reader has some familiarity with the forth language
  programming.


Contents:
---------
 1. Overview
 2. Distribution files
 3. Acknowledgments
 4. Legal
 5. Installation
 6. Getting started
 7. Screen editor
 8. Machine code assembler
 9. Further suggestions
10. Error messages
11. Programming reference
12. Future development


1. Overview
-----------
DX-Forth is a Forth language compiler/development system for all
CP/M-80 and compatible disk operating systems including Z-System.

DX-Forth is intended to be a complete, easy to use, programming
tool for the creation of CP/M applications - comparable in
quality and facility to other popular CP/M programming languages
such as MBASIC, Turbo Pascal and BDS C.

DX-Forth's features include:

- Forth-83 Standard
- Fast direct-threaded code
- Generate turnkey applications without compiler overhead
- Video terminal functions, installable for most terminals
- Fast floating point and trigonometric functions
- Many extensions including ANS FORTH functions
- Flexible disk I/O using bytes, sectors or lines of text
- DU: style filenames for access to all CP/M user areas
- Z-System (ZCPR) support through ZENV function
- Program error return code for CP/M-3 and Z-System
- Multitasking
- Overlays for large applications
- 8080/Z80 Forth assembler for CODE words
- Full source code included


Why Forth-83?

It may be asked why DX-Forth is based on the FORTH-83 Standard
rather than the newer ANS FORTH?  Some of the deciding factors
for choosing FORTH-83 were:

- ANS FORTH's main advantage over FORTH-83 is source code
  portability.  In practice few applications (except perhaps for
  text book examples) will ever be written portably.

- An ANS FORTH version with the same functionality would have
  resulted in a larger kernel size (mainly to do with the disk
  I/O functions).

- There is little or no performance improvement in ANS FORTH over
  FORTH-83, particularly for machines with 8-bit CPU's.

In any case, it will be noted that many DX-Forth extensions (i.e.
functions not defined in the FORTH-83 standard) have names and
definitions that conform to the ANS FORTH specification.

Note: the file MISC.SCR includes definitions which will enhance
ANS FORTH compatibility.


2. Distribution files
---------------------
The following files are included in the DX-Forth 1.0
distribution:

Executable files -

FORTH.COM      DX-Forth compiler
FORTH-F.COM    DX-Forth compiler with floating point and
               trigonometric functions
INSTALL.COM    Terminal installation program for DX-Forth and
               applications
INSTALL.DTA    Terminal data file (Turbo Pascal compatible) used
               by INSTALL.COM

Documentation files -

FORTH83.GLO    Glossary from the Forth-83 Standard
ASM.DOC        Forth 8080/Z80 assembler
DXFORTH.GLO    Glossary for DX-Forth Extensions
DXFORTH.DOC    DX-Forth documentation (this file)
EDITOR.DOC     Full-screen editor
EDLIN.DOC      Line editor
MULTI.DOC      Multitasker
READ.ME        Brief information about DX-Forth

Screen source files -

ASM.SCR        Z80/8080 Forth assembler
BENCH.SCR      Several benchmark programs
BLK2TXT.SCR    Block to text conversion utility
COPY.SCR       Sample byte-oriented filecopy utility
COPYFAST.SCR   Sample sector-oriented filecopy utility
EDITOR.SCR     Full-screen editor
EDLIN.SCR      Line editor
INSTALL.SCR    Source for INSTALL.COM
MISC.SCR       Miscellaneous forth functions
MULTI.SCR      Multitasker
OVERLAY.SCR    Overlay system
STRINGS.SCR    Sample string package
TXT2BLK.SCR    Text to block conversion utility
ZINS.SCR       Auto terminal install routine for Z-System

DX-Forth assembler source files -

FORTH.Z80      Main file
ARITH.MAC      Arithmetic and logical functions
COMPARE.MAC    Stack comparison functions
CONTROL.MAC    Control structures
DISK.MAC       Disk and file functions
FLOAT.MAC      Floating point and trigonometric functions
MEMORY.MAC     Memory operations
NUMBER.MAC     Numeric functions
STACK.MAC      Stack functions
STRING.MAC     String functions
UTILITY.MAC    Utility functions

Misc -

CRCKLIST.CRC   CRC verification filelist


3. Acknowledgments
------------------
No software is written in a vacuum; therefore the author wishes
to gratefully acknowledge all those in the CP/M and Forth
communities who have generously made their source code available
for public scrutiny.  Without these to serve as a starting point
and source for ideas, DX-Forth would not have been written.


4. Legal
--------
DX-Forth and all the files in this distribution (apart from
excerpts taken from the FORTH-83 and dp-ANS FORTH documents) are
hereby placed into the public domain by the author.  As a public
domain work, no copyright restrictions apply or may be
subsequently imposed.

DX-Forth is an experimental software and is provided without
support.  The author makes no guarantee as to fitness for
purpose, nor assumes liability for any error, omission, damage or
loss caused by the use of DX-Forth.  Anyone wishing to use this
software does so entirely at his or her own risk.


5. Installation
---------------
Installation customises DX-Forth or compiled turnkey applications
to suit the characteristics of the user's video terminal.

| IMPORTANT NOTE:
|
| When distributing a DX-Forth turnkey application that makes use
| of any of the following video functions
|
|    PAGE  AT-XY  CLEAR-LINE  HIGHLIGHT  NORMAL  INSERT-LINE
|    DELETE-LINE  INIT-VIDEO  EXIT-VIDEO
|
| you *must* also include the installation files INSTALL.COM and
| INSTALL.DTA with your release - otherwise users will be unable
| to customise the application to suit their hardware.

FORTH.COM is pre-configured for a Televideo 912/920/925 terminal.
If this does not correspond to your terminal or you wish to
change it, run install

     A> INSTALL FORTH.COM

You will be presented with several options:

     1) Terminal selection

     Select from a number of video terminals including the
     Z-System TermCap currently in memory.

     If your terminal is not listed, try another make of terminal
     - often different manufacturers will use similar control
     codes.  If this still doesn't work, the best option is to
     create a custom terminal definition.  At present, DX-Forth's
     INSTALL doesn't have this capability BUT...

     DX-Forth's terminal data file INSTALL.DTA is fully
     compatible with the terminal data files from Borland's Turbo
     Pascal or Turbo Modula2.  If you have access to either of
     these programs or the freely available PD-GINST, you can
     create a custom terminal definition entry to suit your
     terminal's characteristics.  Refer to the instructions that
     came with Turbo Pascal or Turbo Modula2 on how to do this.
     If using PD-GINST, you should run it on itself i.e.

          A> PD-GINST  PD-GINST.COM

     Once the new terminal entry has been created, rename the
     data file to INSTALL.DTA and run DX-Forth's INSTALL.COM as
     before.

     2) CPU speed

     Enter the speed of the computer's CPU to the nearest MHz.
     The value is non-critical and only affects the accuracy of
     the MS function.

     3) Time delays

     A delay is usually sent after a clear screen, cursor motion
     or clear to end-of-line sequence to prevent subsequent
     characters sent to the terminal from being lost.  The delays
     range from 0 to 255 milli-seconds and may be set by the
     user.  If a fast terminal or computer with memory mapped
     video is used, then all delays can be set to 0 mS.  Most
     terminals, however, will require a delay after a screen
     clear - a value of 50 mS should be sufficient.

     4) Arrow key codes

     Many keyboards have arrow keys (up, down, right, left) which
     produce a code when pressed.  This option allows the user to
     view or modify the arrow key codes within DX-Forth to those
     corresponding to his or her keyboard.

     If arrow keys are not available or produce more than one
     code per keypress (e.g. ANSI terminals) then the WordStar-
     style default values should be used.

     NOTE: Currently DX-Forth makes no use of arrow key codes.
     However, they are available for user applications and can be
     accessed at the following memory address locations:

     Address        Key            Default value
     -------        ---            -------------
     335 (014Fh)    Up arrow       05h (Ctrl-E)
     336 (0150h)    Down arrow     18h (Ctrl-X)
     337 (0151h)    Right arrow    04h (Ctrl-D)
     338 (0152h)    Left arrow     13h (Ctrl-S)

     It should be re-emphasized that the arrow key codes do NOT
     move the terminal's cursor or have any other effect - they
     only represent the values returned when the arrow keys on
     the keyboard are struck.

     5) No Warm-Boot option

     DX-Forth and turnkey applications normally perform a warm-
     boot on exit.  In non-banked CP/M systems this results in
     reloading of the system tracks of the disk in drive A.

     This may be defeated by enabling the No Warm-Boot option;
     but at a loss of 2k bytes of application memory space.

     6) Save changes and exit

     Saves the current installation settings to disk if requested
     and exits.


6. Getting started
------------------
Two versions of the DX-Forth compiler have been provided:

FORTH.COM      The forth compiler kernel.  It includes everything
               required to load and compile forth source files
               (called 'screens').

FORTH-F.COM    The same as FORTH.COM but includes the floating
               point and trigonometric functions.  These increase
               the size of the kernel by 2.5 Kbytes.


First, enter forth by executing FORTH.COM (or FORTH-F.COM) from
the CP/M prompt e.g.

     A> FORTH

You will be greeted with DX-Forth's start-up screen showing the
version number, compilation date and the name of the video
terminal currently installed.  If you executed FORTH-F.COM rather
than FORTH.COM you will also be informed that the floating point
functions are available.

Now type

     MAP

This displays a 'map' of DX-Forth's current statistics and
settings including dictionary segment sizes, available memory,
vocabularies, vocabulary search order, logged drive, open file
etc.

To see the names of all forth functions in the dictionary, type

     WORDS

Press any key to stop the display.  If you want to see only words
whose names begin with M then type

     WORDS M

You may also note some word names are preceded by certain flags -

'#'  indicates the word is Immediate.

'|'  indicates the word resides in the System dictionary.

Forth users should be familiar with Immediate words, however
System words are peculiar to DX-Forth and are explained in the
programming section.

You can capture output to a printer e.g.

     PRINTER  WORDS

and restore output to the console with

     CONSOLE

Adding a new function to forth's dictionary is easy.  Let's try
the ubiquitous 'hello world'.  Type in the following line, paying
attention to the spaces.

     : HELLO-WORLD ." Hello world" ;

You have just compiled a new forth command called HELLO-WORLD.
If you now type WORDS you will see its name at the top of the
list.

Execute HELLO-WORLD by typing its name.  It should simply print
the message 'Hello world'.

Removing a forth word from the dictionary is even easier.  Type

    FORGET HELLO-WORLD

This discards HELLO-WORLD ... and any forth word that may have
been defined after it.

Perhaps you would like to save HELLO-WORLD as your first turnkey
CP/M application?  To do this, re-enter the previous HELLO-WORLD
definition if you discarded it.  Once you have tested it to make
sure it works as expected, save it to disk with

    TURNKEY HELLO-WORLD HELLO.COM

If you now type DIR you should see HELLO.COM in the disk
directory.  Note - you may optionally specify a filename with DIR
or use wildcards e.g. DIR *.COM

Now, the most important thing you should know - how to get out of
forth and back to CP/M.  Do this now by typing BYE.

Once back in CP/M, you can try out your new HELLO program.  You
will notice that HELLO.COM is considerably smaller in size than
the FORTH.COM used to create it.  This illustrates one of
DX-Forth's main features - turnkey applications are saved without
word headers or compiler overhead.  The benefits are that
applications take less disk space, are quicker to load, and have
more TPA memory available when they execute.


7. Screen editor
----------------
Forth has traditionally used 'blocks' for mass storage.  Blocks
may hold any type of data including text.  In DX-Forth, blocks
are used primarily to store forth source listings.  Each 'screen'
(the name given to blocks that hold forth source text) represents
1024 bytes of data organised as 16 lines of 64 characters each.
DX-Forth screens are saved as conventional CP/M disk files and
are distinguished by a .SCR filetype (some forths use .BLK as the
filetype).

Screen files require a special text editor.  Two such editors
have been included in DX-Forth - a full-screen editor and a line
editor.  These are supplied in source form and need to be loaded
before use.  Most users, however, will only need the full-screen
editor.

NOTE: Before loading and using the full-screen editor, ensure
that FORTH.COM and FORTH-F.COM have been properly installed (see
section 5) as the full-screen editor requires the clear-screen,
clear to end-of-line, and cursor motion terminal codes in order
to function.

The file EDITOR.SCR contains the source listing for the full-
screen editor.  From the CP/M prompt, load forth and open
EDITOR.SCR

     A>FORTH EDITOR  ( if no filetype is given .SCR is assumed )

Forth will boot-up with the message 'Using  A0:EDITOR.SCR'.
Typing MAP shows the name of the open screenfile and its size.

Alternately, open EDITOR.SCR from within forth with

     USING EDITOR

Once EDITOR.SCR has been successfully opened, you can view the
contents of the file with the LIST command.  0 LIST displays
screen 0, 1 LIST displays screen 1 etc.

To list the first three screens to a printer you could use

     PRINTER  0 LIST  1 LIST  2 LIST  CONSOLE

or the simpler command

     0 2 SHOW

which prints three screens to the page followed by a form-feed.

Now compile the editor into the dictionary with

     1 LOAD

Once loading has completed, typing WORDS shows several new
commands have been added to the dictionary.

Typing MAP reveals that some system memory has been consumed and
there is now a new vocabulary in addition to FORTH - the EDITOR
vocabulary.  If you are curious to see what is in the EDITOR
vocabulary, then type

     EDITOR WORDS

Because we don't want to LOAD the editor each time we need to
edit a forth screen file, it would be a good idea to save a new
forth version that includes the compiled editor.  Let's do this
and call it FORTHED.COM

     SAVE FORTHED  ( if no filetype is given .COM is assumed )

For details on how to use the editor, refer to the EDITOR.DOC
documentation file.


8. Machine code assembler
-------------------------
Though threaded-code forth generates code which is compact and
quite fast - up to 10 times faster than interpreted BASIC - there
may be occasions when the full speed of machine code is required.

The 8080/Z80 assembler provided with DX-Forth allows writing of
forth 'code' words.  Code words are simply machine language
routines which end with a jump to NEXT.  For details on using the
assembler, refer to the documentation file ASM.DOC.

As with the screen editor, the assembler is not built-in.  It
must be loaded and then a new version of the forth compiler can
be saved if desired.

ASM.SCR contains the source for the assembler.  Open the file and
compile it

     USING ASM  1 LOAD

You can now save it using the SAVE command.

I usually save a version of forth where the assembler and editor
are both resident e.g.

     USING ASM  1 LOAD  USING EDITOR  1 LOAD  SAVE F.COM

Whether you will want to do this depends on how much memory you
have available and the size of the applications you will
subsequently wish to compile.  If space becomes a problem,
remember that you don't need the screen editor present if you're
just compiling and saving applications.  Similarly, if your
application has no CODE or ;CODE words then the assembler need
not be resident either.


9. Further suggestions
----------------------
If you have worked your way through the previous sections - you
now know how to look around DX-Forth, list and compile forth
screen files, save new versions of forth and create turnkey
applications.

If this is your first encounter with forth, I hope this brief
tour through DX-Forth will encourage you to look further.  Get a
book on forth and learn it - forth really is EASY!

The best way to learn forth (or any language) is by studying
examples and several have been provided with DX-Forth.  When you
encounter a forth word that you are unfamiliar with, look up its
definition in the glossaries provided.

A sample filecopy program is provided in source form (COPY.SCR).
As well as illustrating a complete forth application, it also
serves as a primer on DX-Forth's file functions.  It will show
you a lot - how to

- get arguments from the CP/M command line
- create file-handles and assign file-buffers
- open disk files
- read a byte from a disk file
- write a byte to a disk file
- flush the output file-buffer
- close disk files
- handle errors

Routines may be extracted for your own use or the entire program
can serve as a skeleton for a more complex one - such as a text
filter.

For examples of more complex 'real world' applications, take a
look at INSTALL.SCR - the source for the DX-Forth installer.

Lastly, a note on 'forth style'.  Most of these programs share a
common trait - word definitions are often too long.  Experienced
forth users advocate writing many short, well-factored, words
rather than a few long ones.  This makes it harder to introduce
errors while simplifying testing and debugging.  Another aid to
readability and maintenance of programs, is the careful choosing
of names - a point often overlooked by many programmers
regardless of language.  Too often, names tend to be short,
cryptic, computer-ese jargon.  Most forths allow names up to 31
characters, so choose long English-like phrases that properly
describe the action of the word being defined.  Having a good
thesaurus at hand is often recommended.  For more about forth-
style, find a copy of Leo Brodie's book Thinking Forth (formerly
published by Prentice-Hall and more recently by the Forth
Interest Group).


10. Error messages
------------------

Compiler error messages:

"block out of range"          Attempted to access a block past
                              the end of the file.
"block r/w error"             Error encountered during block read
                              or write operation.
"can't create file"           Disk full or write-protected.
"can't delete file"           File not found or disk write-
                              protected.
"can't extend file"           Disk full or write-protected.
"can't rename file"           File not found or disk write-
                              protected.
"can't save file"             Error occurred during save
                              (probably disk full).
"compilation only"            Word may be used only during
                              compilation.
"conditionals not paired"     Conditional statements (IF ELSE
                              THEN etc.) not properly paired.
"definition incomplete"       Definition was not properly formed.
"execution only"              Word may be used only during
                              execution.
"in protected dictionary"     Specified word is in the protected
                              dictionary and cannot be forgotten.
"invalid name"                Attempted compilation of a function
                              name whose length was outside the
                              range 1 to 31.
"is redefined"                Definition has the same name as a
                              pre-existing word in the
                              dictionary.
"is undefined"                Specified word could not be found
                              in the dictionary using the
                              vocabulary search order - CONTEXT
                              CURRENT FORTH.
"loading only"                Word may be used only during
                              loading.
"no buffer"                   Attempted to define a file-handle
                              using a buffer number outside the
                              range 1 to #BUFFERS.
"no file open"                File operation was requested but no
                              file was open.
"out of memory"               Dictionary or stack full.
"specify filename"            Filename required but none was
                              given.
"stack empty"                 Attempted to remove a non-existent
                              value from the stack.

Assembler error messages:

"duplicate label"             Label number was previously used.
"invalid label number"        Exceeded the maximum number of
                              labels.
"relative jump out of range"  Attempted to exceed the range of a
                              Z80 relative jump.
"too many forward references" Exceeded the maximum number of
                              forward references to labels.
"unresolved reference"        A label was referenced but never
                              defined.

Run-time error messages:

DX-Forth does not perform run-time error checking.  It is the
responsibility of the application programmer to include error
checking appropriate to the task.


11. Programming reference
-------------------------
This section contains programming and technical information
specific to DX-Forth.

11.1   File system
11.2   Application and System words
11.3   Executing applications
11.4   No Warm-Boot option
11.5   User Patch area
11.6   Overlays
11.7   Multitasking
11.8   User variables
11.9   Compiler security
11.10  ZINS routine
11.11  Assembling DX-Forth


11.1  File system

DX-Forth uses the CP/M BDOS for all disk file management.  A
flexible set of file operations are supported - read or write
characters (bytes), lines of text, or CP/M 128-byte records to a
maximum of 8 Mbytes per file with automatic access across CP/M
user areas.  The usual forth mass storage functions BLOCK,
BUFFER, FLUSH are present in DX-Forth but are used only in the
management of forth source files or 'screens'.

File-Handles
------------
Most DX-Forth disk file operations (open, read/write, close etc.)
are performed upon a 'current file-handle'.  The use of file-
handles in DX-Forth is analogous to the use of the File Control
Block by CP/M.  A DX-Forth file-handle is a named structure which
contains information pertaining to a disk file - file status
(open or closed), CP/M user number, buffer address and size, file
position, FCB address etc.

A file-handle is defined using the word FILE e.g.

     1 FILE MAIN-FILE

This creates a file-handle named MAIN-FILE and associates it with
file buffer 1.  When MAIN-FILE is subsequently executed, it then
becomes the 'current' file-handle.

Disk file functions open, create, seek, read, write and close all
assume the current file-handle as the target.  Once a file-handle
has been made current, it remains so until different file-handle
is invoked.  To switch between several disk files simply requires
invoking the appropriate file-handle, and thus making it current.

File-handles may be re-used.  After a disk file has been closed,
the file-handle associated with it, can then be used for
operations on other disk files.

How many file-handles will an application need?  A seperate file-
handle is required for each opened disk file.  Thus, if a program
needs five disk files to be open simultaneously, then five file-
handles must be created.

File Buffers
------------
Several DX-Forth file functions require an internal file buffer
for proper operation.  These 'buffered' functions include
READ-CHAR, READ-FILE, READ-LINE, WRITE-CHAR, WRITE-FILE,
WRITE-LINE, REPOSITION-FILE and FLUSH-FILE.

NOTE: Buffered file functions may only be used on file-handles
that have a valid file buffer associated with it.  Failing to do
so will result in unpredictable results or failure of the
application.

When any buffered file function is to be used in an application,
it is the programmer responsibility to allocate a valid, unused,
file buffer.  This is done at the same time a file-handle is
being created, e.g.

     1 FILE IN-FILE
     2 FILE OUT-FILE

In this example, file-handle IN-FILE is being associated with
file buffer 1 and OUT-FILE with file buffer 2.

The maximum number of file buffers provided by DX-Forth is given
by #BUFFERS.  The default value is 2.  This allows an application
to have up to 2 'buffered' disk files open at any one time (e.g.
one input file and one output file).  If desired, the number of
file buffers may be increased or decreased.  (See the entry for
#BUFFERS in the glossary for details.)

NOTE: It is permissable to associate the same file buffer with
several file-handles provided that only one of these file-handles
has an open disk file.

Should a file-handle not make use of any of the 'buffered' file
functions then a file buffer is not required.  In this case, use
file buffer 0 (which does not exist) when creating the file-
handle.

This completes the discussion of file-handles and file buffers.
For further information on the various file functions available,
refer to the glossary and the sample programs COPY.SCR and
COPYFAST.SCR for an illustration of their use.

While DX-Forth's file handling is slightly more complex to use
than ANS FORTH, it is nevertheless easy to master and -
importantly - makes much more effective use of the limited memory
available to most CP/M systems.


11.2  Application and System words

When a word is compiled into DX-Forth, it added to either the
Application dictionary or the System dictionary.
(Actually there is but one dictionary, physically divided into
two segments.  It is this physical partitioning that enables
DX-Forth to generate small turnkey applications, free of compiler
overhead.)

Executing the words APPLICATION or SYSTEM causes all subsequent
definitions to be compiled into the corresponding dictionary
segment.  (The word MAP shows the current compilation dictionary
and statistics for each segment.)

The Application dictionary contains words (less their headers)
that are available for use by either turnkey applications or by
the forth compiler.

The System dictionary contains words that are used exclusively by
the forth compiler.  Also included in the System dictionary are
the headers from each forth word.  System words are NOT saved
during the generation of turnkey applications.

To see which words are System or Application, type WORDS.  If the
word is preceded by a '|' character, then it resides in the
System dictionary otherwise it resides in the Application
dictionary.

| IMPORTANT:
|
| Under no circumstances should a turnkey application be allowed
| to execute any System word.  Attempting to do so will result in
| unpredictable behaviour or failure of the application.

To prevent users inadvertently compiling System words into the
Application dictionary, DX-Forth will issue a warning message
when such an attempt is made.  The message is available only if
the warning flag is on (i.e. the variable WARNING contains a non-
zero value).

NOTE: There is one instance where compilation of System words
into the Application dictionary will produce a warning message
but is not an error condition and will not result in failure of a
turnkey application.  This commonly occurs during the compilation
of defining words.  For example, compiling the following
definition

     APPLICATION

     : BYTE-CONSTANT
       CREATE C,  DOES> C@  ;

will cause the message shown below to appear

     "CREATE is system  C, is system  (;CODE) is system"

DX-Forth is warning the user that CREATE C, (;CODE) are System
words and are being compiled into the Application dictionary.
The reason why this will NOT cause the application to fail is
that the words between CREATE and DOES> inclusive represent the
COMPILING part of the defining word.  This part is executed only
during compilation of the application - never by the application
itself.


11.3  Executing applications

Turnkey applications can often be fully tested and debugged from
within the forth environment.  However when they are eventually
executed from the CP/M command-line, there will be some
differences of which the programmer should be aware.

- The functions INIT-VIDEO and EXIT-VIDEO are automatically
  executed by the DX-Forth compiler on entry and exit
  respectively.  This does not occur when turnkey applications
  are run.  Applications which need INIT-VIDEO and EXIT-VIDEO
  must explicitly execute these as required.

  NOTE: If an application uses ABORT" for termination, EXIT-VIDEO
  will not be executed.

- The amount of unused memory available to an application will
  vary depending on whether it is run from within forth or from
  the CP/M command-line.  UNUSED can be used by applications to
  determine free memory.

- The memory region at 005Ch and 0080h (CP/M default FCB and DMA)
  is overwritten by the Forth compiler during DIR, SAVE or
  TURNKEY.  Otherwise, this region is unaffected and may be used
  by turnkey applications to interrogate the CP/M command-line or
  parsed FCB.


11.4  No Warm-Boot option

DX-Forth and turnkey applications automatically perform a warm-
boot (BDOS function 1) on exit.  The allows all the available TPA
memory to be used by the program but has the disadvantage that
the CP/M Console Command Processor must be reloaded on exit.  If
this is not desired, the NO WARMBOOT option may be enabled by
changing the byte at address location 272 (0110h) to a non-zero
value, or by using the INSTALL program.

NOTE: Enabling NO WARMBOOT reduces the amount of free memory.
Turnkey applications will have 2K bytes less free memory and the
DX-Forth compiler will have 2K bytes less System memory.


11.5  User Patch area

A user patch area consisting of five bytes has been reserved
exclusively for use by applications.

User Patch     Address
----------     -------
    1          267 (010Bh)
    2          268 (010Ch)
    3          269 (010Dh)
    4          270 (010Eh)
    5          271 (010Fh)

This area may be used for any purpose by an application.
Possible uses are:

  - hardwiring an application program's options or configuration.
  - contain the address of a user's D-A port address.


11.6  Overlays

DX-Forth can compile applications up to 25k in size.  While this
may seem small compared to other language compilers it will be
found that the threaded code compiled by DX-Forth allows more to
be done in a given space.  However, if larger applications are
needed this can be achieved with overlays.

Before resorting to overlays, the programmer should ensure all
available memory is being used.  For example, if the application
does not use any 'buffered' disk functions then an extra 2k
applications space can be gained by reducing the number of file
buffers from two to zero (see the glossary entry for #BUFFERS on
how to do this).  As delivered, DX-Forth caters for machines with
reduced TPA memory.  System memory normally begins at 7000 hex.
If over 50k of TPA is available, then system memory may begin at
8000 hex giving an extra 4K application space - but this requires
modification of the DX-Forth source file and re-assembling.

Using overlays will require a little more planning of the
application.  Some important aspects the programmer must consider
are listed below.

- The resident part of the program must ensure that the correct
  overlay is in memory before executing an overlay word.

- An overlay must not execute words in other overlays or words in
  the resident part which, in turn, execute words in a different
  overlay.

- Overlays may include variable storage but the contents will be
  valid only until the next overlay is loaded.

See OVERLAY.SCR for a demonstration of a simple overlay system.


11.7  Multitasking

A co-operative 'round robin' multi-tasker is provided with
DX-Forth.  It permits an application to have several tasks run
concurrently.

Refer to the multitasker documentation MULTI.DOC and source file
MULTI.SCR for further details.


11.8  User variables

In common with early forth systems, DX-Forth has 'user
variables'.  User variables occupy a common region in memory.
They hold various system and boot up values and are also used for
multitasking applications.

In DX-Forth 1.0, user variables 60 to 127 are available for use by
applications.  User variables are defined with the forth word
USER, thus

     60 USER VAR1
     62 USER VAR2
     66 USER VAR3 ...

The number preceding USER indicates the offset (in bytes) from
the user area base address where the variable will be stored.
This allows the programmer to define the position and number of
bytes allocated by each user variable.  In the example above,
VAR1 occupies 2 bytes (1 cell) at offset 60, VAR2 occupies 4
bytes (2 cells) at offset 62.

As with normal variables, executing the name of a user variable
returns its address in memory.  Unlike normal variables however,
the address returned by a user variable may not be assumed to be
a constant - even during the execution of an application.


11.9  Compiler security

DX-Forth uses Fig-Forth style compiler security.  Most
programmers will never need to worry about compiler security
issues except when interfacing new control structures with
existing ones, or writing new compiler words with built-in
security.

Compiler security words used by DX-Forth are listed below.  How
and when to use them is a topic of its own and is not discussed
here (see the DX-Forth source files for examples of use).

!CSP  ( -- )             Save the current stack pointer.
?CSP  ( -- )             Issue a 'definition incomplete' message
                         if the current stack pointer does not
                         equal the value saved.
?COMP  ( -- )            Issue an error message if not compiling.
?EXEC  ( -- )            Issue an error message if not executing.
?PAIRS  ( n1 n2 -- )     Issue a 'conditionals not paired'
                         message if n1 and n2 do not match.
SMUDGE  ( -- )           Toggle the 'smudge' bit of the last word
                         defined. The smudge bit controls whether
                         a word name will be found during a
                         dictionary search.


11.10  ZINS Routine

The ZINS routine (see ZINS.SCR) performs automatic terminal
installation for DX-Forth or its applications when running
Z-System (ZCPR3, NZCOM etc).

ZINS may be used as part of a general terminal install program or
included in DX-Forth applications to dynamically adjust to the
current TermCap in memory if Z-System is found present.

NOTE: Due to the Turbo Pascal compatible install area used by
DX-Forth, certain Z-System cursor motion commands cannot be
properly emulated.  The exceptions are handled as follows -

     '%>xy'    treated as '%.'
     '%D'      treated as '%2' if the number of screen columns is
               less than 100 or as '%3' otherwise.

The command and stack effects for ZINS is simply -

     ZINS  ( -- )

If Z-System is found not to be present, nothing is changed.

While it is entirely possible to use ZINS in an application and
have it run transparently as far as the end-user is concerned,
some would regard this as bad programming practice.  Users needs
vary and there may be instances where he/she may not want auto-
installation.  A way around this would be to enable (or disable)
auto-installation according to a CP/M command-line switch when
the application is first run. e.g.

     A>PROGNAME -Z

Lastly, assembly language programmers may find the code for ZINS
interesting.  With some small changes (leave out the arrow key
patches and include a check for a valid ZENV address) ZINS could
be used to install any Turbo Pascal generated program from
Z-System's in-memory TermCap.  Occupying only 450 or so bytes, it
could be reduced even further by using Z80 relative jumps.


11.11  Assembling DX-Forth

The following steps shows how to re-assemble the source for
DX-Forth.  Ensure that FORTH.Z80 and all the .MAC files are on
the disk before proceeding.

Step 1
------
Assemble source files using SLR Z80ASM or Microsoft MACRO-80 to
produce FORTH.REL

  A> Z80ASM FORTH M           ; if using Z80ASM or SLR180

    or

  A> M80 =FORTH.Z80           ; if using Macro-80

Step 2
------
Link using SLR SLRNK or Digital Research LINK to produce
FORTH.COM (Microsoft linker L80 is unsuitable)

; note the next free code segment location is 156F !!!

  A> SLRNK FORTH,FORTH/N/E

  SuperLinker Copyright (C) 1983-86 by SLR Systems Release 1.31

  0103-156E (91EC)      0F05 Left

    or

  A> LINK FORTH

  LINK 1.31

  ABSOLUTE     1EAF (74A0-92EE)  ; aseg actually begins at 7000!!!
  CODE SIZE    146C (0103-156E)
  DATA SIZE    0000
  COMMON SIZE  0000
  USE FACTOR     F4

Step 3
------
Move aseg segment to the correct position using SID3 or DDT.

  A> SID FORTH.COM

  CP/M 3 SID - Version 3.0
  NEXT MSZE  PC  END
  9300 9300 0100 B9FF           ; last memory location is 9280

  #M7000,9300,156F              ; move aseg code down

  #D3800                        ; dump memory to find new end

  3800: 6E 27 74 20 64 65 6C 65 74 65 20 66 69 6C 65 77 n't delete filew
  3810: 02 86 52 45 4E 41 4D 45 7A 92 AD 92 CD 58 02 8F ..RENAMEz....X..
  3820: 02 F4 01 FD 8B 87 02 10 A5 06 C0 02 1B 03 DC 02 ................
  3830: 80 08 CE 02 FD 8B 28 15 C7 0E 11 63 61 6E 27 74 ......(....can't
  3840: 20 72 65 6E 61 6D 65 20 66 69 6C 65 77 02 88 46  rename filew..F
  3850: 4F 52 54 48 2D 38 33 A2 92 EC 92 C3 1D 01 00 00 ORTH-83.........
  3860: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  3870: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  3880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................

  ; if using SID3 save new FORTH.COM

  #WFORTH.COM,100,3860
  006Fh record(s) written.

  ; if using DDT and CP/M 2, exit DDT with ^C then save FORTH.COM

  A> SAVE 56 FORTH.COM


12. Future development
----------------------
When DX-Forth was first envisaged, it was intended that two
versions would be produced - an 8080 version (for 8080/8085
users) followed by a Z80 version.  Due to the longer than
expected development time, a Z80 version is now unlikely.
The author considers DX-Forth 1.0 to be quite complete and no
further development (apart from bug-fixes) is planned.

It is realised however, that there may be those who would like
to improve upon DX-Forth and it is for this reason that the full
source listings have been included.

The author would be happy to hear comments from users and,
especially, of any software bugs found in DX-Forth.  See the
READ.ME file for the current E-mail address.
