.ORIG x3000

AND R3, R3, #0		; z = 0

LD R1, x		; load x into R1
BRz end			; end if x = 0

ADD R3, R3, #1		; z = 1

LD R2, y		; load y into R2
BRz end

i_loop

AND R0, R0, #0  	; scratch = 0
LD R1, x		; load x into R1

j_loop

ADD R0, R0, R3		; scratch += z

ADD R1, R1, #-1		; decrement multiplication counter
BRp j_loop		; jump to start of multiplication loop

ADD R3, R0, #0		; z = scratch

ADD R2, R2, #-1		; decrement exponent counter
BRp i_loop 		; jump to start of exponent loop

end

HALT

x .FILL x0005
y .FILL x0003

.END