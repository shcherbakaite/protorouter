#lang racket

; out_Servo_STO_DO2, J2-11 test
(connect `n1-13 `24VDC)
(connect `AI0 `J2-11)
(enable `24VDC)
(expect "Applied 24V to n1-13. Expected 24V on J2-11 (via TSTO1)" (EQ-WITHIN `AI0 24 1))