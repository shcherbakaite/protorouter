; out_Relay_3_Lights_Drive_Fwd_DO6

; Master Bus On
(apply-voltage `J2-16 48) ; 48V
(apply-ground `J2-32)     ; Ground

(define rail24V (get-voltage-source 24))

(connect `n1-17 rail24V) ; Enable Lights, K3
(connect `n1-32 rail24V) ; Enable Aux Power, K2

(let ([v (voltage*  `J2-44)])
	(expect (format "Applied 12V via n1-17 to Coil of Relay K3. Expected 12V on J2-21. Measured ~s V." v) (eq-within v 12 1)))

(let ([v (voltage*  `J2-22)])
	(expect (format "Applied 12V via n1-17 to Coil of Relay K3. Expected 12V on J2-22. Measured ~s V." v) (eq-within v 12 1)))

