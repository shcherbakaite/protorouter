#lang racket/base

(require rackunit
         "net.rkt"
         "connections.rkt")


(require racket/set)

(test-case
 "Merging nets"
 (let ([result (nets-add-connection (list  (set `J2-1 `GND)  (set `J2-2)) (connection `J2-1 `J2-2))])
    (check equal? result (list (set 'GND 'J2-2 'J2-1)))))

(test-case
 "Creating nets from empty"
 (let ([result (nets-add-connection `() (connection `J2-1 `J2-2))])
    (check equal? result (list (set 'J2-2 'J2-1)))))

(test-case
 "Creating nets in non-empty"
 (let ([result (nets-add-connection (list (set 'J2-1 'GND)) (connection 'J2-2 'J2-3))])
    (check equal? result (list (set 'J2-2 'J2-3) (set 'J2-1 'GND) ))))