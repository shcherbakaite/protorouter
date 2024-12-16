#lang racket

; out_Relay_5_GndDrive_Brake_DO5

; Master Bus On
(apply-voltage `J2-16 48) ; 48V
(apply-ground `J2-32)     ; Ground

(apply-voltage `n1-16 24)

(let ([v (voltage `J2-3)])
	(expect (format "Applied 24V via n1-16 to Coil of Relay K5. Expected 48V on J2-3. Measured ~s V." v) (eq-within v 48 1)))

(let ([v (voltage `J2-39)])
	(expect (format "Applied 24V via n1-16 to Coil of Relay K5. Expected 48V on J2-39. Measured ~s V." (eq-within v 48 1))))

(let ([v (voltage `J2-44)])
	(expect (format "Applied 24V via n1-16 to Coil of Relay K5. Expected 48V on J2-44. Measured ~s V." (eq-within v 48 1))))

(disconnect-all)
