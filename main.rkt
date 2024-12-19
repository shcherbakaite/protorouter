#lang racket/load

(require "connections.rkt")

(require "power-supply.rkt")

(require "dmm.rkt")

(require "visualize.rkt")

(require "matrix.rkt")

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

(define (eq-within measured expected err)
	(and (< measured (+ expected err)) (> measured (- expected err))))

(define-syntax-rule (expect msg expr)
  (when (not expr)
    ;(error 'expect "~s: ~s" msg (quote expr))))
    (printf "~s: ~s\n" msg (quote expr))))


(define (expect-resistance-eq a b expected err)
  (let ([measured (resistance a b)])
    (expect (format "Expected resistance between ~s and ~s is ~s (+/- ~s) Ohm. Measured ~s Ohm." a b expected err measured) (eq-within measured expected err))))

(define (expect-resistance-lt a b expected)
  (let ([measured (resistance a b)])
    (expect (format "Expected resistance between ~s and ~s to be less than ~s Ohm. Measured ~s Ohm." a b expected measured) (< measured expected))))


(define (expect-resistance-gt a b expected)
  (let ([measured (resistance a b)])
    (expect (format "Expected resistance between ~s and ~s to be greater than ~s Ohm. Measured ~s Ohm." a b expected measured) (> measured expected))))

(define (expect-voltage-eq a expected err)
  (let ([measured (voltage a)])
    (expect (format "Expected ~s (+/- ~s) V on ~s. Measured ~s V." expected err a measured) (eq-within measured expected err))))


(define (prompt a t)
  `())

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
   ;(run-test (string->path "n1-29_DO_COM.rkt"))
   (run-all-tests)
   ; (run-test "J2-30_LIDAR_GND.rkt")
   
   ; (run-test "J2-34_Rear_Lift_GND.rkt")
   
   ; (run-test "J5a-32_MICROPLEX_12V.rkt")
   
   ; (run-test "J30-A_J30-B_J30-C.rkt")
   
   ; (run-test (string->path "J5a-30_OP_CONSOLE_12V.rkt"))

    ; (run-test "J2-30_LIDAR_GND.rkt")
   
   ; (run-test "J2-34_Rear_Lift_GND.rkt")
   
   ; (run-test "J5a-32_MICROPLEX_12V.rkt")
   
   ; (run-test "J30-A_J30-B_J30-C.rkt")
   
   ; (run-test "J5a-28_OP_CONSOLE_24V.rkt")
   ;  (run-test "J2-30_LIDAR_GND.rkt")
   
   ; (run-test "J2-34_Rear_Lift_GND.rkt")
   
   ; (run-test "J5a-32_MICROPLEX_12V.rkt")
   
   ; (run-test "J30-A_J30-B_J30-C.rkt")
   
   ; (run-test "J5a-28_OP_CONSOLE_24V.rkt")

   ;  (run-test "J2-30_LIDAR_GND.rkt")
   
   ; (run-test "J2-34_Rear_Lift_GND.rkt")
   
   ; (run-test "J5a-32_MICROPLEX_12V.rkt")
   
   ; (run-test "J30-A_J30-B_J30-C.rkt")
   
   ; (run-test "J5a-28_OP_CONSOLE_24V.rkt")

   ;  (run-test "J2-30_LIDAR_GND.rkt")
   
   ; (run-test "J2-34_Rear_Lift_GND.rkt")
   
   ; (run-test "J5a-32_MICROPLEX_12V.rkt")
   
  ; (run-test "J30-A_J30-B_J30-C.rkt")
   
   ; (run-test "J5a-28_OP_CONSOLE_24V.rkt")

   ;  (run-test "J2-30_LIDAR_GND.rkt")
   
   ; (run-test "J2-34_Rear_Lift_GND.rkt")
   
   ; (run-test "J5a-32_MICROPLEX_12V.rkt")
   
   ; (run-test "J30-A_J30-B_J30-C.rkt")
   
   ; (run-test "J5a-28_OP_CONSOLE_24V.rkt")

   ;  (run-test "J2-30_LIDAR_GND.rkt")
   
   ; (run-test "J2-34_Rear_Lift_GND.rkt")
   
   ; (run-test "J5a-32_MICROPLEX_12V.rkt")
   
   ; (run-test "J30-A_J30-B_J30-C.rkt")
   
   ; (run-test "J5a-28_OP_CONSOLE_24V.rkt")

   ;  (run-test "J2-30_LIDAR_GND.rkt")
   
   ; (run-test "J2-34_Rear_Lift_GND.rkt")
   
   ; (run-test "J5a-32_MICROPLEX_12V.rkt")
   
   ; (run-test "J30-A_J30-B_J30-C.rkt")
   
   ; (run-test "J5a-28_OP_CONSOLE_24V.rkt")

   ))

;(load "n1-15_J5a-18_J2-2_J2-38_J2-43_out_Relay_6_GndDrive_Interlock_DO4.rkt")
;(disconnect-all)
;(matrix-implement-current-connections)

(displayln (set-count connections))

  