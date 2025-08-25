#lang racket/load

(require "connections.rkt")

(require "power-supply.rkt")

(require "dmm.rkt")

(require "dmm-class.rkt")

(require "visualize.rkt")

(require "interaction.rkt")

(require "matrix.rkt")

(require "expect.rkt")

(require "run.rkt")

; This test model is written in Racket. Why Racket? Racket is a LISP and by its nature encourages
; writing very succint programs - which is exactly the quality needed for programming small test sequences.
; Racket has a track record of being used as a scripting language in commercial settings, but it is far
; from being the only available Scheme implementation.

; https://www.youtube.com/watch?v=ydyztGZnbNs

(attach-dmm (new fluke45-dmm%))

(define (fus a)
  (connect `DMM_LO a )
  (connect `DMM_V_HI 'GND))

(define (ro a b)
  (connect `DMM_LO a )
  (connect `DMM_V_HI b))

(define (dah v a)
  (connect `PS_RAIL1 a )
  (power-supply-set `PS_RAIL1 v))

(thread
 (lambda ()
   (run-all-tests)
   `()
   ))



  