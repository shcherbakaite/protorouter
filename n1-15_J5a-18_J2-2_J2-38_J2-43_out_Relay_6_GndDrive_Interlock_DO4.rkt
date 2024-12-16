#lang racket
; This test involves multiple signals E-STOP and Interlock.
; Relay K10 interrupts coil current to K6 relay when K10 is off.
; K10 turns off 4 seconds after E-STOP signal goes low. 

; Master Bus On
(apply-voltage `J2-16 48) ; 48V
(apply-ground `J2-32)     ; Ground

; E-STOP signal to enable K10 safety relay
(apply-voltage `J5a-18 24)

; out_Relay_6_GndDrive_Interlock_DO4
(apply-voltage `n1-15 24)

(let ([v (voltage `J2-2)])
	(expect (format "Applied 24V via n1-15 to Coil of Relay K6. Expected 48V on J2-2. Measured ~s V. (Check K10 mode)" v) (eq-within v 48 1)))

(let ([v (voltage `J2-38)])
	(expect (format "Applied 24V via n1-15 to Coil of Relay K6. Expected 48V on J2-38. Measured ~s V. (Check K10 mode)" v) (eq-within v 48 1)))

(let ([v (voltage `J2-43)])
	(expect (format "Applied 24V via n1-15 to Coil of Relay K6. Expected 48V on J2-43. Measured ~s V. (Check K10 mode)" v) (eq-within v 48 1)))

; Disable E-STOP signal and wait for K10 safety relay to cut interlock signal
(disconnect `J5a-18)
(apply-ground `J5a-18)

; Wait for sefety relay K10 to go off
(wait 5000)

(let ([v (voltage `J2-2)])
	(expect (format "Applied 24V via n1-15 to Coil of Relay K6. Expected 48V on J2-2. Measured ~s V. (Check K10 mode)" v) (eq-within v 48 1)))

(let ([v (voltage `J2-38)])
	(expect (format "Applied 24V via n1-15 to Coil of Relay K6. Expected 48V on J2-38. Measured ~s V. (Check K10 mode)" v) (eq-within v 48 1)))

(let ([v (voltage `J2-43)])
	(expect (format "Applied 24V via n1-15 to Coil of Relay K6. Expected 48V on J2-43. Measured ~s V. (Check K10 mode)" v) (eq-within v 48 1)))

(disconnect-all)