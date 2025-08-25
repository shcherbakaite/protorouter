#lang racket

(require racket/class)

(require "connections.rkt")

(require "matrix.rkt")

(require "dmm-class.rkt")

;; Test and measurement department over here

(provide dmm-v dmm-r dmm-i resistance voltage voltage* attach-dmm)

(define dmm-instance #f)

(define (attach-dmm d)
  (set! dmm-instance d))

(define (dmm-v)
  (matrix-update)
  (send dmm-instance vdc!)
  (printf "Reading voltage...\n")
  (send dmm-instance measure?))
  ;48) ; build the matrix

(define (dmm-i)
  (matrix-update)
  (send dmm-instance adc!)
  (printf "Reading current...\n")
  (send dmm-instance measure?))

(define (dmm-r)
  (matrix-update)
  (send dmm-instance ohms!)
  (printf "Reading resistance...\n")
  (send dmm-instance measure?))

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



