;#lang racket

; out_Relay_4_GndDrive_KSI_DO3

; Master Bus On
(apply-voltage `J2-16 48) ; 48V
(apply-ground `J2-32)     ; Ground

(apply-voltage `n1-14 24)

(let ([v (voltage `J2-1)])
    (expect (format "Applied 24V via n1-14 to Coil of Relay K4. Expected 48V on J2-1. Measured ~s V" v) (eq-within v 48 1)))

(let ([v (voltage `J2-15)])
	(expect (format "Applied 24V via n1-14 to Coil of Relay K4. Expected 48V on J2-15. Measured ~s V" v) (eq-within v 48 1)))

(let ([v (voltage `J2-37)])
	(expect (format "Applied 24V via n1-14 to Coil of Relay K4. Expected 48V on J2-37. Measured ~s V" v) (eq-within v 48 1)))

(let ([v (voltage `J2-43)])
	(expect (format "Applied 24V via n1-14 to Coil of Relay K4. Expected 48V on J2-43. Measured ~s V" v) (eq-within v 48 1)))

;(disconnect-all)