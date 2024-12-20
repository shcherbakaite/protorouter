#lang racket

(require "dmm.rkt")

(provide expect-resistance-eq expect-resistance-lt expect-resistance-gt expect-voltage-eq expect eq-within)

(define-syntax-rule (expect msg expr)
  (when (not expr)
    ;(error 'expect "~s: ~s" msg (quote expr))))
    (printf "~s: ~s\n" msg (quote expr))))

; Expect resistance equal within error margin
(define (expect-resistance-eq a b expected err)
  (let ([measured (resistance a b)])
    (expect (format "Expected resistance between ~s and ~s is ~s (+/- ~s) Ohm. Measured ~s Ohm." a b expected err measured) (eq-within measured expected err))))

; Expect resistance less than
(define (expect-resistance-lt a b expected)
  (let ([measured (resistance a b)])
    (expect (format "Expected resistance between ~s and ~s to be less than ~s Ohm. Measured ~s Ohm." a b expected measured) (< measured expected))))

; Expect resistance greater than
(define (expect-resistance-gt a b expected)
  (let ([measured (resistance a b)])
    (expect (format "Expected resistance between ~s and ~s to be greater than ~s Ohm. Measured ~s Ohm." a b expected measured) (> measured expected))))

; Expect voltage equal withing error margin
(define (expect-voltage-eq a expected err)
  (let ([measured (voltage*  a)])
    (expect (format "Expected ~s (+/- ~s) V on ~s. Measured ~s V." expected err a measured) (eq-within measured expected err))))

(define (eq-within measured expected err)
	(and (< measured (+ expected err)) (> measured (- expected err))))