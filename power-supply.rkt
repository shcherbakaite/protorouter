#lang racket

(require "connections.rkt")

(provide apply-voltage apply-ground)

;; Power Resources

(define available-resources (mutable-set `PS_RAIL1 `PS_RAIL2 `PS_RAIL3))


;; Low Level Power Management

(define (power-supply-set rail v)
  `())

(define (power-supply-on rail)
  `())

(define (power-supply-off rail)
  `())

(define (power-supply-passthrough rail)
  `())

;; High Level Power Management

(define (apply-voltage a v)
  (connect `PS_RAIL1 a))

(define (apply-ground a)
  (connect `GND a))

; list of connections