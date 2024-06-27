TITLE	'rndtst - test - Test R register as random number generator'
; 26-Dec-2016 <ethan.dicks@gmail.com>
ORG	100H
;
BDOS	EQU	5	;BDOS entry point
COUT	EQU	2	;BDOS Output character
CR	EQU	13
LF	EQU	10
;
START:
	LXI	H,INTRO	;address of intro string
	CALL	STROUT
;
	LXI	H,ITSA	;address type message string
	CALL	STROUT
	XRA	A	;zero A
	DCR	A
	JPE	NOTZ80
	LXI	H,NMZ80	;address Z80 string
	CALL	STROUT
	CALL	CRLF
	JMP	DORND
NOTZ80:	LXI	H,NM8080	;address 8080 string
	CALL	STROUT
	JMP	CRLF
;
DORND:	CALL	TSTRND
	CALL	TSTRND
	CALL	TSTRND
	CALL	TSTRND
	JMP	TSTRND	;return to CCP

;
; TSTRND - get random number and print it
;
TSTRND:	LXI	H,0
	DB	0EDH, 5FH	; LD A,R in hex for 8080 ASM
	MOV	L,A
	CALL	DECPRT
	JMP	CRLF

;
; DECPRT - print byte in M/HL as decimal number
;
DECPRT:	PUSH	H
	PUSH	D
	PUSH	B
	MVI	B,0	;leading-zero flag
	LXI	D,-10000
	CALL	SUBTR
	LXI	D,-1000
	CALL	SUBTR
	LXI	D,-100
	CALL	SUBTR
	LXI	D,-10
	CALL	SUBTR
	MOV	A,L
	ADI	'0'
	CALL	CHROUT
	POP	B
	POP	D
	POP	H
	RET

;
SUBTR:	MVI	C,'0'-1
SUBT2:	INR	C
	DAD	D
	JC	SUBT2
;
;	SBC	HL,DE
	MOV	A,L
	SUB	E
	MOV	L,A
	MOV	A,H
	SBB	D
	MOV	H,A
;
	MOV	A,C	;get count
;
	CPI	'1'	;less than 1?
	JNC	NZERO	;no
	MOV	A,B	;check flag
	ORA	A	;is set?
	MOV	A,C	;restore count
	RZ	 	;skip leading 0
	JMP	CHROUT
;set flag on non-zero chars
NZERO:	MVI	B,0FFH
	JMP	CHROUT

;
; STROUT - print null terminated string
;
STROUT: 
STLOOP:	MOV	A,M
	ORA	A
	JZ	STRDON
	CALL	CHROUT
	INX	H
	JMP	STLOOP
STRDON:
	RET
	

;
; CRLF - print CR and LF
;
CRLF	MVI	A,CR
	CALL	CHROUT
	MVI	A,LF
;
	; FALL THROUGH

;
; CHROUT - print one char via BDOS 2
;
CHROUT:	PUSH	H
	PUSH	A
	MOV	E,A
	MVI	C,COUT
	CALL	BDOS
	POP	A
	POP	H
	RET
;

INTRO:	DB	'RNDTST - Test R register as random number generator', CR, LF, 0
ITSA:	DB	'CPU is a',0
NMZ80:	DB	' Z80',0
NM8080:	DB	'n 8080',0

	END	START
