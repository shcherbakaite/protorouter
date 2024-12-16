#lang racket

; This test model is written in Racket. Why Racket? Racket is a LISP and by its nature encourages
; writing very succint programs - which is exactly the quality needed for programming small test sequences.
; Racket has a track record of being used as a scripting language in commercial settings, but it is far
; from being the only available Scheme implementation.

; https://www.youtube.com/watch?v=ydyztGZnbNs

(require math)

; This tester model is based on relay matrix. 

; Declare array of resources on X-side of the matrix
(define resources 
  (array
   #[`DMM-V_HI
     `DMM_LO
     `DMM_I_HI
     `PS_RAIL1
     `PS_RAIL2
     `PS_RAIL3
     `LOAD_1]))

;(ps-set `PS_RAIL1 24)
;(ps-set `PS_RAIL1 `GND)
;(ps-set `PS_RAIL1 `BATTERY)
;(ps-disable `PS_RAIL1)

; Declare array of target test connections on the Y-side of the matrix
(define targets 
  (array
   #[`GND      ; Reference for DMM needs to be on Y side
     `DMM_I
     `LOAD_2
     `J2-1
     `J2-2
     `J2-3
     `J2-4
     `J2-5
     `J2-6
     `J2-7
     `J2-8
     `J2-9
     `J2-11
     `J2-12
     `J2-13
     `J2-14
     `J2-15
     `J2-16
     `J2-17
     `J2-18
     `J2-19
     `J2-20
     `J2-21
     `J2-22
     `J2-23
     `J2-24
     `J2-25
     `J2-26
     `J2-27
     `J2-28
     `J2-29
     `J2-30
     `J2-31
     `J2-32
     `J2-33
     `J2-34
     `J2-35
     `J2-36
     `J2-37
     `J2-38
     `J2-39
     `J2-40
     `J2-41
     `J2-42
     `J2-43
     `J2-44
     `J2-45
     `J2-46
     `J2-47
     `J2-48
     `J2-49
     `J2-50
     `J2-51
     `J2-52
     `J2-53
     `J2-54
     `J2-55
     `J2-56
     `J2-57
     `J2-58
     `J2-59
     `J2-60
     `J5-1
     `J5-2
     `J5-3
     `J5-4
     `J5-5
     `J5-6
     `J5-7
     `J5-8
     `J5-9
     `J5-11
     `J5-12
     `J5-13
     `J5-14
     `J5-15
     `J5-16
     `J5-17
     `J5-18
     `J5-19
     `J5-20
     `J5-21
     `J5-22
     `J5-23
     `J5-24
     `J5-25
     `J5-26
     `J5-27
     `J5-28
     `J5-29
     `J5-30
     `J5-31
     `J5-32
     `J5-33
     `n1-1
     `n1-2
     `n1-3
     `n1-4
     `n1-5
     `n1-6
     `n1-7
     `n1-8
     `n1-9
     `n1-10
     `n1-11
     `n1-12
     `n1-13
     `n1-14
     `n1-15
     `n1-16
     `n1-17
     `n1-18
     `n1-19
     `n1-20
     `n1-21
     `n1-22
     `n1-23
     `n1-24
     `n1-25
     `n1-26
     `n1-27
     `n1-28
     `n1-29
     `n1-30
     `n1-31
     `n1-32
     `n1-33
     `n3-1
     `n3-2
     `n3-3
     `n3-4
     `n3-5
     `n3-6
     `n3-7
     `n3-8
     `n3-9
     `n3-10
     `n3-11
     `n3-12
     `n3-13
     `n3-14
     `n3-15
     `n3-16
     `n3-17
     `n3-18
     `n3-19
     `n3-20
     `n3-21
     `n3-22
     `n3-23
     `n3-24
     `n3-25
     `n3-26
     `n3-27
     `n3-28
     `n3-29
     `n3-30
     `n3-31
     `n3-32
     `n3-33
     
]))

; Declare boolean matrix of relay states where each relay at X Y
; connects row X to column Y when the value at X Y is #t
(define matrix
  (array->mutable-array (make-array
                         (vector (array-size resources) (array-size targets) ) #f)))

; Clear column x of array arr
(define (set-column arr x value)
  (match-let ([(vector _ dimy) (array-shape matrix)])
    (for ([i dimy])
      (array-set! arr (vector x i) value))))

; Clear row y of array arr
(define (set-row arr y value)
  (match-let ([(vector dimx _) (array-shape matrix)])
    (for ([i dimx])
      (array-set! arr (vector i y) value))))

; Clear matrix column
(define (matrix-clear-col x) (set-column matrix x #f))

; Clear matrix row
(define (matrix-clear-row y) (set-row matrix y #f))

; Create exclusive connection between resource X and target Y.
; All existing connectiond of X and Y are severed.
(define (connect x y)
  (matrix-clear-col x) ; disconnect resource x from any other targets
  (matrix-clear-row y) ; disconnect target y from any other resources
  (array-set! matrix (vector x y) #t))


(define (lt) #f)

; Perform resistance measurement between target pins a and b
; a, b - > R(a,b)
(define (resistance a b)
  (disconnect `DMM_LO)
  (disconnect `DMM-V_HI)
  (connect `DMM_LO a )
  (connect `DMM-V_HI b)
  (let ([v (dmm-r)])
    (disconnect `DMM_LO) ; clean up
    (disconnect `DMM-V_HI)
    v))

; Connect DMM probes for voltage test
(define (voltage a)
  (connect `DMM_LO a )
  (connect `DMM-V_HI 'GND)
  (dmm-v))

(define (voltage-reference a)
  (connect `DMM_LO a ))

