10 REM test VT100 escape codes
20 REM
30 ESC$ = CHR$(27)+"["
40 REM Clear Screen
50 CLS$ = ESC$ + "2J"
60 PRINT "Press Return to clear screen";: INPUT " ", Q$
70 PRINT CLS$;
80 REM several cursor positioning examples
90 PRINT "Press Return to position cursor";: INPUT " ", Q$
100 CP1$ = ESC$ + "10;20H"
110 PRINT CP1$; "Cursor at (10,20). Press Return to go to (15,15)";: INPUT " ", Q$
120 CP2$ = ESC$ + "15;15f"
130 PRINT CP2$; "Cursor at (15,15). Press Return for diagonal positioning";: INPUT " ", Q$
140 FOR I = 1 TO 24
150 T$ = ESC$ + MID$(STR$(I),2) + ";" + MID$(STR$(I), 2) + "H"
160 PRINT T$ + "$";
170 NEXT I
180 REM Delete Line
190 CP2$ = ESC$ + "10;10f"
200 PRINT CP2$;
210 PRINT "Press Return to Delete Line demo";: INPUT " ", Q$
220 FOR I = 1 TO 5
230 PRINT ESC$ + "2K";
240 NEXT I
250 PRINT "Press Return for color demo";: INPUT " ", Q$
260 REM foreground color
270 FOR I = 30 TO 37
280 PRINT ESC$ +  MID$(STR$(I), 2) + "m" + "Color"; I
290 NEXT I
300 REM black again
310 PRINT ESC$ +  "30m" + "Black again"
320 REM background color
330 FOR I = 40 TO 47
340 PRINT ESC$ +  MID$(STR$(I), 2) + "m" + "Background color"; I
350 NEXT I
360 REM white again
370 PRINT ESC$ +  "47m" + "White again"
380 END
