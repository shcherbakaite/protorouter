; n1_VSUP
; Master Bus On

(apply-voltage `J2-16 48) ; 48V
(apply-ground `J2-32)     ; Ground

(expect-voltage-eq `n1-19 24 1)

