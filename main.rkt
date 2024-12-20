#lang racket/load

(require "connections.rkt")

(require "power-supply.rkt")

(require "dmm.rkt")

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

; Connect DMM probes for voltage test
(define (fus a)
  (connect `DMM_LO a )
  (connect `DMM_V_HI 'GND))

; Connect DMM probes for resistance test
(define (ro a b)
  (connect `DMM_LO a )
  (connect `DMM_V_HI b))

; Apply voltage to pin
(define (dah v a)
  (connect `PS_RAIL1 a )
  (power-supply-set `PS_RAIL1 v))








; "Expected 120 (+/-5) Ohm terminator between pin UTSG-4 and UTSG-3. Measured 75 Ohm"

; set background state
; modify state
; check state


; (define resistance-map
;   `(((n2b-2 . J2-47) (expect-resistance-lt 0.5) )
;     ((n2b-7 . J2-48) (λ (x) (< x 0.5) ))
;     ((n2b-2 . n2b-7) (λ (x) (eq-within x 120 5) ))
;     ((J2-47 . J2-48) (λ (x) (eq-within x 120 5) ))
;     ((UTSG-4 . UTSG-3) (λ (x) (eq-within x 120 5)))))


; ; Measure resistance of pin pairs
; (define (resistance-map pairs)
;   (map pairs ( λ (p) (resistance (car p) (cdr p)) ))


(thread
 (lambda ()
   (run-all-tests)
   `()
   ))

;(load "n1-15_J5a-18_J2-2_J2-38_J2-43_out_Relay_6_GndDrive_Interlock_DO4.rkt")
;(disconnect-all)
;(matrix-update)

(displayln (set-count connections))

  