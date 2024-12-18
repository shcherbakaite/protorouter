#lang racket

(provide matrix-implement-net matrix-implement-nets matrix-dim-y matrix-dim-x matrix-connected? matrix-connect)

(require math)

(require "targets.rkt")

; Declare boolean matrix of relay states where each relay at X Y
; connects row X to column Y when the value at X Y is #t
(define matrix
  (array->mutable-array (make-array
                         (vector (length X-axis) (length Y-axis) ) #f)))

(define (matrix-dim-x)
  (match-let ([(vector dimx _) (array-shape matrix)])
    dimx))

(define (matrix-dim-y)
  (match-let ([(vector _ dimy) (array-shape matrix)])
    dimy))

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
(define (matrix-exclusive-connect x y)
  (matrix-clear-col x) ; disconnect resource x from any other targets
  (matrix-clear-row y) ; disconnect target y from any other resources
  (array-set! matrix (vector x y) #t))

(define (matrix-connect x y)
  (array-set! matrix (vector x y) #t))

(define (matrix-connected? x y)
  (array-ref matrix (vector x y)))

(define current-row 0)

(define (node-index node)
  (index-of X-axis node))

(define (matrix-implement-net net)
  (for/set ([node net])
    (let ([x (node-index node)]
          [y current-row])
      (matrix-connect x y)))
  (set! current-row (+ current-row 1)))

(define (matrix-implement-nets nets)
  (when (not (null? nets))
    (matrix-implement-net (car nets))
    (matrix-implement-nets (cdr nets))))

; pick a row y
; for each node, find its x
; connect x y





