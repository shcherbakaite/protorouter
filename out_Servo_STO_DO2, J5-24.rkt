#lang racket

; out_Servo_STO_DO2, J5-24 test
(connect `n1-13 `24VDC)
(connect `AI0 `J5-24)
(enable `24VDC)
(expect "No connection: n1-13 to J5-24, via TSTO1." (eq-within `AI0 24 1))
