#lang sketching
; Original example by Rusty Robinson
 
; Hue is the color reflected from or transmitted through an object 
; and is typically referred to as the name of the color (red, blue, yellow, etc.) 
; Move the cursor vertically over each bar to alter its hue. 

(require "targets.rkt")

(require "matrix.rkt")

(require "run.rkt")

(require racket/set)

(define bar-width 20)
(define last-bar  -1)
 
(define (setup)
  (size 2200 360)  
  (color-mode 'hsb height height height)
  (background 0)
  (no-stroke))

(define (draw-x-axis labels offset-x)
  (when (not (null? labels))
    (push-matrix)
    (translate offset-x 80)
    (rotate (radians -90))
    (text-size 8)
    (text (car labels) 0 0)
    (pop-matrix)
    (draw-x-axis (cdr labels) (+ offset-x 10)  )))

(define (draw-y-axis labels offset-y)
  (when (not (null? labels))
    (push-matrix)
    (translate 5 offset-y)
    (text-size 8)
    (text (car labels) 0 0)
    (pop-matrix)
    (draw-y-axis (cdr labels) (+ offset-y 10)  )))

(define (draw-matrix)
  (stroke-weight 5)
  (stroke-cap 'round)
  (color-mode 'rgb 255)
  (stroke 255 0 0)
  (push-matrix)
  (translate 26 107)
  (for ([x (in-range 0 (matrix-dim-x))])
  (for ([y (in-range 0 (matrix-dim-y))])
    (if (matrix-connected? x y)
        (stroke 255 0 0)
        (stroke 35 35 35))
    (point (* x 10) (* y 10)
    )))
   (pop-matrix))

(define (draw-title)
  (text current-test 0 0))

(define X-labels (map symbol->string X-axis))
(define Y-labels (map symbol->string Y-axis))

(define (draw)
  (define which-bar (quotient mouse-x bar-width))
  (background 0)
  (draw-title)
  (draw-x-axis X-labels 20)
  (draw-y-axis Y-labels  100)
  (draw-matrix) )

