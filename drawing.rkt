#lang racket

(provide 
    line-geometry
    gl-draw-line
    gl-draw-circle
    gl-draw-point)

(require 
    ffi/vector
    opengl
    control
    "vec.rkt")

(define 2pi (* 2 pi))

(define (line-geometry p1 p2)
    (f32vector
       ;; Character 'A'
       (vector-ref p1 0)  (vector-ref p1 1)
       (vector-ref p2 0)  (vector-ref p2 1)))


(define (gl-draw-line p1 p2 color width)
    (glLineWidth width)
    (glColor3f (vec-r color) (vec-g color) (vec-b color))
    (glBegin GL_LINES)
    (glVertex2f (vec-x p1) (vec-y p1))
    (glVertex2f (vec-x p2) (vec-y p2))
    (glEnd))


(define (gl-draw-circle center diameter color width filled?)
    (glLineWidth width)
    (glColor3f (vec-r color) (vec-g color) (vec-b color))
    (if filled?
        (glBegin GL_POLYGON)
        (glBegin GL_LINE_LOOP))
    (define radius (* 0.5 diameter ))
    (define angle 0.0)
    (define angle-step (/ 0.05 (* pi diameter)))
    (while (< angle 2pi)
        (set! angle (+ angle angle-step))
        (define p1 (vec2 (* radius (cos angle)) (* radius (sin angle)) ))
        ;(define p2 (vec2 (* radius (cos next-angle)) (* radius (sin next-angle)) ))
        (set! p1 (vec+ center p1))
        (glVertex2f (vec-x p1) (vec-y p1)))
    (glEnd))


(define (gl-draw-point center diameter color)
    (glPointSize diameter)
    (glColor3f (vec-r color) (vec-g color) (vec-b color))
    (glBegin GL_POINTS)
    (glVertex2f (vec-x center) (vec-y center))
    (glEnd))

  