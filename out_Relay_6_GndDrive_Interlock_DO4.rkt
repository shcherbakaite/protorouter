#lang racket
; This test involves multiple signals E-STOP and Interlock.
; Relay K10 interrupts coil current to K6 relay when K10 is off.
; K10 turns off 4 seconds after E-STOP signal goes low. 

; E-STOP signal to enable K10 safety relay
(connect `PS_RAIL2 `J5a-18)
(ps-set `PS_RAIL2 24)

; out_Relay_6_GndDrive_Interlock_DO4
(connect `PS_RAIL1 `n1-15)

(connect `DMM_V_LO `GND)
(ps-set `PS_RAIL1 24)
(connect `DMM_V_HI `J2-2)
(expect "Applied 24V via n1-15 to Coil of Relay K6. Expected 48V on J2-2. (Check K10 mode)" (eq-within `DMM_V 48 1))
(connect `DMM_V_HI `J2-38)
(expect "Applied 24V via n1-15 to Coil of Relay K6. Expected 48V on J2-38. (Check K10 mode)" (eq-within `DMM_V 48 1))
(connect `DMM_V_HI `J2-43)
(expect "Applied 24V via n1-15 to Coil of Relay K6. Expected 48V on J2-43. (Check K10 mode)" (eq-within `DMM_V 48 1))

; E-STOP signal to enable K10 safety relay
(connect `PS_RAIL2 `J5a-18)
(ps-set `PS_RAIL2 0)

; Wait for sefety relay K10 to go off
(wait 5000)

(connect `DMM_V_HI `J2-2)
(expect "Applied 24V via n1-15 to Coil of Relay K6 with K10 off. Expected 0V on J2-2 (Check K10 mode)" (eq-within `DMM_V 0 1))
(connect `DMM_V_HI `J2-38)
(expect "Applied 24V via n1-15 to Coil of Relay K6 with K10 off. Expected 0V on J2-38 (Check K10 mode)" (eq-within `DMM_V 0 1))
(connect `DMM_V_HI `J2-43)
(expect "Applied 24V via n1-15 to Coil of Relay K6 with K10 off. Expected 0V on J2-43 (Check K10 mode)" (eq-within `DMM_V 0 1))


      
