; This is a simple example program written in assembler
;
; Assemble it via:
;
;   ASM hello
;
; This will produce two output files:
;
;   HELLO.PRN - This can be ignored
;   HELLO.HEX - The loader will use this
;
; Once this has been done run the loader:
;
;   LOAD hello
;
; This will read "hello.hex" and produce "hello.com", which you can then
; run.
;

        ORG     0100H           ; CP/M base of TPA (transient program area)
        MVI     C,09H           ; Print string function
        LXI     D,MESSAGE       ; Point
        CALL    0005H           ; Call bdos
        RET                     ; To cp/m
MESSAGE:DB      0DH,0AH,'Hello, World!',0DH,0AH,'$'
        END
