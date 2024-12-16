#lang racket

; out_Relay_2, J5a-26.rkt

; Master Bus On
(apply-voltage `J2-16 48) ; 48V
(apply-ground `J2-32)     ; Ground

(apply-voltage `n1-32 24) ; Enable Aux Power, K2
(let ([v (voltage `J5a-26)])
    (expect (format "Enabled auxilary power, relay K2. Expected 24V on J2-31. Measured ~s V." v) (eq-within v 24 1)))

(disconnect-all)