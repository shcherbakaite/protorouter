#lang racket

; DI_COM test
(connect `DMM_LO `n1-29)
(connect `DMM_V_HI `PS_RAIL1)
(ps-set `PS_RAIL1 24)
(expect "Expected n1-9 ground" (eq-within `DMM_V 24 1))