; Apply voltage to pin
(define (apply-voltage v a)
  (connect `PS_RAIL1 a )
  (power-supply-set `PS_RAIL1 v))

; Create a reference potential and measure it against some ground pin
(define (grounded? a level err)
  (connect `DMM_LO a)
  (connect `DMM-V_HI `PS_RAIL1)
  (power-supply-set `PS_RAIL1 level)
  (eq-within (dmm-v) level err))

; Run a cross-talk test
(define (static-test exclusion)
    (voltage `n1-3)
    (voltage `n1-7)
  )

; Connect DMM probes for voltage test
(define (fus a)
  (connect `DMM_LO a )
  (connect `DMM-V_HI 'GND))

; Connect DMM probes for resistance test
(define (ro a b)
  (connect `DMM_LO a )
  (connect `DMM-V_HI b))

; Apply voltage to pin
(define (dah v a)
  (connect `PS_RAIL1 a )
  (power-supply-set `PS_RAIL1 v))


(define static-levels-off
  `((n1-1 . 0)
    (n1-3 . 0)
    (n1-2 . 0)
    (n1-4 . 0)
    (n1-5 . 0)
    (n1-6 . 0)
    (n1-7 . 0)
    (n1-8 . 0)
    (n1-9 . 0)
    (n1-10 . 0)
    (n1-12 . 0)
    (n1-13 . 2)
    (n1-14 . 0)
    (n1-15 . 0)
    (n1-16 . 0)
    (n1-17 . 0)
    (n1-18 . 0)
    (n1-19 . 0)))

(define static-levels-off
  `(((n1-1 . n1-2) . 120)
    (n1-3 . 0)
    (n1-2 . 0)
    (n1-4 . 0)
    (n1-5 . 0)
    (n1-6 . 0)
    (n1-7 . 0)
    (n1-8 . 0)
    (n1-9 . 0)
    (n1-10 . 0)
    (n1-12 . 0)
    (n1-13 . 2)
    (n1-14 . 0)
    (n1-15 . 0)
    (n1-16 . 0)
    (n1-17 . 0)
    (n1-18 . 0)
    (n1-19 . 0)))

(define (static-voltage-check levels))
(for ([x levels])
  (let ([p (car x)]
        [v (cdr x)])
    (displayln (string-append (symbol->string p) " " (number->string v) "V"))))


(define (static-check-excluding levels excluding)
  ())

(define (resistance-map map)
  )

(array
 #[
  #[#f #f #f #f #f]
  #[1 2 3 4 5]
  #[2 3 4 5 6]
  #[3 4 5 6 7]])

; (power-supply-passthrough `PS_RAIL1)
; (power-supply-disable `PS_RAIL1)
; (power-supply-enable `PS_RAIL1)

(define (dmm-v) 48.5)

(define (eq-within value err)
	(and (< value (+ value err)) (> value (- value err))))

; (define (lt f value)
;   (< (f) value

; (expect-resistance-eq `UTSG-4 `UTSG-3 120 5)
; (expect-resistance-lt `UTSG-4 `UTSG-3 0.5)

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
    (expect (format "Expected ~s (+/- ~s) V on ~s. Measured ~s V." expected err a) (eq-within measured expected err))))



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











  