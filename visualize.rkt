#lang sketching
; Original example by Rusty Robinson
 
; Hue is the color reflected from or transmitted through an object 
; and is typically referred to as the name of the color (red, blue, yellow, etc.) 
; Move the cursor vertically over each bar to alter its hue. 

(require "connections.rkt")


(require "targets.rkt")

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
    (translate 10 offset-y)
    (text-size 8)
    (text (car labels) 0 0)
    (pop-matrix)
    (draw-y-axis (cdr labels) (+ offset-y 10)  )))

(define (draw)
  (define which-bar (quotient mouse-x bar-width))
  ;(text (format "~s" (set-count connections)) 10 140)
  (draw-x-axis (map symbol->string X-axis) 20)
  (draw-y-axis (list "1" "2" "3" "4" "5" "6") 100 )
  )