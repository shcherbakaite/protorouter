#lang racket

; DI_COM test
(apply-ground `J2-32)
(expect-resistance-lt `n1-9 `GND 0.5)
(disconnect-all)