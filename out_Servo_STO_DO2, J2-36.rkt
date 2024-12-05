#lang racket

; out_Servo_STO_DO2, J2-36 test
(connect `n1-13 `24VDC)
(connect `AI0 `J2-36)
(enable `24VDC)
(expect "Applied 24V to n1-13. Expected 24V on J2-36 (via TSTO1)" (eq-within `AI0 24 1))