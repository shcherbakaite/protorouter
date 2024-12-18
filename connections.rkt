#lang racket

;; Keep track of connections

(provide connection connect connections disconnect disconnect-all connection-a connection-b)

(require racket/struct)

(require racket/set)

(define connections (mutable-set))

(define (connection=? a b _)
  (or
   (and (equal? (connection-a a)(connection-a b))
        (equal? (connection-b a)(connection-b b)))
   (and (equal? (connection-a a)(connection-b b))
        (equal? (connection-b a)(connection-a b)))))

(struct connection (a b)
  #:methods gen:equal+hash
  [(define equal-proc connection=?)
   (define (hash-proc self _)
     (+ (eq-hash-code (connection-a self)) (eq-hash-code (connection-b self)) ))
   (define (hash2-proc self _)
     (+ (eq-hash-code (connection-a self)) (eq-hash-code (connection-b self)) ))]
   #:methods gen:custom-write
  [(define write-proc
     (make-constructor-style-printer
      (lambda (obj) 'connection)
      (lambda (obj) (list (connection-a obj) (connection-b obj)))))])

(define (connect a b)
  (set-add! connections (connection a b)))

(define (disconnect a b)
  (set-remove! connections (connection a b)))

(define (disconnect-all)
  (set-clear! connections))