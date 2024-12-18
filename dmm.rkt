#lang racket

(require "connections.rkt")

(require "matrix.rkt")

;; Test and measurement department over here

(provide dmm-v dmm-r dmm-i resistance voltage)


(define (dmm-v)
  (matrix-implement-current-connections)
  (printf "Reading voltage...\n")
  48) ; build the matrix

(define (dmm-i)
  (matrix-implement-current-connections)
  0)

(define (dmm-r)
  (matrix-implement-current-connections)
  120)

;; Variable holding reference used for (voltage ...) function
(define voltage-reference `GND)

;; Change voltage reference
(define (set-voltage-reference a)
  (set! voltage-reference a))

; Perform voltage measurement referenced to voltage-reference
(define (voltage a)
  (connect `DMM_LO voltage-reference )
  (connect `DMM_V_HI a)
  (let ([v (dmm-v)])
    (disconnect `DMM_LO voltage-reference) ; clean up
    (disconnect `DMM_V_HI a)
    v))

; Perform resistance measurement between target pins a and b
(define (resistance a b)
  (connect `DMM_LO a )
  (connect `DMM_V_HI b)
  (let ([r (dmm-r)])
    (disconnect `DMM_LO a) ; clean up
    (disconnect `DMM_V_HI b)
    r))


