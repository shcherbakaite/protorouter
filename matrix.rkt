#lang racket

(provide matrix-implement-net matrix-implement-nets matrix-dim-y matrix-dim-x matrix-connected? matrix-connect matrix-implement-current-connections)

(require math)

(require "targets.rkt")

(require "connections.rkt")

(require "net.rkt")

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

(define (matrix-clear)
  (for ([x (in-range 0 (matrix-dim-x))])
  (for ([y (in-range 0 (matrix-dim-y))])
    (array-set! matrix (vector x y) #f)
    )))

;(define current-row 0)

(define (node-index node)
  (match (index-of X-axis node)
    [#f (error (format "Node does not exists: ~s" node) )]
    [i i]))

(define (matrix-implement-net current-row net)
  (for/set ([node net])
    (let ([x (node-index node)]
          [y current-row])
      (matrix-connect x y)))
  (set! current-row (+ current-row 1)))

(define (matrix-implement-nets current-row nets)
  (when (not (null? nets))
    (matrix-implement-net current-row (car nets))
    (matrix-implement-nets (+ current-row 1) (cdr nets))))

(define (matrix-implement-current-connections)
  (define nets (nets-add-connections `() (set->list connections)))
  (matrix-clear)
  (matrix-implement-nets 0 nets))

; pick a row y
; for each node, find its x
; connect x y





