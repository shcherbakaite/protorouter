#lang sketching
; Original example by Rusty Robinson
 
; Hue is the color reflected from or transmitted through an object 
; and is typically referred to as the name of the color (red, blue, yellow, etc.) 
; Move the cursor vertically over each bar to alter its hue. 

(require "connections.rkt")

(require racket/set)

(define bar-width 20)
(define last-bar  -1)
 
(define (setup)
  (size 640 360)  
  (color-mode 'hsb height height height)
  (background 0)
  (no-stroke))

;(define (draw-x-axis )

(define (draw)
  (define which-bar (quotient mouse-x bar-width))
  (text (format "~s" (set-count connections)) 10 140)
  (unless (= which-bar last-bar)
    (define bar-x (* which-bar bar-width))
    (fill mouse-y height height)
    (rect bar-x 0 bar-width height)
    (set! last-bar which-bar)))
