/*
 *  Binary Editor -- a small binary editor for programmers
 *
 *  Copyright (C) 2017-2022 Lars Lindehaven
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are
 *  met:
 *
 *    * Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *
 *    * Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 *  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#include "ctype.h"
#include "stdio.h"

/* DEFINITIONS ------------------------------------------------------------ */

#define PROG_NAME   "Binary Editor"
#define PROG_AUTH   "Lars Lindehaven"
#define PROG_VERS   "v0.1.6 2022-09-13"
#define PROG_SYST   "CP/M"

#define WORDBITS    16                              /* # of bits in a word  */
#define MAX_FNAME   16                              /* Max filename length  */
#define MAX_WHERE   2047                            /* Max change info size */
#define MAX_BYTES   (MAX_WHERE * WORDBITS)          /* Max byte buffer size */

#define ED_ROWS     16                              /* # of rows            */
#define ED_COLS     16                              /* # of columns         */
#define ED_PAGE     (ED_ROWS * ED_COLS)             /* Page size            */

#define ED_TITLE    1                               /* Title row            */
#define ED_INFO     (ED_TITLE + 1)                  /* Information row      */
#define ED_MSG      (ED_INFO + 1)                   /* Message row          */
#define ED_HEAD     (ED_MSG + 2)                    /* Heading row          */
#define ED_ROWT     (ED_HEAD + 1)                   /* Top of page          */
#define ED_ROWB     (ED_ROWT + ED_ROWS - 1)         /* Bottom of page       */
#define ED_TAIL     (ED_ROWB + 1)                   /* Trailing row         */

#define ED_CLM      2                               /* Column Left Margin   */
#define ED_CHW      3                               /* Column Hex Width     */
#define ED_CHL      (ED_CLM + 8)                    /* Column Hex Left      */
#define ED_CHR      (ED_CHL + ED_COLS * ED_CHW)     /* Column Hex Right     */
#define ED_CAW      1                               /* Column ASCII Width   */
#define ED_CAL      (ED_CHR + 4)                    /* Column ASCII Left    */
#define ED_CAR      (ED_CAL + ED_COLS * ED_CAW)     /* Column ASCII Right   */

/* ANSI Screen */
#define TERM_ROWS   25      /* # of rows on terminal screen.                */
#define TERM_COLS   80      /* # of columns on terminal screen.             */

/* GLOBALS ---------------------------------------------------------------- */

/* CP/M Keyboard */
char *key[] = {
    "L.Lindehaven",
    "\x0a",                 /* ^J  Help                                     */
    "\x05",                 /* ^E  Cursor one row up                        */
    "\x18",                 /* ^X  Cursor one row down                      */
    "\x13",                 /* ^S  Cursor one column left                   */
    "\x04",                 /* ^D  Cursor one column right                  */
    "\x12",                 /* ^R  Cursor one page up                       */
    "\x03",                 /* ^C  Cursor one page down                     */
    "\x14",                 /* ^T  Cursor to beginning of byte buffer (top) */
    "\x16",                 /* ^V  Cursor to end of byte buffer (bottom)    */
    "\x01",                 /* ^A  Set edit mode HEX                        */
    "\x06",                 /* ^F  Set edit mode ASCII                      */
    "\x1a",                 /* ^Z  Toggle edit mode (ASCII/HEX)             */
    "\x17",                 /* ^W  Write byte buffer to file (save)         */
    "\x1b",                 /* ESC Quit                                     */
    "\x00",                 /* Reserved for future use                      */
    "\x00",                 /* Reserved for future use                      */
};

char *help[] = {
   "^J  Help (this)",
   "^E  Row up     ",
   "^X  Row down   ",
   "^S  Col left   ",
   "^D  Col right  ",
   "^R  Page up    ",
   "^C  Page down  ",
   "^T  Top        ",
   "^V  Bottom     ",
   "^A  HEX mode   ",
   "^F  ASCII mode ",
   "^Z  Toggle mode",
   "^W  Write file ",
   "ESC Quit       ",
   "               ",
   "               "
};

char fname[MAX_FNAME];      /* Filename                                     */
int eatop = 0;              /* Address on top row in editor                 */
int aoffs = 0x0100;         /* Offset when displaying address               */
int erow = 0;               /* Row in editor                                */
int ecol = 0;               /* Column in editor                             */
int eascii = 0;             /* Edit mode: 0 (HEX) or 1 (ASCII)              */
int bcurr = 0;              /* Current position in byte buffer              */
int bsize = 0;              /* Size of byte buffer                          */
int bchanges = 0;           /* # of changes made in byte buffer             */
int bwhere[MAX_WHERE];      /* Where changes have been made                 */
char bbuff[MAX_BYTES];      /* Byte buffer (maximum 32767 bytes)            */


