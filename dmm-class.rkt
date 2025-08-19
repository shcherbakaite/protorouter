#lang racket

(require racket/class)
(require "connections.rkt")
(require "matrix.rkt")

;; Basic DMM Class Template
;; 
;; This is a proper Racket class template for implementing basic DMM functionality.
;; Basic measurement modes: VDC, VAC, OHMS, CONTINUITY, ADC, AAC, RANGE

(provide dmm%)

;; Basic DMM Class Definition
(define dmm%
  (class object%
    (super-new)
    
    (abstract dc-voltage)
    (abstract ac-voltage)
    (abstract resistance)
    (abstract dc-current)
    (abstract ac-current)
       
    ))


(require libserialport)



;; Basic DMM Class Definition
(define fluke45-dmm%
  (class dmm%
    (super-new)
    
    (define/override (dc-voltage)
      1)
    ;(abstract ac-voltage)
    ;(abstract resistance)
    ;(abstract dc-current)
    ;(abstract ac-current)


    ))