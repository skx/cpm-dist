/* A Semi-literate Brainfuck Compiler for CP/M

   James Stanley 2020
   james@incoherency.co.uk

   The compiler itself should be relatively portable, although the generated
   code squarely targets CP/M. I think it only generates 8080 code (a subset
   of Z80) but I have not tested it on anything other than a Z80.

   Compile it within CP/M using the HI-TECH C Compiler:
   C>C -V E:BFC.C

   Then you can compile a Brainfuck program:
   C>BFC E:HELLO.BF

   And then you can execute the generated program written to E:HELLO.COM:
   C>E:HELLO

   This is my first attempt at anything resembling literate programming. I
   hope you enjoy.

   Changes by Steve Kemp 2026:
   - The input code was reworked to blindly replace '\r' with '\n' when reading STDIN.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* We use a compile-time stack to store branch targets for loops.

   1024 elements of stack space is quite generous, but we don't want the memory
   for anything else so it doesn't hurt. */
#define STACKSZ 1024

/* Some global variables: */

unsigned int *stack; /* stack for loop branch targets   */
int sp;              /* index for next push on to stack */

FILE *src_fp; /* Program source code file pointer        */
int src_char; /* The next character read from the source */
int src_eof;  /* Set to 1 when EOF is reached            */

char *prog;    /* Generated code goes in here              */
int prog_size; /* The allocated size for the "prog" buffer */
int prog_idx;  /* The index for the next output byte       */

/* FILE I/O */

/* The file is read 1 byte at a time by the tokeniser, so to "load" the source
   code we just open the specified file in src_fp, and set src_char/src_eof to
   indicate the current state. */
void load(char *f) {
    src_fp = fopen(f, "r");
    if (!src_fp) {
	fprintf(stderr, "error: can't read %s\n", f);
	exit(1);
    }
    src_char = -1;
    src_eof = 0;
}

/* To save the generated program, a single fwrite() call is sufficient.

   The file is opened in "wb" (write, binary) mode so that CP/M will not insert
   0x0d bytes before any 0x0a in the output file. */
void save(char *f) {
    FILE *fp;
    int wrote;
    if (!(fp = fopen(f, "wb"))) {
	fprintf(stderr, "error: can't write %s\n", f);
	exit(1);
    }
    wrote = fwrite(prog, 1, prog_size, fp);
    if (wrote != prog_size) {
	fprintf(stderr, "error: failed to write full output (only wrote %d of %d bytes)\n", wrote, prog_size);
	exit(1);
    }
    fclose(fp);
}

/* CODE GENERATION */

/* Code generation is centred around emitting bytes into the output program.
   We do this by first resizing the prog buffer if necessary, and then sticking
   the new byte in it.

   A '+' is output to the console every time the buffer is reallocated, as a
   basic progress indicator. */
void emit(char c) {
    if (prog_idx >= prog_size) {
	prog_size += 128;
	prog = realloc(prog, prog_size);
	putchar('+');
    }
    prog[prog_idx++] = c;
}

/* The preamble goes at the very start of our generated program. It first
   zeroes out RAM starting at the end of the generated code and finishing at
   the byte before the start of the BDOS. CP/M stores the BDOS start address in
   address 0x0006 (thanks Graham!) so we copy the address from 0x0006 into the
   bc register pair, initialise hl to point just past the end of our generated
   program, and then loop up zeroing out the address in hl, until hl equals bc.

   As part of this, we will zero out the CCP, but this is fine because it gets
   restored by the BDOS when we jump to address 0 at the end.

   The address space layout for the generated program will look like this:

   +-------------+-----------------------+------------------------------------------+-------------+
   | 0x00 - 0xff | code (unknown length) |      memory (zeroed by preamble)         |    - 0xffff |
   +-------------+-----------------------+------------------------------------+-----+------+------+
   |  Zero page  |                   Transient Program Area                   | CCP | BDOS | BIOS |
   +-------------+------------------------------------------------------------+-------------------+

   Note there is no bounds-checking on memory accesses.

   We can't yet generate bytes for $prog_size because we don't know how large
   the program will end up being, so we emit 0s for now, which will be
   corrected later. */
void emit_preamble() {
    emit(0x26); emit(0);          /* ld h, 0 */
    emit(0x2e); emit(6);          /* ld l, 6 */
    emit(0x4e);                   /* ld c, (hl) */
    emit(0x23);                   /* inc hl */
    emit(0x46);                   /* ld b, (hl) */
    emit(0x21); emit(0); emit(0); /* ld hl, $prog_size */
    emit(0x36); emit(0);          /* loop: ld (hl), 0 */
    emit(0x23);                   /* inc hl */
    emit(0x7c);                   /* ld a, h */
    emit(0x90);                   /* sub b */
    emit(0x57);                   /* ld d, a */
    emit(0x7d);                   /* ld a, l */
    emit(0x91);                   /* sub c */
    emit(0xb2);                   /* or d */
    emit(0x20); emit(0xf5);       /* jr nz loop */
    emit(0x21); emit(0); emit(0); /* ld hl, $prog_size */
}

