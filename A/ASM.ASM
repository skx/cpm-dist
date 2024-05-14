; Digital Research ASM assembler
; disassembled by Larry A. Greene
; got any comments or suggestions?
; send to greenela@clear.lakes.com

; using command ASM TEST.ABC will assemble TEST.ASM with drive designations
; following period. A=ASM file drive, B=HEX file drive, C=SYM file drive

	ORG	0100H

H0000	EQU	0000H		; Cold re-entry to system
H0005	EQU	0005H		; BDOS
H005C	EQU	005CH		; FCB
H0080	EQU	0080H		; DMA

	LXI	SP,H0200	; Set stack
	LHLD	H0005+1
	SHLD	H01CD		; Set end of memory = BDOS base
	JMP	H0200
H010C:	DB	' '		; 120 byte line buffer for PRN output
H010D:	DB	'C'		; If H010C is non-space then contains error code:
				; B = unknown
				; C = comma missing
				; D = not an 8 bit value for DB label expression
				; E = bad register syntax
				; L = bad mnemonic
				; N = function not supported
				; O = unknown (some form of syntax error)
				; P = duplicate label or phase error
				; R = wrong register
				; S = syntax error
				; U = unclained label
				; V = bad value
H010E:	DB	'OPY'
H0111:	DB	'R'
H0112:	DB	'IGHT(C) 1978, DIGITAL RESEARCH '
	DS	53H
H0184:	DS	01H		; Index into H010C PRN buffer
H0185:	DS	01H		; Char type. 4=EOL 3=literal 2=digit 1=alpha
H0186:	DS	02H		; Holds value of numeric expression from H1106 call
H0188:	DS	01H		; Index into H0189 ASM buffer
H0189:	DS	01H		; 64 byte ASM line buffer
H018A:	DS	01H
H018B:	DS	3EH
H01C9:	DS	02H
H01CB:	DW	H20F0		; Contains end of symbol table
H01CD:	DS	02H		; Contains BDOS base (end of memory space)
H01CF:	DS	01H		; Assembly pass count 0=build symbol table 1=table done
H01D0:	DS	02H		; Address counter (for HEX file also)
H01D2:	DS	02H		; Address printed at start of line in PRN file
H01D4:	DW	H20F0		; Start of symbol table (fixed)
H01D6:	DS	2AH		; Stack space below H0200
H0200:	JMP	H0CE0		; Cold start
H0203:	JMP	H0DA1		; Open ASM file
H0206:	JMP	H0DCA		; Get char from H029D ASM file buffer.
				; Reads disk as needed.
	JMP	H0E34		; Write byte in ACC reg to PRN file. all regs preserved
	JMP	H0EAA		; Write ACC reg to HEX file (direct - after processed)
	JMP	H0EDE		; Write ACC reg to console
H0212:	JMP	H0CBC		; Print string at (HL). terminates with cr
H0215:	JMP	H0F00		; Print H010C line buffer to PRN file w/echo to console
H0218:	JMP	H0F2F		; Put error code from ACC reg into H010C flag
H021B:	JMP	H104C		; Write byte in ACC reg to HEX file in ASCII form
H021E:	JMP	H0F39		; Close files and exit
H0221:	DS	02H		; HEX file pointer (base address of line)
H0223:	DS	01H		; Index into line of H0224
H0224:	DS	10H		; Obj code line buffer for PRN and HEX use
H0234:	DS	01H		; Current disk
H0235:	DS	01H		; ASM file drive designation
H0236:	DS	01H		; PRN file drive designation
H0237:	DS	01H		; HEX file drive designation
H0238:	DS	9		; ASM filename
	DB	'ASM'
H0244:	DS	14H
H0258:	DS	01H		; PRN filename
H0259:	DS	9
	DB	'PRN'
	DS	15H
H027A:	DS	9		; HEX filename
	DB	'HEX'
	DS	15H
H029B:	DS	02H		; Index into H029D buffer
H029D:	DS	400H		; Buffer for ASM file read
H069D:	DS	02H		; Index into H069F buffer
H069F:	DS	300H		; Buffer for PRN file write
H099F:	DS	02H		; Index into H09A1 buffer
H09A1:	DS	300H		; Buffer for HEX file write
H0CA1:	LXI	H,H0234		; Select drive in ACC reg and make it the current drive
	CMP	M
	RZ
	MOV	M,A
	MOV	E,A
	MVI	C,0EH
	CALL	H0005
	RET
H0CAE:	INX	H
	MOV	A,M
	CPI	20H
	JZ	H0CB8
	SBI	41H
	RET
H0CB8:	LDA	H0234
	RET
H0CBC:	MOV	A,M		; Print string at (HL). terminate w/cr
	CALL	H0EDE
	MOV	A,M
	INX	H
	CPI	0DH
	JNZ	H0CBC
	MVI	A,0AH
	CALL	H0EDE
	RET
H0CCD:	LXI	D,H005C		; Move 9 bytes from FCB to (HL)
	MVI	B,09H		; Error exit if '?' found
H0CD2:	LDAX	D
	CPI	3FH
	JZ	H0DBB
	MOV	M,A
	INX	H
	INX	D
	DCR	B
	JNZ	H0CD2
	RET
H0CE0:	LXI	H,H0FA0		; Cold start
	CALL	H0CBC		; Print title
	JMP	H0D3F
H0CE9:	MVI	C,0FH		; Open file
	CALL	H0005
	CPI	0FFH
	RNZ
	LXI	H,H0FB9
	CALL	H0CBC
	JMP	H0000
H0CFA:	MVI	C,10H		; Close file
	CALL	H0005
	CPI	0FFH
	RNZ
	LXI	H,H1029
	CALL	H0CBC
	JMP	H0000
H0D0B:	MVI	C,13H		; Delete file. (DE) = FCB
	JMP	H0005
H0D10:	MVI	C,16H		; Make file. (DE) = FCB
	CALL	H0005		; Error exit if disk full
	CPI	0FFH
	RNZ
	LXI	H,H0FD0
	CALL	H0CBC
	JMP	H0000
H0D21:	LDA	H0235		; Select ASM file drive
	CALL	H0CA1
	RET
H0D28:	LDA	H0236
	CPI	19H
	RZ
	CPI	17H
	RET
H0D31:	LDA	H0236		; Select PRN file drive
	CALL	H0CA1
	RET
H0D38:	LDA	H0237		; Select HEX file drive
	CALL	H0CA1
	RET
H0D3F:	LDA	H005C		; Drive designation
	CPI	20H
	JZ	H0DBB		; Error exit
	MVI	C,19H
	CALL	H0005		; Get current disk
	STA	H0234
	LXI	H,0064H		; Get optional drive designations following '.'
	CALL	H0CAE		; After filename else use current drive
	STA	H0235
	CALL	H0CAE
	STA	H0237
	CALL	H0CAE
	STA	H0236
	LXI	H,H0238		; ASM filename
	CALL	H0CCD		; Move filename
	CALL	H0D28
	JZ	H0D83
	LXI	H,H0259
	PUSH	H
	PUSH	H
	CALL	H0CCD
	CALL	H0D31		; Select PRN file drive
	POP	D
	CALL	H0D0B		; Delete old PRN file
	POP	D
	CALL	H0D10		; Make new PRN file
H0D83:	LDA	H0237
	CPI	19H
	JZ	H0D9E
	LXI	H,H027A
	PUSH	H
	PUSH	H
	CALL	H0CCD
	CALL	H0D38		; Select HEX file drive
	POP	D
	CALL	H0D0B		; Delete old HEX file
	POP	D
	CALL	H0D10		; Make new HEX file
H0D9E:	JMP	H1100		; Enter assembler with HEX and PRN files open
H0DA1:	LXI	H,0400H		; Open ASM file. force reading of first byte
	SHLD	H029B		; Of ASM file by setting index to EOF
	XRA	A
	STA	H0244
	STA	H0258
	STA	H0223
	CALL	H0D21
	LXI	D,H0238
	CALL	H0CE9
	RET
H0DBB:	LXI	H,H0FE3		; 'source filename error' exit
	CALL	H0CBC
	JMP	H0000
H0DC4:	MOV	A,D
	CMP	H
	RNZ
	MOV	A,E
	CMP	L
	RET
H0DCA:	PUSH	B		; Get char from ASM file
	PUSH	D
	PUSH	H
	LHLD	H029B
	LXI	D,0400H
	CALL	H0DC4
	JNZ	H0E19
	CALL	H0D21
	LXI	H,0000H
	SHLD	H029B
	MVI	B,08H
	LXI	H,H029D
H0DE7:	PUSH	B
	PUSH	H
	MVI	C,14H
	LXI	D,H0238
	CALL	H0005
	POP	H
	POP	B
	ORA	A
	MVI	C,80H
	JNZ	H0E0D
	LXI	D,H0080
	MVI	C,80H		; Extra code not needed (see 3 lines previous)
