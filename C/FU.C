/*
 * Simple file utility - allows listing files on drives, deleting and
 * executing files.
 *
 * TODO:
 *  Allow reading text-files?
 *  Confirm for delete?
 *
 * Quick-compile, assuming full cpm-dist:
 *
 *  A:SLASH ERA fu.com ; CC fu ; AS fu ; LN fu.o c.lib t.lib
 *
 * Compile/Link this via the Aztec C-compiler on C:
 *
 *   CC FU
 *   AS FU
 *   LN FU.O T.LIB C.LIB
 */

#define BDOS_DFIRST 17
#define BDOS_DNEXT 18
#define ERASE_FILE 19
#define FCB 0x005c
#define DMABUF 0x0080
#define CHAR_MASK 0x7F

/*
 * Drive contains the drive-letter.
 */
char drive = 0;

/*
 * Files contains the list of files we've found - max 150.
 * Extra byte for null-terminator.
 */
char files[12 * 50] = { 0 };

/*
 * Count of valid files.
 */
char files_count = 0;

/*
 * offset of the selected file
 */
int offset = 0;

/*
 * Find the files on the given drive, and update the global
 * files-list with the results.
 */
void find_files() {

    char *fcb = FCB;
    int n;
    int i;

    files_count = 0;

    fcb[0] = 0; /* default drive */

    strcpy (fcb + 1, "???????????"); /* Match any file */

    if ((n = bdos (BDOS_DFIRST, FCB)) != 255)
        do
        {
            char *fcbbuf = DMABUF + 32 * n;

            /* copy the file into the next slot */
            for (i = 0; i < 11; i++)
            {
                files[i + (files_count*12)] = fcbbuf[1 + i] & CHAR_MASK;
            }
            files_count = files_count + 1;

#if 0
            a[0] = arg;
            printf("EXEC\n");

            execv("ECHO.COM",a);
#endif
        } while ((n=bdos (BDOS_DNEXT, FCB)) != 255);
}



void set_drive(d) int d; {
    drive = (d-'A');
    setDR(drive);
    offset = 0;
}

void draw_ui(all) int all; {
    int i;
    int j;
    int first = 1;

    if ( all > 0 ) {
            /* clear screen and draw border */
            printf("%c[2J%c[0;0H", 27, 27);

            printf("+------------------------------------------------------------------------------+\n");
            printf("| File Utility v0.1 - https://github.com/skx/cpm-dist                          |\n");
            printf("| Current Drive <%c:> - Change Drive: Ctrl-A - Ctrl-P                           |\n", 'A' + drive);
            printf("| J - Down, K -  Up, (E)execute,  (D)elete                                     |\n");
            printf("+------------------------------------------------------------------------------+\n");

            for( i = 0; i < 20; i++) {
                printf("|                                                                              |\n");
            }
            printf("+------------------------------------------------------------------------------+\n");
        }


    for( i = 0; i < 20 ; i++ ) {
        /* move cursor to row i+3,4 */
        printf("%c[%d;4H", 27, i+6);

        if ( i + offset < files_count) {

            if ( first ) {
                /* reverse video */
                printf("%c[7m", 27);
            }

            for( j = 0; j < 11 ; j++ ) {
                printf("%c", files[( (i+offset) * 12) + j]);
            }

            if ( first ) {
                /* normal video */
                printf("%c[m", 27);
                first = 0;
            }

        } else {
            printf("           ");
        }
    }
}

int main(argc, argv) int argc, argv[]; {
    int i ;
    int refresh = 1;

    set_drive( 'A' );


    /*
     * Main loop
     */
    while( 1 ) {
        int ch;

        /* update our list of files */
        find_files();

        /* refresh our UI */
        draw_ui(refresh);
        refresh = 0;

        ch = keyPressed();

        if( ch >= 1 && ch <= 16 ) {
            set_drive('A' + ch - 1);
            refresh = 1;
        } else if ( ch == 'q' || ch == 'Q' || ch == 27) {
            /* clear screen */
            printf("%c[2J%c[0;0H", 27, 27);
            return 0;
        } else if ( ch == 'j' || ch == 'J') {
            if (offset < files_count ) {
                offset++;
            } else {
                offset = 0;
            }
        } else if ( ch == 'k' || ch == 'K') {
            if (offset > 0) {
                offset--;
            } else {
                offset = files_count;
            }
        } else if ( ch == 'e' || ch == 'E') {
            char n[12];
            for( i = 0; i<11; i++ ) {
                n[i] = files[( (offset) * 12) + i];
            }
            n[12]=0;
            execl(n, 0);
        } else if ( ch == 'd' || ch == 'D') {
            char n[12];
            char *fcb = FCB;
            int i;
            for( i = 0; i<11; i++ ) {
                n[i] = files[( (offset) * 12) + i];
            }
            n[12]=0;

            /* copy the name into the fcb */
            fcb[0] = 0;
            strcpy (fcb + 1,n);

            bdos(ERASE_FILE, FCB);
        }
    }
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


; void setDR(int);
    public setDR_
    public setDR
setDR:
setDR_:
     lxi h, 2
     dad sp
     mov e , m
     mvi c,14
     call 5
     ret

#endasm
