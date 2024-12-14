#lang racket

; out_HMI_Enable_BTN_LED_DO09
(expect "Expected resistance from n1-31 to J5a-22 < 0.5 Ohm" (resistance-lt `n1-31 `J5a-22))