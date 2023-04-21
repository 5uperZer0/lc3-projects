.ORIG x3000

AND R3, R3, #0			; R3 = 0

ADD R1, R1, #10

while 

ADD R3, R3, #-2			; R0 -= 2

ADD R2, R1, R3

BRp while

HALT

.END
