#lang racket

(provide nets-add-connection nets-add-connections)

(require racket/set)

(require "connections.rkt")

(define (swap-args f)
  (lambda (a b)
    (f b a)))

(define (maybe-first lst)
  (if (null? lst)   ; Check if the list is empty
      '()           ; Return an empty list if true
      (first lst))) ; Otherwise, return the first element

(define (nets-merge netA netB)
  (set-union netA netB))

(define (net-add net node)
  (set-add net node))

;; Take out a net containing a node from the list, returns the net and the remaining list of nets
(define (take-node-net nets node)
  (let-values ([(node-nets rest) (partition (lambda (net) (set-member? net node) ) nets )] )
    (values (maybe-first node-nets) rest) )) ; There can only be one net among list of nets that can contain a node, since nets are disjoint sets

;; Take a list of nets and return a new list of nets taking into account new connection. Creates new nets or merges nets.
(define (nets-add-connection nets connection)
  (define node-left (connection-a connection))   ; decompose connection left node
  (define node-right (connection-b connection))  ; decompose connection right node
  (let*-values
      ([(left-net rest) (take-node-net nets node-left)]        ; find a net containing left node
       [(right-net rest) (take-node-net rest node-right)])     ; find a net containing right node
    (match (cons left-net right-net)
      [(cons `() `())                                          ; Case I    1. neither node is in any nets    
       (cons (set node-left node-right) rest) ]                ;           2. create new net and add to head of the list
      
      [(cons `() right-net)                                    ; Case II:  1. left node is not in any net, right node found.
       (let ([new-right-net (net-add right-net node-left)])    ;           2. add left node to the right net (by connection)
         (cons new-right-net rest)) ]                          ;           3. reconstruct net list, push new net onto head
      
      [(cons left-net `())                                     ; Case III: 1. right node is not in any net, left node found.
       (let ([new-left-net (net-add left-net node-right)])     ;           2. add right node to the left net (by connection)
         (cons new-left-net rest)) ]                           ;           3. reconstruct net list, push new net onto head

      [(cons left-net right-net)                               ; Case IV:  1. left and right nodes are found in existing nets
       (let ([merged-net (nets-merge right-net left-net)])     ;           2. merge the nets
         (cons merged-net rest))]                              ;           3. reconstruct net list, push new net onto head
      
      )))

(define (nets-add-connections nets connections)
  (foldl (swap-args nets-add-connection) nets connections))
