;/.ASM by John M. Kodis

;CP/M U.G. contrubution November 1980
;
;The "slant" program reads a command line which
;may contain several program invocations.  A $$$.SUB
;file is built with these commands.  This file is
;then executed.
;
;For example, the command line:
;
;/ asm copy; load copy; dir copy*.*; type copy.prn
;
;will build a file containing commands to assemble
;and load the file named 'copy', search the directory
;for all copy programs, and type the COPY.PRN file.
;
;Based on "/.ASM", CPMUG 40.1.  This program was
;written because the abstract for volume 40 states
;that 40.1 works only under CP/M version 1.4,
;and that the source code cannot be provided.  This
;version overcomes both of these difficulties.
;	(Note: 40.1 "1.4 only" meant "not 1.3".
;	 it does work with 2.2 <Ward C.>)
;
;PROCESSOR:	ASM
;DEPENDENCIES:	NONE
;NOTES:		Set "DUP" to true, to define a version
;		which will write "/.SUB" out to disk
;		to facilitate re-executing the same commands.
;		To re-execute them, REN $$$.SUB=/.SUB
;		then ^C.  Alternatively, PIP $$$.SUB=/.SUB
;
;		You might wish to name the version of this
;		program assembled with DUP true, as ".COM
;
;		(but this will "screw up" the Master CATalog
;		 system which reauires its "-name.xxx" to be
;		 the first file found)
;
;	A program for quickie, use once and throw away submits.
;
;	The command syntax is:
;
;	A>/ <command line>[[;<command line>] ... ] <cr>
;
closef	equ	16
delete	equ	19
writef	equ	21
makef	equ	22
dmaf	equ	26
;
boot	equ	  0	;for a warm start
bdos	equ	  5	;cp/m entry point
chcnt	equ	080h	;character count
cibuf	equ	081h	;console input buffer
tpa	equ	100h	;transient program area
;
dup	equ	0
;
	org	tpa
;
slant:	lxi	h,chcnt
	mov	a,l
	add	m
	inr	a
	mov	l,a
	mvi	m,0	;zero the byte after the end of the command line.
;
	lxi	d,cibuf	;de is the source pointer.
	lxi	h,subbuf+1;hl is the destination pointer.
;
nxtcmd:	ldax	d
	cpi	' '
	jnz	xfer	;skip over leading blanks.
	inx	d
	jmp	nxtcmd
;
xfer:	ldax	d
	ana	a	;end of line?
	jz	cmdend
	cpi	';'	;end of command?
	jz	cmdend
	mov	m,a	;if neither, xfer it to the output buffer,
	inx	d
	inx	h	;bump both pointers,
	jmp	xfer	;and try again.
;
cmdend:	mvi	m,0	;zero the byte after the end of the line.
	mov	a,l
	dcr	a
	ani	7fh	;accumulator has character count.
	mov	b,a	;save it.
	mov	a,l
	ani	80h
	mov	l,a	;hl points to the character count byte.
	mov	m,b
;
	ldax	d
	ana	a	;if we've reached the end of the input line...
	jz	fileit	;let's "file it".
	lxi	b,129
	dad	b
	inx	d	;point to the next character in the input.
	jmp	nxtcmd	;loop back for the next command.
;
fileit:	push	h	;save address of last zone
	if	dup
	lxi	d,xfcb
	mvi	c,delete
	call	bdos
	endif
	lxi	d,fcb
	mvi	c,delete
	call	bdos	;delete any existing command files.
;
	if	dup
	lxi	d,xfcb
	mvi	c,makef
	call	bdos
	endif
	lxi	d,fcb
	mvi	c,makef
	call	bdos	;create the new command files.
;
	pop	h
wrloop:	push	h
	xchg
	mvi	c,dmaf
	call	bdos
;
	if	dup
	lxi	d,xfcb
	mvi	c,writef
	call	bdos
	endif
	lxi	d,fcb
	mvi	c,writef
	call	bdos	;write the new commands, one command per
			;disk sector, writing the last command first.
;
	pop	h	;get current dma address
	lxi	d,-128
	dad	d
	lxi	d,subbuf
	mov	a,l
	sub	e
	mov	a,h
	sbb	d
	jnc	wrloop
;
	if	dup
	lxi	d,xfcb
	mvi	c,closef
	call	bdos
	endif
	lxi	d,fcb
	mvi	c,closef
	call	bdos	;close the files after writing the last sector.
;
	rst	boot	;back to cp/m via a warm start.
			;changing this to a "ret" will return
			;to CP/M without the warm start, and so
			;the command file will not be executed
			;until the next boot from this disk.
;
fcb:	db	1, '$$$     SUB'
	dw	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
xfcb:	db	1, '/       SUB'
	dw	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
;
	org	($+0ffh) and 0ff00h
;
subbuf:	ds	0
;
	end	slant
