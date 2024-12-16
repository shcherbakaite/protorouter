#lang racket

; STO1 Tests

; out_Servo_STO_DO2, J2-11 test
(expect-resistance-lt `n1-13 `J2-11 0.5)

; out_Servo_STO_DO2, J2-36 test
(expect-resistance-lt `n1-13 `J2-36 0.5)

; out_Servo_STO_DO2, J5-24 test
(expect-resistance-lt `n1-13 `J2-24 0.5)

(disconnect-all)
