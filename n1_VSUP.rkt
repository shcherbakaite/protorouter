#lang racket

; n1_VSUP
(connect `DMM_V_HI `n1-19)
(connect `DMM_V_LO `GND)

(expect "Expected 24V on n1-19" (eq-within `DMM_V 24 1))
