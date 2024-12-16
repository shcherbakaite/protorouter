#lang racket

; STO1 Tests

; out_Servo_STO_DO2, J2-11 test

(expect "Tested resistance from n1-13 to J2-11 (via TSTO1). Expected < 0.5 Ohm." (< (resistance `n1-13 `J2-11) 0.5)

; out_Servo_STO_DO2, J2-36 test
(expect "Tested resistance from n1-13 to J2-36 (via TSTO1). Expected < 0.5 Ohm." (< (resistance `n1-13 `J2-36 0.5))

; out_Servo_STO_DO2, J5-24 test
(expect "Tested resistance from n1-13 to J2-24 (via TSTO1). Expected < 0.5 Ohm." (< (resistance `n1-13 `J2-24 0.5))