H0DFE:	LDAX	D
	MOV	M,A
	INX	D
	INX	H
	DCR	C
	JNZ	H0DFE
	DCR	B
	JNZ	H0DE7
	JMP	H0E19
H0E0D:	CPI	03H
	JNC	H0E2B
H0E12:	MVI	M,1AH
	INX	H
	DCR	C
	JNZ	H0E12
H0E19:	LXI	D,H029D
	LHLD	H029B
	PUSH	H
	INX	H
	SHLD	H029B
	POP	H
	DAD	D
	MOV	A,M
	POP	H
	POP	D
	POP	B
	RET
H0E2B:	LXI	H,H0FFA		; 'source file read error' exit
	CALL	H0CBC
	JMP	H0000
H0E34:	PUSH	B		; Output char in ACC reg to PRN designation:
	MOV	B,A		; Z = null, X = console, else to H069F buffer
	LDA	H0236		; And write to disk as needed
	CPI	19H		; 'Z'
	JZ	H0E51
	CPI	17H		; 'X'
	MOV	A,B
	JNZ	H0E4A
	CALL	H0EDE		; Write to console
	JMP	H0E51
H0E4A:	PUSH	D
	PUSH	H
	CALL	H0E53
	POP	H
	POP	D
H0E51:	POP	B
	RET
H0E53:	LHLD	H069D		; Write byte to PRN file
	XCHG
	LXI	H,H069F
	DAD	D
	MOV	M,A
	XCHG
	INX	H
	SHLD	H069D
	XCHG
	LXI	H,0300H
	CALL	H0DC4
	RNZ
	CALL	H0D31
	LXI	H,0000H
	SHLD	H069D
	LXI	H,H069F
	LXI	D,H0259
	MVI	B,06H		; 6 times 80H = 300H
H0E7A:	MOV	A,M		; Write HEX file comes here
	CPI	1AH
	RZ
	PUSH	B
	PUSH	D
	MVI	C,80H
	LXI	D,H0080
H0E85:	MOV	A,M
	STAX	D
	INX	H
	INX	D
	DCR	C
	JNZ	H0E85
	POP	D
	PUSH	D
	PUSH	H
	MVI	C,15H		; Write sequential
	CALL	H0005
	POP	H
	POP	D
	POP	B
	ORA	A
	JNZ	H0EA1
	DCR	B
	RZ
	JMP	H0E7A
H0EA1:	LXI	H,H1011
	CALL	H0CBC
	JMP	H0F77
H0EAA:	PUSH	B		; Write ACC to HEX file with disk buffering
	PUSH	D
	PUSH	H
	CALL	H0EB4
	POP	H
	POP	D
	POP	B
	RET
H0EB4:	LHLD	H099F
	XCHG
	LXI	H,H09A1
	DAD	D
	MOV	M,A
	XCHG
	INX	H
	SHLD	H099F
	XCHG
	LXI	H,0300H
	CALL	H0DC4		; Compare DE and HL - buffer full?
	RNZ			; No
	CALL	H0D38		; Select HEX file drive
	LXI	H,0000H
	SHLD	H099F
	LXI	H,H09A1
	LXI	D,H027A
	MVI	B,06H
	JMP	H0E7A
H0EDE:	PUSH	B		; Write ACC reg to console
	PUSH	D
	PUSH	H
	MVI	C,02H
	MOV	E,A
	CALL	H0005
	POP	H
	POP	D
	POP	B
	RET
H0EEB:	MOV	C,A		; Write ACC reg to PRN designation. echo error
	CALL	H0E34		; To console if H010C is non-space
	LDA	H010C
	CPI	20H
	RZ
	LDA	H0236
	CPI	17H
	RZ
	MOV	A,C
	CALL	H0EDE		; Echo to console
	RET
H0F00:	LDA	H0184		; Print H010C line buffer to PRN file with
	LXI	H,H010C		; Echo to console. H0184 = # of chars in line
H0F06:	ORA	A
	JZ	H0F15
	MOV	B,A
	MOV	A,M
	CALL	H0EEB		; Write byte w/echo
	INX	H
	MOV	A,B
	DCR	A
	JMP	H0F06
H0F15:	STA	H0184		; Write CR to PRN file then clear line buffer
	MVI	A,0DH
	CALL	H0EEB
	MVI	A,0AH
	CALL	H0EEB
	LXI	H,H010C
	MVI	A,78H
H0F27:	MVI	M,20H
	INX	H
	DCR	A
	JNZ	H0F27
	RET
H0F2F:	MOV	B,A
	LXI	H,H010C
	MOV	A,M
	CPI	20H
	RNZ
	MOV	M,B
	RET
H0F39:	CALL	H0D28		; Close files and exit
	JZ	H0F4F		; Taken if no PRN file designated
H0F3F:	LHLD	H069D
	MOV	A,L
	ORA	H
	JZ	H0F4F
	MVI	A,1AH		; Fill to end of buffer with ctrl-Z
	CALL	H0E34
	JMP	H0F3F
H0F4F:	LDA	H0237
	CPI	19H
	JZ	H0F77		; Taken if no HEX file designated
	LDA	H0223		; Index
	ORA	A
	CNZ	H10B8		; Write final line to HEX file
	LHLD	H01D0
	SHLD	H0221
	CALL	H10B8		; Write EOF address as data
H0F67:	LHLD	H099F
	MOV	A,L
	ORA	H
	JZ	H0F77
	MVI	A,1AH
	CALL	H0EAA
	JMP	H0F67
H0F77:	CALL	H0D28		; Error in writing PRN or HEX file comes here
	JZ	H0F86		; Taken if no PRN file designation
	CALL	H0D31		; Select PRN file drive
	LXI	D,H0259
	CALL	H0CFA		; Close PRN file
H0F86:	LDA	H0237		; Check HEX designation
	CPI	19H
	JZ	H0F97		; Taken if no HEX file designation
	CALL	H0D38		; Select HEX file drive
	LXI	D,H027A
	CALL	H0CFA		; Close HEX file
H0F97:	LXI	H,H103C
	CALL	H0CBC
	JMP	H0000
H0FA0:	DB	'CP/M ASSEMBLER - VER 2.0'
	DB	0DH
H0FB9:	DB	'NO SOURCE FILE PRESENT'
	DB	0DH
H0FD0:	DB	'NO DIRECTORY SPACE'
	DB	0DH
H0FE3:	DB	'SOURCE FILE NAME ERROR'
	DB	0DH
H0FFA:	DB	'SOURCE FILE READ ERROR'
	DB	0DH
H1011:	DB	'OUTPUT FILE WRITE ERROR'
	DB	0DH
H1029:	DB	'CANNOT CLOSE FILES'
	DB	0DH
H103C:	DB	'END OF ASSEMBLY'
	DB	0DH
H104C:	PUSH	B		; Write ACC reg to HEX file
	MOV	B,A
	LDA	H0237
	CPI	19H
	MOV	A,B
	JZ	H1098
	PUSH	D
	PUSH	PSW
	LXI	H,H0223
	MOV	A,M
	ORA	A
	JZ	H1084
	CPI	10H
	JC	H106C
	CALL	H10B8		; Write complete line to HEX file. H0221 = addr
	JMP	H1084
H106C:	LHLD	H01D0
	XCHG
	LHLD	H0221		; If (H0221) + ACC = (H01D0) then jump to H108A
	MOV	C,A		; Else H1081
	MVI	B,00H
	DAD	B
	MOV	A,E
	CMP	L
	JNZ	H1081
	MOV	A,D
	CMP	H
	JZ	H108A
H1081:	CALL	H10B8		; Write complete line to HEX file
H1084:	LHLD	H01D0
	SHLD	H0221
H108A:	LXI	H,H0223		; Write ACC reg to H0224 obj buffer and
	MOV	E,M		; Increment H0223 index
	INR	M
	MVI	D,00H
	LXI	H,H0224
	DAD	D
	POP	PSW
	MOV	M,A
	POP	D
H1098:	POP	B
	RET
H109A:	PUSH	PSW		; Write ACC reg to HEX file in HEX ASCII form
	RRC
	RRC
	RRC
	RRC
	ANI	0FH
	CALL	H10AF
	POP	PSW
	PUSH	PSW
	ANI	0FH
	CALL	H10AF
	POP	PSW
	ADD	D
	MOV	D,A		; Keep running checksum for Intel HEX form
	RET
H10AF:	ADI	90H
	DAA
	ACI	40H
	DAA
	JMP	H0EAA
