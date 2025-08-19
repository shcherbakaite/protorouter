#lang racket

(provide XA XB Y)

; (define X-axis
; (list
;     `XA1
;     `XA2
;     `XA3
;     `XA4
;     `XA5
;     `XA6
;     `XA7
;     `XA8
;     `XA9
;     `XA10
;     `XA11
;     `XA12
;     `XA13
;     `XA14
;     `XA15
;     `XA16
;     `XA17
;     `XA18
;     `XA19
;     `XA20
;     `XA21

; ))

; (define Y-axis
; (list
;      `Y1 ; Net connection resources
;      `Y2
;      `Y3
;      `Y4))
;      ;`Y5))
;      ;`ROW6))

(define (XA x)
    (string->symbol (string-append "XA" (number->string x))))

(define (XB x)
    (string->symbol (string-append "XB" (number->string x))))

(define (Y y)
    (string->symbol (string-append "Y" (number->string y))))



