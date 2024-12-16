#lang racket

; J2-12_Front_Lift_Logic_GND test
(apply-ground `J2-32)
(expect-resistance-lt `J2-12 `GND 0.5)
(disconnect-all)