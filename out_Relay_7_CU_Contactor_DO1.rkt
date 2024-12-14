#lang racket

; out_Relay_7_CU_Contactor_DO1 test
(connect `PS_RAIL1 `n1-12)
(connect `DMM_V_HI `J2-19)
(connect `DMM_V_LO `GND)
(ps-set `PS_RAIL1 24)
(expect "Applied 24V to n1-12. Expected 24V on J2-19" (eq-within `DMM_V 48 1))
