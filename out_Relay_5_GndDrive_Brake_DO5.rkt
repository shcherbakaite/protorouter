#lang racket

; out_Relay_5_GndDrive_Brake_DO5
(connect `PS_RAIL1 `n1-16)

(connect `DMM_V_LO `GND)
(ps-set `PS_RAIL1 24)
(connect `DMM_V_HI `J2-3)
(expect "Applied 24V via n1-16 to Coil of Relay K5. Expected 48V on J2-3" (eq-within `DMM_V 48 1))
(connect `DMM_V_HI `J2-39)
(expect "Applied 24V via n1-16 to Coil of Relay K5. Expected 48V on J2-39" (eq-within `DMM_V 48 1))
(connect `DMM_V_HI `J2-44)
(expect "Applied 24V via n1-16 to Coil of Relay K5. Expected 48V on J2-44" (eq-within `DMM_V 48 1))