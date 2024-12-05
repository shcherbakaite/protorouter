#lang racket



(define (connect a b)
  (printf "Connected ~a to ~a\n" a b))

(define (enable a)
  (printf "Enabled ~a\n" a))


(define (eq-within channel nominal error)
  (printf "Expecting ~a < ~a < ~a\n" (- nominal error) channel (+ nominal error) )
  #t)

(define ns (make-base-namespace))

(define x 10)

(define (expect msg passed)
 passed)





; out_Servo_STO_DO2, J2-11 test
(connect `n1-13 `24VDC)
(connect `AI0 `J2-11)
(enable `24VDC)
(expect "Applied 24V to n1-13. Expected 24V on J2-11 (via TSTO1)" (eq-within `AI0 24 1))