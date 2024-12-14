#lang racket

; out_HMI_KEY_ON_LED_DO8
(expect "Expected resistance from n1-30 to J5a-23 < 0.5 Ohm" (resistance-lt `n1-30 `J5a-23))