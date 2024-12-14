#lang racket

; out_Relay_8_Servo_Contactor_DO0 test
(connect `PS_RAIL1 `n1-11)
(connect `DMM_V_HI `J2-18)
(connect `DMM_V_LO `GND)
(ps-set `PS_RAIL1 24)
(expect "Applied 24V to Relay K8-A1. Expected 48V on J2-18" (eq-within `DMM_V 48 1))
