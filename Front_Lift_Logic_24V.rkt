#lang racket

; Aux power ON
(connect `PS_RAIL2 `n1-32)
(ps-set `PS_RAIL2 24)

(connect `DMM_V_HI 