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
 * NOTE: The C compiler doesn't understand "%02X" to output a hex
 * value as upper-case, it only understands "%02x", and I added a
 * manual step to upper-case the hex-digits.
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

            /* build a line of output here.
               specifically so we can upper-case it. */
            char buf[100];

            /* set the buffer to be full of nulls */
            for ( i = 0; i < sizeof(buf); i++)
                buf[i] = 0x00;

            /* Add the offset */
            sprintf(buf, "%04x ", offset);

            /* Add the hex contents */
            for (i = 0; i < 16 ; i++ )
                sprintf(buf + strlen(buf), "%02x ", tmp[i]);

            /* Upper case the output line - before we add the ASCII*/
            for ( i = 0 ; i < sizeof(buf); i++ )
                buf[i] = toupper(buf[i]);

            /* Add the ASCII */
            for (i = 0; i < 16 ; i++ )
                if ( tmp[i]>= 32 && tmp[i]<128)
                    sprintf(buf + strlen(buf), "%c", tmp[i]);
                else
                    sprintf(buf + strlen(buf), " ");

            /* Now output a complete line */
            printf("%s\n", buf);

            /* reset our position, and bump the offset */
            i= 0;
            offset= offset + 16;
        }
    }

    /* All done */
    fclose(f);
    exit(0);

}
