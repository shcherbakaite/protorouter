#lang racket

(provide current-test run-test run-all-tests)

(require "connections.rkt")

(define current-test "") 

(define (run-test test)
  (define test-dir (string->path "./tests"))
  (displayln (format "Running test: ~s\n" (path->string test)))
  (set! current-test  (path->string test))
  (disconnect-all) ; reset connections
  (load (build-path test-dir test)))


(define (run-all-tests)
  (map run-test (directory-list "./tests")))