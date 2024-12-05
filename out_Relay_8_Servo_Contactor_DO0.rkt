#lang racket

; out_Relay_8_Servo_Contactor_DO0 test
(connect `n1-11 `24VDC)
(connect `AI0 `J2-18)
(enable `24VDC)
(expect "Applied 24V to Relay K8-A1. Expected 48V on J2-18" (EQ-WITHIN `AI0 48 1))