#lang sketching
; Original example by Rusty Robinson
 
; Hue is the color reflected from or transmitted through an object 
; and is typically referred to as the name of the color (red, blue, yellow, etc.) 
; Move the cursor vertically over each bar to alter its hue. 

(require "connections.rkt")

(require "targets.rkt")

(require "matrix.rkt")

(require "net.rkt")

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
        (stroke 10 10 10))
    (point (* x 10) (* y 10)
    )))
   (pop-matrix))

(define (draw)
  (define which-bar (quotient mouse-x bar-width))
  ;(text (format "~s" (set-count connections)) 10 140)
  (draw-x-axis (map symbol->string X-axis) 20)
  (draw-y-axis (list "1" "2" "3" "4" "5" "6") 100 )
  
  ;(point 200 200)
  (draw-matrix)
  )


(define nets
  (nets-add-connections `()
                        (list
                         (connection `n1-1 `GND)
                         (connection `n1-3 `GND)
                         (connection `n1-5 `GND)
                         (connection `n1-6 `GND)
                         (connection `n1-7 `GND)
                         (connection `n1-8 `GND)
                         (connection `n1-9 `GND)
                         (connection `n1-10 `GND)
                         (connection `n1-11 `GND)
                         (connection `n1-19 `DMM_V_HI)
                         
                         (connection `J5a-1 `DMM_LO)
                         (connection `PS_RAIL1 `J2-45)
                         (connection `PS_RAIL2 `J2-44)
                         (connection `PS_RAIL3 `J2-40)
                         (connection `J2-30 `PS_RAIL3)


                         )))

(matrix-implement-nets nets)