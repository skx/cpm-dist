/*
 * dump.c - A file-dumping program for CP/M which shows ASCII as
 *          well as the hex contents of files.
 *
 * Compile via the Aztec C compiler:
 *
 *   CC DUMP
 *   AS DUMP
 *   LN DUMP.O C.LIB
 *
 *
 * Steve Kemp 29/04/2024
 * https://github.com/skx/cpm-dist/
 *
 */
#include "libc.h"

main(argc, argv)
int argc; char **argv ;
{
    char tmp[16];
    int i;
    int offset;
    int c, f;

    i = 0;
    offset = 0;

    if ( argc != 2 ) {
            printf("Usage: DUMP filename.ext\n");
            exit(1);
    }

    /* open the file */
    f = fopen(argv[1], "r");
    if ( !f ) {
	printf("Failed to open %s\n", argv[1]);
	exit(1);
    }

    /* read character by character, until the end of file */
    while(( c = getc(f)) != EOF)
    {

        /* read character into our temporary buffer */
        tmp[i] = c;
        i++;

        /* Got a full line? */
        if ( i == 16 ){

            /* Show the offset */
            printf("%04x ", offset);

            /* Show the hex */
            for (i = 0; i < 16 ; i++ )
                printf("%02x ", tmp[i]);

            /* Show the ASCII */
            for (i = 0; i < 16 ; i++ )
                if ( tmp[i]>= 32 && tmp[i]<128)
                    printf("%c", tmp[i]);
                else
                    printf(" ");

            /* newline */
            printf("\n");

            /* reset our position, and bump the offset */
            i= 0;
            offset= offset + 16;
        }
    }

    /* All done */
    fclose(f);
    exit(0);

}
