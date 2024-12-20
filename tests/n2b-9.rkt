; n2b-9 CAN B 24V

; Master Bus On
(apply-voltage `J2-16 48) ; 48V
(apply-ground `J2-32)     ; Ground

(let ([v (voltage*  `n2b-9)])
    (expect (format "Enabled master bus power. Expected 24V on n2b-9. Measured ~s V." v) (eq-within v 24 1)))
