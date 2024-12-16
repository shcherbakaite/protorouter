#lang racket

; n1_in_Charge_Connect_DI8

; Master Bus On
; In case of cross-talk
(apply-voltage `J2-16 48) ; 48V
(apply-ground `J2-32)     ; Ground

; Relay 9 Off
(apply-voltage `J2-7 0)

(let ([v (voltage `n1-20)])
	(expect (format "Expected 0V on n1-20 with Charge detect Relay 9 OFF. Measured ~s" v) (eq-within v 0 1))

(apply-voltage `J2-7 48)

(let ([v (voltage `n1-20)])
	(expect (format "Expected 24V on n1-20 with Charge detect Relay 9 ON. Measured ~s" v) (eq-within v 0 1)))

(disconnect-all)
