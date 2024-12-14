#lang racket

; Aux power ON
(connect `PS_RAIL2 `n1-32)
(ps-set `PS_RAIL2 24)

; out_Relay_3_Lights_Drive_Fwd_DO6
(connect `PS_RAIL1 `n1-17)
(connect `DMM_V_LO `GND)
(ps-set `PS_RAIL1 12)

(connect `DMM_V_HI `J2-21)
(expect "Applied 12V via n1-17 to Coil of Relay K3. Expected 12V on J2-21" (eq-within `DMM_V 12 1))
(connect `DMM_V_HI `J2-22)
(expect "Applied 12V via n1-17 to Coil of Relay K3. Expected 12V on J2-22" (eq-within `DMM_V 12 1))