/* PROGRAM ---------------------------------------------------------------- */

int main(argc, argv) int argc, argv[]; {
    int rc = 0;

    if (argc > 1) {
        if (strlen(argv[1]) > MAX_FNAME - 1) {
            fprintf(stderr, "Filename is too long.");
            return -1;
        } else {
            strcpy(fname, argv[1]);
            if (fileRead())
                return -1;
        }
        if (argc == 3) {
            aoffs = atoi(argv[2]);
        }
    } else {
        fprintf(stderr, "Usage: be filename.ext [address offset]");
        return -1;
    }
    scrClr();
    rc = edLoop();
    scrClr();
    return rc;
}

/* EDITING ---------------------------------------------------------------- */

/* Main editor loop */
int edLoop() {
    int ch;

    sysTitle();
    sysHead();
    edResetChanges();
    edUpdAll();
    while (1) {
        sysInfo();
        edPosCur();
        ch = keyPressed();
        if (ch == *key[1])
            edHelp();
        else if (ch == *key[2])
            rowUp();
        else if (ch == *key[3])
            rowDown();
        else if (ch == *key[4] || ch == 127)
            colLeft();
        else if (ch == *key[5] || ch == 9)
            colRight();
        else if (ch == *key[6])
            pageUp();
        else if (ch == *key[7])
            pageDown();
        else if (ch == *key[8])
            buffTop();
        else if (ch == *key[9])
            buffBottom();
        else if (ch == *key[10])
            eascii = 0;
        else if (ch == *key[11])
            eascii = 1;
        else if (ch == *key[12])
            eascii ^= 1;
        else if (ch == *key[13])
            fileWrite();
        else if (ch == *key[14]) {
            fileQuit();
            return 0;
        /* *key[15] and *key[16] are free to use */
        }
        else
            edInput(ch);
    }
}

/* Position cursor depending on edit mode (HEX or ASCII) */
edPosCur() {
    if (eascii)
        scrPosCur(ED_ROWT + erow, ED_CAL + ED_CAW * ecol);
    else
        scrPosCur(ED_ROWT + erow, ED_CHL + ED_CHW * ecol);
}

/* Edit current line */
edInput(ch) char ch; {
    int hi, lo, new;

    if (eascii) {
        if (ch != bbuff[bcurr] && ch > 0x1f && ch < 0x7f) {
            bbuff[bcurr] = ch;
            edSetChange(bcurr);
            edUpd(erow, 1);
            colRight();
        }
    } else {
        if ((hi = edHex2Nibble(ch)) > -1) {
            putchar(tolower(ch));
            ch = keyPressed();
            if ((lo = edHex2Nibble(ch)) > -1) {
                putchar(tolower(ch));
                new = 16 * hi + lo;
                if (new != bbuff[bcurr]) {
                    bbuff[bcurr] = new;
                    edSetChange(bcurr);
                }
            }
            edUpd(erow, 1);
            colRight();
        }
    }
}

/* Convert hexadecimal to nibble (0-15) */
int edHex2Nibble(ch) char ch; {
    if (ch >= '0' && ch <= '9')
        return (ch - '0');
    else if (ch >= 'A' && ch <= 'F')
        return (ch - 'A' + 10);
    else if (ch >= 'a' && ch <= 'f')
        return (ch - 'a' + 10);
    else
        return -1;
}

/* Store number of changes and where they have been made  */
edSetChange(bindex) int bindex; {
    if (!edIsChanged(bindex)) {
        bwhere[bindex / WORDBITS] |= 1 << bindex % WORDBITS;
        bchanges += 1;
    }
}

/* Check if byte is changed */
int edIsChanged(bindex) int bindex; {
    return ((bwhere[bindex / WORDBITS] >> bindex % WORDBITS) & 1);
}

/* Reset number of changes and where they have been made  */
edResetChanges() {
    int i;

    for (i = 0; i < MAX_WHERE; i++)
        bwhere[i] = 0;
    bchanges = 0;
}

