#lang racket

; n4 GND
(apply-ground `J2-32)
(expect-resistance-lt `n4-3 `GND 0.5)
(expect-resistance-lt `n4-5 `GND 0.5)
(expect-resistance-lt `n4-6 `GND 0.5)
