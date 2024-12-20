#lang racket

(require "connections.rkt")

(require "matrix.rkt")

;; Test and measurement department over here

(provide dmm-v dmm-r dmm-i resistance voltage voltage*)


(define (dmm-v)
  (matrix-update)
  (printf "Reading voltage...\n")
  48) ; build the matrix

(define (dmm-i)
  (matrix-update)
  (printf "Reading current...\n")
  1)

(define (dmm-r)
  (matrix-update)
  (printf "Reading resistance...\n")
  120)

(define (voltage* a)
  (voltage  a `GND))

; Perform voltage measurement referenced to voltage-reference
(define (voltage  a b)
  (connect `DMM_LO b )
  (connect `DMM_V_HI a)
  (let ([v (dmm-v)])
    (disconnect `DMM_LO b) ; clean up
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