/* Update all columns on row(s) on editor screen */
edUpd(fromrow, nrows) int fromrow, nrows; {
    int r, c, i;

    for (r = fromrow; r < fromrow + nrows && r < ED_ROWS; r++) {
        scrClrRow(ED_ROWT + r);
        scrPosCur(ED_ROWT + r, ED_CLM);
        printf("%04x", aoffs + eatop + r * ED_COLS);
        for (c = 0; c < ED_COLS; c++) {
            i = eatop + r * ED_COLS + c;
            scrPosCur(ED_ROWT + r, ED_CHL + ED_CHW * c);
            if (edIsChanged(i))
                scrInvVideo();
            printf("%02x", bbuff[i]);
            scrPosCur(ED_ROWT + r, ED_CAL + ED_CAW * c);
            if (bbuff[i] > 0x1f && bbuff[i] < 0x7f)
                putchar(bbuff[i]);
            else
                putchar('.');
            if (edIsChanged(i))
                scrNorVideo();
        }
    }
}

/* Update editor screen from first row to last row */
edUpdAll() {
    scrHideCursor();
    edUpd(0, ED_ROWS);
    scrShowCursor();
}

/* Display command help */
edHelp() {
    int r, helprows;

    helprows = sizeof(help) / sizeof(help[0]);
    for (r = 0; r < ED_ROWS; r++)
        scrClrRow(ED_ROWT + r);
    for (r = 0; r < ED_ROWS && r < helprows; r++) {
        scrPosCur(ED_ROWT + r, TERM_COLS/2 - strlen(help[0]));
        printf("%s", help[r]);
    }
    sysMsgKey("Press any key to continue editing: ");
    edUpdAll();
}

/* CURSOR MOVEMENT -------------------------------------------------------- */

/* Move cursor one row up */
rowUp() {
    if (bcurr >= ED_COLS) {
        bcurr -= ED_COLS;
        if (eatop >= ED_COLS && erow == 0) {
            eatop -= ED_COLS;
            edUpdAll();
        } else if (erow > 0) {
            erow--;
        }
        edPosCur();
    }
}

/* Move cursor one row down */
rowDown() {
    if (bcurr < bsize-ED_COLS) {
        bcurr += ED_COLS;
        if (eatop <= bsize-ED_COLS && erow == ED_ROWS-1) {
            eatop += ED_COLS;
            edUpdAll();
        } else if (erow < ED_ROWS-1) {
            erow++;
        }
        edPosCur();
    }
}

/* Move cursor one column left */
colLeft() {
    if (bcurr > 0) {
        bcurr--;
        if (ecol > 0) {
            ecol--;
        } else {
            ecol = ED_COLS-1;
            if (eatop >= ED_COLS && erow == 0) {
                eatop -= ED_COLS;
                edUpdAll();
            } else if (erow > 0) {
                erow--;
            }
        }
        edPosCur();
    }
}

/* Move cursor one column right */
colRight() {
    if (bcurr < bsize-1) {
        bcurr++;
        if (ecol < ED_COLS-1) {
            ecol++;
        } else {
            ecol = 0;
            if (eatop <= bsize-ED_COLS && erow == ED_ROWS-1) {
                eatop += ED_COLS;
                edUpdAll();
            } else if (erow < ED_ROWS-1) {
                erow++;
            }
        }
        edPosCur();
    }
}

/* Move cursor one page up */
pageUp() {
    if (bcurr >= ED_PAGE) {
        bcurr -= ED_PAGE;
        if (bcurr < ED_PAGE) {
            bcurr = ecol;
            eatop = 0;
            erow = 0;
        } else {
            eatop -= ED_PAGE;
        }
        edUpdAll();
        edPosCur();
    }
}

/* Move cursor one page down */
pageDown() {
    if (bcurr < bsize - ED_PAGE) {
        bcurr += ED_PAGE;
        eatop += ED_PAGE;
        edUpdAll();
        edPosCur();
    }
}

/* Move cursor to beginning of buffer */
buffTop() {
    if (bcurr != 0) {
        bcurr = 0;
        eatop = 0;
        erow = 0;
        ecol = 0;
        edUpdAll();
        edPosCur();
    }
}

/* Move cursor to end of buffer */
buffBottom() {
    if (bcurr != bsize - 1) {
        bcurr = bsize - 1;
        eatop = bsize - ED_COLS;
        erow = 0;
        ecol = bcurr % ED_COLS;
        edUpdAll();
        edPosCur();
    }
}

/* FILE I/O --------------------------------------------------------------- */

