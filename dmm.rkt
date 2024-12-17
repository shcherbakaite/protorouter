#lang racket

(require "connections.rkt")

;; Test and measurement department over here

(provide dmm-v dmm-r dmm-i resistance voltage)


(define (dmm-v)
  (printf "Reading voltage...\n")
  48) ; build the matrix

(define (dmm-i)
  0)

(define (dmm-r)
  120)

;; Variable holding reference used for (voltage ...) function
(define voltage-reference `GND)

;; Change voltage reference
(define (set-voltage-reference a)
  (set! voltage-reference a))

; Perform voltage measurement referenced to voltage-reference
(define (voltage a)
  (connect `DMM_LO voltage-reference )
  (connect `DMM-V_HI a)
  (let ([v (dmm-v)])
    (disconnect `DMM_LO voltage-reference) ; clean up
    (disconnect `DMM-V_HI a)
    v))

; Perform resistance measurement between target pins a and b
(define (resistance a b)
  (connect `DMM_LO a )
  (connect `DMM-V_HI b)
  (let ([r (dmm-r)])
    (disconnect `DMM_LO a) ; clean up
    (disconnect `DMM-V_HI b)
    r))


