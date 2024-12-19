#lang racket

(provide current-test run-test)

(require "connections.rkt")

(define current-test "") 

(define (run-test test)
  (define test-dir (string->path "./tests"))
  (set! current-test test)
  (disconnect-all) ; reset connections
  (load (build-path test-dir test)))
