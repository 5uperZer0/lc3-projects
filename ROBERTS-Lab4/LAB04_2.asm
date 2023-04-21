	.ORIG x5000

MEMDUMP
	
	STI 	R6, OUT_STACK_R6
	LD	R6, OUT_STACK_BASE		; Set stack base

	STR	R0, R6, #0			
	
	STR	R1, R6, #-1			; Push R1

	STR	R2, R6, #-2			; Push R2

	STR	R3, R6, #-3			; Push R3

	STR	R4, R6, #-4			; Push R4

	STR	R5, R6, #-5			; Push R5

	STR	R7, R6, #-7			; Push R7

	ADD	R6, R6, #-8
	
	AND	R4, R4, #0
	ADD	R4, R0, #0			; Copy R0 to R4
	
	NOT 	R4, R4
	ADD 	R4, R4, #1
	ADD 	R4, R1, R4			; R4 = R1 - R4
	BRn	INVALID_ADDRESSES

	AND	R4, R4, #0
	ADD	R4, R0, #0			; Copy R0 to R4
	
	AND 	R5, R5, #0
	ADD 	R5, R5, R1			; Copy R1 to R5

	LEA 	R0, MEMCONBEGIN
	PUTS
	
	ADD 	R0, R4, #0			; Copy R4 to R0
	JSR	WORD_OUT			; Use WORD_OUT to print address

	LEA	R0, MEMCONMIDDLE
	PUTS	

	ADD 	R0, R5, #0			; Copy R5 to R0
	JSR	WORD_OUT			; Use WORD_OUT to print address

	LEA	R0, MEMCONEND
	PUTS

	LD 	R0, CHAR_NL
	OUT

MDLOOP

	ADD	R3, R4, #0			; Copy R4 to R3
	NOT 	R3, R3
	ADD 	R3, R3, #1
	ADD 	R3, R3, R5
	BRn 	MDMP_EXIT			; Branch if R3 > R5

	ADD	R0, R4, #0			; Copy R4 to R0	
	JSR 	WORD_OUT			; Print address

	LD	R0, CHAR_SPACE
	OUT
	OUT
	OUT					; Print 3 spaces
	
	LDR	R0, R4, #0			; Load value at address stored in R4
	JSR 	WORD_OUT
	
	LD 	R0, CHAR_NL
	OUT

	ADD	R4, R4, #1			; Increment R4
	BRnzp 	MDLOOP

MDMP_EXIT
	
	ADD 	R6, R6, #8

	LDR	R0, R6, #0

	LDR	R1, R6, #-1

	LDR	R2, R6, #-2

	LDR	R3, R6, #-3

	LDR	R4, R6, #-4

	LDR	R5, R6, #-5

	LDR	R7, R6, #-7

	LDR	R6, R6, #-6

	RET

WORD_OUT
	
	STR	R0, R6, #0			
	
	STR	R1, R6, #-1			; Push R1

	STR	R2, R6, #-2			; Push R2

	STR	R3, R6, #-3			; Push R3

	STR	R4, R6, #-4			; Push R4

	STR	R5, R6, #-5			; Push R5
	
	STR	R6, R6, #-6

	STR	R7, R6, #-7			; Push R7

	ADD 	R6, R6, #-8

	LD 	R0, CHAR_X
	OUT

	LEA 	R5, NIBBLE_1_SHIFT

WO_NIBBLE_LOOP
	
	LD 	R1, MSB_MASK
	LDR	R0, R6, #8			; R0 = starting address

	LDR 	R3, R5, #0			; R3 = mem[R5]
	BRz	WO_NIB_SHIFT_DONE		; Branch if mem[R5] = 0

WO_CLS_LOOP
	
	AND	 R2, R1, R0			
	BRz	WO_CLS				; Branch if MSB = 0
	AND 	R2, R2, #0			
	ADD 	R2, R2, #1			; Else, set carry bit

WO_CLS
	
	ADD 	R0, R0, R0			; Bit shift R0
	ADD	R0, R2, R0			; Add carry bit
	ADD 	R3, R3, #-1			; Decrement R3
	BRp	WO_CLS_LOOP

WO_NIB_SHIFT_DONE
	
	LD 	R1, NUM_MASK
	AND	R0, R1, R0			; Apply num mask to R0
	LD	R1, CHAR_NL			; R1 = 0xA

	NOT 	R1, R1
	ADD	R1, R1, #1			; Two's complement R1

	ADD 	R1, R1, R0
	BRn	WO_CHAR_NUM

	ADD 	R0, R1, #0			; R0 = R1

	LD 	R1, ALPHA_BASE			; R1 = 'A'
	
	ADD 	R0, R1, R0
	
	BRnzp	WO_CHAR_PRINT

WO_CHAR_NUM
	
	LD 	R1, DIGIT_BASE
	ADD 	R0, R1, R0			; R0 += R1 (Gets ascii number)

WO_CHAR_PRINT
	
	OUT					; Print char

	LDR 	R3, R5, #0
	BRz	WO_EXIT				; Branch if R5 points at a zero
	
	ADD 	R5, R5, #1			; Increment R5

	BRnzp	WO_NIBBLE_LOOP

WO_EXIT
	
	ADD 	R6, R6, #8
	
	LDR	R0, R6, #0

	LDR	R1, R6, #-1

	LDR	R2, R6, #-2

	LDR	R3, R6, #-3

	LDR	R4, R6, #-4

	LDR	R5, R6, #-5

	LDR	R7, R6, #-7

	LDR	R6, R6, #-6

	RET

INVALID_ADDRESSES
	
	LEA	R0, INVALID_ADDRESS
	PUTS

	HALT

; --------------------------------------
; GLOBAL VARIABLES
 
MEMCONBEGIN     .STRINGZ "Memory Contents " ; First bit of header line
MEMCONMIDDLE     .STRINGZ " to " ; Middle bit of header line
MEMCONEND       .STRINGZ ":" ; Ending bit of header line
INVALID_ADDRESS .STRINGZ "The starting address is larger than the ending address!"
CHAR_X          .FILL x0078 ; The value for lowercase 'x' in ASCII
CHAR_NL         .FILL x000A ; Newline character
CHAR_SPACE      .FILL x0020 ; The value for the space character in ASCII 

OUT_STACK_BASE  .FILL x5FFF ; The base address of the stack
OUT_STACK_R6    .FILL x5FF9 ; The address in memory that the contents of R6 will go to

; Amounts to shift each nibble left circularly by (with x0000 as a sentinel to tell us to not shift and continue). Normally we'd need to right shift, but LC-3 makes this very difficult. So instead we shift left circularly. 
NIBBLE_1_SHIFT  .FILL #4
                .FILL #8
                .FILL #12
                .FILL x0000
 
MSB_MASK        .FILL x8000 ; A mask that looks for the most significant bit in the word being set. In other words, it is 1000 0000 0000 0000 in binary. 
 
NUM_MASK        .FILL x000F ; A mask that looks for the lowest nibble of the word being set. In other words, it is 0000 0000 0000 1111 in binary. 
 
ALPHA_BASE      .FILL x0041 ; The beginning of the uppercase ASCII letters
DIGIT_BASE      .FILL x0030 ; The beginning of the digits in ASCII

; --------------------------------------

.END	; Print address
