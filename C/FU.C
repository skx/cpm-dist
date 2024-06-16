/*
 * Simple file utility - allows listing files on drives, deleting and
 * executing files.
 *
 * Quick-compile assuming you have full cpm-dist and you're on C:
 *
 *  A:SLASH ERA fu.com ; CC fu ; AS fu ; LN fu.o c.lib t.lib
 *
 * Explicit instructions for doing it manually:
 *
 *   CC FU
 *   AS FU
 *   LN FU.O T.LIB C.LIB
 *
 * CHANGELOG / TODO LIST:
 *
 * TODO before v4:
 *  [X] - Share code to get filenames for view/delete.
 *  [X] - Moved clear-screen routine into a function.
 *  [X] - Shrink size, as much as we can. 14k -> 12k so far.
 *  [X] - Show the current filter in the header.
 *
 * TODO before v3:
 *  [X] - Allow reading text-files.
 *  [X] - Don't require newline for Y/N prompt (file delete)
 *
 * TODO: before v2:
 *  [X] - Confirm for delete.
 *  [X] - Filter to limit to *.COM, or similar.
 *  [X] - Determine drive on startup.
 */
#include "STDIO.h"

#define BDOS_DFIRST 17
#define BDOS_DNEXT 18
#define ERASE_FILE 19
#define SET_DMA    26
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
char *files;

/*
 * Filter
 */
char filter[12];

/*
 * Count of valid files.
 */
char files_count = 0;

/*
 * offset of the selected file
 */
int offset = 0;


#ifndef NULL
#define NULL 0
#endif

int compare(cx, cy)
char *cx; char *cy;
{
    while (*cx && *cy)
    {
        if (*cx != *cy)
            return 0;
        cx++;
        cy++;
    }
    return (*cy == '\0');
}

char *strstr(haystack,needle)
char *haystack; char *needle;
{
    while (*haystack != '\0')
    {
        if ((*haystack == *needle) && compare(haystack, needle))
            return haystack;
        haystack++;
    }
    return NULL;
}

/*
 * Return the name of the currently selected file.
 */
char *get_filename() {
    static char name[14];
    int i;
    int n = 0;

    /* empty the name buffer */
    for( i = 0 ; i < sizeof(name); i++ ) {
        name[i] = 0;
    }

    /* build up the name */
    for( i = 0; i<8; i++ ) {
        if (files[( (offset) * 12) + i] != ' ' ) {
            name[n]=files[( (offset) * 12) + i];
            n++;
        }
    }

    /* if we have an extension append the dot */
    if ( files[( (offset) * 12) + 8] != ' ' ) {
        name[n] = '.';
        n++;
    }

    /* add the  extension */
    for( i = 8; i<11; i++ ) {
        if (files[( (offset) * 12) + i] != ' ' ) {
            name[n]=files[( (offset) * 12) + i];
            n++;
        }
    }

    return name;
}

/*
 * clear screen
 */
void cls() {
    printf("%c[2J%c[0;0H", 27, 27);
}

/*
 * Find the files on the given drive, and update the global
 * files-list with the results.
 */
void find_files() {

    char *fcb = FCB;
    int n;
    int i;

    /* Empty any past list */
    for( i = 0 ; i < (150 * 12) ; i++ ) {
        files[i] = 0;
    }

    /* We've found no files */
    files_count = 0;

    /* Set our DMA address */
    bdos(SET_DMA, DMABUF);

    fcb[0] = 0; /* default drive */

    strcpy (fcb + 1, "???????????"); /* Match any file */

    if ((n = bdos (BDOS_DFIRST, FCB)) != 255)
        do
        {
            char *fcbbuf = DMABUF + 32 * n;
            int add = 1;

            /* copy the file into the next slot */
            for (i = 0; i < 11; i++)
            {
                files[i + (files_count*12)] = fcbbuf[1 + i] & CHAR_MASK;
            }
            files[11 + (files_count*12)] = 0;

            /* if there is a filter in-place */
            if (filter[0] != 0 ) {

                /* We'll not add this entry if the filename doesn't match that */
                if ( (strstr(files + (files_count*12), filter)) == NULL ) {
                    add = 0;
                } else {
                    add = 1;
                }
            }
            files_count = files_count + add;
        } while ((n=bdos (BDOS_DNEXT, FCB)) != 255);
}



