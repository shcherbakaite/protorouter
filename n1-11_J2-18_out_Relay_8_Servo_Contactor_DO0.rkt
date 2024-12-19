; out_Relay_8_Servo_Contactor_DO0 test

; Master Bus On
(apply-voltage `J2-16 48) ; 48V
(apply-ground `J2-32)     ; Ground

(apply-voltage `n1-11 24) ; Relay 8 On
(let ([v (voltage `J2-18)])
    (expect (format "Applied 24V to Relay K8-A1. Expected 48V on J2-18. Measured ~s V" v) (eq-within v 48 1)))
