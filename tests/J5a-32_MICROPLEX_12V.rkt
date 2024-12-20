; MICROPLEX 12V, J2-32.rkt

; Master Bus On
(apply-voltage `J2-16 48) ; 48V
(apply-ground `J2-32)     ; Ground

(apply-voltage `n1-32 24) ; Enable Aux Power, K2
(let ([v (voltage*  `J5a-32)])
    (expect (format "Enabled auxilary power, relay K2. Expected 12V on J2-32. Measured ~s V." v) (eq-within v 12 1)))

