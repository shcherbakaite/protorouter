#lang racket

(require racket/set)

(define jumpers (mutable-set))

(struct jumper (from-col from-place to-column to-place))

(define (create-jumper from-col from-place to-column to-place)
  (set-add! jumpers (jumper from-col from-place to-column to-place)))