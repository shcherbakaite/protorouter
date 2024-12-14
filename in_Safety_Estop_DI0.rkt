#lang racket

; in_Safety_Estop_DI0 test
(expect "Measured resistance from J5a-18 to n1-1. Expected < 0.5 Ohm." (resistance-lt `n1-1 `J5a-18 0.5))