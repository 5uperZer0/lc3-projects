.ORIG x3000
;	Your main() function starts here
	LD 	R6, STACK_PTR			;	LOAD the pointer to the bottom of the stack in R6		(R6 = x5013)
	ADD 	R6, R6, #-1			;	Allocate room for your return value 				(R6 = x5012)
	ADD 	R5, R6, #0			;	MAKE your frame pointer R5 point to local variables		(R5 = x5012)
	LEA 	R4, GLOBAL_VARS			;	MAKE your global var pointer R4 point to globals		(R4 = ADDRESS(GLOBAL_VARS))

	LEA 	R0, ARRAY_POINTER		;	LOAD the address of your array pointer
	STR 	R0, R5, #0			;	STORE pointer to array in stack					(R5 = x5012)
	ADD 	R6, R6, #-2			;	MAKE stack pointer go back two addresses			(R6 = x5010)
	
	STR 	R0, R6, #0			;	STORE pointer to array (input to sumOfSquares)			(R6 = x5010)
	ADD 	R6, R6, #-1			;	MAKE stack pointer go back one address				(R6 = x500F)

	LDR 	R0, R4, #0			;	LOAD MAX_ARRAY_SIZE value into R0
	STR 	R0, R6, #0			;	STORE MAX_ARRAY_SIZE value into stack				(R6 = x500F)

	ADD 	R6, R6, #-1			;	MAKE stack pointer go back one address				(R6 = x500E)
	JSR 	sumOfSquares			;	CALL sumOfSquares() function
	LDR 	R0, R5, #-4			;	LOAD return value of sumOfSquares() into R0			(R5 = x5012)

	ADD 	R6, R6, #1			;	POP input to sumOfSquares off the stack				(R6 = x5010)

	STR 	R0, R5, #-1			;	STORE int total into stack					(R5 = x5012)
	STR 	R0, R5, #1			;	STORE main() return value into stack				(R5 = x5012)

	ADD 	R6, R6, #4			;	POP stack											(R6 = x5014)
	HALT


GLOBAL_VARS				;	Your global variables start here
MAX_ARRAY_SIZE	.FILL x0005		;	MAX_ARRAY_SIZE is a global variable and predefined
ARRAY_POINTER	.FILL x0002		;	ARRAY_POINTER points to the top of your array (5 elements)
		.FILL x0003
		.FILL x0005
		.FILL x0000
		.FILL x0001
STACK_PTR	.FILL x5013		;	STACK_PTR is a pointer to the bottom of the stack	(x5013)

sumOfSquares	

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
	
	ADD	R6, R6, #-1		; Make room for counter
	
	ADD 	R5, R6, #0		; Initialize new frame pointer

	ADD	R6, R6, #-2		; Make room for sum and x
	
	LDR	R2, R5, #8		; Load arraySize into R2

	AND	R3, R3, #0
	STR	R3, R5, #0		; counter = 0

	STR	R3, R5, #-1		; sum = 0

	NOT 	R2, R2
	ADD	R2, R2, #1		; Negate sentinel value

WHILE_LOOP

	ADD	R1, R2, R3		; R1 = counter + sentinel

	BRzp	END_WHILE_LOOP		; End loop if counter >= arraySize

	LDR	R0, R5, #9		; Load *a into R0
	
	ADD 	R0, R0, R3		; R0 = *a + counter

	LDR	R0, R0, #0
	
	STR 	R0, R5, #-2		; x = a[counter]

	ADD	R6, R6, #-1

	JSR	square			; call square

	LDR	R0, R5, #-3		; R0 = square's return value

	LDR	R1, R5, #-1		; R1 = sum
	
	ADD	R1, R0, R1		; R1 = sum + square's return val

	STR	R1, R5, #-1		; store sum to stack

	ADD 	R3, R3, #1		; increment counter
	
	STR	R3, R5, #0		; store counter value to stack

	BRnzp WHILE_LOOP 

END_WHILE_LOOP

	LDR	R0, R5, #-1		; R0 = sum
	
	STR	R0, R5, #7

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

	ADD	R6, R6, #2		; Pop the rest of the stack	

	RET

square
	
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

	ADD	R6, R6, #-1		; Make room for product
	
	ADD	R5, R6, #0		; Initialize FP

	AND 	R0, R0, #0
	STR	R0, R5, #0		; product = 0

	LDR	R1, R5, #8		; R1 = x

	ADD	R2, R1, #0		; R2 = x

MUL_LOOP

	ADD	R0, R0, R1		; R0 is running total

	ADD 	R2, R2, #-1		; Decrement R2

	BRp	MUL_LOOP

	STR	R0, R5, #0		; product = R0

	STR	R0, R5, #7		; return value = R0

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

	ADD	R6, R6, #2		; Pop the rest of the stack
	
	RET

.END