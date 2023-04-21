.ORIG x3000

	LD	R6, STACK_PTR		; Load stack pointer
	
	ADD 	R6, R6, #-1		; Make room for x

	ADD	R5, R6, #0		; Initialize frame pointer

	ADD	R6, R6, #-1		; Make room for y

	LEA 	R0, PROMPT
	PUTS				; Print user input prompt

	GETC
	OUT

	LD	R2, NUMS_BEGIN		
	NOT 	R2, R2
	ADD	R2, R2, #1		; Load and negate numbers sentinel value	
	
	ADD	R2, R2, R0		; Convert char to decimal value
	BRn 	INVALID_INPUT
	ADD	R2, R2, #-9
	BRp	INVALID_INPUT		; Make sure that value is valid		
	ADD	R2, R2, #9		
	
	STR 	R2, R5, #0		; Store valid user input to x

	ADD 	R6, R6, #-1			
	STR	R2, R6, #0		; Push x for fib

	ADD	R6, R6, #-1		; Make room for return value
	JSR	FIBONACCI		; Call fibonacci
	ADD	R6, R6, #1		; Pop fibonacci input

	LDR	R0, R5, #-3		; Load return value
	STR	R0, R5, #-1		; Store fib output to y				

	LEA	R0, ANSWER_START
	PUTS					

	LDR	R0, R5, #0
	ADD	R6, R6, #-1
	STR	R0, R6, #0		; Push PRINT_DECIMAL_NUM input	

	JSR	PRINT_DECIMAL_NUM	; Call PRINT_DECIMAL_NUM (returns void)

	LEA	R0, ANSWER_MIDDLE
	PUTS

	LDR	R0, R5, #-1
	ADD	R6, R6, #-1
	STR	R0, R6, #0		; Push PRINT_DECIMAL_NUM input	

	JSR	PRINT_DECIMAL_NUM	; Call PRINT_DECIMAL_NUM (returns void)

	STR	R0, R5, #1

	HALT

INVALID_INPUT

	LEA	R0, INVALID_CHAR
	PUTS
	
	HALT

; -----------------------------------------------------
; GLOBAL VARIABLES

PROMPT		.STRINGZ "Please enter a number n: "
ANSWER_START	.STRINGZ "\nF("
ANSWER_MIDDLE	.STRINGZ ") = "
STACK_PTR	.FILL x5013
NUMS_BEGIN 	.FILL x0030
INVALID_CHAR	.STRINGZ "\nInvalid input!"

; -----------------------------------------------------

FIBONACCI

	ADD 	R6, R6, #-1
	STR	R7, R6, #0		; Push R7
	
	ADD 	R6, R6, #-1
	STR	R5, R6, #0		; Push R5

	ADD 	R6, R6, #-1
	STR	R3, R6, #0		; Push R3

	ADD 	R6, R6, #-1
	STR	R2, R6, #0		; Push R2

	ADD 	R6, R6, #-1
	STR	R1, R6, #0		; Push R1

	ADD 	R6, R6, #-1
	STR	R0, R6, #0		; Push R0
	
	
	ADD	R6, R6, #-1		; Making room for local vars
	ADD	R5, R6, #0

	LDR	R0, R5, #8		; Load input value
	STR	R0, R5, #7		; return value = R0 (0)	
	BRz	RETURN

	ADD 	R1, R0, #-1
	STR	R0, R5, #7		; return value = R0 (1)
	BRz  	RETURN		
	
	ADD	R6, R6, #-1	
	STR	R1, R6, #0		; Push x-1

	ADD	R6, R6, #-1
	JSR	FIBONACCI		; Call fibonacci

	LDR	R0, R5, #-2		; Put returned value in R0
	
	ADD	R6, R6, #1		; Pop fibonacci input

	ADD	R1, R1, #-1
	ADD	R6, R6, #-1
	STR	R1, R6, #0		; Push x-2

	ADD	R6, R6, #-1
	JSR 	FIBONACCI		; Call fibonacci
	
	LDR	R2, R5, #-6		; Put returned value in R2

	ADD	R6, R6, #1		; Pop fibonacci input

	ADD	R0, R0, R2		; R0 = R0 + R2

	STR	R0, R5, #7		; Store return value

RETURN	

	ADD	R6, R5, #0

	ADD	R6, R6, #1
	LDR	R0, R6, #0		; Pop R0

	ADD	R6, R6, #1
	LDR	R1, R6, #0		; Pop R1

	ADD	R6, R6, #1
	LDR	R2, R6, #0		; Pop R2

	ADD	R6, R6, #1
	LDR	R3, R6, #0		; Pop R3

	ADD	R6, R6, #1
	LDR	R5, R6, #0		; Pop R5

	ADD	R6, R6, #1
	LDR	R7, R6, #0		; Pop R7

	ADD	R6, R6, #-2		; Pop rest of stack

	RET

PRINT_DECIMAL_NUM

	ADD 	R6, R6, #-1
	STR	R7, R6, #0		; Push R7
	
	ADD 	R6, R6, #-1
	STR	R5, R6, #0		; Push R5

	ADD 	R6, R6, #-1
	STR	R3, R6, #0		; Push R3

	ADD 	R6, R6, #-1
	STR	R2, R6, #0		; Push R2

	ADD 	R6, R6, #-1
	STR	R1, R6, #0		; Push R1

	ADD 	R6, R6, #-1
	STR	R0, R6, #0		; Push R0
	
	
	ADD	R6, R6, #-1		; Making room for local vars
	ADD	R5, R6, #0

	LDR	R1, R5, #7		; R1 = input value

	AND 	R0, R0, #0

TENS_LOOP	

	ADD	R0, R0, #1		; Increment 10s place counter

	ADD	R1, R1, #-10		 ; Subtract 10

	BRzp TENS_LOOP	

	ADD	R0, R0, #-1		; Decrement 10s place to compensate for final loop

	ADD	R1, R1, #10		; Adding 10 back makes R0 the 1s place
	
	LD	R2, NUMS_BEGIN

	ADD	R0, R0, #0
	BRz	ONES			; Skip 10s place if it's equal to zero
	ADD 	R0, R0, R2
	OUT
ONES
	ADD	R1, R1, R2		; Convert counters to ASCII
	ADD	R0, R1, #0
	OUT				; Print 2 digit number	

	ADD	R6, R5, #0

	ADD	R6, R6, #1
	LDR	R0, R6, #0		; Pop R0

	ADD	R6, R6, #1
	LDR	R1, R6, #0		; Pop R1

	ADD	R6, R6, #1
	LDR	R2, R6, #0		; Pop R2

	ADD	R6, R6, #1
	LDR	R3, R6, #0		; Pop R3

	ADD	R6, R6, #1
	LDR	R5, R6, #0		; Pop R5

	ADD	R6, R6, #1
	LDR	R7, R6, #0		; Pop R7

	ADD	R6, R6, #-2		; Pop rest of stack

	RET

.END