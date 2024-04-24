/*
 * Simple echo-program, compile and use like so:
 *
 * C> CC ECHO
 * C> AS ECHO
 * C> LN ECHO.O T.LIB C.LIB
 * C> ECHO HELLO, WORLD
 * HELLO, WORLD
 */
#include "STDIO.H"

main(argc, argv)
int argc;
char *argv[];
{
    int i;

    /*
     * Print each argument, add a newline on the last one, otherwise
     * add a trailing space.
     */
    for( i = 1; i < argc; i++ ) {
        printf("%s%s", argv[i], ( i + 1 ) == argc ? "\n" : " ");
    }

    return 0;
}
