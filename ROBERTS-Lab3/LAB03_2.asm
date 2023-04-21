	.ORIG	x3000

	LD	R6, STKBASE	; Set up user stack

	LEA R0, PRMPT1
	PUTS			; Prompt for the first string

	LEA R0, STRNG1
	ADD	R6, R6, #-1	; Push the address to store the string at
	STR	R0, R6, #0
	AND R5, R5, #0
	ADD R5, R6, #0		; set main's frame pointer
	JSR	GETSP		; Call GETSP
	ADD	R6, R6, #2	; Clean up (pop parameter & return value)


;	Output both strings:
	LEA	R0, OUT1	; First string...
	PUTS
	LEA	R0, STRNG1

	PUTSP

	HALT

STKBASE	.FILL		xFDFF		; The bottom of the stack will be xFDFF
LF	.FILL		#-10		; Linefeed sentinel
PRMPT1	.STRINGZ	"Please enter a string to pack: "
OUT1	.STRINGZ	"Your string was: "
STRNG1	.BLKW		#80		; Room for 158 characters (packed) + NULL
CLL	.FILL		xFF00		; Clear lower
CLU	.FILL		x00FF		; Clear upper



GETSP	

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
	ADD     R2, R0, #0		; R2 now holds string storage location

	ADD R5, R6, #-1			; Set new frame pointer

INPUT_LOOP
	
	GETC				; Get a character
	OUT				; Print that character
	
	AND R4, R4, #0			
	ADD R4, R0, #0			; Store first character

	LD R1, LF
	ADD R1, R1, R0			; check for sentinel

	BRz END_INPUT			; if equals sentinel, end
	
	LD R1, CLU
	AND R4, R4, R1
	STR R4, R2, #0			; Store R4	

	GETC
	OUT
	
	AND R3, R3, #0			
	ADD R3, R0, #0			; Store second character

	LD R1, LF
	ADD R1, R1, R0			; check for sentinel

	BRz END_INPUT			; if equals sentinel, end
	
	AND R0, R0, #0			
	ADD R0, R0, #8			; R0 = 8 (counter)
	LD R1 CLU
	AND R3, R3, R1			; CLU

BIT_SHIFT_LOOP
	
	ADD R3, R3, R3			; R3 += R3
	ADD R0, R0, #-1
	BRp BIT_SHIFT_LOOP		; continue looping if counter > 0

	LD R1, CLL
	AND R3, R3, R1			; CLL
	ADD R4, R3, R4			; Pack characters
	STR R4, R2, #0
	ADD R2, R2, #1			; Store and increment
	BRnzp INPUT_LOOP

END_INPUT


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

	LDR	R1, R5, #-1		; Load R1 from xFDFD
	
	LDR 	R0, R5, #0		; Load R0 from xFDFE

	RET

	.END