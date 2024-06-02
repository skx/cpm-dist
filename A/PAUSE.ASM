; pause.ASM - Pause for a keypress.
;
; Assemble it via:
;
;   ASM PAUSE
;
; This will produce two output files:
;
;   PAUSE.PRN - This can be ignored
;   PAUSE.HEX - The loader will use this
;
; Once this has been done run the loader:
;
;   LOAD PAUSE
;
; This will read "PAUSE.hex" and produce "PAUSE.com", which you can then
; run.
;

        ORG     0100H           ; CP/M base of TPA (transient program area)
        MVI     C,09H           ; Print string function
        LXI     D,MESSAGE       ;
        CALL    0005H           ; Call bdos

        MVI     C,01H           ; Keyboard input function
        CALL    0005H           ; Call bdos

        MVI     C,09H           ; Print string function
        LXI     D,CLEAR         ;
        CALL    0005H           ; Call bdos
        RET                     ; To cp/m
MESSAGE:DB 27, '[2J'            ; "clear"
        DB 27, '[', 'H'         ; "home"
        DB 0DH, 0AH, 'Press any key to continue ..',0DH,0AH,'$'
CLEAR:  DB 27, '[2J'            ; "clear"
        DB 27, '[', 'H'         ; "home"
        DB '$'
        END
