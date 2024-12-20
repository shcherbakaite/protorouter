#lang racket

(require "connections.rkt")

(provide apply-voltage apply-ground remove-voltage power-supply-set power-supply-on power-supply-off power-supply-passthrough power-supply-release-all)

;; Power Resources

(define power-resources (make-hash
                         (list
                          `[PS_RAIL1 . #f]
                          `[PS_RAIL2 . #f]
                          `[PS_RAIL3 . #f])))                          

;; Find unused power rail
(define (find-free-power-rail)
  (for/first ([key (in-hash-keys power-resources)]
    #:when (not (hash-ref  power-resources key)))
      key))

;; Low Level Power Management

(define (power-supply-set rail v)
  (void))

(define (power-supply-on rail)
  (void))

(define (power-supply-off rail)
  (void))

(define (power-supply-passthrough rail)
  (void))

;; High Level Power Management

(define (power-supply-reserve)
  (define next-rail (find-free-power-rail))
  (hash-set! power-resources next-rail #t)
  next-rail)

(define (power-supply-release rail)
  (hash-set! power-resources rail #f))

(define (power-supply-release-all)
  (for ([rail (in-hash-keys power-resources)])
    (hash-set! power-resources rail #f)))

; Apply voltage to a target node
(define (apply-voltage a v)
  (define next-rail (power-supply-reserve))
  (when next-rail
    (power-supply-set next-rail v)
    (power-supply-on next-rail)
    (connect next-rail a)
    next-rail))

; Disconnect all power sources and grounds from node
(define (remove-voltage a)
  (disconnect a `GND)
  (for ([key (in-hash-keys power-resources)])
        (disconnect a `PS_RAIL1)))

; Apply GND to a target node
(define (apply-ground a)
  (connect `GND a))