H10B8:	MVI	A,3AH		; Write complete line to HEX file
	CALL	H0EAA		; Write ACC reg to HEX file
	LXI	H,H0223
	MOV	E,M		; # of bytes to write
	XRA	A
	MOV	D,A
	MOV	M,A		; Reset index to 0
	LHLD	H0221		; Address of line in HEX file
	MOV	A,E
	CALL	H109A
	MOV	A,H		; Write line address
	CALL	H109A
	MOV	A,L
	CALL	H109A
	XRA	A
	CALL	H109A
	MOV	A,E
	ORA	A
	JZ	H10E8
	LXI	H,H0224
H10DF:	MOV	A,M
	INX	H
	CALL	H109A
	DCR	E
	JNZ	H10DF
H10E8:	XRA	A
	SUB	D		; Checksum
	CALL	H109A		; Write checksum to HEX file
	MVI	A,0DH
	CALL	H0EAA
	MVI	A,0AH
	CALL	H0EAA
	RET
	DB	0,0,0,0,0,0,0,0
H1100:	JMP	H1340		; Enter assembler with PRN and HEX files open
H1103:	JMP	H1132		; Output cr/lf to PRN file (clears line buffer)
H1106:	JMP	H11C0		; Parse line up to non-alphanumeric char (EOL)
				; Reading from ASM file as necessary. if char is
				; Numeric then return value in H0186. if LF (0Ah
				; Found, will print line to PRN file with echo
				; To console on 2nd pass.
H1109:	NOP			; Previous char from H110A
H110A:	NOP			; Last char read from ASM file
H110B:	NOP			; Base 2,8,10 or 16 for numeric value
H110C:	CALL	H0206		; Get char from ASM file and store in
	PUSH	PSW		; H010C PRN line buffer
	CPI	0DH
	JZ	H1130
	CPI	0AH
	JZ	H1130
	LDA	H0184
	CPI	78H
	JNC	H1130
	MOV	E,A
	MVI	D,00H
	INR	A
	STA	H0184
	LXI	H,H010C
	DAD	D
	POP	PSW		; Restore char
	MOV	M,A		; Store in PRN line buffer
	RET
H1130:	POP	PSW		; Restore char
	RET
H1132:	CALL	H1149		; Print CR/LF to PRN file
	STA	H110A
	STA	H0184
	MVI	A,0AH
	STA	H1109
	CALL	H0215		; Print PRN line buffer
	MVI	A,10H
	STA	H0184		; Index to label field
	RET
H1149:	XRA	A
	STA	H0188
	STA	H110B
	RET
H1151:	LXI	H,H0188		; Store char in H0189 buffer
	MOV	A,M
	CPI	40H
	JC	H115F
	MVI	M,00H
	CALL	H131E
H115F:	MOV	E,M
	MVI	D,00H
	INR	M
	INX	H
	DAD	D
	LDA	H110A
	MOV	M,A
	RET
H116A:	MOV	A,M		; Null out '$' at (HL)
	CPI	24H
	RNZ
	XRA	A
	MOV	M,A
	RET
H1171:	LDA	H110A		; Return z clear if '0-9' digit
	SUI	30H
	CPI	0AH
	RAL
	ANI	01H
	RET
H117C:	CALL	H1171		; Return z clear if '0-9' or 'A-F' hex digit
	RNZ
	LDA	H110A
	SUI	41H
	CPI	06H		; A-F = 0-5. carry set if A-F
	RAL			; Carry to bit 0
	ANI	01H		; =1 if A-F
	RET
H118B:	LDA	H110A		; Return z clear if 'A-Z' alpha
	SUI	41H
	CPI	1AH
	RAL
	ANI	01H
	RET
H1196:	CALL	H118B		; Return z clear if 'A-Z' or '0-9' alphanumeric
	RNZ
	CALL	H1171
	RET
H119E:	LDA	H110A
	CPI	61H
	RC
	CPI	7BH
	RNC
	ANI	5FH
	STA	H110A
	RET
H11AD:	CALL	H110C		; Get char and store in PRN line buffer
	STA	H110A		; Save in last char
	JMP	H132D		; Go convert lower/upper conditionally
	RET			; Bogus
H11B7:	CPI	0DH
	RZ
	CPI	1AH
	RZ
	CPI	21H
	RET
H11C0:	XRA	A		; Parse line
	STA	H0185		; Clear char mode
	CALL	H1149
H11C7:	LDA	H110A		; Each char loops here
	CPI	09H
	JZ	H11F4
	CPI	3BH
	JZ	H11E1
	CPI	2AH
	JNZ	H11ED
	LDA	H1109
	CPI	0AH
	JNZ	H11ED
H11E1:	CALL	H11AD		; Search ahead to EOL
	CALL	H11B7
	JZ	H11FA
	JMP	H11E1
H11ED:	ORI	20H
	CPI	20H
	JNZ	H11FA
H11F4:	CALL	H11AD		; Get next char
	JMP	H11C7		; Loop for next char
H11FA:	CALL	H118B
	JZ	H1205		; If not alpha
	MVI	A,01H
	JMP	H1239
H1205:	CALL	H1171
	JZ	H1210		; If not digit
	MVI	A,02H
	JMP	H1239
H1210:	LDA	H110A
	CPI	27H		; Single quote
	JNZ	H1221
	XRA	A
	STA	H110A
	MVI	A,03H
	JMP	H1239
H1221:	CPI	0AH
	JNZ	H1237
	LDA	H01CF		; Assembly pass count
	ORA	A
	CNZ	H0215		; On 2nd pass print line to PRN file
	LXI	H,H010C
	MVI	M,20H		; Clear error char
	MVI	A,10H
	STA	H0184		; Index to label field for PRN file
H1237:	MVI	A,04H
H1239:	STA	H0185
H123C:	LDA	H110A		; Last char
	STA	H1109		; Previous char
	ORA	A
	CNZ	H1151		; Store char in ASM buffer
	CALL	H11AD		; Get char and store in PRN line buffer
	LDA	H0185		; Char mode
	CPI	04H		; EOL ?
	RZ
	CPI	03H		; Literal?
	CNZ	H119E		; Convert lower to upper case if not in quotes
	LXI	H,H110A
	LDA	H0185		; Char mode
	CPI	01H		; Alpha?
	JNZ	H126C
	CALL	H116A		; Null out '$' from last char
	JZ	H123C		; Taken if last char was '$'
	CALL	H1196
	RZ			; Taken if not alphanumeric
	JMP	H123C
H126C:	CPI	02H
	JNZ	H1302
	CALL	H116A
	JZ	H123C		; Taken if '$'
	CALL	H117C
	JNZ	H123C		; Taken if hex digit
	LDA	H110A
	CPI	4FH		; 'O' octal
	JZ	H128A
	CPI	51H		; 'Q' octal
	JNZ	H128F
H128A:	MVI	A,08H		; Base 8 for octal
	JMP	H1296
H128F:	CPI	48H		; 'H'
	JNZ	H12A0
	MVI	A,10H		; Base 16 hex for 'H'
H1296:	STA	H110B
	XRA	A
	STA	H110A
	JMP	H12BB
H12A0:	LDA	H1109
	CPI	42H		; 'B' binary
	JNZ	H12AD
	MVI	A,02H		; Base 2 for binary
	JMP	H12B4
H12AD:	CPI	44H		; 'D' decimal
	MVI	A,0AH		; base 10 decimal (default)
	JNZ	H12B8
H12B4:	LXI	H,H0188		; Index
	DCR	M		; Ignore trailing char
H12B8:	STA	H110B		; Set base
H12BB:	LXI	H,0000H
	SHLD	H0186
	LXI	H,H0188
	MOV	C,M
	INX	H
H12C6:	MOV	A,M
	INX	H
	CPI	41H
	JNC	H12D2
	SUI	30H
	JMP	H12D4
H12D2:	SUI	37H
H12D4:	PUSH	H
	PUSH	B
	MOV	C,A
	LXI	H,H110B
	CMP	M
	CNC	H1318
	MVI	B,00H
	MOV	A,M
	LHLD	H0186
	XCHG
	LXI	H,0000H
H12E8:	ORA	A
	JZ	H12F7
	RAR
	JNC	H12F1
	DAD	D
H12F1:	XCHG
	DAD	H
	XCHG
	JMP	H12E8
H12F7:	DAD	B
	SHLD	H0186
	POP	B
	POP	H
	DCR	C
	JNZ	H12C6
	RET
H1302:	LDA	H110A
	CPI	0DH
	JZ	H131E
	CPI	27H
	JNZ	H123C
	CALL	H11AD
	CPI	27H
	RNZ
	JMP	H123C
H1318:	PUSH	PSW		; 'V' bad value error. all regs preserved
	MVI	A,56H
	JMP	H1324
H131E:	PUSH	PSW		; 'O' error. all regs preserved
	MVI	A,4FH
	JMP	H1324
H1324:	PUSH	B
	PUSH	H
	CALL	H0218
	POP	H
	POP	B
	POP	PSW
	RET
H132D:	PUSH	PSW		; Convert lower to upper case if not in quotes
	LDA	H0185		; Char mode
	CPI	03H		; Literal?
	CNZ	H119E		; Convert if not literal
	POP	PSW
	RET
	DB	0,0,0,0,0,0,0,0
H1340:	JMP	H15A0		; Enter assembler with PRN and HEX files open
H1343:	JMP	H145C		; Clear H135B buffer
H1346:	JMP	H149E		; Using label in H0188 buffer, search for
				; Duplicate label. return H01D6=0 if no duplicat
				; Else H01D6 holds address of link field of dup.
H1349:	JMP	H1498		; Ret dup label addr in HL. z-set if no dup
H134C:	JMP	H14EB		; Add symbol. see H14EB for more description
H134F:	JMP	H1560		; Set nibble in symbol table at (H01D6) from
;ACC reg low nibble. when nibble designated by X is set then symbol has been
;assigned value. (H01D6): 00 00 X3 BDOS DW 0005
H1352:	JMP	H1572		; Get nibble from symbol table
H1355:	JMP	H158D		; Set value field of symbol at (H01D6) from HL
H1358:	JMP	H1596		; Get value of symbol at (H01D6) into HL
H135B:	DS	100H		; Buffer table holds 16 bit values. offset into
				; Table based on checksum of chars in label
H145B:	DS	01H
H145C:	LXI	H,H135B
	MVI	B,80H
	XRA	A
H1462:	MOV	M,A
	INX	H
	MOV	M,A
	INX	H
	DCR	B
	JNZ	H1462
	LXI	H,0000H
	SHLD	H01D6
	RET
H1471:	LXI	H,H0188		; Add all chars of label then mask bit 7
	MOV	B,M
	XRA	A
H1476:	INX	H
	ADD	M
	DCR	B
	JNZ	H1476
	ANI	7FH
	STA	H145B
	RET
	MOV	B,A		; Bogus code until H148E. image from addr 1566h
	LHLD	H01D6
	INX	H
	INX	H
	MOV	A,M
	ANI	0F0H
	ORA	B
	MOV	M,A
	RET
H148E:	LHLD	H01D6		; Get length of symbol table
	INX	H
	INX	H
	MOV	A,M
	ANI	0FH
	INR	A
	RET
H1498:	LHLD	H01D6
	MOV	A,L
	ORA	H
	RET
H149E:	CALL	H1471		; Search for duplicate label. return H01D6=0 if
	LXI	H,H0188		; No duplicate or pointing to link field before
	MOV	A,M		; Duplicate
	CPI	11H
	JC	H14AC
	MVI	M,10H		; 16 chars max length of label
H14AC:	LXI	H,H145B
	MOV	E,M
	MVI	D,00H
	LXI	H,H135B
	DAD	D
	DAD	D
	MOV	E,M
	INX	H
	MOV	H,M
	MOV	L,E
H14BB:	SHLD	H01D6
	CALL	H1498
	RZ
	CALL	H148E
	LXI	H,H0188
	CMP	M
	JNZ	H14E1
	MOV	B,A
	INX	H
	XCHG
	LHLD	H01D6
	INX	H
	INX	H
	INX	H
H14D5:	LDAX	D
	CMP	M
	JNZ	H14E1
	INX	D
	INX	H
	DCR	B
	JNZ	H14D5
	RET
H14E1:	LHLD	H01D6
	MOV	E,M
	INX	H
	MOV	D,M
	XCHG
	JMP	H14BB
H14EB:	LXI	H,H0188		; Add symbol from H0188 buffer to end of symbol
	MOV	E,M		; Table at (H01CB) and zero value field
	MVI	D,00H
	LHLD	H01CB
	SHLD	H01D6
	DAD	D
	LXI	D,0005H
	DAD	D
	XCHG
	LHLD	H01CD
	MOV	A,E
	SUB	L
	MOV	A,D
	SBB	H
	XCHG
	JNC	H1541		; Taken if end of symbol space
	SHLD	H01CB
	LHLD	H01D6
	XCHG
	LXI	H,H145B
	MOV	C,M
	MVI	B,00H
	LXI	H,H135B
	DAD	B
	DAD	B
	MOV	C,M
	INX	H
	MOV	B,M
	MOV	M,D
	DCX	H
	MOV	M,E
	XCHG
	MOV	M,C
	INX	H
	MOV	M,B
	LXI	D,H0188
	LDAX	D
	CPI	11H
	JC	H152F
	MVI	A,10H		; Max length of label = 16 chars
H152F:	MOV	B,A
	DCR	A
	INX	H
	MOV	M,A		; Store length-1
H1533:	INX	H		; Store label name
	INX	D
	LDAX	D
	MOV	M,A
	DCR	B
	JNZ	H1533
	XRA	A		; Zero value field
	INX	H
	MOV	M,A
	INX	H
	MOV	M,A
	RET
H1541:	LXI	H,H154A
	CALL	H0212
	JMP	H021E
H154A:	DB	'SYMBOL TABLE OVERFLOW'
	DB	0DH
H1560:	RAL
	RAL
	RAL
	RAL
	ANI	0F0H
	MOV	B,A
	LHLD	H01D6
	INX	H
	INX	H
	MOV	A,M
	ANI	0FH
	ORA	B
	MOV	M,A
	RET
H1572:	LHLD	H01D6
	INX	H
	INX	H
	MOV	A,M
	RAR
	RAR
	RAR
	RAR
	ANI	0FH
	RET
H157F:	CALL	H148E		; Return HL pointing to value field of
	LHLD	H01D6		; Symbol at (H01D6)
	MOV	E,A
	MVI	D,00H
	DAD	D
	INX	H
	INX	H
	INX	H
	RET
H158D:	PUSH	H
	CALL	H157F
	POP	D
	MOV	M,E
	INX	H
	MOV	M,D
	RET
H1596:	CALL	H157F
	MOV	E,M
	INX	H
	MOV	D,M
	XCHG
	RET
	DB	0,0
H15A0:	JMP	H1860		; Enter assembler with PRN and HEX files open
	JMP	H1783
H15A6:	JMP	H1810		; Check word for match. return z-set for match
				; And regs ACC=parm1, B=parm2
H15A9:	DW	H15C4		; Mnem length = 1 (as in reg designation char)
	DW	H15D4		; Mnem length = 2
	DW	H15E6		; Mnem length = 3
	DW	H1682		; Mnem length = 4
	DW	H16AE		; Mnem length = 5
	DW	H16BD		; Bogus?
H15B5:	DB	10H		; # of 1 char words in H15C4 table
	DB	09H		; # of 2 char words in H15D4 table
	DB	34H		; # of 3 char words in H15E6 table
	DB	0BH		; # of 4 char words in H1682 table
	DB	03H		; # of 5 char words in H16AE table
H15BA:	DW	H16BD		; Length = 1
	DW	H16DD		; Length = 2
	DW	H16EF		; Length = 3
	DW	H1757		; Length = 4
	DW	H176D		; Length = 5
H15C4:	DB	0DH

; the following tables must have at least two words in table and words must be
; in alphabetical order

	DB	'()*+,-/ABCDEHLM'
H15D4:	DB	'DBDIDSDWEIIFINORSP'
H15E6:	DB	'ACIADCADDADIANAANDANICMACMCCMPCPIDAADADDCRDCXENDEQUHLTINRINXJMPL'
	DB	'DALXIMODMOVMVINOPNOTORAORGORIOUTPOPPSWRALRARRETRLCRRCRSTSBBSBISE'
	DB	'TSHLSHRSTASTCSUBSUIXORXRAXRI'
H1682:	DB	'CALLENDMLDAXLHLDPCHLPUSHSHLDSPHLSTAXXCHGXTHL'
H16AE:	DB	'ENDIFMACROTITLE'

; the following are 2 byte parameters corresponding to each word.
; they are referenced in source comments as parm1 and parm2.
; for first pair at H16BD: parm1 = 0FH, parm2 = 0AH
; if parm1 = 10H then parm2 represents a register as follows:
; B=0 C=1 D=2 E=3 H=4 L=5 M,SP,PSW=6

H16BD:	DB	0FH,0AH
	DB	0CH,14H,0DH,1EH,00H,50H
	DB	05H,46H,0EH,0AH,06H,46H,01H,50H
	DB	10H,07H,10H,00H,10H,01H,10H,02H
	DB	10H,03H,10H,04H,10H,05H,10H,06H
H16DD:	DB	11H,01H,13H,0F3H,11H,02H,11H,03H
	DB	13H,0FBH,11H,08H,21H,0DBH,0AH,28H
	DB	10H,06H
H16EF:	DB	1AH,0CEH,1DH,88H,1DH,80H,1AH,0C6H
	DB	1DH,0A0H,09H,32H,1AH,0E6H,13H,2FH
	DB	13H,3FH,1DH,0B8H,1AH,0FEH,13H,27H
	DB	15H,09H,1EH,05H,1FH,0BH,11H,04H
	DB	11H,07H,13H,76H,1EH,04H,1FH,03H
	DB	17H,0C3H,1CH,3AH,14H,01H,02H,50H
	DB	18H,40H,19H,06H,13H,00H,08H,3CH
	DB	1DH,0B0H,11H,0AH,1AH,0F6H,21H,0D3H
	DB	16H,0C1H,10H,06H,13H,17H,13H,1FH
	DB	13H,0C9H,13H,07H,13H,0FH,20H,0C7H
	DB	1DH,98H,1AH,0DEH,11H,0BH,03H,50H
	DB	04H,50H,1CH,32H,13H,37H,1DH,90H
	DB	1AH,0D6H,0BH,28H,1DH,0A8H,1AH,0EEH
H1757:	DB	17H,0CDH,11H,06H,1BH,0AH,1CH,2AH
	DB	13H,0E9H,16H,0C5H,1CH,22H,13H,0F9H
	DB	1BH,02H,13H,0EBH,13H,0E3H
H176D:	DB	11H,05H,11H,09H,11H,0CH
H1773:	DB	'NZZ NCC POPEP M '
H1783:	MVI	E,0FFH
	INR	B
	MVI	C,00H
H1788:	XRA	A
	MOV	A,B
	ADD	C
	RAR
	CMP	E
	JZ	H17C4
	MOV	E,A
	PUSH	H
	PUSH	D
	PUSH	B
	PUSH	H
	MOV	B,D
	MOV	C,B
	MVI	D,00H
	LXI	H,0000H
H179C:	DAD	D
	DCR	B
	JNZ	H179C
	POP	D
	DAD	D
	LXI	D,H0189
H17A6:	LDAX	D
	CMP	M
	INX	D
	INX	H
	JNZ	H17B6
	DCR	C
	JNZ	H17A6
	POP	B
	POP	D
	POP	H
	MOV	A,E
	RET
H17B6:	POP	B
	POP	D
	POP	H
	JC	H17C0
	MOV	C,E
	JMP	H1788
H17C0:	MOV	B,E
	JMP	H1788
H17C4:	XRA	A
	INR	A
	RET
H17C7:	LDA	H0189
	LXI	B,0C217H
	CPI	4AH
	RZ
	MVI	B,0C4H
	CPI	43H
	RZ
	LXI	B,0C013H
	CPI	52H
	RET
H17DB:	LDA	H0188
	CPI	04H
	JNC	H180D
	CPI	03H
	JZ	H17F2
	CPI	02H
	JNZ	H180D
	LXI	H,H018B
	MVI	M,20H
H17F2:	LXI	B,0008H
	LXI	D,H1773
H17F8:	LXI	H,H018A
	LDAX	D
	CMP	M
	INX	D
	JNZ	H1805
	LDAX	D
	INX	H
	CMP	M
	RZ
H1805:	INX	D
	INR	B
	DCR	C
	JNZ	H17F8
	INR	C
	RET
H180D:	XRA	A
	INR	A
	RET
H1810:	LDA	H0188
	MOV	C,A
	DCR	A
	MOV	E,A
	MVI	D,00H
	PUSH	D
	CPI	05H		; Max length of mnem
	JNC	H185A
	LXI	H,H15B5
	DAD	D
	MOV	B,M
	LXI	H,H15A9
	DAD	D
	DAD	D
	MOV	D,M
	INX	H
	MOV	H,M
	MOV	L,D
	MOV	D,C
	CALL	H1783
	JNZ	H1845		; ACC now = nth pair of whichever 2 byte table
	POP	D
	LXI	H,H15BA
	DAD	D
	DAD	D
	MOV	E,M
	INX	H
	MOV	D,M
	MOV	L,A
	MVI	H,00H
	DAD	H
	DAD	D
	MOV	A,M
	INX	H
	MOV	B,M
	RET
H1845:	POP	D
	CALL	H17C7
	RNZ
	PUSH	B
	CALL	H17DB
	MOV	A,B
	POP	B
	RNZ
	ORA	A
	RAL
	RAL
	RAL
	ORA	B
	MOV	B,A
	MOV	A,C
	CMP	A
	RET
H185A:	POP	D
	XRA	A
	INR	A
	RET
	DB	0,0
H1860:	JMP	H1BA0		; Enter assembler with PRN and HEX files open
H1863:	JMP	H1A19		; Return addr of symbol in H01C9 and (HL) reg
	JMP	H196E
H1869:	JMP	H1938		; Return 'USE FACTOR' value in DE reg
H186C:	DS	01H		; Flag 0 or FFh
H186D:	DS	0AH		; Buffer for parm1 values
H1877:	DS	0AH		; Buffer for parm2 values
H1881:	DS	10H
H1891:	DS	01H		; Index into H186D or H1877 buffers
H1892:	DS	01H		; Index into H1881 buffer
H1893:	XCHG			; Store HL reg pair in H1881 buffer and incremen
	LXI	H,H1892		; H1892 index by 2
	MOV	A,M
	CPI	10H
	JC	H18A2
	CALL	H1B85
	MVI	M,00H
H18A2:	MOV	A,M
	INR	M
	INR	M
	MOV	C,A
	MVI	B,00H
	LXI	H,H1881
	DAD	B
	MOV	M,E
	INX	H
	MOV	M,D
	RET
H18B0:	PUSH	PSW		; Store parm1,parm2 in H186D and H1877 buffers
	LXI	H,H1891		; And increment H1891 index
	MOV	A,M
	CPI	0AH
	JC	H18BF
	MVI	M,00H
	CALL	H1B85		; 'E' error
H18BF:	MOV	E,M
	MVI	D,00H
	INR	M
	POP	PSW
	LXI	H,H186D
	DAD	D
	MOV	M,A
	LXI	H,H1877
	DAD	D
	MOV	M,B
	RET
H18CF:	LXI	H,H1892		; Get previous pair to HL reg from H1881 buffer
	MOV	A,M
	ORA	A
	JNZ	H18DE
	CALL	H1B85
	LXI	H,0000H
	RET
H18DE:	DCR	M
	DCR	M
	MOV	C,M
	MVI	B,00H
	LXI	H,H1881
	DAD	B
	MOV	C,M
	INX	H
	MOV	H,M
	MOV	L,C
	RET
H18EC:	CALL	H18CF		; Get 2 pairs from H1881 buffer to HL and DE reg
	XCHG
	CALL	H18CF
	RET
H18F4:	MOV	L,A		; Call subroutine from H1901 table based on
	MVI	H,00H		; Parm1 value from H186D table
	DAD	H
	LXI	D,H1901
	DAD	D
	MOV	E,M
	INX	H
	MOV	H,M
	MOV	L,E
	PCHL
H1901:	DW	H1989
	DW	H1992
	DW	H1999
	DW	H199F
	DW	H19AB
	DW	H19BF
	DW	H19C6
	DW	H19D0
	DW	H19D9
	DW	H19E0
	DW	H19EC
	DW	H19F8
	DW	H1B85
H191B:	CALL	H18EC
	MOV	A,D
	ORA	A
	JNZ	H1927
	MOV	A,E
	CPI	11H
	RC
H1927:	CALL	H1B85		; Call 'E' error
	MVI	A,10H
	RET
H192D:	XRA	A
	SUB	L
	MOV	L,A
	MVI	A,00H
	SBB	H
	MOV	H,A
	RET
H1935:	CALL	H18EC
H1938:	XCHG
	SHLD	H196B
	LXI	H,H196D
	MVI	M,11H
	LXI	B,0000H
	PUSH	B
	XRA	A
H1946:	MOV	A,E
	RAL
	MOV	E,A
	MOV	A,D
	RAL
	MOV	D,A
	DCR	M
	POP	H
	RZ
	MVI	A,00H
	ACI	00H
	DAD	H
	MOV	B,H
	ADD	L
	LHLD	H196B
	SUB	L
	MOV	C,A
	MOV	A,B
	SBB	H
	MOV	B,A
	PUSH	B
	JNC	H1964
	DAD	B
	XTHL
H1964:	LXI	H,H196D
	CMC
	JMP	H1946
H196B:	NOP
	NOP
H196D:	NOP
H196E:	MOV	B,H
	MOV	C,L
	LXI	H,0000H
H1973:	XRA	A
	MOV	A,B
	RAR
	MOV	B,A
	MOV	A,C
	RAR
	MOV	C,A
	JC	H1982
	ORA	B
	RZ
	JMP	H1983
H1982:	DAD	D
H1983:	XCHG
	DAD	H
	XCHG
	JMP	H1973
H1989:	CALL	H18EC
	CALL	H196E
	JMP	H1A01
H1992:	CALL	H1935
	XCHG
	JMP	H1A01
H1999:	CALL	H1935
	JMP	H1A01
H199F:	CALL	H191B
H19A2:	ORA	A
	JZ	H1A01
	DAD	H
	DCR	A
	JMP	H19A2
H19AB:	CALL	H191B
H19AE:	ORA	A
	JZ	H1A01
	PUSH	PSW
	XRA	A
	MOV	A,H
	RAR
	MOV	H,A
	MOV	A,L
	RAR
	MOV	L,A
	POP	PSW
	DCR	A
	JMP	H19AE
H19BF:	CALL	H18EC
H19C2:	DAD	D
	JMP	H1A01
H19C6:	CALL	H18EC
	XCHG
	CALL	H192D
	JMP	H19C2
H19D0:	CALL	H18CF
H19D3:	CALL	H192D
	JMP	H1A01
H19D9:	CALL	H18CF
	INX	H
	JMP	H19D3
H19E0:	CALL	H18EC
	MOV	A,D
	ANA	H
	MOV	H,A
	MOV	A,E
	ANA	L
	MOV	L,A
	JMP	H1A01
H19EC:	CALL	H18EC
	MOV	A,D
	ORA	H
	MOV	H,A
	MOV	A,E
	ORA	L
	MOV	L,A
	JMP	H1A01
H19F8:	CALL	H18EC
	MOV	A,D
	XRA	H
	MOV	H,A
	MOV	A,E
	XRA	L
	MOV	L,A
H1A01:	JMP	H1893
H1A04:	LDA	H0185
	CPI	04H
	RNZ
	LDA	H0189
	CPI	0DH
	RZ
	CPI	3BH
	RZ
	CPI	2CH
	RZ
	CPI	21H
	RET
H1A19:	XRA	A
	STA	H1891
	STA	H1892
	DCR	A
	STA	H186C
	LXI	H,0000H
	SHLD	H01C9
H1A2A:	CALL	H1A04
	JNZ	H1A5D
H1A30:	LXI	H,H1891
	MOV	A,M
	ORA	A
	JZ	H1A48
	DCR	M
	MOV	E,A
	DCR	E
	MVI	D,00H
	LXI	H,H186D
	DAD	D
	MOV	A,M
	CALL	H18F4		; Call subroutine from table
	JMP	H1A30
H1A48:	LDA	H1892
	CPI	02H
	CNZ	H1B85		; Call 'E' error
	LDA	H010C
	CPI	20H
	RNZ
	LHLD	H1881
	SHLD	H01C9
	RET
H1A5D:	LDA	H010C
	CPI	20H
	JNZ	H1B7F
	LDA	H0185		; Char type
	CPI	03H
	JNZ	H1A89
	LDA	H0188
	ORA	A
	CZ	H1B85
	CPI	03H
	CNC	H1B85
	MVI	D,00H
	LXI	H,H0189
	MOV	E,M
	INX	H
	DCR	A
	JZ	H1A85
	MOV	D,M
H1A85:	XCHG
	JMP	H1B71
H1A89:	CPI	02H		; Char type = numeric
	JNZ	H1A94
	LHLD	H0186		; Numeric value
	JMP	H1B71

; non-alphanumeric chars encountered in label being evaluated come here to
; evaluate possible expression (math)

H1A94:	CALL	H15A6		; Scan for match. if match then ACC=parm1 B=parm
	JNZ	H1B31		; Taken if no match
	CPI	10H
	JNC	H1B26
	CPI	0CH
	MOV	C,A
	LDA	H186C
	JNZ	H1AB5
	ORA	A
	CZ	H1B85		; 'E' error
	MVI	A,0FFH
	STA	H186C
	MOV	A,C
	JMP	H1B03
H1AB5:	ORA	A
	JNZ	H1B0E
H1AB9:	PUSH	B
	LDA	H1891
	ORA	A
	JZ	H1ADE
	MOV	E,A
	DCR	E
	MVI	D,00H
	LXI	H,H1877
	DAD	D
	MOV	A,M
	CMP	B
	JC	H1ADE
	LXI	H,H1891
	MOV	M,E
	LXI	H,H186D
	DAD	D
	MOV	A,M
	CALL	H18F4		; Call subroutine from table
	POP	B
	JMP	H1AB9
H1ADE:	POP	B
	MOV	A,C
	CPI	0DH
	JNZ	H1B03
	LXI	H,H1891
	MOV	A,M
	ORA	A
	JZ	H1AFC
	DCR	A
	MOV	M,A
	MOV	E,A
	MVI	D,00H
	LXI	H,H186D
	DAD	D
	MOV	A,M
	CPI	0CH
	JZ	H1AFF
H1AFC:	CALL	H1B85
H1AFF:	XRA	A
	JMP	H1B08
H1B03:	CALL	H18B0
	MVI	A,0FFH
H1B08:	STA	H186C
	JMP	H1B7F
H1B0E:	MOV	A,C		; Parm1
	CPI	05H
	JZ	H1B7F
	CPI	06H
	JNZ	H1B1E
	INR	A		; F(-)
	MOV	C,A
	JMP	H1AB9
H1B1E:	CPI	08H		; F(NOT) = 8
	CNZ	H1B85
	JMP	H1AB9
H1B26:	CPI	11H
	CZ	H1B85
	MOV	L,B
	MVI	H,00H
	JMP	H1B71
H1B31:	LDA	H0185
	CPI	04H
	JNZ	H1B50
	LDA	H0189
	CPI	24H		; '$'
	JZ	H1B4A
	CALL	H1B85
	LXI	H,0000H
	JMP	H1B71
H1B4A:	LHLD	H01D2
	JMP	H1B71
H1B50:	CALL	H1346		; Check for duplicate label
	CALL	H1349		; Test results
	JNZ	H1B64		; Taken if no duplicate
	MVI	A,50H		; 'P'
	CALL	H0218		; Error
	CALL	H134C		; Add symbol
	JMP	H1B6E
H1B64:	CALL	H1352		; Test nibble
	ANI	07H
	MVI	A,55H		; 'U'
	CZ	H0218		; Error
H1B6E:	CALL	H1358		; Get symbol value into HL
H1B71:	LDA	H186C
	ORA	A
	CZ	H1B85
	XRA	A
	STA	H186C
	CALL	H1893
H1B7F:	CALL	H1106		; F(+)
	JMP	H1A2A
H1B85:	PUSH	H		; 'E' error
	MVI	A,45H
	CALL	H0218
	POP	H
	RET
H1B8D:	CALL	H1352
	ORA	A
	JZ	H1DB5
	RET
	DB	0,0,0,0,0,0,0,0,0,0,0
H1BA0:	XRA	A		; Entry to assembler with PRN and HEX files open
	STA	H01CF		; Reset pass count to 0
	CALL	H1343		; Clear buffer

; 2nd pass loops here

H1BA7:	CALL	H1103		; New line (send CR/LF to PRN file)
	CALL	H0203		; Open ASM file
	LXI	H,0000H
	SHLD	H20EB
	SHLD	H01D0
	SHLD	H01D2
	SHLD	H20ED
H1BBC:	CALL	H1106		; Parse word into H0189 and H010C buffers and
H1BBF:	LDA	H0185		; Set char type in H0185
	CPI	02H
	JZ	H1BBC		; Handle digit
	CPI	04H
	JNZ	H1BDD
	LDA	H0189
	CPI	2AH		; '*'
	JNZ	H1F31
	CALL	H2000
	JNZ	H1F7C		; 'S' error
	JMP	H1F52
H1BDD:	CPI	01H
	JNZ	H1F7C		; Not alpha
	CALL	H15A6		; Check word for match
	JZ	H1C30
	CALL	H1346		; Check for duplicate label
	CALL	H1349		; Test results
	JNZ	H1BFE		; If no duplicate
	CALL	H134C		; Add symbol to table
	LDA	H01CF		; Assembler pass#
	ORA	A
	CNZ	H20D7		; 'P' error if duplicate symbol on 1st pass
	JMP	H1C0C
H1BFE:	CALL	H1352		; Get symbol assignment nibble
	CPI	06H
	JNZ	H1C0C		; If label assigned value
	CALL	H20E3		; 'N' error
	JMP	H1F52
H1C0C:	LHLD	H20EB
	MOV	A,L
	ORA	H
	CNZ	H20DD		; 'L' error
	LHLD	H01D6
	SHLD	H20EB
	CALL	H1106
	LDA	H0185
	CPI	04H
	JNZ	H1BBF
	LDA	H0189
	CPI	3AH
	JNZ	H1BBF
	JMP	H1BBC
H1C30:	CPI	11H
	JNZ	H1DD7
	MOV	E,B
	MVI	D,00H
	DCX	D
	LXI	H,H1C43
	DAD	D
	DAD	D
	MOV	E,M
	INX	H
	MOV	H,M
	MOV	L,E
	PCHL

;table for parm1 = 11h. parm2 referenced in ()

H1C43:	DW	H1C5B		; (01h) DB
	DW	H1CA9		; (02h) DS
	DW	H1CC0		; (03h) DW
	DW	H1CDE		; (04h) END
	DW	H1D15		; (05h) ENDIF
	DW	H1D18		; (06h) ENDM (function not supported. gives 'N' error)
	DW	H1D1E		; (07h) EQU
	DW	H1D40		; (08h) IF
	DW	H1D87		; (09h) MACRO (function not supported. gives 'N' error)
	DW	H1D8D		; (0Ah) ORG
	DW	H1DA7		; (0Bh) SET
	DW	H1DCE		; (0Ch) TITLE
H1C5B:	CALL	H200A
H1C5E:	CALL	H1106
	LDA	H0185
	CPI	03H
	JNZ	H1C8C
	LDA	H0188
	DCR	A
	JZ	H1C8C
	MOV	B,A
	INR	B
	INR	B
	LXI	H,H0189
H1C76:	DCR	B
	JZ	H1C86
	PUSH	B
	MOV	B,M
	INX	H
	PUSH	H
	CALL	H2048
	POP	H
	POP	B
	JMP	H1C76
H1C86:	CALL	H1106
	JMP	H1C9B
H1C8C:	CALL	H1863
	LHLD	H01C9
	MOV	A,H
	ORA	A
	CNZ	H20D1		; 'D' error if DB label not 8-bit value
	MOV	B,L
	CALL	H2048
H1C9B:	CALL	H1FF9
	CALL	H1EBA
	CPI	2CH
	JZ	H1C5E
	JMP	H1F31
H1CA9:	CALL	H200A		; F(DS)
	CALL	H20A6
	CALL	H1ED1		; Get 16 bit value/address into HL
	XCHG
	LHLD	H01D2
	DAD	D
	SHLD	H01D2
	SHLD	H01D0		; Address PC counter
	JMP	H1F31
H1CC0:	CALL	H200A		; F(DW)
H1CC3:	CALL	H1ED1
	PUSH	H
	MOV	B,L
	CALL	H2048
	POP	H
	MOV	B,H
	CALL	H2048
	CALL	H1FF9
	CALL	H1EBA
	CPI	2CH
	JZ	H1CC3
	JMP	H1F31
H1CDE:	CALL	H200A		; F(END)
	CALL	H20A6		; Print final PRN line addr to buffer
	LDA	H010C
	CPI	20H
	JNZ	H1F31
	CALL	H1ED1		; Get addr to HL of symbol following END (if any
	LDA	H010C		; END w/o symbol gives 'E' error (both passes)
	CPI	20H
	JNZ	H1CFA
	SHLD	H20ED		; Value of symbol after END. possibly EOF addr?
H1CFA:	MVI	A,20H
	STA	H010C
	CALL	H1106
	LDA	H0185
	CPI	04H
	JNZ	H1F7C
	LDA	H0189
	CPI	0AH
	JNZ	H1F7C
	JMP	H1F8B
H1D15:	JMP	H1DD1		; F(ENDIF)
H1D18:	CALL	H20E3		; F(ENDM) gives 'N' error (not supported)
	JMP	H1DD1
H1D1E:	CALL	H2000		; F(EQU)
	JZ	H1F7C
	LHLD	H01D2
	PUSH	H
	CALL	H1ED1
	SHLD	H01D2
	CALL	H200A
	CALL	H20A9
	LXI	H,H0112
	MVI	M,3DH
	POP	H
	SHLD	H01D2
	JMP	H1F31
H1D40:	CALL	H200A		; F(IF)
	CALL	H1ED1
	LDA	H010C
	CPI	20H
	JNZ	H1F31
	MOV	A,L
	RAR
	JC	H1F31
H1D53:	CALL	H1106
	LDA	H0185
	CPI	04H
	JNZ	H1D6E
	LDA	H0189
	CPI	1AH
	MVI	A,42H
	CZ	H0218
	JZ	H1F8B
	JMP	H1D53
H1D6E:	CPI	01H
	JNZ	H1D53
	CALL	H15A6
	JNZ	H1D53
	CPI	11H
	JNZ	H1D53
	MOV	A,B
	CPI	05H
	JNZ	H1D53
	JMP	H1DD1
H1D87:	CALL	H20E3		; F(MACRO) gives 'N' error (not supported)
	JMP	H1F31
H1D8D:	CALL	H1ED1		; F(ORG)
	LDA	H010C
	CPI	20H
	JNZ	H1F31
	SHLD	H01D2		; ORG address for PC counters
	SHLD	H01D0
	CALL	H200A
	CALL	H20A6
	JMP	H1F31
H1DA7:	CALL	H2000		; F(SET)
	JZ	H1F7C
	CALL	H1B8D
	CPI	05H
	CNZ	H20DD
H1DB5:	MVI	A,05H
	CALL	H134F
	CALL	H1ED1
	PUSH	H
	CALL	H2000
	POP	H
	CALL	H1355
	LXI	H,0000H
	SHLD	H20EB
	JMP	H1F31
H1DCE:	CALL	H20E3
H1DD1:	CALL	H1106
	JMP	H1F31
H1DD7:	SUI	13H		; ACC = parm1 value from H15A6 call
	CPI	21H		; Bug here. should have been 0Fh
	JNC	H1F7C		; Taken for parm1<13h or >=34h (should be >=22h)
	MOV	E,A		; See table following. range only 13h to 21h
	MVI	D,00H
	LXI	H,H1DEB
	DAD	D
	DAD	D
	MOV	E,M
	INX	H
	MOV	H,M
	MOV	L,E
	PCHL

;table for parm1 = 13h to 21h. parm1 value in ()

H1DEB:	DW	H1E09		; (13h) DI EI CMA CMC DAA HLT NOP RAL RAR RET RLC RRC ST
				;      PCHL SPHL XTHL XCHG
	DW	H1E12		; (14h) LXI
	DW	H1E1E		; (15h) DAD
	DW	H1E24		; (16h) POP PUSH
	DW	H1E38		; (17h) JMP CALL
	DW	H1E41		; (18h) MOV
	DW	H1E50		; (19h) MVI
	DW	H1E60		; (1Ah) ACI ADI ANI CPI ORI XRI SUI SBI
	DW	H1E69		; (1Bh) LDAX STAX
	DW	H1E78		; (1Ch) LDA STA LHLD SHLD
	DW	H1E81		; (1Dh) ADC ADD ANA CMP ORA XRA SUB SBB
	DW	H1E88		; (1Eh) DCR INR
	DW	H1E8F		; (1Fh) DCX INX
	DW	H1E9E		; (20h) RST
	DW	H1EA5		; (21h) IN OUT
H1E09:	CALL	H2048
	CALL	H1106
	JMP	H1EB1
H1E12:	CALL	H1EFC		; Process reg char following LXI instruction
	CALL	H1F17		; Check for comma
	CALL	H1F11
	JMP	H1EB1
H1E1E:	CALL	H1EFC		; Process reg char following DAD instruction
	JMP	H1EB1
H1E24:	CALL	H1EF2
	CPI	38H
	JZ	H1E31
	ANI	08H
	CNZ	H20BD
H1E31:	MOV	A,C
	ANI	30H
	ORA	B
	JMP	H1EAE
H1E38:	CALL	H2048
	CALL	H1F11
	JMP	H1EB1
H1E41:	CALL	H1EF2		; F(MOV)
	ORA	B
	MOV	B,A
	CALL	H1F17
	CALL	H1EE7		; Parse reg value
	ORA	B
	JMP	H1EAE
H1E50:	CALL	H1EF2		; Get reg mask following MVI instruction
	ORA	B
	CALL	H2047		; Store opcode
	CALL	H1F17		; Check for comma
	CALL	H1F0B		; Parse and store 8 bit label/value after comma
	JMP	H1EB1
H1E60:	CALL	H2048		; Store opcode in HEX file
	CALL	H1F0B		; Parse operand
	JMP	H1EB1
H1E69:	CALL	H1EF2
	ANI	28H
	CNZ	H20BD
	MOV	A,C
	ANI	10H
	ORA	B
	JMP	H1EAE
H1E78:	CALL	H2048
	CALL	H1F11
	JMP	H1EB1
H1E81:	CALL	H1EE7
	ORA	B
	JMP	H1EAE
H1E88:	CALL	H1EF2
	ORA	B
	JMP	H1EAE
H1E8F:	CALL	H1EF2
	ANI	08H
	CNZ	H20BD
	MOV	A,C
	ANI	30H
	ORA	B
	JMP	H1EAE
H1E9E:	CALL	H1EF2
	ORA	B
	JMP	H1EAE
H1EA5:	CALL	H2048
	CALL	H1F0B
	JMP	H1EB1
H1EAE:	CALL	H2047
H1EB1:	CALL	H200A		; Each instruction line comes here to close
	CALL	H1FF9		; Update PRN file PC counter (H01D2) for next line
	JMP	H1F31
H1EBA:	LDA	H0185
	CPI	04H
	CNZ	H20D1
	LDA	H0189
	CPI	2CH
	RZ
	CPI	3BH
	RZ
	CPI	0DH
	CNZ	H20D1
	RET
H1ED1:	PUSH	B		; Get 16 bit reg value or label address into HL reg.
	CALL	H1106		; Parse word
	CALL	H1863		; Process word
	LHLD	H01C9		; Holds value (example: C reg value = 0001)
	POP	B
	RET
H1EDD:	CALL	H1ED1		; Get 8 bit reg value or label address into ACC reg.
	MOV	A,H
	ORA	A
	CNZ	H20C7
	MOV	A,L
	RET
H1EE7:	CALL	H1EDD		; Parse 8 bit reg char value into ACC (0 to 7 = ACC to M
	CPI	08H
	CNC	H20C7		; 'V' error (bad register designation)
	ANI	07H
	RET
H1EF2:	CALL	H1EE7		; Get 8 bit reg char value (0-7) into bits 3,4,5 of ACC
	RAL
	RAL
	RAL
	ANI	38H
	MOV	C,A
	RET
H1EFC:	CALL	H1EF2		; Store 16 bit regs (even# B,D or H) ORA'd with B(=parm2
	ANI	08H		; Bit 3 set if odd# reg (ACC,C,E or L)
	CNZ	H20BD		; 'R' error
	MOV	A,C
	ANI	30H
	ORA	B
	JMP	H2047
H1F0B:	CALL	H1EDD		; Parse and store 8 bit label/address (operand)
	JMP	H2047
H1F11:	CALL	H1ED1		; Parse and store 16 bit label/address (operand)
	JMP	H2074
H1F17:	PUSH	PSW		; Check for comma
	PUSH	B
	LDA	H0185
	CPI	04H
	JNZ	H1F29
	LDA	H0189
	CPI	2CH
	JZ	H1F2E
H1F29:	MVI	A,43H
	CALL	H0218
H1F2E:	POP	B
	POP	PSW
	RET
H1F31:	CALL	H200A
	LDA	H0185
	CPI	04H
	JNZ	H1F7C
	LDA	H0189
	CPI	0DH
	JNZ	H1F4A
	CALL	H1106
	JMP	H1BBC
H1F4A:	CPI	3BH		; ';'
	JNZ	H1F72
	CALL	H200A
H1F52:	CALL	H1106
	LDA	H0185
	CPI	04H
	JNZ	H1F52
	LDA	H0189
	CPI	0AH
	JZ	H1BBC
	CPI	1AH
	JZ	H1F8B
	CPI	21H
	JZ	H1BBC
	JMP	H1F52
H1F72:  CPI     21H
	JZ	H1BBC
	CPI	1AH
	JZ	H1F8B
H1F7C:	MVI	A,53H
	CALL	H0218
	JMP	H1F52
H1F84:	MOV	A,E		; HL=DE-HL
	SUB	L
	MOV	L,A
	MOV	A,D
	SBB	H
	MOV	H,A
	RET
H1F8B:	LXI	H,H01CF		; Assembler pass count
	MOV	A,M
	INR	M		; Increment 1st to 2nd pass
	ORA	A
	JZ	H1BA7		; If 2nd pass
	CALL	H1106		; Here after 2nd pass
	CALL	H20A6
	LXI	H,H0111
	MVI	M,0DH
	LXI	H,H010D
	CALL	H0212
	LHLD	H01CB
	XCHG
	LHLD	H01D4
	CALL	H1F84
	PUSH	H
	LHLD	H01CD
	XCHG
	LHLD	H01D4
	CALL	H1F84
	MOV	E,H
	MVI	D,00H
	POP	H
	CALL	H1869
	XCHG
	CALL	H20A9		; Put HL in PRN buffer just before 'USE FACTOR'
	LXI	H,H0111
	LXI	D,H1FD6
H1FCB:	LDAX	D		; Put 'USE FACTOR' in PRN buffer
	ORA	A
	JZ	H1FE4
	MOV	M,A
	INX	H
	INX	D
	JMP	H1FCB
H1FD6:	DB	'H USE FACTOR'
	DB	0DH,00H
H1FE4:	LXI	H,H010E
	CALL	H0212
	LHLD	H20ED
	SHLD	H01D0
	JMP	H021E		; Go close files and exit
H1FF3:	MOV	A,D
	CMP	H
	RNZ
	MOV	A,E
	CMP	L
	RET
H1FF9:	LHLD	H01D0
	SHLD	H01D2
	RET
H2000:	LHLD	H20EB		; Test H20EB for 0. move to H01D6 and ret in HL
	SHLD	H01D6
	CALL	H1349
	RET

; on 1st pass if H20EB non-zero then set PC counter to value of symbol operand
; at (H20EB). clear up unevaluated label, if any. on 2nd pass make sure label
; value is set and matches current PC else 'P' phase error

H200A:	CALL	H2000
	RZ
	LXI	H,0000H
	SHLD	H20EB
	LDA	H01CF		; Pass count
	ORA	A
	JNZ	H2031		; If 2nd pass
	CALL	H1352		; Test nibble (see H134F notes)
	PUSH	PSW
	ANI	07H
	CNZ	H20DD		; 'L' error
	POP	PSW
	ORI	01H
	CALL	H134F		; Set nibble flag
	LHLD	H01D2
	CALL	H1355		; Set value of symbol to HL
	RET
H2031:	CALL	H1352		; Test nibble
	ANI	07H
	CZ	H20D7		; 'P' error
	CALL	H1358		; Get symbol value
	XCHG
	LHLD	H01D2
	CALL	H1FF3
	CNZ	H20D7
	RET

;on 2nd pass store byte from ACC in hex ascii form to H010C PRN line buffer
;and HEX file. also write PC address in hex ascii if at beginning of line.

H2047:	MOV	B,A
H2048:	LDA	H01CF		; Store byte in B reg
	ORA	A		; Pass count
	MOV	A,B
	JZ	H206C		; If 1st pass, only advance PC counter
	PUSH	B
	CALL	H021B		; Write byte to HEX file
	LDA	H010D
	CPI	20H
	LHLD	H01D2		; PC counter of PRN line
	CZ	H20A9		; Print PC at start of PRN line (if no error)
	LDA	H20EF		; PRN file line index
	CPI	10H		; 10h = start of label field
	POP	B
	JNC	H206C
	MOV	A,B
	CALL	H2096		; Print byte in hex to PRN file
H206C:	LHLD	H01D0		; Advance PC counter
	INX	H
	SHLD	H01D0
	RET
H2074:	PUSH	H		; Write HL to PRN buffer and HEX file
	MOV	B,L
	CALL	H2048
	POP	H
	MOV	B,H
	JMP	H2048
H207E:	ADI	30H
	CPI	3AH
	RC
	ADI	07H
	RET
H2086:	CALL	H207E
	LXI	H,H20EF
	MOV	E,M
	MVI	D,00H
	INR	M
	LXI	H,H010C
	DAD	D
	MOV	M,A
	RET
H2096:	PUSH	PSW		; Print byte to PRN buffer
	RAR
	RAR
	RAR
	RAR
	ANI	0FH
	CALL	H2086
	POP	PSW
	ANI	0FH
	JMP	H2086
H20A6:	LHLD	H01D2		; Print PC addr in ascii to PRN buffer
H20A9:	XCHG
	LXI	H,H20EF
	PUSH	H
	MVI	M,01H
	MOV	A,D
	PUSH	D
	CALL	H2096
	POP	D
	MOV	A,E
	CALL	H2096
	POP	H
	INR	M
	RET
H20BD:	PUSH	PSW		; 'R' error
	PUSH	B
	MVI	A,52H
	CALL	H0218
	POP	B
	POP	PSW
	RET
H20C7:	PUSH	PSW		; 'V' error
	PUSH	H
	MVI	A,56H
	CALL	H0218
	POP	H
	POP	PSW
	RET
H20D1:	PUSH	PSW		; 'D' error
	MVI	A,44H
	JMP	H20E6
H20D7:	PUSH	PSW		; 'P' error
	MVI	A,50H
	JMP	H20E6
H20DD:	PUSH	PSW		; 'L' error
	MVI	A,4CH
	JMP	H20E6
H20E3:	PUSH	PSW		; 'N' error
	MVI	A,4EH
H20E6:	CALL	H0218
	POP	PSW
	RET
H20EB:	DS	02H		; Last H01D6 value from H1346 call
H20ED:	DS	02H		; EOF addr after 'END' (value of symbol)
H20EF:	DS	1		; Char index into H010C PRN line buffer
H20F0:	DS	1		; Label table begins here
	END
