#lang racket

; in_KEY_ON_DI4 test
(expect "Measured resistance from J5a-19 to n1-5. Expected < 0.5 Ohm." (resistance-lt `n1-5 `J5a-19 0.5))