/* The postamble goes at the very end of our generated program. All it does
   is jump to address 0 which returns control to the CCP.

   Having written the "jp 0" instruction, we can now patch in the correct
   values for $prog_size in the preamble.

   The high byte of $prog_size (second byte because the Z80 is little-endian)
   gets 1 added to it because the program will be loaded into address 0x100,
   which means all addresses are 0x100 larger than their corresponding
   index in prog[]. We'll see this again later when generating branch target
   addresses for loops. */
void emit_postamble() {
    emit(0xc3); emit(0); emit(0); /* jp 0 */
    prog[8] = prog_size&0xff;
    prog[9] = 1+(prog_size>>8);
    prog[22] = prog_size&0xff;
    prog[23] = 1+(prog_size>>8);
}

/* We use BDOS call number 1 to request a byte of input from the console.
   This blocks until a byte is available.

   The BDOS call is made by putting the number 1 in register c and calling
   address 5. We push the hl register pair before, and pop it after, the
   BDOS call because it gets clobbered by the BDOS.

   The BDOS returns the input character in register a.

   In the event that we received a '\r', we throw it away and instead return '\n'.
*/
void emit_input() {
    emit(0x0e); emit(1);          /* ld c, 1           */
    emit(0xe5);                   /* push hl           */
    emit(0xcd); emit(5); emit(0); /* call 5            */
    emit(0xe1);                   /* pop hl            */
    emit(0xfe); emit('\r');       /* cp '\r'           */
    emit(0x20); emit(2);          /* jr nz, label      */
    emit(0x3e); emit('\n');       /* ld a, '\n'        */
    emit(0x77);                   /* label: ld (hl), a */
}

/* We use BDOS call number 2 to write a byte to the console.

   To make the BDOS call we put number 2 in register c and the byte to write
   in register e and then call address 5. Again we push hl before, and pop it
   after, the BDOS call because it gets clobbered.

   In the event that the program tries to write a '\n', we make sure to first
   write a '\r' so that the carriage is returned to the start of the line. */
void emit_output() {
    emit(0x7e);                   /* ld a, (hl)        */
    emit(0xfe); emit('\n');       /* cp '\n'           */
    emit(0x20); emit(9);          /* jr nz, label      */
    emit(0x1e); emit('\r');       /* ld e, '\r'        */
    emit(0x0e); emit(2);          /* ld c, 2           */
    emit(0xe5);                   /* push hl           */
    emit(0xcd); emit(5); emit(0); /* call 5            */
    emit(0xe1);                   /* pop hl            */
    emit(0x5e);                   /* label: ld e, (hl) */
    emit(0x0e); emit(2);          /* ld c, 2           */
    emit(0xe5);                   /* push hl           */
    emit(0xcd); emit(5); emit(0); /* call 5            */
    emit(0xe1);                   /* pop hl            */
}

/* "+" and "-" are implemented in terms of emit_add().

   We support changing the value of the cell by more than 1 at a time in
   the interest of efficiency, although empirically this does not make as much
   of an impact as I had hoped.

   As a micro-optimisation, we revert to "inc (hl)" and "dec (hl)" when only
   changing the value by 1, because these execute in 11 clock cycles, compared
   to the 21 cycles required for arbitrary addition.*/
void emit_add(unsigned char n) {
    if (n == 1) {
	emit(0x34);          /* inc (hl)   */
    } else if (n == 0xff) {
	emit(0x35);          /* dec (hl)   */
    } else if (n != 0) {
	emit(0x7e);          /* ld a, (hl) */
	emit(0xc6); emit(n); /* add a, $n  */
	emit(0x77);          /* ld (hl), a */
    }
}

/* ">" and "<" are implemented in terms of emit_right().

   Again we support changing the memory pointer by more than 1 at a time.

   As a micro-optimisation, we revert to "inc hl" and "dec hl" when changing
   the value by 3 or less because these execute in only 6 clock cycles,
   compared to 21 cycles for arbitrary changes. */
void emit_right(int n) {
    if (n >= -3 && n < 0) {
	while (n++) emit(0x2b);               /* dec hl     */
    } else if (n <= 3 && n > 0) {
	while (n--) emit(0x23);               /* inc hl     */
    } else if (n != 0) {
	emit(0x01); emit(n&0xff); emit(n>>8); /* ld bc, $n  */
	emit(0x09);                           /* add hl, bc */
    }
}