/* Read file to byte buffer */
fileRead() {
    FILE *fp;
    int i;

    if (!(fp = fopen(fname, "r"))) {
        fprintf(stderr, "Cannot open %s", fname);
        return -1;
    }
    for (i = 0; i < MAX_BYTES; ++i) {
        bbuff[i] = fgetc(fp);
        if (feof(fp))
            break;
    }
    fclose(fp);
    if (i >= MAX_BYTES) {
        fprintf(stderr, "Not enough memory to read %s", fname);
        return -1;
    }
    bsize = i;
    return 0;
}

/* Write byte buffer to file */
fileWrite() {
    FILE *fp;
    int bytes;

    if (!(fp = fopen(fname, "w"))) {
        sysMsgKey("Could not open file for writing! Press any key: ");
        return -1;
    }
    for (bytes = 0; bytes < bsize; bytes++) {
        fputc(bbuff[bytes], fp);
    }
    if (fclose(fp) == EOF) {
        sysMsgKey("Could not close file after writing! Press any key: ");
        return -1;
    }
    if (bytes < bsize) {
        sysMsgKey("Could not write to file! Press any key: ");
        return -1;
    }
    edResetChanges();
    edUpdAll();
    return 0;
}

/* Let user choose to save or disregard any changes made */
fileQuit() {
    char ch = ' ';

    if (bchanges) {
        while (ch != 'S' && ch != 'Q') {
            ch = sysMsgKey("There are unsaved changes. S(ave) or Q(uit)? ");
            ch = toupper(ch);
            if (ch == 'S')
                fileWrite();
        }
    }
}

/* SYSTEM INFORMATION ----------------------------------------------------- */

/* Print system title. */
sysTitle() {
    scrPosCur(ED_TITLE, ED_CLM);
    printf("%s %s for %s by %s", PROG_NAME, PROG_VERS, PROG_SYST, PROG_AUTH);
}

/* Display the file information */
sysInfo() {
    scrPosCur(ED_INFO, ED_CLM);
    printf("%s ", fname);
    if (bchanges) {
        scrInvVideo();
        putchar('*');
    } else {
        scrNorVideo();
        putchar(' ');
    }
    printf(" %5d ", bchanges);
    scrNorVideo();
    printf(" %04x/%04x ", bcurr, bsize-1);
    if (eascii) printf("ASCII"); else printf("HEX  ");
    printf("  Press ^J for help");
}

/* Print header on system line */
sysHead() {
    int i;

    scrPosCur(ED_HEAD, 0);
    for (i = 0; i < TERM_COLS; i++)
        putchar('=');
    scrPosCur(ED_HEAD, ED_CLM-1);
    printf(" ADDR ");
    scrPosCur(ED_HEAD, ED_CHL-1);
    printf(" HEX ");
    scrPosCur(ED_HEAD, ED_CAL-1);
    printf(" ASCII ");
    scrPosCur(ED_TAIL, 0);
    for (i = 0; i < TERM_COLS; i++)
        putchar('=');
}

/* Print message on system line */
sysMsg(s) char *s; {
    scrClrRow(ED_MSG);
    scrPosCur(ED_MSG, ED_CLM);
    printf("%s", s);
}

/* Print message on system line and wait for a key press */
int sysMsgKey(s) char *s; {
    int ch;

    scrInvVideo();
    sysMsg(s);
    ch = keyPressed();
    scrNorVideo();
    scrClrRow(ED_MSG);
    return ch;
}

/* ANSI SCREEN ------------------------------------------------------------ */

/* Clear screen and send cursor to upper left corner. */
scrClr() {
    printf("\x1b[2J");
    printf("\x1b[H");
}

/* Move cursor to row, col */
scrPosCur(row, col) int row, col; {
    printf("\x1b[%d;%dH", row+1, col+1);
}

/* Erase from the cursor to the end of the line */
scrClrEol() {
    printf("\x1b[K");
}

/* Move cursor to row and clear line */
scrClrRow(row) int row; {
    scrPosCur(row, 0);
    scrClrEol();
}

/* Set inverse video */
scrInvVideo() {
    printf("\x1b[7m");
}

/* Set normal video */
scrNorVideo() {
    printf("\x1b[27m");
}

/* Hide cursor */
scrHideCursor() {
    printf("\x1b[?25l");
}

/* Show cursor */
scrShowCursor() {
    printf("\x1b[?25h");
}

/* CP/M KEYBOARD ---------------------------------------------------------- */

#asm
; int keyPressed(void);
    public keyPressed
keyPressed:
    lxi d,253
    mvi c,6
    call 5
    mvi h,0
    mov l,a
    ret
#endasm

