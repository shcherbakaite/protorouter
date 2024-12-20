; Master Bus On
(apply-voltage `J2-16 48) ; 48V
(apply-ground `J2-32)     ; Ground

(let ([v (voltage*  `n3-6)])
    (expect (format "Enabled master bus, but left relay K2 OFF. Expected 0V on n1-6. Measured ~s V." v) (eq-within v 0 0.5)))

(let ([v (voltage*  `J5a-7)])
    (expect (format "Enabled master bus, but left relay K2 OFF. Expected 0V on J5a-7. Measured ~s V." v) (eq-within v 0 0.5)))

; Enable Aux Power, K2
(apply-voltage `n1-32 24)

(let ([v (voltage*  `n3-6)])
    (expect (format "Enabled auxilary power, relay K2. Expected 5V on n1-6. Measured ~s V." v) (eq-within v 5 0.5)))

(let ([v (voltage*  `J5a-7)])
    (expect (format "Enabled master bus, but left relay K2 OFF. Expected 0V on J5a-7. Measured ~s V." v) (eq-within v 5 0.5)))

