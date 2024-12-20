; OP_CONSOLE_24V, J5a-28

; Master Bus On
(apply-voltage `J2-16 48) ; 48V
(apply-ground `J2-32)     ; Ground

(let ([v (voltage*  `J5a-28)])
    (expect (format "Enabled master bus power. Expected 24V on J5a-28. Measured ~s V." v) (eq-within v 24 1)))

