#lang racket

; out_Relay_2, J2-10.rkt

(connect `PS_RAIL1 `n1-32)
(ps-set `PS_RAIL1 24)

(connect `DMM_V_HI `J2-10)
(connect `DMM_LO `GND)

(expect "Enabled auxilary power, relay K2. Expected 24V on J2-10" (eq-within `AI0 24 1))
