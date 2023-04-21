.ORIG x3000


AND R3, R3, #0			; zero out R3

NOT R1, R1
ADD R1, R1, #1			; make two's complement of R1

ADD R2, R0, R1			; R2 = R0 + (negative) R1

BRnp else			; if result is not zero, jump to else

ADD R3, R3, #5			; R3 = 5

BRnzp done			; skip else

else

ADD R3, R3, #-5			; R3 = -5

done

HALT

.END