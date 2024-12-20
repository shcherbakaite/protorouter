#lang racket

(provide prompt)

(define (prompt a t)
  (displayln a)
  (sleep t))