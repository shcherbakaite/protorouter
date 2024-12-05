#lang racket

; DI_COM test
(connect `AI1- `n1-9)
(connect `AI1+ `VDC24)
(enable `24VDC)
(expect "Expected n1-9 ground" (EQ-WITHIN `AI1 24 1))