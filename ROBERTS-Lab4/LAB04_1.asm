;	EC1
;	EC2 

.ORIG x4000
	
	STI 	R6, STACK_R6
	LD	 R6, STACK			; Set SP	

	STR 	R0, R6, #0			; Push R0
		
	ADD 	R6, R6, #-1
	STR 	R1, R6, #0			; Push R1			

	ADD 	R6, R6, #-1
	STR 	R2, R6, #0			; Push R2			

	ADD 	R6, R6, #-1		
	STR 	R3, R6, #0			 ; Push R3	

	ADD 	R6, R6, #-1		
	STR 	R4, R6, #0			; Push R4	

	ADD 	R6, R6, #-1		
	STR 	R5, R6, #0			; Push R5	

	ADD 	R6, R6, #-2		
	STR 	R7, R6, #0			; Push R7	
	
	LEA 	R0, PROMPT
	PUTS					; Print prompt

	LD 	R1, CHARACTER_COUNT		; Load character counter

CHAR_GET

	GETC
	OUT
	
	LD 	R2, X_VAL			; x sentinel value
	NOT 	R2, R2
	ADD 	R2, R2, #1			; Two's complement for comparisons

	ADD 	R2, R2, R0
	BRz 	X_DETECTED			; Compare and jump if character is 'x'
	
	LD 	R2, ALPHA_VAL			; Lower alphabet sentinel value	
	NOT 	R2, R2
	ADD 	R2, R2, #1	

	ADD	R6, R6, #-1
	STR	R2, R6, #0
	
	ADD	R2, R2, R0
	ADD	R2, R2, #-5
	BRp 	INVALID_INPUT			; Branch if input > x66

	LDR 	R2, R6, #0 
	ADD	R6, R6, #1
	
	ADD 	R2, R2, R0
	BRzp	ALPHA_DETECTED
		
	ADD 	R2, R2, #-16	
	ADD	R2, R2, #-16			; Update to uppercase sentinel

	ADD	R6, R6, #-1
	STR	R2, R6, #0
	
	ADD	R2, R2, R0
	ADD	R2, R2, #-5
	BRp 	INVALID_INPUT			; Branch if input > x46

	LDR 	R2, R6, #0 
	ADD	R6, R6, #1

	ADD 	R2, R2, R0
	BRzp 	ALPHA_DETECTED			; branch if uppercase letter detected
	
	LD 	R2,	 NUMERIC_VAL		; Number sentinel value	
	NOT 	R2, R2
	ADD 	R2, R2, #1

	ADD	R6, R6, #-1
	STR	R2, R6, #0
	
	ADD	R2, R2, R0
	ADD	R2, R2, #-9
	BRp 	INVALID_INPUT			; Branch if input > x39

	LDR 	R2, R6, #0 
	ADD	R6, R6, #1

	ADD 	R2, R2, R0
	BRzp 	NUMERIC_DETECTED		; branch if number detected

	BRnzp 	CHAR_FINISHED	
	
ALPHA_DETECTED

	ADD 	R2, R2, #10			; Obtain one-digit hex value

	ADD 	R3, R1, #-1			; Decrement character count
	
	BRz 	CHAR_FINISHED			; Branch if counter = 0
	
	ADD 	R3, R3, #-1			; Decrement counter
	
	BRnzp 	BITSHIFT

NUMERIC_DETECTED

	ADD 	R3, R1, #-1			; R3 = R1 - 1

	BRz 	CHAR_FINISHED			; Branch if counter = 0

	ADD 	R3, R3, #-1			; Decrement counter

BITSHIFT
	ADD 	R2, R2, R2
	ADD 	R2, R2, R2
	ADD 	R2, R2, R2
	ADD 	R2, R2, R2			; Bit shift

	ADD 	R3, R3, #-1			; Decrement counter

	BRzp	BITSHIFT			; Shift until counter <= 0 
	BRnzp	CHAR_FINISHED			; Branch if counter = 0

X_DETECTED
CHAR_FINISHED

	ADD 	R4, R2, R4			; Add bit-shifted character to accumulator

	ADD	R1, R1, #-1			; Decrement character count
	BRp 	CHAR_GET			; Loop back if we still need another character

	LD	R0, NEWLINE_VAL
	OUT					; Print newline

	AND	R0, R0, #0
	ADD 	R0, R0, R4			; Put R4 into R0	
	
	LDR 	R7, R6, #0
	ADD 	R6, R6, #2			; Pop R7

	LDR 	R5, R6, #0
	ADD 	R6, R6, #1			; Pop R5

	LDR 	R4, R6, #0
	ADD 	R6, R6, #1			; Pop R4

	LDR 	R3, R6, #0
	ADD 	R6, R6, #1			; Pop R3

	LDR 	R2, R6, #0
	ADD 	R6, R6, #1			; Pop R2

	LDR 	R1, R6, #0
	ADD 	R6, R6, #1			; Pop R1

	LDI	R6, STACK_R6

	RET

INVALID_INPUT
	
	LEA	R0, INVALID_CHAR
	PUTS
	
	HALT
	
;===================================

; GLOBAL VARIABLES	

	STACK_R6	.FILL x4700
	STACK		.FILL x46FA
	CHARACTER_COUNT	.FILL #5
	PROMPT		.STRINGZ "Enter your address: \n"

	X_VAL		.FILL x0078
	ALPHA_VAL	.FILL x0061
	NUMERIC_VAL	.FILL x0030
	NEWLINE_VAL	.FILL x000A
	INVALID_CHAR	.STRINGZ "\nInvalid input!"


;===================================

	.END