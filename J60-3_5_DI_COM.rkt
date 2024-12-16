#lang racket

; J60-3 5 GND test
(apply-ground `J2-32)
(expect-resistance-lt `J60-3 `GND 0.5)
(expect-resistance-lt `J60-5 `GND 0.5)
(disconnect-all)