/* "[": When entering a loop we push the current output location onto the stack
   before emitting the loop start code.

   "or a" is used to set the condition flags based on the contents of the "a"
   register.

   We can't set the branch target address because we don't know it yet. This
   will be filled in when the code for the matching "]" is generated. */
void emit_loopstart() {
    stack[sp++] = prog_idx;
    if (sp >= STACKSZ) {
	fprintf(stderr, "error: stack overflow\n");
	exit(1);
    }
    emit(0x7e);                   /* ld a, (hl)    */
    emit(0xb7);                   /* or a          */
    emit(0xca); emit(0); emit(0); /* jp z, $target */
}

/* "]": Pop the address of the matching "[" off the stack and generate code to
   jump there.

   Modify the loop start code to set the correct branch target address for
   when the loop exits.

   Notice that all of the branch targets have 1 added to their (little-endian)
   high byte. This is because the code is loaded at 0x100 when executing. */
void emit_loopend() {
    int target;
    if (sp <= 0) {
	fprintf(stderr, "error: stack undeflow\n");
	exit(1);
    }
    target = stack[--sp];
    emit(0xc3); emit(target&0xff); emit(1+(target>>8)); /* jp $target */
    prog[target+3] = prog_idx&0xff;
    prog[target+4] = 1+(prog_idx>>8);
}

/* TOKENISER */

/* peek() returns the next byte from the source file, reading it using fgetc()
   if necessary.

   This is the only place that actually touches the file, and is also what
   sets src_eof when EOF is encountered. */
int peek() {
    if (src_char == -1) {
	src_char = fgetc(src_fp);
	if (src_char == EOF) src_eof = 1;
    }
    return src_char;
}

/* To throw away the next byte from the file we just set src_char = -1 so that
   peek() gives us the next byte next time. */
void discard() {
    src_char = -1;
}

/* Check whether the next byte from the file is any one of the bytes in the "s"
   string. It is used to tell when the next byte is not a Brainfuck character
   so that it can be skipped over. */
int peek_oneof(char *s) {
    for (; *s; s++)
	if (peek() == *s)
	    return 1;
    return 0;
}

/* Check if the next character is as specified, and if so consume it from the
   input and return 1. */
int consume(char c) {
    if (peek() == c) {
	discard();
	return 1;
    }
    return 0;
}

/* MAIN */

int main(int argc, char **argv) {
    int nright, i;
    unsigned char nadd;
    char *output_name;

    if (argc != 2) {
	fprintf(stderr, "usage: BFC FOO.BF\n");
	exit(1);
    }

    /* Let's generate the output filename.

       In the worst case (argv[1] has no dot in it), we need to add 4 bytes to
       its length (".COM") plus a trailing nul byte. */
    output_name = malloc(strlen(argv[1]) + 5);
    strcpy(output_name, argv[1]);

    /* Now find the final '.' in the filename (if any) and change the extension
       to ".COM".

       On CP/M there can only be one '.' character, but it doesn't hurt to stay
       portable. */
    for (i = strlen(output_name)-1; i>0 && output_name[i]!='.'; i--);
    if (i)
	output_name[i] = '\0';
    strcat(output_name, ".COM");

    /* Allocate the stack, load the source file, and emit the preamble code. */
    stack = malloc(sizeof(int) * STACKSZ);
    load(argv[1]);
    emit_preamble();

    /* Loop until we've reached EOF on the source code file. */
    while (!src_eof) {
	/* We count the number of consecutive "+" or "-" operators and
	   emit_add() accordingly.

	   emit_add() generates no code when nadd == 0. */
	nadd = 0;
	while (consume('+')) nadd++;
	while (consume('-')) nadd--;
	emit_add(nadd);

	/* Similarly, we count the number of consecutive ">" or "<" operators
	   and emit_right() accordingly.

	   emit_right() also generates no code when nright == 0. */
	nright = 0;
	while (consume('>')) nright++;
	while (consume('<')) nright--;
	emit_right(nright);

	/* Other operators are more straightforward. */
	if (consume('.')) emit_output();
	if (consume(',')) emit_input();
	if (consume('[')) emit_loopstart();
	if (consume(']')) emit_loopend();

	/* Finally we skip over any non-Brainfuck characters that happen to be
	   present in the program source code. */
	while (!src_eof && !peek_oneof("+-><.,[]"))
	    discard();
    }

    /* Emit the postamble code, save the generated code to the output file,
       and print a '\n' to terminate the "++++++++++" on the console. */
    emit_postamble();
    save(output_name);
    putchar('\n');

    /* All done, great success. */
    return 0;
}
