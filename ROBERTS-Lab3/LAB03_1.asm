;	Main program to test the subroutine GETS
;	This program simply prompts for two strings and
;	displays them back using PUTS
; -------------------------------------------------------------------------

.ORIG	x3000

;	Set up the user stack:
	LD	R6, STKBASE	

;	Prompt for the first string:
	LEA	R0, PRMPT1
	PUTS

;	Call GETS to get first string:
	LEA	R0, STRNG1
	ADD	R6, R6, #-1	
	STR	R0, R6, #0		; Push the address to store the string at (@ xFDFE)
	AND 	R5, R5, #0
	ADD 	R5, R6, #0		; Set frame pointer 
	JSR	GETS			; Call GETS
	ADD	R6, R6, #2		; Clean up (pop parameter & return value)


;	Output both strings:
	LEA	R0, OUT1		; First string...
	PUTS
	LEA	R0, STRNG1
	PUTS
	
	HALT

;	GLOBAL VARIABLES
;	----------------
STKBASE	.FILL		xFDFF		; The bottom of the stack will be xFDFF
LF	.FILL		#-10		; A linefeed character
STRNG1	.BLKW		#80		; Room for 79 characters (unpacked) + NULL
PRMPT1	.STRINGZ	"Please enter a string to echo: "
OUT1	.STRINGZ	"Your string: "

GETS

	ADD	R6, R6, #-1
	STR 	R1, R6, #0		; Push R1 @ xFDFD

	ADD 	R6, R6, #-1
	STR 	R2, R6, #0		; Push R2 @ xFDFC

	ADD 	R6, R6, #-1
	STR 	R3, R6, #0		; Push R3 @ xFDFB

	ADD 	R6, R6, #-1
	STR 	R4, R6, #0		; Push R4 @ xFDFA

	ADD 	R6, R6, #-1
	STR 	R5, R6, #0		; Push R5 (FP) @ xFDF9

	ADD 	R6, R6, #-1
	STR 	R7, R6, #0		; Push R7 (RET) @ xFDF8

	AND 	R2, R2, #0
	ADD 	R2, R2, R0		; R2 will now hold location to write string to

	ADD 	R5, R6, #-1		; Set new frame pointer

LOOP

	GETC				; Get a character
	OUT			 	; Print that character

	LD 	R1, LF			; Load sentinal value (x0A)
	ADD 	R1, R1, R0		; Compare character with sentinal

	BRz 	END_LOOP		; If equal, end loop

	STR 	R0, R2, #0		; Else, store character
	ADD 	R2, R2, #1		

	BRnzp 	LOOP			; Continue getting input

END_LOOP

	LDR 	R7, R6, #0
	ADD 	R6, R6, #1		; Pop R7 from xFDF8

	LDR 	R5, R6, #0
	ADD 	R6, R6, #1		; Pop R5 from xFDF9

	LDR 	R4, R6, #0
	ADD 	R6, R6, #1 		; Pop R4 from xFDFA

	LDR 	R3, R6, #0
	ADD 	R6, R6, #1 		; Pop R3 from xFDFB

	LDR 	R2, R6, #0
	ADD 	R6, R6, #1		; Pop R2 from xFDFC

	LDR 	R1, R5, #-1		; Load R1 from xFDFD

	LDR 	R0, R5, #0		; Load R0 from xFDFE (once again holds pointer to str)


	RET

.END