void set_drive(d) int d; {
    drive = (d-'A');
    setDR(drive);
    offset = 0;
}

void fill_line() {
    printf("+------------------------------------------------------------------------------+\n");
}

void draw_ui(all) int all; {
    int i;
    int j;
    int first = 1;

    if ( all > 0 ) {
        /* clear screen and draw border */
        cls();

        fill_line();
        printf("| File Utility v0.4 - https://github.com/skx/cpm-dist                          |\n");
        printf("| Current Drive <%c:> Current Filter %11s - Change Drive: Ctrl-A - Ctrl-P|\n", 'A' + drive, filter);
        printf("| J - Down, K -  Up, (D)elete, (E)execute, (F)ilter, (V)iew                    |\n");
        fill_line();


        for( i = 0; i < 20; i++) {
            printf("|");
            for( j = 0; j < 78; j++) {
                printf(" ");
            }
            printf("|\n");
        }
        fill_line();

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

    files = malloc(12 * 150);

    /* get current drive and set it */
    i = getDR();
    set_drive( i+ 'A' );

    /* filter is unset, so we'll show all files */
    for ( i = 0; i < 11; i++ ){
        filter[i] = 00;
    }

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
            cls();
            return 0;
        } else if ( ch == 'j' || ch == 'J') {
            if (offset < files_count-1 ) {
                offset++;
            } else {
                offset = 0;
            }
        } else if ( ch == 'k' || ch == 'K') {
            if (offset > 0) {
                offset--;
            } else {
                offset = files_count-1;
            }
        } else if ( ch == 'e' || ch == 'E') {
            char n[12];
            for( i = 0; i<11; i++ ) {
                n[i] = files[( (offset) * 12) + i];
            }
            n[12]=0;
            execl(n, 0);
        } else if ( ch == 'v' || ch == 'V') {
            char *name;
            int i;
            int n = 0;

            /* clear the screen */
            cls();

            /* Get the filename selected */
            name = get_filename();

            printf("Reading '%s'\n", name);
            i = fopen( name, "r");
            if ( i ) {
                int newline= 0;


                while(( n = getc(i)) != EOF) {
                     printf("%c", n & CHAR_MASK);
                     if ( n == '\n' || n == '\r') {
                         newline++;
                     }
                     if( newline > 18 ) {
                         newline = 0;
                         printf("Press any key for the next page, ESCAPE to abort.\n");
                         n = keyPressed();
                         if ( n == 27 ) {
                             goto abort_page;
                         }
                         cls();
                     }

                }
            abort_page:
                fclose(i);
            }

            printf("Press any key to return back to FU\n");
            keyPressed();

            /* Try to reset state */
            i = getDR();
            set_drive( i+ 'A' );

            offset = 0;
            files_count = 0;
            refresh = 1;

        } else if ( ch == 'f' || ch == 'F') {
            int n = 0;
            int c = 0;

            /* remove old filter */
            for ( i = 0; i < 11; i++ ){
                filter[i] = 00;
            }

            printf("   Enter Filter:");
            while ((c = getchar()) != EOF) {
                if ( c == '\n')  {
                    break;
                }
                filter[n] = toupper(c);
                n++;
            }

            /* overwrite the text */
            refresh=1;
        } else if ( ch == 'd' || ch == 'D') {
            char c;

            /* Get the filename selected */
            char *name = get_filename();

            printf("   Really delete:%s?", name);
            while ((c = keyPressed()) != EOF) {
                if ( c == 'n' || c == 'N' || c == 27)  {
                    break;
                }
                if ( c == 'y' || c == 'Y') {
                    unlink(name);
                    break;
                }
            }
            refresh = 1;
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


; int getDR();
    public getDR_
    public getDR
getDR:
getDR_:
     mvi c,25
     call 5
     mvi h,0
     mov l,a
     ret

#endasm
