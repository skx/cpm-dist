20 ESC$ = CHR$(27)+"["

100 REM foreground color
110 FOR I = 30 TO 37
120 PRINT ESC$ +  MID$(STR$(I), 2) + "m" + "Color"; I
130 NEXT I
140 REM black again
150 PRINT ESC$ +  "30m" + "Black Color again"
160 PRINT " "

200 REM background color
210 FOR I = 40 TO 47
220 PRINT ESC$ +  MID$(STR$(I), 2) + "m" + "Background color"; I
230 NEXT I
240 REM white again
250 PRINT ESC$ +  "47m" + "White Background again"
260 PRINT " "

300 REM attributes
310 PRINT ESC$ + "1m" + "Bold on"
320 PRINT ESC$ + "4m" + "Underline on"
330 PRINT ESC$ + "5m" + "Italic on"
340 PRINT ESC$ + "7m" + "Inverse on"
350 PRINT ESC$ + "8m" + "Coverd on"
360 PRINT ESC$ + "0m" + "turn off attributes"
370 PRINT " "

