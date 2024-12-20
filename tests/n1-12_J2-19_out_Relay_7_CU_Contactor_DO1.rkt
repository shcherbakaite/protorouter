; out_Relay_7_CU_Contactor_DO1 test

; Master Bus On
(apply-voltage `J2-16 48) ; 48V
(apply-ground `J2-32)     ; Ground

(apply-voltage `n1-12 24) ; Relay 7 On
(let ([v (voltage*  `J2-19)])
    (expect (format "Applied 24V to n1-12. Expected 48V on J2-19 from Relay 7. Measured ~s V" v) (eq-within v 48 1)))

