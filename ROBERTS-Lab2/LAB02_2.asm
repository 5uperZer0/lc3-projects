.ORIG x3000

AND R3, R3, #0			; zero the adder 

AND R0, R0, #0			; zero the counter

LD R1, max			; load the number of maximum iterations

NOT R1, R1			; MAX  = !MAX

ADD R1, R1, #1		; MAX += 1 (finishes two's complement)

adder_loop

ADD R3, R3, #5			; add 5 to adder

ADD R0, R0, #1			; add one to counter

ADD R2, R1, R0			; R2 = R1 + R0 

BRn adder_loop			; if |R1| > R0, return to start of loop

HALT				; HALT

max .FILL x0005

.END